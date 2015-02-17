% GUI backend for Rappture
%
% Rappture documentation available at http://rapture.org
%
% Copyright (C) 2014--2015 Stephen J. Polly and Alex J. Grede
% GPL v3, See LICENSE for details
% This function is part of straincomp (https://nanohub.org/resources/straincomp)
% ----------------------------------------------------------------------
%  MAIN PROGRAM - generated by the Rappture Builder
% ----------------------------------------------------------------------

% open the XML file containing the run parameters
% the file name comes in from the command-line via variable 'infile'
io = rpLib(infile);

mats = {"Al", "Ga", "In", "Al_(x)Ga_(1-x)", "Al_(x)In_(1-x)", "In_(x)Ga_(1-x)",...
        "P", "As", "Sb", "As_(y)P_(1-y)", "As_(y)Sb_(1-y)", "Sb_(y)P_(1-y)"};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get input values from Rappture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get input value for input.number(QDDia) and convert to nm
str = rpLibGetString(io,'input.number(QDDia).current');
[QDDia,err] = rpUnitsConvertDbl(str, 'nm');

% get input value for input.number(QDH) and convert to nm
str = rpLibGetString(io,'input.number(QDH).current');
[QDH,err] = rpUnitsConvertDbl(str, 'nm');

% get input value for input.number(QDDen) and convert to cm-2
str = rpLibGetString(io,'input.number(QDDen).current');
[QDDen,err] = rpUnitsConvertDbl(str, 'cm-2');

% get input value for input.number(WL) and convert to nm
str = rpLibGetString(io,'input.number(WL).current');
[WL,err] = rpUnitsConvertDbl(str, 'nm');

% get input value for input.group(Sub).choice(SubIII)
SubIII = mats{str2num(rpLibGetString(io,'input.group(Sub).choice(SubIII).current'))}

% get input value for input.group(Sub).choice(SubV)
SubV = mats{str2num(rpLibGetString(io,'input.group(Sub).choice(SubV).current'))};

% get input value for input.group(Sub).number(Subx)
Subx = rpLibGetDouble(io,'input.group(Sub).number(Subx).current');
if (length(SubIII) < 3)
  Subx = 1;
end

% get input value for input.group(Sub).number(Suby)
Suby = rpLibGetDouble(io,'input.group(Sub).number(Suby).current');
if (length(SubV) < 3)
  Suby = 1;
end

% get input value for input.group(QD).choice(QDIII)
QDIII = mats{str2num(rpLibGetString(io,'input.group(QD).choice(QDIII).current'))};

% get input value for input.group(QD).choice(QDV)
QDV = mats{str2num(rpLibGetString(io,'input.group(QD).choice(QDV).current'))};

% get input value for input.group(QD).number(QDx)
QDx = rpLibGetDouble(io,'input.group(QD).number(QDx).current');
if (length(QDIII) < 3)
  QDx = 1;
end

% get input value for input.group(QD).number(QDy)
QDy = rpLibGetDouble(io,'input.group(QD).number(QDy).current');
if (length(QDV) < 3)
  QDy = 1;
end

% get input value for input.group(SC).choice(SCIII)
SCIII = mats{str2num(rpLibGetString(io,'input.group(SC).choice(SCIII).current'))};

% get input value for input.group(SC).choice(SCV)
SCV = mats{str2num(rpLibGetString(io,'input.group(SC).choice(SCV).current'))};

% get input value for input.group(SC).number(SCx)
SCx = rpLibGetDouble(io,'input.group(SC).number(SCx).current');
if (length(SCIII) < 3)
  SCx = 1;
end

% get input value for input.group(SC).number(SCy)
SCy = rpLibGetDouble(io,'input.group(SC).number(SCy).current');
if (length(SCV) < 3)
  SCy = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Add your code here for the main body of your program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% spit out progress messages as you go along...
%rpUtilsProgress(0, 'Starting...');
%rpUtilsProgress(5, 'Loading data...');
%rpUtilsProgress(50, 'Half-way there');
%rpUtilsProgress(100, 'Done');

% Unit Conversions -----------------------------------------
QDDensity=QDDen * 1e-16; %Angstrom^-2 {5e-6 A^-2 = 5e10 cm^-2}
QDDiameter=QDDia * 10; %Angstrom
QDHeight=QDH * 10; %Angstrom
WLThickness=WL * 10; %Angstrom

% Parse Material Selection ---------------------------------
[AC,BC,AD,BD] = parseSelection(SubIII, SubV);
[aSub,c11iSub,c12iSub,c11aSub,c12aSub] = calcMaterial(AC,AD,Subx,BC,BD,Suby);

[AC,BC,AD,BD] = parseSelection(QDIII, QDV);
[aQD,c11iQD,c12iQD,c11aQD,c12aQD] = calcMaterial(AC,AD,QDx,BC,BD,QDy);

[AC,BC,AD,BD] = parseSelection(SCIII, SCV);
[aSC,c11iSC,c12iSC,c11aSC,c12aSC] = calcMaterial(AC,AD,SCx,BC,BD,SCy);


% Stiffness Calculations ----------------------------------
%Interpolated stiffness ratios
ASCi=c11iSC + c12iSC - (2*c12iSC.^2./c11iSC);
AQDi=c11iQD + c12iQD - (2*c12iQD.^2./c11iQD);

%Adachi equation stiffness ratios
ASCa=c11aSC + c12aSC - (2*c12aSC.^2./c11aSC);
AQDa=c11aQD + c12aQD - (2*c12aQD.^2./c11aQD);


% QD Volume Calculations -----------------------------------
% QD as spherical cap
vQDSphCap=pi.*QDHeight./6 .* (3 .*(QDDiameter/2).^2 + QDHeight.^2); %[A^3]

% QD as cylinder
QDsigma=(QDDiameter/2)^2*pi; %QD base area [A^2]
vQDCyl=QDHeight*QDsigma; %[A^3]

% QD as oblate hemispheroid
vQDOblSph=((4/3)*pi*(QDDiameter/2)^2*QDHeight)/2; %[A^3]

% Strain Compensation Calculations -------------------------
% CET QD Thickness
CETQDi=QDHeight*((AQDi .* aSC^2 .* (aSub - aQD))./(ASCi .* aQD^2 .* (aSC - aSub))); %[A]
CETQDa=QDHeight*((AQDa .* aSC^2 .* (aSub - aQD))./(ASCa .* aQD^2 .* (aSC - aSub))); %[A]

%CET WL Thickness
CETWLi=WLThickness*((AQDi .* aSC^2 .* (aSub - aQD))./(ASCi .* aQD^2 .* (aSC - aSub))); %[A]
CETWLa=WLThickness*((AQDa .* aSC^2 .* (aSub - aQD))./(ASCa .* aQD^2 .* (aSC - aSub))); %[A]

%Effective coverage of QD material (Cylinder)
tQDWLCyl=(QDsigma*QDDensity)*QDHeight+(1-QDsigma*QDDensity)*WLThickness; %[A]

%mCET Cylinder weighted SC thickness
mCETcyli=(QDsigma*QDDensity)*CETQDi + (1-QDsigma*QDDensity)*CETWLi; %[A]
mCETcyla=(QDsigma*QDDensity)*CETQDa + (1-QDsigma*QDDensity)*CETWLa; %[A]

%Effective coverage of QD material (Oblate Hemispheroid)
tQD=vQDOblSph*QDDensity; %average thickness of QD per area [A]
tQDWL=WLThickness+tQD; %WL is treated as external to QD [A]

%mCET Oblate Hemispheroid
mCETsphi=tQDWL*((AQDi .* aSC^2 .* (aSub - aQD))./(ASCi .* aQD^2 .* (aSC - aSub))); %[A]
mCETspha=tQDWL*((AQDa .* aSC^2 .* (aSub - aQD))./(ASCa .* aQD^2 .* (aSC - aSub))); %[A]

%Interpolated stiffness ratios
ASCi=c11iSC + c12iSC - (2*c12iSC.^2./c11iSC);
AQDi=c11iQD + c12iQD - (2*c12iQD.^2./c11iQD);

%Adachi equation stiffness ratios
ASCa=c11aSC + c12aSC - (2*c12aSC.^2./c11aSC);
AQDa=c11aQD + c12aQD - (2*c12aQD.^2./c11aQD);

%Effective lattice constant of CET
a0SLQDCETi=edzerostress(AQDi, QDHeight, aQD, ASCi, CETQDi, aSC); %[A]
a0SLQDCETa=edzerostress(AQDa, QDHeight, aQD, ASCa, CETQDa, aSC); %[A]

%Effective lattice constant of mCET Cylinder
%QD
a0SLQDmCETcyli=edzerostress(AQDi, QDHeight, aQD, ASCi, mCETcyli, aSC); %[A]
a0SLQDmCETcyla=edzerostress(AQDa, QDHeight, aQD, ASCa, mCETcyla, aSC); %[A]
%WL
a0SLWLmCETcyli=edzerostress(AQDi, WLThickness, aQD, ASCi, mCETcyli, aSC); %[A]
a0SLWLmCETcyla=edzerostress(AQDa, WLThickness, aQD, ASCa, mCETcyla, aSC); %[A]

%Effective lattice constant of mCET Oblate Hemispheroid
%QD
a0SLQDmCETsphi=edzerostress(AQDi, vQDOblSph/QDsigma + WLThickness, aQD, ASCi, mCETsphi, aSC); %[A]
a0SLQDmCETspha=edzerostress(AQDa, vQDOblSph/QDsigma + WLThickness, aQD, ASCa, mCETspha, aSC); %[A]
%WL
a0SLWLmCETsphi=edzerostress(AQDi, WLThickness, aQD, ASCi, mCETsphi, aSC); %[A]
a0SLWLmCETspha=edzerostress(AQDa, WLThickness, aQD, ASCa, mCETspha, aSC); %[A]

%Calculation of tetragonally distorted lattice constant
apQDi=(aQD-aSub)*(1 + 2 * c12iQD/c11iQD)+aSub; %[A]
apQDa=(aQD-aSub)*(1 + 2 * c12aQD/c11aQD)+aSub; %[A]

a0pSCi=(aSC-aSub)*(1 + 2 * c12iSC/c11iSC)+aSub; %[A]
a0pSCa=(aSC-aSub)*(1 + 2 * c12aSC/c11aSC)+aSub; %[A]

%Calculation of absolute misfit strain
e0QD=abs(aSub-aQD)/aSub;
e0SC=abs(aSub-aSC)/aSub;

%Calculation of absolute effective misfit strain CET
e0SLQDCETi=abs(aSub-a0SLQDCETi)/aSub;
e0SLQDCETa=abs(aSub-a0SLQDCETa)/aSub;

%Calculation of absolute effective misfit strain mCET Cylinder
%QD
e0SLQDmCETcyli=abs(aSub-a0SLQDmCETcyli)/aSub;
e0SLQDmCETcyla=abs(aSub-a0SLQDmCETcyla)/aSub;
%WL
e0SLWLmCETcyli=abs(aSub-a0SLWLmCETcyli)/aSub;
e0SLWLmCETcyla=abs(aSub-a0SLWLmCETcyla)/aSub;

%Calculation of absolute effective misfit strain mCET Oblate Hemispheroid
%QD
e0SLQDmCETsphi=abs(aSub-a0SLQDmCETsphi)/aSub;
e0SLQDmCETspha=abs(aSub-a0SLQDmCETspha)/aSub;
%WL
e0SLWLmCETsphi=abs(aSub-a0SLWLmCETsphi)/aSub;
e0SLWLmCETspha=abs(aSub-a0SLWLmCETspha)/aSub;

%Calculation of Poisson Ratio
nuQDi=c12iQD/(c11iQD+c12iQD);
nuQDa=c12aQD/(c11aQD+c12aQD);

nuSCi=c12iSC/(c11iSC+c12iSC);
nuSCa=c12aSC/(c11aSC+c12aSC);

%Pick the largest Poisson ratio to err toward underestimate of hc
if nuQDi > nuSCi
    nui=nuQDi;
else
    nui=nuSCi;
end

if nuQDa > nuSCa
    nua=nuQDa;
else
    nua=nuSCa;
end

alpha=pi/3;
lambda=pi/3;

%Calculation of critical SL thickness CET
hcCETi=matthewsblakeslee(1,a0SLQDCETi,e0SLQDCETi,nui,alpha,lambda,0.001); %[A]
hcCETa=matthewsblakeslee(1,a0SLQDCETa,e0SLQDCETa,nua,alpha,lambda,0.001); %[A]

%Calculation of critical SL thickness mCET Cylinder
%QD
hcmCETQDcyli=matthewsblakeslee(1,a0SLQDmCETcyli,e0SLQDmCETcyli,nui,alpha,lambda,0.001); %[A]
hcmCETQDcyla=matthewsblakeslee(1,a0SLQDmCETcyla,e0SLQDmCETcyla,nua,alpha,lambda,0.001); %[A]
%WL
hcmCETWLcyli=matthewsblakeslee(1,a0SLWLmCETcyli,e0SLWLmCETcyli,nui,alpha,lambda,0.001); %[A]
hcmCETWLcyla=matthewsblakeslee(1,a0SLWLmCETcyla,e0SLWLmCETcyla,nua,alpha,lambda,0.001); %[A]

%Calculation of critical SL thickness mCET Oblate Hemispheroid
%QD
hcmCETQDsphi=matthewsblakeslee(1,a0SLQDmCETsphi,e0SLQDmCETsphi,nui,alpha,lambda,0.001); %[A]
hcmCETQDspha=matthewsblakeslee(1,a0SLQDmCETspha,e0SLQDmCETspha,nua,alpha,lambda,0.001); %[A]
%WL
hcmCETWLsphi=matthewsblakeslee(1,a0SLWLmCETsphi,e0SLWLmCETsphi,nui,alpha,lambda,0.001); %[A]
hcmCETWLspha=matthewsblakeslee(1,a0SLWLmCETspha,e0SLWLmCETspha,nua,alpha,lambda,0.001); %[A]
 
%Calculation of maximum SL repeat units CET
maxCETi=floor(hcCETi/(CETQDi+QDHeight));
maxCETa=floor(hcCETa/(CETQDa+QDHeight));

%Calculation of maximum SL repeat units mCET Cylinder
%QD
maxmCETQDcyli=floor(hcmCETQDcyli/(mCETcyli+QDHeight));
maxmCETQDcyla=floor(hcmCETQDcyla/(mCETcyla+QDHeight));
%SC
maxmCETWLcyli=floor(hcmCETWLcyli/(mCETcyli+WLThickness));
maxmCETWLcyla=floor(hcmCETWLcyla/(mCETcyla+WLThickness));

%Calculation of maximum SL repeat units mCET Oblate Hemispheroid
%QD
maxmCETQDsphi=floor(hcmCETQDsphi/(mCETsphi+vQDOblSph/QDsigma+WLThickness));
maxmCETQDspha=floor(hcmCETQDspha/(mCETspha+vQDOblSph/QDsigma+WLThickness));
%SC
maxmCETWLsphi=floor(hcmCETWLsphi/(mCETsphi+WLThickness));
maxmCETWLspha=floor(hcmCETWLspha/(mCETspha+WLThickness));




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save output values back to Rappture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% save output value for output.string(results)
rpLibPutString(io,'output.log',...
               sprintf('%s\n', 'Literature/Interpolated (i) or Empirically Calculated Values (e) ------'),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '+-----+------------+------------+------------+------------+------------+'),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '| Mat |   lc [A]   |  C11i[GPa] |  C12i[GPa] |  C11e[GPa] |  C12e[GPa] |'),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '+-----+------------+------------+------------+------------+------------+'),1);
