function [a0] = edzerostress(A1, t1, a1, A2, t2, a2)
%Funtion edzerostress returns the effective lattice constant of a...
%strained superlattice based on given material parameters.
%
% Copyright (C) 2014--2016 Stephen J. Polly and Alex J. Grede
% GPL v3, See LICENSE for details
% This function is part of straincomp (https://nanohub.org/resources/straincomp)
a0=(A1*t1*a1*a2^2 + A2*t2*a2*a1^2)/(A1*t1*a2^2 + A2*t2*a1^2);
end
