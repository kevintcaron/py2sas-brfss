/*Kevin's Sample BRFSS Estimates in SAS - SD in 2022*/

/*create library*/
libname library "C:\Users\wrn0\GitHub\py2sas-brfss\data";

/*create sas dataset in data folder*/
/*libname xptfile xport "C:\Users\wrn0\GitHub\py2sas-brfss\data\LLCP2022.xpt";*/
proc copy inlib=xptfile outlib=library;
run;

/*show contents of dataset*/
Proc contents data=library.Llcp2022;
run;

/*create subset of dataset for south dakota*/
data library.Llcp2022_subset;
    set library.Llcp2022;
    where _STATE = 46;
run;

/*recode south dakota data to ignore non-response*/
data library.Llcp2022_subset_recoded;
    set library.Llcp2022_subset;
    attrib CURRENTUSE label="Current Smoker" length=3;
    
    /* Recode _RFSMOK3 to binary variable CURRENTUSE */
    if _RFSMOK3 = 1 then CURRENTUSE = 0; /* No */
    else if _RFSMOK3 = 2 then CURRENTUSE = 1; /* Yes */
    else if _RFSMOK3 = 9 then CURRENTUSE = .; /* Nonresponse */
run;


/*conduct the weighted analysis with the SD subset recoded to eliminate nonrespnse*/
PROC SURVEYFREQ DATA=library.Llcp2022_subset_recoded;
  STRATA _STSTR;
  CLUSTER _PSU;
  WEIGHT _LLCPWT;
  TABLES CURRENTUSE / ROW CL;
RUN;

/*conduct the weighted means analysis with the SD subset recoded to eliminate nonrespnse*/
PROC SURVEYMEANS DATA=library.Llcp2022_subset_recoded MEAN STDERR CLM;
  STRATA _STSTR;              /* Stratification variable */
  CLUSTER _PSU;               /* Primary Sampling Unit */
  WEIGHT _LLCPWT;             /* Sampling weights */
  VAR CURRENTUSE;             /* Variable of interest */
RUN;



/*conduct the weighted analysis using crosstab*/
/*PROC CROSSTAB DATA=library.Llcp2022_subset_recoded DESIGN=WR;*/
/*  NEST _STSTR _PSU;    /* Specify stratification and clustering */*/
/*  WEIGHT _LLCPWT;      /* Specify survey weight */*/
/*  TABLES CURRENTUSE;   /* Cross-tabulation of interest */*/
/*  PRINT / STYLE=NORMAL; /* Request standard output */*/
/*RUN;*/
