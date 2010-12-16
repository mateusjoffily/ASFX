function Cfg = ASFX_setDestinationRect(Cfg, ratio, loc)

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

MatlabResolutionNow = get(0, 'ScreenSize');

if isfield(Cfg, 'Screen') && isfield(Cfg.Screen, 'Resolution') && ...
   isfield(Cfg.Screen.Resolution, 'width')
    screenW = Cfg.Screen.Resolution.width;
else
    screenW = MatlabResolutionNow(3);
end

if isfield(Cfg, 'Screen') && isfield(Cfg.Screen, 'Resolution') && ...
   isfield(Cfg.Screen.Resolution, 'height')
    screenH = Cfg.Screen.Resolution.height;
else
    screenH = MatlabResolutionNow(4);
end

if numel(ratio) == 1
    ratioW = ratio;
    ratioH = ratio;
elseif numel(ratio) == 2
    ratioW = ratio(1);
    ratioH = ratio(2);
else
    return
end

rectW = screenW * ratioW;
rectH = screenH * ratioH;

switch loc
    case 'center'
        w1 = fix( (screenW - rectW) / 2 );
        w2 = fix( w1 + rectW );
        h1 = fix( (screenH - rectH) / 2 );
        h2 = fix( h1 + rectH );
        
    case 'top'
        w1 = fix( (screenW - rectW) / 2 );
        w2 = fix( w1 + rectW );
        h1 = 0;
        h2 = fix( h1 + rectH );
end

% Set Destination Rectangle
Cfg.Screen.destinationRect = [w1 h1 w2 h2];

end
