function Cfg = ASFX_setCfg(Cfg, mode, debugOK, TR)

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

% ASF configuration structure
%--------------------------------------------------------------------------
Cfg.Screen.color             = [0, 0, 0];

Cfg.Screen.Resolution.width = 1024;
Cfg.Screen.Resolution.height = 768;

if exist('debugOK', 'var') && debugOK
    % Small window for debugging
    Cfg.Screen.rect = [1, 1, 800, 600];
end

if exist('TR', 'var')
    % Dummy scans: ~10s of dummy scans should be set
    dummy_scans  = ceil( 10 / TR );
else
    dummy_scans  = 0;
end

Cfg.synchToScanner = dummy_scans; % Wait for trigger from MR scanner

switch mode
    case 'mriScanner'
        Cfg.responseDevice      = 'LUMINASERIAL';
        Cfg.synchToScannerPort  = 'SERIAL';
        Cfg.issueTriggers       = 1;  % Send triggers to output device
        Cfg.digitalOutputDevice = 'PARALLEL';

        % Adjust display position for CIMEC MR-Scanner
        Cfg = ASFX_setDestinationRect(Cfg, 0.75, 'top');
        
    case 'mriSimulator'
        Cfg.responseDevice        = 'LUMINASERIAL';
        Cfg.synchToScannerPort    = 'SIMULATE';
        %Cfg.scannerSynchTimeOutMs = '10';
        Cfg.issueTriggers         = 1; % Send triggers to output device
        Cfg.digitalOutputDevice   = 'PARALLEL';
        
    case 'lab'
        Cfg.responseDevice        = 'MOUSE';

end

end