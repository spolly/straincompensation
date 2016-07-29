function [ hcOpt, mCETOpt, optmaxmCET] = weightedStrainOpt( m, n,AQD, ASC, aSub, aQD,...
    aSC, QDHeight, WLThickness, mCET, nu, alpha,lambda,acc )
%Funtion weightedStrainOpt returns the maximum SL thickness, its related 
%SC thickness, and themaximum number of superlattice repeat units, 
%with given material parameters.
%
% Copyright (C) 2014--2015 Stephen J. Polly and Alex J. Grede
% GPL v3, See LICENSE for details
% This function is part of straincomp (https://nanohub.org/resources/straincomp)
mCETOpt=mCET*(m);

%Effective lattice constant of mCET
%QD
a0SLQDmCET=edzerostress(AQD, QDHeight, aQD, ASC, mCETOpt, aSC); %[A]
%WL
a0SLWLmCET=edzerostress(AQD, WLThickness, aQD, ASC, mCETOpt, aSC); %[A]

%Calculation of absolute effective misfit strain mCET
%QD
e0SLQDmCET=(a0SLQDmCET-aSub)/aSub;
%WL
e0SLWLmCET=(a0SLWLmCET-aSub)/aSub;

%Calculation of critical SL thickness mCET
%QD
hcmCETQD=matthewsblakeslee(1,a0SLQDmCET,e0SLQDmCET,nu,alpha,lambda,0.001); %[A]
%WL
hcmCETWL=matthewsblakeslee(1,a0SLWLmCET,e0SLWLmCET,nu,alpha,lambda,0.001); %[A]


%Calculation of maximum SL repeat units mCET
%QD
optmaxmCETQD=(hcmCETQD/(mCETOpt+max([QDHeight WLThickness])));
%WL
optmaxmCETWL=(hcmCETWL/(mCETOpt+max([QDHeight WLThickness])));


if abs(optmaxmCETQD-optmaxmCETWL)/optmaxmCETWL < acc
    %if the two values are equal to within the supplied precision
     hcOpt=hcmCETQD;
     optmaxmCET=optmaxmCETWL;
elseif (optmaxmCETQD < 1) && (optmaxmCETWL < 1)
    %if no condition allows for at least 1 repeat layer
     hcOpt=hcmCETQD;
     mCETOpt=mCET;
     optmaxmCET=optmaxmCETWL;
     
else
    %keep looking
    if optmaxmCETQD < optmaxmCETWL
        if n==0
            m=m+1;
        else
            m=m+1/(2^n);
            n=n+1;
        end
    else
        m=m-1/(2^n);
        n=n+1;
    end
    
    [hcOpt, mCETOpt, optmaxmCET]=weightedStrainOpt(m,n,AQD,ASC,aSub,aQD,aSC,QDHeight,WLThickness,mCET,nu,alpha,lambda,acc);
end