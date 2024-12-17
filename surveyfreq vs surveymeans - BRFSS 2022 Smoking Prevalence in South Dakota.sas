%let path = C:\Users\wrn0\GitHub\py2sas-brfss\data;
libname library "&path.";

proc copy inlib=xptfile outlib=library;
run;

/*Restrict data to South Dakota*/
data library.llcp2022_sd;
    set library.llcp2022;
    where _STATE = 46;
run;

/*Re-code smoker variable to binary and null for non response*/
data library.llcp2022_sd_recoded;
    set library.llcp2022_sd;
    attrib CURRENTUSE label="Current Smoker";
    
    /* Recode _RFSMOK3 to binary variable CURRENTUSE */
    if _RFSMOK3 = 1 then CURRENTUSE = 0;
    else if _RFSMOK3 = 2 then CURRENTUSE = 1;
    else if _RFSMOK3 = 9 then CURRENTUSE = .;

	/* Recode _RFSMOK3 to constant */
    if _RFSMOK3 = 1 then CONST = 1;
    else if _RFSMOK3 = 2 then CONST = 1;
    else if _RFSMOK3 = 9 then CONST = 1;
run;


/*Prevalence and 95% CIs with surveyfreq*/
proc surveyfreq data=library.Llcp2022_sd_recoded;
  strata _STSTR;
  cluster _PSU;
  weight _LLCPWT;
  tables CURRENTUSE / row cl;
run;

/*Prevalence and 95% CIs with surveymeans*/
proc surveymeans data=library.Llcp2022_sd_recoded mean stderr clm;
  strata _STSTR;
  cluster _PSU;
  weight _LLCPWT;
  var CURRENTUSE;
run;
