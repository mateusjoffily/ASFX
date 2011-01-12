function varargout = ASFX_cond(fasf)
% ASFX_cond Create conditions file from ASF log file.
%   ASFX_COND(fasf)
%
% Optional input arguments:
%   fasf - ASFX log file full name 
%
% Optional output arguments:
%   names     - cell array of conditions names
%   onsets    - cell array of conditions onsets
%	durations - cell array of conditions durations
%   pmod      - structure array of conditions parametric modulation
%   numberOfIgnoredDummyScans  - number of dummys scans accounted for
%                                correcting conditions onsets
% _________________________________________________________________________

% Last modified 11-01-2011 Mateus Joffily

if nargin == 0
    % Select ASFX *.mat data file
    [fasf, pasf] = uigetfile('*.mat', 'Select ASFX output file');
    fasf = fullfile(pasf, fasf);
end

% Load experiment information
load(fasf, 'ExpInfo');

% Conditions' name
names = {'fix' 'NN' 'PS' 'PI' 'US' 'UI' 'Ple' 'Unp' 'Sen' 'Int'};

% Related stimuli in ASF definition file
stimID = {'XX01_fix', 'NN_', 'PS_', 'PI_', 'US_', 'UI_', ...
    'ASF_piacere', 'ASF_dispiacere', 'ASF_vigilanza', ...
    'ASF_pensiero'};

pages     = cell(size(stimID));
for i = 1:length(pages)
    pages{i}  = find(cellfun(@isempty,strfind(ExpInfo.stimNames, ...
                                                         stimID{i}))==0);
end

% Initiliaze onsets, durations and parametric modulation
onsets    = cell(size(names));
durations = cell(size(names));

% Initialize parametric modulation for verbal-report scales
pmod = struct('names', {}, 'param', {}, 'poly', {});
pmod(7).names = {'rate'};
pmod(7).param = {};
pmod(7).poly = {1};
pmod(8).names = {'rate'};
pmod(8).param = {};
pmod(8).poly = {1};
pmod(9).names = {'rate'};
pmod(9).param = {};
pmod(9).poly = {1};
pmod(10).names = {'rate'};
pmod(10).param = {};
pmod(10).poly = {1};

% Set reference start time
start_time = ExpInfo.TrialInfo(1).timing(1,3);  % after dummy scans (i.e. 1st page of 1st trial)
% start_time = ExpInfo.Cfg.experimentStart;  % experiment start time

% Get onsets, durations and modulation parameters
nT  = length(ExpInfo.TrialInfo);
nCP = length(pages);
cRT = 0;    % count rating trials
for iT = 1:nT   % Loop over trials
    TPages = ExpInfo.TrialInfo(iT).trial.pageNumber;
    nTP = length(TPages);
    if nTP == 6  % It is a rating trial
        rates = 6 - ExpInfo.TrialInfo(iT).VR.key;
        cRT = cRT + 1;
    end
    PagesOnsets    = ExpInfo.TrialInfo(iT).timing(:,3)' - start_time;
    PagesDurations = [diff(PagesOnsets) ...
                      ExpInfo.TrialInfo(iT).timing(end,1) * ...
                      ExpInfo.Cfg.Screen.monitorFlipInterval];
    for iTP = 1:nTP  % Loop over trial pages
        if iTP == 6   % skip last page of picture trials
            break;
        end
        for iCP = 1:nCP   % Loop over condition pages
           idx = find(pages{iCP} == TPages(iTP), 1);
           if ~isempty(idx)
               onsets{iCP}(end+1)    = PagesOnsets(iTP);
               if iCP >= 2 && iCP <= 6
                   % the duration of picture conditions is the full trial.
                   durations{iCP}(end+1) = sum(PagesDurations);
               else
                   durations{iCP}(end+1) = PagesDurations(iTP);
               end
               if iCP >= 7 && iCP <= 10   % verbal-report scales
                   pmod(iCP).param{1}(cRT) = rates(pages{iCP}-3);
               end
           end
        end
    end
end

% Useful to syncronize with BrainProducts
numberOfIgnoredDummyScans = ExpInfo.Cfg.synchToScanner;
expDurationInSecs = ExpInfo.TrialInfo(end).tStart + ...
                    ExpInfo.TrialInfo(end).timing(1);

% Append to conditions .mat file
[pcond fcond] = fileparts(fasf);
fcond = fullfile(pcond, [fcond '_cond_asf.mat']);
save(fcond, 'names', 'onsets', 'durations', 'pmod', ...
            'numberOfIgnoredDummyScans');

% Set outputs
if nargout == 6
    varargout{1} = names;
    varargout{2} = onsets;
    varargout{3} = durations;
    varargout{4} = pmod;
    varargout{5} = numberOfIgnoredDummyScans;
    varargout{6} = expDurationInSecs;
end

