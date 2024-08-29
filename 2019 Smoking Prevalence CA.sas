
/*libname xptfile xport "C:\Users\wrn0\GitHub\py2sas-brfss\data\LLCP2019.xpt";*/
libname library "C:\Users\wrn0\GitHub\py2sas-brfss\data";

proc copy inlib=xptfile outlib=library;
run;


Proc contents data=library.Llcp2019;
run;


data library.Llcp2019_subset;
    set library.Llcp2019;
    where _STATE = 6;
run;

data library.Llcp2019_subset_recoded;
    set library.Llcp2019_subset;
    attrib CURRENTUSE label="Current Smoker" length=3;
    
    /* Recode _RFSMOK3 to binary variable CURRENTUSE */
    if _RFSMOK3 = 1 then CURRENTUSE = 0; /* No */
    else if _RFSMOK3 = 2 then CURRENTUSE = 1; /* Yes */
    else if _RFSMOK3 = 9 then CURRENTUSE = .; /* Nonresponse */

	attrib VETERAN label="Veteran" length=3;
	/* Recode VETERAN3 to binary variable VETERAN */
    if VETERAN3 = 1 then VETERAN = 1; /* Yes */
    else if VETERAN3 = 2 then VETERAN = 0; /* Yes */
    else if VETERAN3 = 7 then VETERAN = .; /* Nonresponse */
	else if VETERAN3 = 9 then VETERAN = .; /* Nonresponse */
    
    format CURRENTUSE YESandNOwZerofmt.; /* Make sure YESandNOwZerofmt. is defined */
	format VETERAN YESandNOwZerofmt.; /* Make sure YESandNOwZerofmt. is defined */
run;

proc contents data=library.Llcp2019_subset_recoded;
run;


/*This gives the exact same values as samplics */
proc surveyfreq data=library.Llcp2019_subset_recoded NOMCAR;
tables VETERAN*CURRENTUSE/ cl(TYPE=LOGIT) row;
strata _STSTR;
cluster _PSU;
weight _LLCPWT;
run;

proc surveyfreq data=library.Llcp2019_subset_recoded NOMCAR;
tables VETERAN3*CURRENTUSE/ cl(TYPE=LOGIT) row;
strata _STSTR;
cluster _PSU;
weight _LLCPWT;
run;

proc sort data=library.Llcp2019_subset_recoded;
by _STSTR _PSU;
run;

PROC CROSSTAB data=library.Llcp2019_subset_recoded FILETYPE=SAS DESIGN=WR;
NEST _STSTR;
WEIGHT _LLCPWT;
CLASS VETERAN;
TABLES (VETERAN)*CURRENTUSE;
TEST CHISQ LLCHISQ;

SETENV ROWWIDTH=12 COLWIDTH=10 LABWIDTH=25;

PRINT NSUM="SAMSIZE" WSUM="POPSIZE" ROWPER SEROW LOWROW UPROW /
 STEST=DEFAULT WSUMFMT=F9.0 SEROWFMT=F6.3 LOWROWFMT=F6.3 UPROWFMT=F6.3
 STESTVALFMT=F10.2;
run;
