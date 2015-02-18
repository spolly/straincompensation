function [hc]=matthewsblakeslee(hi,a0,e0,nu,alpha,lambda,acc)
%Funtion matthewsblakeslee returns the critical thickness
%of a superlattice with given material parameters.
%
% Copyright (C) 2014--2015 Stephen J. Polly and Alex J. Grede
% GPL v3, See LICENSE for details
% This function is part of straincomp (https://nanohub.org/resources/straincomp)
try
    hc=(a0/sqrt(2))/(2 * pi * abs(e0))...
        *(1 - nu * cos(alpha)^2)/((1 + nu)*cos(lambda))...
        *(log(hi/(a0/sqrt(2)))+1);
    if hc <= 0
        hc=matthewsblakeslee(hi+hi, a0, e0, nu, alpha, lambda, acc);
    elseif abs(hc-hi)/hc > acc
        hc=matthewsblakeslee(hc, a0, e0, nu, alpha, lambda, acc);
    end
catch
   hc=0;
end
end

