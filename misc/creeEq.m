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
% % Imlementation of the retina image equalisation proposed by 
% % Cree, M. J.; Gamble, E. & Cornforth, D. (2005), Colour normalisation to reduce interpatient and 
% % intra-patient variability in microaneurysm detection in colour retinal images, in 
% % 'WDIC2005 ARPS Workshop on Digital Image Computing'.
function [img2Out] = creeEq( imgIn2, p1, p2, p3, p4, p5, p6 )
%%creeEq: retina equalization described in Cree2005

%     % resize
%     lastSizeImg = [750 round(  750*(size(imgIn2, 2)/size(imgIn2, 1)) ) ];
%     rgbImg2 = imresize( imgIn2, lastSizeImg );
    rgbImg2 = imgIn2;
    
    %init
    img2Out = zeros(size(rgbImg2));
    
    if ( nargin == 2 )
        imgInModel = p1;
        % use imgInModel
        rMean = mean(vectorize(imgInModel(:,:,1)));
        rStd = std(vectorize(imgInModel(:,:,1)));
        gMean = mean(vectorize(imgInModel(:,:,2)));
        gStd = std(vectorize(imgInModel(:,:,2)));
        bMean = mean(vectorize(imgInModel(:,:,3)));
        bStd = std(vectorize(imgInModel(:,:,3)));
        %
    else
        rMean = p1;
        rStd = p2;
        gMean = p3;
        gStd = p4;
        bMean = p5;
        bStd = p6;
    end
    
    img2Out(:,:,1) = preprocessMed( rgbImg2(:,:,1), rMean, rStd );
    img2Out(:,:,2) = preprocessMed( rgbImg2(:,:,2), gMean, gStd );
    img2Out(:,:,3) = preprocessMed( rgbImg2(:,:,3), bMean, bStd );
    
    % cast back
    img2Out = cast(img2Out, class(imgIn2));
end

function normImg = preprocessMed( imgPlane, meanTgt, stdTgt )
    medFiltWin = round([size(imgPlane, 1)*0.04 size(imgPlane, 1)*0.04]); % around 30 x 30
    
    bgImg = medfilt2(imgPlane, medFiltWin);
    
%     % subtract bg with reconstruction
%     maskImg = double(imgPlane);
%     pxLbl = maskImg < bgImg;
%     maskImg(pxLbl) = bgImg(pxLbl);
%     medRestored = imreconstruct( double(bgImg), maskImg );
%     normImg = double(imgPlane)-double(medRestored);
%     %
    
    % or no reconstruction
    normImg = double(imgPlane)-double(bgImg);
    %
    
    currMean = mean(normImg(:));
    currStd = std(normImg(:));
    
    normImg = (normImg - currMean)./currStd;
    normImg = normImg .* stdTgt + meanTgt;
end