function [a,C11,C12]=getMaterial(IIIV)
%All material properties from:
% [1]I. Vurgaftman, J. R. Meyer, and L. R. Ram-Mohan, "Band parameters
% for III-V compound semiconductors and their alloys," Journal of Applied
% Physics, vol. 89, no. 11, pp. 5815--5875, Jun. 2001.
%
% Copyright (C) 2014--2016 Stephen J. Polly and Alex J. Grede
% GPL v3, See LICENSE for details
% This function is part of straincomp (https://nanohub.org/resources/straincomp)
switch IIIV
    case 'GaAs'
        a=5.65325; %[Angstrom]
        C11=1221; %[GPa]
        C12=566; %[GPa]
    case 'GaP'
        a=5.4505; %[Angstrom]
        C11=1405; %[GPa]
        C12=620.3; %[GPa]
    case 'GaSb'
        a=6.0959; %[Angstrom]
        C11=884.2; %[GPa]
        C12=402.6; %[GPa]
    case 'InAs'
        a=6.0583; %[Angstrom]
        C11=832.9; %[GPa]
        C12=452.6; %[GPa]
    case 'InP'
        a=5.8697; %[Angstrom]
        C11=1011; %[GPa]
        C12=561; %[GPa]
    case 'InSb'
        a=6.4794; %[Angstrom]
        C11=684.7; %[GPa]
        C12=373.5; %[GPa]
    case 'AlAs'
        a=5.6611; %[Angstrom]
        C11=1250; %[GPa]
        C12=534; %[GPa]
    case 'AlP'
        a=5.4672; %[Angstrom]
        C11=1330; %[GPa]
        C12=630; %[GPa]
    case 'AlSb'
        a=6.1355; %[Angstrom]
        C11=876.9; %[GPa]
        C12=434.1; %[GPa]
end
