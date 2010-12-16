%function [ VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos ] = ASFX_xFlip(windowPtr, texture, cfg, bPreserveBackBuffer)

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

%% ASF_xFlip (extended Screen('Flip'))
function [ VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos ] = ASFX_xFlip(windowPtr, texture, cfg, bPreserveBackBuffer)
% persistent flipval
% 
% if isempty( flipval )
%     flipval = 0;
% end

[bUpDn, T, keyCodeKbCheck] = KbCheck;
if bUpDn % break out of loop
    if find(keyCodeKbCheck) == 81
        fprintf(1, 'USER ABORTED PROGRAM\n');
        ASF_PTBExit(windowPtr, cfg, 1)
        %FORCE AN ERROR
        error('USERABORT')
        %IF TRY/CATCH IS ON THE FOLLOWING LINE CAN BE COMMENTED OUT
        %PTBExit(windowPtr);
    end
end

switch bPreserveBackBuffer
    case 0 %DESTRUCTIVE FLIP
            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', windowPtr);
    case 1 %NONDESTRUCTIVE FLIP
        if cfg.Screen.useBackBuffer
            %FOR A MACHINE THAT HAS AUXILIARY BACKBUFFERS
            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', windowPtr, [], 1);
        else
            %FOR A MACHINE THAT HAS NO BACKBUFFERS
            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', windowPtr);
            %--------------------------------------------------------------
            % Draw many textures at once - Modified by Mateus Joffily
            %--------------------------------------------------------------
            if numel(texture) == 1
                Screen('DrawTexture', windowPtr, texture);
            else
                Screen('DrawTextures', windowPtr, texture);
            end
            %--------------------------------------------------------------
        end
end
