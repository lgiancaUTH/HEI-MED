% % % % Disclaimer:
% %  This code is provided "as is". It can be used for research purposes only and all the authors 
% %  must be acknowledged. 
% % % % Authors:
% % Luca Giancardo
% % % % Date:
% % 2010-03-01
% % % % Version:
% % 1.0
% % % % Description:
% % get a binary image of the Field of View mask
function [ fovMask ] = getFovMask( gImg, erodeFlag, seSize )
%GETFOVMASK get a binary image of the Field of View mask
% gImg: green challe uint8 image
% erodeFlag: if set it will erode the mask
    %Param
    lowThresh = 0;
    if( nargin < 3)
        seSize = 10;
    end

    histRes = hist(gImg(:), 0:255);
    d = diff(histRes);
    
    lvlFound = find( d >= lowThresh, 1, 'first' );
    
    fovMask = ~(gImg <= lvlFound);
    
    if( nargin > 1 && erodeFlag > 0 )
        se = strel('disk', seSize);
        fovMask = imerode(fovMask,se);
        
        %erode also borders
        fovMask(1:seSize*2,:) = 0;
        fovMask(:,1:seSize*2) = 0;
        fovMask(end-seSize*2:end,:) = 0;
        fovMask(:,end-seSize*2:end) = 0;
    end

end

