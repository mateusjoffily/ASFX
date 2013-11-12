function [trialdefs, factorinfo, errorflag, factorNames] = ASFX_readTrialDefs(fname, Cfg)

% Last modified 16-11-2010 Mateus Joffily

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

%each line is composed of a list of entries, one line per trial
%<code> [pageNumber_1, pageDuration_1, getResponse_1, correctResponse_1]...
%       [pageNumber_n, pageDuration_n, getResponse_n, correctResponse_n]
if ~isfield(Cfg, 'randomizeTrials'), Cfg.randomizeTrials = 0; else end;
if ~isfield(Cfg, 'userDefinedSTMcolumns'), Cfg.userDefinedSTMcolumns = 0; else end;
factorNames = {''};
errorflag = 0;

if exist(fname, 'file') == 2
    %FILE EXISTS
    fid = fopen(fname);
    
    %GET FACTOR LEVELS AND IF EXISTS FACTOR NAMES
    aline = fgetl(fid);
    tmpfactorinfo = textscan(aline, '%d');
    nLevels = length(tmpfactorinfo{:});
    factorinfo = double(tmpfactorinfo{:})';
    tmpfactorinfoX = textscan(aline, '%s');
    tmpfactorinfoX = tmpfactorinfoX{:};
    if (length(tmpfactorinfoX)> nLevels)
        %MORE ENTRIES THAN JUST NUMBERS, THUS WE HAVE TEXT CODING FACTOR NAMES
        for i = 1:nLevels
            factorNames{i} = tmpfactorinfoX{i+nLevels}; 
        end
    end

    counter = 0;
    while 1
        counter = counter + 1;
        aline = fgetl(fid);
        if ~ischar(aline), break, end
        %fprintf(1, '%s\n', aline)
        aline = str2num(aline); %#ok<ST2NM>
        trialdefs(counter).code = aline(1); %#ok<AGROW>
        trialdefs(counter).tOnset = aline(2); %#ok<AGROW>
        
        %SPACE FOR USER DEFINED TRIAL DEFINITIONS
        if Cfg.userDefinedSTMcolumns
            for c = 1:Cfg.userDefinedSTMcolumns
                trialdefs(counter).userDefined(c) = aline(2+c); %#ok<AGROW>
            end
        end
        
        % Mateus Joffily - 25/11/2010 - Remove RT columns from TRD files
%         trialdefs(counter).pageNumber = aline(Cfg.userDefinedSTMcolumns+3:2:(end-2)); %#ok<AGROW>
%         trialdefs(counter).pageDuration = aline(Cfg.userDefinedSTMcolumns+4:2:(end-2)); %#ok<AGROW>
%         trialdefs(counter).startRTonPage = aline(end-1); %#ok<AGROW>
%         trialdefs(counter).correctResponse = aline(end); %#ok<AGROW>
        trialdefs(counter).pageNumber      = aline(Cfg.userDefinedSTMcolumns+3:4:end);
        trialdefs(counter).pageDuration    = aline(Cfg.userDefinedSTMcolumns+4:4:end);
        trialdefs(counter).getResponse     = aline(Cfg.userDefinedSTMcolumns+5:4:end);
        trialdefs(counter).correctResponse = aline(Cfg.userDefinedSTMcolumns+6:4:end);
    end
    fclose(fid);
else
    %FILE DOES NOT EXIST
    errorflag = 1;
    error('FILE %s NOT FOUND', fname) 
end

if Cfg.randomizeTrials
    fprintf(1, 'RANDOMIZING TRIALS ... ');
    %RANDOMIZE ORDER OF TRIALS BUT NOT THE TRIAL ONSET VECTOR
    tOnset = [trialdefs.tOnset];
    if Cfg.randomizeTrialsNoImmediateRepeat
        doRepeat = 1;
        i = 0;
        fprintf(1, 'PASS %05d', i);
        while doRepeat
            i = i + 1;
            idx = randperm(counter-1);
            doRepeat = any(diff(idx) == 0);
            if (mod(i, 10) == 0)
                fprintf(1, '\b\b\b\b\b%05d', i);
            end
        end
        trialdefs = trialdefs(idx);
        fprintf(1, ' ');
    else
        trialdefs = trialdefs(randperm(counter-1));
    end
    for iTrial = 1:(counter - 1)
        trialdefs(iTrial).tOnset = tOnset(iTrial); 
    end
    fprintf(1, 'DONE\n')
end

