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
% % Class to access the Diabetic Macular Edema Dataset (DMED)
classdef Dmed < DatasetRet

   properties(SetAccess='private')
       data
       origImgNum % real img num
       imgNum % current imgNum
       idMap % maps abstract id to real id
       roiExt
       imgExt
       metaExt
       gndExt
       mapGzExt
       mapExt
       baseDir
   end
   
   methods
       function obj = Dmed( dirIn )
       %DatasetCSV  constructor
%            obj = obj@DatasetRet;
           
           % set constants
           obj.roiExt = '.jpg.ROI';
           obj.imgExt = '.jpg';
           obj.metaExt = '.meta';
           obj.gndExt = '.GND';
           obj.mapGzExt = '.map.gz';
           obj.mapExt = '.map';
           obj.baseDir = dirIn;

           % store in obj.data file prefixes
           dirList = dir([obj.baseDir '/*' obj.imgExt ]);
           obj.data = struct([]);
           idxData = 1;
           for i=1:length(dirList)
                fileName = dirList(i).name;
                checkBad = dir([obj.baseDir '/' fileName '*bad' ]);
                if( isempty(checkBad) )
                    obj.data{idxData} = fileName(1:end-length(obj.imgExt));
                    idxData = idxData + 1;
                end
           end      
           
           obj.origImgNum = length(obj.data);
           obj.imgNum = obj.origImgNum;
           obj.idMap = 1:obj.imgNum;
           
       end
       function imgNum = getNumOfImgs(obj)
           imgNum = obj.imgNum;
       end
       function img = getImg(obj, id)
           if( id < 1 || id > obj.imgNum )
                img = [];
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
                imgAddress = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.imgExt];
                img = imread( imgAddress );
           end
       end
       function [imgGT, blobInfo] = getGT(obj, id)
           if( id < 1 || id > obj.imgNum )
                imgGT = [];
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
                %-- decompress gz file
                mapGzFile = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.mapGzExt];
                if( exist( mapGzFile, 'file') )
                    gunzip(mapGzFile, obj.baseDir);
                end
                gndFile = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.gndExt];
                mapFile = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.mapExt];
                %--
                % load map info
                fMap = fopen(mapFile, 'r');
                if( fMap > 0 )
                    resImg = fread(fMap, 3, 'int');
                    imgGT = fread(fMap, [resImg(2) resImg(3)], 'int');
                    fclose(fMap);
                    imgGT = imgGT';                

                    % get description
                    [blobInfo] = ReadGNDFile( gndFile );
                else
                    %if there is not any GND file available consider it as healthy
                    blobInfo = {};
                    img = obj.getImg( id );
                    imgGT = zeros( [size(img,1) size(img,2)] );
                end
                %-- remove decompressed file
                if( exist( mapGzFile, 'file') )
                    delete( mapFile );
                end
                %--
           end
       end
       function healthy = isHealthy(obj, id)
           healthy = 1;
           if( id < 1 || id > obj.imgNum )
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
               gndFile = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.gndExt];

               if( exist( gndFile, 'file' ) )
                   % get description
                   [blobInfo] = ReadGNDFile( gndFile );
                   lesList = regexpi( blobInfo, 'MicroAneurysm|Exudate' );

                   for i=1:length(lesList)
                       if( ~isempty(lesList{i}) )
                           healthy = 0;
                           break;
                       end
                   end
               else
                   healthy = 1;
               end
           end
       end
       function healthy = hasNoDarkLes(obj, id)
           healthy = 1;
           if( id < 1 || id > obj.imgNum )
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
               gndFile = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.gndExt];

               if( exist( gndFile, 'file' ) )
                   % get description
                   [blobInfo] = ReadGNDFile( gndFile );
                   lesList = regexpi( blobInfo, '0' );

                   for i=1:length(lesList)
                       if( ~isempty(lesList{i}) )
                           healthy = 0;
                           break;
                       end
                   end
               else
                   healthy = 1;
               end
           end
       end
       function healthy = hasNoBrightLes(obj, id)
           healthy = 1;
           if( id < 1 || id > obj.imgNum )
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
               gndFile = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.gndExt];

               if( exist( gndFile, 'file' ) )
                   % get description
                   [blobInfo] = ReadGNDFile( gndFile );
                   lesList = regexpi( blobInfo, '1' );

                   for i=1:length(lesList)
                       if( ~isempty(lesList{i}) )
                           healthy = 0;
                           break;
                       end
                   end
               else
                   healthy = 1;
               end
           end
       end
       function healthy = hasNoExudates(obj, id)
           healthy = 1;
           if( id < 1 || id > obj.imgNum )
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
               gndFile = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.gndExt];

               if( exist( gndFile, 'file' ) )
                   % get description
                   [blobInfo] = ReadGNDFile( gndFile );
                   lesList = regexpi( blobInfo, 'Exudate' );

                   for i=1:length(lesList)
                       if( ~isempty(lesList{i}) )
                           healthy = 0;
                           break;
                       end
                   end
               else
                   healthy = 1;
               end
           end
       end
       function qa = getQuality(obj, id)
           if( id < 1 || id > obj.imgNum )
                imgVess = [];
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
                metaFile = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.metaExt];
                fMeta = fopen(metaFile, 'r');
                if( fMeta > 0 )
                    res = char(fread(fMeta, inf, 'char'));
                    res = res';
                    fclose(fMeta);
                    
                    [tok, mat] = regexpi(res, 'QualityValue\W+([0-9\.]+)', 'tokens');
                    if( ~isempty(tok) )
                        qa = str2double(tok{1});
                    else
                        qa = -1;
                    end
                else
                    qa = -1;
                end
                

           end
       end
       
       function ethnicityStr = getEthnicity(obj, id)
           if( id < 1 || id > obj.imgNum )
                ethnicityStr = [];
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
                metaFile = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.metaExt];
                fMeta = fopen(metaFile, 'r');
                if( fMeta > 0 )
                    res = char(fread(fMeta, inf, 'char'));
                    res = res';
                    fclose(fMeta);
                    
                    [tok, mat] = regexpi(res, 'PatientRace\~(\w+)', 'tokens');
                    if( ~isempty(tok) )
                        ethnicityStr = cell2mat(tok{1});
                    else
                        ethnicityStr = [];
                    end
                else
                    ethnicityStr = [];
                end
           end
       end
       
       %Get other attribute
       function attrStr = getMetaAttr(obj, id, attrIn)
           if( id < 1 || id > obj.imgNum )
                attrStr = [];
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
                metaFile = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.metaExt];
                fMeta = fopen(metaFile, 'r');
                if( fMeta > 0 )
                    res = char(fread(fMeta, inf, 'char'));
                    res = res';
                    fclose(fMeta);
                    
                    [tok, mat] = regexpi(res, [attrIn '~([a-z\s\.\/\\0-9]+).+'], 'tokens');
                    if( ~isempty(tok) )
                        attrStr = deblank(cell2mat(tok{1}));
                    else
                        attrStr = [];
                    end
                else
                    attrStr = [];
                end
           end
       end

       function imgVess = getVesselSeg(obj, id, newSize)
       %%getVesselSegRS: get vessels. if newSize is given, it specifies the final size of the image
           imgVess = [];
           if( id < 1 || id > obj.imgNum )
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
                vessAddress = [obj.baseDir '/' obj.data{obj.idMap(id)} '_vess.png' ];
                if( exist(vessAddress, 'file') )
                    if( nargin < 3 )
                        imgOrig = obj.getImg(id);
                        newSize = size(imgOrig);
                    end
                    imgVess = imread( vessAddress );
                    imgVess = imresize(imgVess, newSize(1:2));
                    % binarise
                    imgVess = imgVess > 30;
                end
           end
       end
       function [onRow, onCol] = getONloc(obj, id)
           onRow = [];
           onCol = [];
           if( id < 1 || id > obj.imgNum )
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
                metaFile = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.metaExt];
                fMeta = fopen(metaFile, 'r');
                if( fMeta > 0 )
                    res = char(fread(fMeta, inf, 'char'));
                    res = res';
                    fclose(fMeta);
                    
                    tokRow = regexpi(res, 'ONrow\W+([0-9\.]+)', 'tokens');
                    tokCol = regexpi(res, 'ONcol\W+([0-9\.]+)', 'tokens');
                    if( ~isempty( tokRow ) && ~isempty( tokCol ) )
                        onRow = str2double(tokRow{1});
                        onCol = str2double(tokCol{1});
                    end
                end
           end
       end
       function [macRow, macCol] = getMacLoc(obj, id)
           if( id < 1 || id > obj.imgNum )
                macRow = [];
                macCol = [];
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
                onRow = -1;
                onCol = -1;
           end
       end
       function setBoundaries(obj, startIdx, endIdx)
           if( startIdx > obj.origImgNum || startIdx < 1)
               error('Wrong boundaries');
           end
           if( endIdx >  obj.origImgNum || endIdx < 1)
               error('Wrong boundaries');
           end
           % set boundary
           obj.imgNum = endIdx-startIdx+1;
           obj.idMap = startIdx:endIdx;
       end
       function resetBoundaries(obj)
           obj.imgNum = obj.origImgNum;
           obj.idMap= 1:obj.imgNum;
       end
       
       function [imgName, imgExt ] = getName(obj, id)
           if( id < 1 || id > obj.imgNum )
                img = [];
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
                imgName = obj.data{obj.idMap(id)};
                imgExt = obj.imgExt;
           end          
       end
       
       function [metaFileLoc, isAvailable] = getMetaFileLoc(obj, id)
       %%getMetaFileLoc: returns the location of the metafile for the given
       %%id, check if it exist and return the information in isPresent
           if( id < 1 || id > obj.imgNum )
                img = [];
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
                metaFileLoc = [obj.baseDir '/' obj.data{obj.idMap(id)} obj.metaExt];
                fMeta = fopen(metaFileLoc, 'r');
                if( fMeta > 0 )
                    isAvailable = 1;
                else
                    isAvailable = 0;
                end
           end          
       end
       
       function showLesions( obj, id )
           if( id < 1 || id > obj.imgNum )
                img = [];
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
               imgIdx = obj.idMap(id);
           
               se = strel('disk', 1);
               %------- Show lesions
                % Get and resize ground truth labels
                [imgGT, blobInfo] = obj.getGT( imgIdx );
                
                %-- find lesion ids and associate a different colour
                lesIdList ={};
                lesColList = {};
                
                % Find MA
                lesMaList = regexpi( blobInfo, 'MicroAneurysm' );
                tmpIdList = [];
                for i=1:length(lesMaList)
                    if( ~isempty(lesMaList{i}) )
                       tmpIdList(end+1) = i;
                    end
                end
                lesIdList{1} = tmpIdList;
                lesColList{1} = 'r';
                % Find Exudates
                lesExList = regexpi( blobInfo, 'Exudate' );
                tmpIdList = [];
                for i=1:length(lesExList)
                    if( ~isempty(lesExList{i}) )
                       tmpIdList(end+1) = i;
                    end
                end
                lesIdList{2} = tmpIdList;
                lesColList{2} = 'y';
                % Find everything else
                tmpIdList = [];
                for i=1:length(lesMaList)
                    if( isempty(lesMaList{i}) && isempty(lesExList{i}) )
                       tmpIdList(end+1) = i;
                    end
                end
                lesIdList{3} = tmpIdList;
                lesColList{3} = 'b';
                %--
                
                % show image
                imshow( obj.getImg( imgIdx ) );
                hold on;
                for idxLesType=1:length(lesIdList)
                    tmpLesList = lesIdList{idxLesType};
                    imgGTles = zeros(size(imgGT));
                    for idxLes=1:length(tmpLesList)
                        imgGTles = imgGTles | (imgGT == tmpLesList(idxLes));
                    end

                    imgGTlesDil = imdilate( imgGTles, se );
                    imgGTlesCont = imgGTlesDil - imgGTles;

                    % plot lesions
                    [r,c]= find( imgGTlesCont );
                    plot(c,r,['.' lesColList{idxLesType}]);
                end
                hold off;
               %-------
           end
       end
       
       function display(obj)
           imgNum = obj.getNumOfImgs();
           
           figRes = figure;
           figRes2 = figure;
           for imgIdx=1:imgNum
               figure(figRes);
               imshow( obj.getImg( imgIdx ) );
               input(['Img ' num2str(imgIdx) ' of ' num2str(imgNum) ', QA ' num2str(obj.getQuality(imgIdx)) ', press enter to show lesions']);
               
               figure(figRes2);
               obj.showLesions( imgIdx );
          
               input(['Img ' num2str(imgIdx) ' of ' num2str(imgNum) ', press enter for next image']);
           end
       end
       function displayImg(obj, id)
           if( id < 1 || id > obj.imgNum )
                img = [];
                error(['Index exceeds dataset size of ' num2str(obj.imgNum) ]);
           else
               imgIdx = obj.idMap(id);
               figRes = figure;
               figRes2 = figure;
               figure(figRes);
               imshow( obj.getImg( imgIdx ) );
               figure(figRes2);
               obj.showLesions( imgIdx );
           end
       end
   end
end 
