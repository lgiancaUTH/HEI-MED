%This prototype software is experimental in nature.
%UT-Battelle, LLC AND THE GOVERNMENT OF THE UNITED STATES OF AMERICA 
%MAKE NO REPRESENTATIONS AND DISCLAIM ALL WARRANTIES, BOTH EXPRESSED AND IMPLIED.
%THERE ARE NO EXPRESS OR IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A 
%PARTICULAR PURPOSE, OR THAT THE USE OF THE SOFTWARE WILL NOT INFRINGE ANY PATENT, 
%COPYRIGHT, TRADEMARK, OR OTHER PROPRIETARY RIGHTS, OR THAT THE SOFTWARE WILL ACCOMPLISH 
%THE INTENDED RESULTS OR THAT THE SOFTWARE OR ITS USE WILL NOT RESULT IN INJURY OR DAMAGE.  
%The user assumes responsibility for all liabilities, penalties, fines, claims, causes of 
%action, and costs and expenses, caused by, resulting from or arising out of, in whole or in 
%part the use, storage or disposal of the SOFTWARE.
%Reads the GND file including the blob IDs and the manifestations / states
% % % % Disclaimer:
% %  This code is provided "as is". It can be used for research purposes only and all the authors 
% %  must be acknowledged. 
% % % % Authors:
% % Priya Govindasamy
% % % % Date:
% % 2010-03-01
% % % % Version:
% % 1.0
% % % % Description:
% % Class to access the Diabetic Macular Edema Dataset (DMED)
function [BlobIDs ManifestationAndStateTypes ActualStates CDRatio Notes] = ReadGNDFile(sF)

    fid = fopen( sF );
    sLine = fgetl(fid);  % this is the number of blobs
    bGetNotes=0;
    Notes='(none)';
    if ( strcmpi(sLine,'GNDVERSION2.0 (INCLUDES NOTES AT THE END OF THE FILE)' ) )
        sLine = fgetl(fid); 
        bGetNotes=1;
    end;
    NumberOfBlobEntries = sscanf(sLine,'%f');
    BlobIDs  = cell(NumberOfBlobEntries,1);
    for i=1:NumberOfBlobEntries
        sLine = fgetl(fid);  %this is the blob type...
        BlobIDs{i} = sLine;
    end;
    sLine = fgetl(fid);  % this is the number of relevant features...
    NumberOfChosenCharacteristics = sscanf(sLine,'%f');
    Characteristics = cell(NumberOfChosenCharacteristics,1);
    for i=1:NumberOfChosenCharacteristics
        sLine = fgetl(fid);
        Characteristics{i} = sLine;
    end;
    
    sLine = fgetl(fid);
    NumberOfManifestations = sscanf(sLine,'%f');
    sLine = fgetl(fid);
    MaxNumberOfStates = sscanf(sLine,'%f')-1;
    
    ManifestationAndStateTypes = cell(NumberOfManifestations,2);
    for i=1:NumberOfManifestations
        Manifestation = fgetl(fid);  % this is the manifestation
        
        for j=1:MaxNumberOfStates
            sLine = fgetl(fid); % this is the available state...
            if ( isempty(sLine) )
            else
                if ( j==1 )
                    States = cell(1,1);
                end;
                States{j,1} = sLine;
            end;
        end;
        ManifestationAndStateTypes{i,1} = Manifestation;
        ManifestationAndStateTypes{i,2} = States;
    end;
    
    ActualStates = cell(NumberOfManifestations,1);
    for i=1:NumberOfManifestations
        ActualStates{i} = fgetl(fid);
    end;
    sLine = fgetl(fid); %feature
    sLine = fgetl(fid); %feature
    sLine = fgetl(fid); %feature
    sLine = fgetl(fid); %Disc-Cup ratio
    CDRatio = sscanf(sLine,'%f');
    if ( bGetNotes )
        Notes = fgetl(fid);
    end;
    
    fclose(fid);