fmt = '| %3s | %0.4e | %0.4e | %0.4e | %0.4e | %0.4e |\n';
rpLibPutString(io,'output.log',...
               sprintf(fmt,'Sub',aSub,c11iSub,c12iSub,c11aSub,c12aSub),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt,'QD',aQD,c11iQD,c12iQD,c11aQD,c12aQD),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt,'SC',aSC,c11iSC,c12iSC,c11aSC,c12aSC),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '+-----+------------+------------+------------+------------+------------+'),1);

rpLibPutString(io,'output.log',...
               sprintf('\n%s\n', 'QD Volumes [nm^3] ----------------------------------------------------'),1);
rpLibPutString(io,'output.log',sprintf('%9s: %0.4e\n','Sph. Cap',vQDSphCap/1000),1);
rpLibPutString(io,'output.log',sprintf('%9s: %0.4e\n','Cylinder',vQDCyl/1000),1);
rpLibPutString(io,'output.log',sprintf('%9s: %0.4e\n','Obl. Sph.',vQDOblSph/1000),1);

rpLibPutString(io,'output.log',...
               sprintf('\n%s\n', 'Strain Compensation --------------------------------------------------'),1);

rpLibPutString(io,'output.log',...
               sprintf('%s\n', '+----------+------------+----------------------+'),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '|  Params  |  Req. SC   |    Eff QD+WL Thick   |'),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '|   Used   |  Thick[nm] | [nm^3 cm^-2] or [nm] |'),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '+----------+------------+----------------------+'),1);
