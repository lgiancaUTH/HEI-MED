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
% % Imlementation of the edge detector proposed by
% % Kirsch, R. A. (1971), 'Computer determination of the constituent structure of biological images.',
% % Computers and Biomedical Research 4(3), 315--328.
function imgOut = kirschEdges( imgIn )
%%kirschEdges: Calculate the edge map using the Kirsch's method
%imgIn: image input (single plane)
%imgOut: edge map

    % Kirsch's Templates
    h1=[5 -3 -3;
        5  0 -3;
        5 -3 -3]/15;
    h2=[-3 -3 5;
        -3  0 5;
        -3 -3 5]/15;
    h3=[-3 -3 -3;
         5  0 -3;
         5  5 -3]/15;
    h4=[-3  5  5;
        -3  0  5;
        -3 -3 -3]/15;
    h5=[-3 -3 -3;
        -3  0 -3;
         5  5  5]/15;
    h6=[ 5  5  5;
        -3  0 -3;
        -3 -3 -3]/15;
    h7=[-3 -3 -3;
        -3  0  5;
        -3  5  5]/15;
    h8=[ 5  5 -3;
         5  0 -3;
        -3 -3 -3]/15;

    % Spatial Filtering by Kirsch's Templates
    t1 = filter2(h1,imgIn);
    t2 = filter2(h2,imgIn);
    t3 = filter2(h3,imgIn);
    t4 = filter2(h4,imgIn);
    t5 = filter2(h5,imgIn);
    t6 = filter2(h6,imgIn);
    t7 = filter2(h7,imgIn);
    t8 = filter2(h8,imgIn);

    % Find the maximum edges value
    imgOut = max(t1,t2);
    imgOut = max(imgOut,t3);
    imgOut = max(imgOut,t4);
    imgOut = max(imgOut,t5);
    imgOut = max(imgOut,t6);
    imgOut = max(imgOut,t7);
    imgOut = max(imgOut,t8);
end