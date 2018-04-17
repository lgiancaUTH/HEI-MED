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
% % abstract class to represent the retinal datasets
classdef DatasetRet < handle
%Dataset Abstract class representing a retina dataset
%   
   properties
   end

   methods(Abstract=true)
       imgNum = getNumOfImgs(obj)
       img = getImg(obj, id)
       [imgGT, blobInfo] = getGT(obj, id)
       imgVess = getVesselSeg(obj, id, newSize)
       [onRow, onCol] = getONloc(obj, id)
       [macRow, macCol] = getMacLoc(obj, id)
       healthy = isHealthy(obj, id)
   end
   
   methods
       function display(obj)
           imgNum = obj.getNumOfImgs();
           
           
           se = strel('disk', 1);
           figRes = figure;
           figRes2 = figure;
           for imgIdx=1:imgNum
               figure(figRes);
               imshow( obj.getImg( imgIdx ) );
               input(['Img ' num2str(imgIdx) ' of ' num2str(imgNum) ', press enter to show lesions']);
               
               %------- Show lesions
               
                % Get and resize ground truth labels
                [imgGT, blobInfo] = obj.getGT( imgIdx );
                imgGTles = imgGT > 0;
                
                imgGTlesDil = imdilate( imgGTles, se );
                imgGTlesCont = imgGTlesDil - imgGTles;
                
                [r,c]= find( imgGTlesCont );
                figure(figRes2);
                imshow( obj.getImg( imgIdx ) );
                hold on;
                plot(c,r,'.b');
                hold off;
               %-------               
               
               
               input(['Img ' num2str(imgIdx) ' of ' num2str(imgNum) ', press enter for next image']);
           end
       end
       
   end

end 
