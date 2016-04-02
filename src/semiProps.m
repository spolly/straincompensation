function [a,C11i,C12i,C11a,C12a] = semiProps(Props, Param)
% SEMIPROPS returns the parameters for compound semi
%
% Adapted from SAMIS (https://github.com/agrede/SAMIS)
% Copyright (C) 2014--2015 Stephen J. Polly and Alex J. Grede
% GPL v3, See LICENSE for details
% This function is part of straincomp (https://nanohub.org/resources/straincomp)
Semi = struct;

if (length(Props.groupB)<1)
% Group IV assumed
  % Only assuming one group A for now
  mat = Props.groupA{1};
  Semi = strainProps(Param.(Props.crystalStructure).(mat));
elseif (length(Props.groupA)+length(Props.groupB)<3)
  % Binary Assumed
  mat = strcat(Props.groupA{find(Props.weightsA>0)},...
               Props.groupB{find(Props.weightsB>0)});
  Semi = strainProps(Param.(Props.crystalStructure).(mat));
else
  % Combination of ternaries (only can do up to quaternary?)
  [mats, weights] = ternaryPermitations(Props.groupA,Props.groupB,...
                                        Props.weightsA,Props.weightsB);
  Semi.mats = mats;
  Semi.weights = weights;
  % Initialize Variables
  Semi.a = 0;
  Semi.C11 = 0;
  Semi.C12 = 0;

  % Add weighted combinations
  for k=1:size(mats,2)
    A = strainProps(Param.(Props.crystalStructure).(mats{1,k}));
    B = strainProps(Param.(Props.crystalStructure).(mats{2,k}));
    C = struct;

    if (isfield(Param.(strcat('Bow_',Props.crystalStructure)),mats{3,k}))
      C = strainProps(Param.(strcat('Bow_',Props.crystalStructure)).(mats{3,k}));
    else
      C.a = 0;
      C.C11 = 0;
      C.C12 = 0;
    endif

    Semi.a = Semi.a + weights(3,k).*bowing(A.a,B.a,C.a,weights(:,k));
    Semi.C11 = Semi.C11 + weights(3,k).*bowing(A.C11,B.C11,C.C11,...
                                               weights(:,k));
    Semi.C12 = Semi.C12 + weights(3,k).*bowing(A.C12,B.C12,...
                                               C.C12,weights(:,k));
  endfor
  % Divide by sum of weights
  Semi.a = Semi.a./sum(weights(3,:));
  Semi.C11 = Semi.C11./sum(weights(3,:));
  Semi.C12 = Semi.C12./sum(weights(3,:));
endif
%[1]S. Adachi, Properties of group-IV, III-V and II-VI semiconductors.
%   Chichester, England; Hoboken, NJ: John Wiley & Sons, 2005.
%[C11a,C12a]=adachi(a);
a = Semi.a;
C11i = Semi.C11;
C12i = Semi.C12;
C11a=exp((-4.16629.*log(a)+9.70098))*100; %[GPa]
C12a=exp((-3.10462.*log(a)+7.10375))*100; %[GPa]

endfunction
