function [a,C11i,C12i,C11a,C12a]=calcMaterial(AC,AD,x,BC,BD,y)
%Funtion calcMaterial returns the calculated (or literature) lattice...
%constant and elastic stiffness coefficients for a given material.
%
% Copyright (C) 2014--2016 Stephen J. Polly and Alex J. Grede
% GPL v3, See LICENSE for details
% This function is part of straincomp (https://nanohub.org/resources/straincomp)
if x < 1
    if y < 1
        %eg AlGaAsSb
        [aAC,C11AC,C12AC]=getMaterial(AC);
        [aBC,C11BC,C12BC]=getMaterial(BC);
        [aAD,C11AD,C12AD]=getMaterial(AD);
        [aBD,C11BD,C12BD]=getMaterial(BD);
        %a=vegard(x,y,aAC,aAD,aBC,aBD);
        %C11i=vegard(x,y,C11AC,C11AD,C11BC,C11BD);
        %C12i=vegard(x,y,C12AC,C12AD,C12BC,C12BD);
        a=(x*y)*aAC+x*(1-y)*aAD+(1-x)*y*aBC+(1-x)*(1-y)*aBD;
        C11i=(x*y)*C11AC+x*(1-y)*C11AD+(1-x)*y*C11BC+(1-x)*(1-y)*C11BD;
        C12i=(x*y)*C12AC+x*(1-y)*C12AD+(1-x)*y*C12BC+(1-x)*(1-y)*C12BD;
    else
        %eg AlGaSb
        [aAC,C11AC,C12AC]=getMaterial(AC);
        [aBC,C11BC,C12BC]=getMaterial(BC);
        %a=vegard(x,y,aAC,0,aBC,0);
        %C11i=vegard(x,y,C11AC,0,C11BC,0);
        %C12i=vegard(x,y,C12AC,0,C12BC,0);
        a=(aAC)*x + (aBC)*(1-x);
        C11i=(C11AC)*x + (C11BC)*(1-x);
        C12i=(C12AC)*x + (C12BC)*(1-x);
    end
else
    if y < 1
        %eg GaAsP
        [aAC,C11AC,C12AC]=getMaterial(AC);
        [aAD,C11AD,C12AD]=getMaterial(AD);
        %a=vegard(x,y,aAC,aAD,0,0);
        %C11i=vegard(x,y,C11AC,C11AD,0,0);
        %C12i=vegard(x,y,C12AC,C12AD,0,0);
        a=(aAC)*y + (aAD)*(1-y);
        C11i=(C11AC)*y + (C11AD)*(1-y);
        C12i=(C12AC)*y + (C12AD)*(1-y);
    else
        %eg GaAs
        [a,C11i,C12i]=getMaterial(AC);
    end
end
%[1]S. Adachi, Properties of group-IV, III-V and II-VI semiconductors.
%   Chichester, England; Hoboken, NJ: John Wiley & Sons, 2005.
%[C11a,C12a]=adachi(a);
C11a=exp((-4.16629.*log(a)+9.70098))*100; %[GPa]
C12a=exp((-3.10462.*log(a)+7.10375))*100; %[GPa]
