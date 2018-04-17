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
% % Test the Exudate segmentation on the DMED dataset

% Add directory contatinig the dataset managing class
addpath('misc');
% The location of the dataset
DMEDloc = './DMED';
% load the dataset
data = Dmed( DMEDloc );

% Show the results of the exudate detection algorithm
for i=1:data.getNumOfImgs()
    rgbImg = data.getImg(i); % get original image
    [onY, onX] = data.getONloc(i); % get optic nerve location
    imgProb = exDetect( rgbImg, 1, onY, onX ); % segment exudates
    % display results
    figure(1);
    imagesc(rgbImg);
    figure(2);
    imagesc(imgProb);
    % block execution up until an image is closed
    uiwait;
end