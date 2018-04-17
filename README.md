# HEI-MED, What is this?

The Hamilton Eye Institute Macular Edema Dataset (HEI-MED) (formerly DMED) is a collection of 169 fundus images to train and test image processing algorithms for the detection of exudates and diabetic macular edema. The images have been collected as part of a telemedicine network for the diagnosis of diabetic retinopathy currently developed by the Hamilton Eye Institute, the Image Science and Machine Vision Group at ORNL with the collaboration of the Université de Bourgogne. The dataset collection and cleaning was completed in 2010.

# Dataset description

The dataset is composed of 169 Jpeg images compressed at highest quality We have made sure that all the images had enough quality, no patient is duplicated, a reasonable mixture of ethnicities and disease stratification is represented.

The table on the right shows the distributions of various characteristics of these images. Each image of the dataset was manually segmented by Dr. Edward Chaum (an expert ophthalmologist). He identified all the exudation areas and other bright lesions such as cotton wool spots, drusens or clearly visible fluid occurring on the fundus. There was no distinction between hard and soft exudates because this differentiation is prone to errors and without a clear clinical advantage for the diagnosis.

In addition to the images and the ground truth, we provide other anonymous clinical metadata about the patients, the optic nerve manually identified location, the machine segmented vasculature (employing the method of Zana and Klein), the ELVD quality metric and a Matlab class to seamlessly access all the data and metadata without having to deal with the internal format of the files. The ELVD quality metric is an algorithm to numerically quantify the quality of a fundus image. More information are available [link](https://tel.archives-ouvertes.fr/tel-00692354 "here").

An object oriented Matlab class to access HEI-MED is provided. The following methods are available:
```
    display() Display all the images in the dataset.
    displayImg(imgID) Display the image indicated by imgID.
    getEthnicity(imgID): string Return the the ethnicity of the patient.
    getGT(imgID): [gtImg, gtInfo] Get the manually segmented lesions.
    getImg(imgID): img Get image with the given imgID.
    getMetaAttr(imgID, attrStr): string Get a meta attribute given the imgID and the attribute name (attrStr).
    getMetaFileLoc(imgID): [locStr, isAvailable] Get the location of the file containing the meta attributes.
    getName(imgID): [nameStr, extStr] Get the location of the image file.
    getNumOfImgs(): num Get the number of images in the dataset.
    getONloc(imgID): [onRow, onCol] Get the hand identified location of the optic nerve.
    getQuality(imgID): num Get the ELVD quality (0-1) of the image.
    getVesselSeg(imgID,newSize): img Get the machine segmented lesion segmentation.
    hasNoBrightLes(imgID): bool Check if the image contains bright lesion.
    hasNoDarkLes(imgID): bool Check if the image contains dark lesion.
    hasNoExudates(imgID): bool Check if the image contains exudate.
    isHealthy(imgID): bool Check if the image does not contain any exudate or microaneurysm.
    resetBoundaries() Reset the dataset's subset selected.
    setBoundaries(startIdx, endIdx) Select a subset in the dataset.
    showLesions(imgID) Display the image indicated by imgID with the lesions.
```

Usage Example
```matlab
% Add directory contatinig the dataset managing class
addpath('misc');

% The location of the dataset
DMEDloc = 'location/of/dataset';

% load the dataset
data = Dmed( DMEDloc );

% Show the results of the exudate detection algorithm
for i=1:data.getNumOfImgs()
    rgbImg = data.getImg(i); % get original image
    [onY, onX] = data.getONloc(i); % get optic nerve location
    imgProb = exDetect( rgbImg, 1, onY, onX ); % segment exudates
end

% display results
figure(1);
imagesc(rgbImg);
figure(2);
imagesc(imgProb);

% block execution up until an image is closed
uiwait;
end
```
# Conditions of use

The HEI-MED can be used exclusevely for non-commercial research purposes. Any type of publications created with this dataset need to reference the following paper: Giancardo, L.; Meriaudeau, F.; Karnowski, T. P.; Li, Y.; Garg, S.; Tobin, Jr, K. W.; Chaum, E. (2012), 'Exudate-based diabetic macular edema detection in fundus images using publicly available datasets.', Medical Image Analysis 16(1), 216--226.

# Contacts

We would like to know what you think about the dataset. So please, send an e-mail with comments, complaints or suggestions to luca DOT giancardo AT tmc DOT uth DOT edu