fmt = '| %8s | %0.4e |     %0.4e       |\n';
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '| CET (QD Height as QW)                        |'),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt, 'Lit (i)', CETQDi/10, QDHeight/10),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt, 'Calc (e)', CETQDa/10, QDHeight/10),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '| Modified CET (QD as Cylinder)                |'),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt, 'Lit (i)', mCETcyli/10, tQDWLCyl/10),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt, 'Calc (e)', mCETcyla/10, tQDWLCyl/10),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '| Modified CET (QD as Oblate-Hemispheroid)     |'),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt, 'Lit (i)', mCETsphi/10, tQDWL/10),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt, 'Calc (e)', mCETspha/10, tQDWL/10),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '+----------+------------+----------------------+'),1);

rpLibPutString(io,'output.log',...
               sprintf('\n%s\n', 'Input values ---------------------------------------------------------'),1);

fmt1 = '| %15s | %-15s |\n';
fmt2 = '| %15s | %0.4e %-4s |\n';

rpLibPutString(io,'output.log',...
               sprintf('%s\n', '+-----------------+-----------------+'),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '|      Input      |      Value      |'),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '+-----------------+-----------------+'),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt1, 'Substrate (III)', SubIII),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt1, 'Substrate (V)', SubV),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt2, 'Substrate (x)', Subx, ''),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt2, 'Substrate (y)', Suby, ''),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt1, 'QD (III)', QDIII),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt1, 'QD (V)', QDV),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt2, 'QD (x)', QDx, ''),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt2, 'QD (y)', QDy, ''),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt1, 'SC (III)', SCIII),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt1, 'SC (V)', SCV),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt2, 'SC (x)', SCx, ''),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt2, 'SC (y)', SCy, ''),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt2, 'QD Diameter', QDDia, 'nm'),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt2, 'QD/QW Height', QDH, 'nm'),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt2, 'QD Density', QDDen, 'cm-2'),1);
rpLibPutString(io,'output.log',...
               sprintf(fmt2, 'WL Thickness', WL, 'nm'),1);
rpLibPutString(io,'output.log',...
               sprintf('%s\n', '+-----------------+-----------------+'),1);

rpLibResult(io);
quit;
