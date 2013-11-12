function varargout = physio_cond(pasf, fasf, pdat, fdat)
% PHYSIO_COND Create conditions file for physiological recordings.
%   PHYSIO_COND(pasf, fasf)
%
% Optional input arguments:
%   pasf - ASF conditions path name 
%   fasf - ASF conditions file name 
%   pdat - Physiological data path name 
%   fdat - Physiological data file name 
%
% Optional output arguments:
%   names     - cell array of conditions names
%   onsets    - cell array of conditions onsets corrected
%	durations - cell array of conditions durations
%   pmod      - structure array of conditions parametric modulation
% _________________________________________________________________________

% Last modified 11-11-2010 Mateus Joffily

if nargin < 4
    % Select ASF conditions file *.mat
    [fcond, pcond] = uigetfile('*.mat', 'Select ASF conditions file');

    % Select data file (.mat)
    [fdat, pdat] = uigetfile('*.mat', 'Select data file');
end

% Load conditions
load(fullfile(pcond, fcond), 'names', 'onsets', 'durations', 'pmod', ...
                             'numberOfIgnoredDummyScans');
                         
% Load data matrix
load(fullfile(pdat, fdat), 'data', 'fs');

% Localize triggers coded 128 (volume acquisition time stamp in CIMEC)
idx = find(data(end,:) == 128);

% Calculate time offset between data acquisition and conditions onsets
 time_offset = idx(numberOfIgnoredDummyScans) / fs;
 
 % Add time offset to conditions onsets
 for iO = 1:numel(onsets)
     onsets{iO} = time_offset + onsets{iO};
 end
 
% Save results in new conditions file, but in physiological data path
[pcond fcond] = fileparts(fullfile(pcond, fcond));
save(fullfile(pdat, [fcond '_physio.mat']), ...
    'names', 'onsets', 'durations', 'pmod');

% Set outputs
if nargout == 4
    varargout{1} = names;
    varargout{2} = onsets;
    varargout{3} = durations;
    varargout{4} = pmod;
end


