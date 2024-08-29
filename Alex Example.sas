***************************************************************************************************
* Prepared by: Alex Schwank
* 
* Description: 2019-2022 BRFSS Quit Attempts
*
* Program name: BRFFS_2019_2022 Quit Attempts.sas
*
* Program Path: "C:\Users\rtv3\OneDrive - CDC\Evaluation\NTCP Evaluation Documents\Personal\Long-Term Outcome Analysis\BRFFS_2019_2022_Quit Attempts.sas" ;
*
*****************************************************************************************************;

Libname library "C:\Users\wrn0\GitHub\py2sas-brfss\data";
run;

proc format library=library cntlout=library.formats; 
options nofmterr;

proc ximport out=library.Llcp2019
    datafile="C:\Users\wrn0\GitHub\py2sas-brfss\data\LLCP2019.xpt";
run;

libname xptfile xport "C:\Users\wrn0\GitHub\py2sas-brfss\data\LLCP2019.xpt";
libname library "C:\Users\wrn0\GitHub\py2sas-brfss\data";

proc copy inlib=xptfile outlib=library;
run;



Proc contents data=library.Llcp2019;
run;
/*CREATE FORMATS FOR ANALYSIS*/

Proc format library=library;  /* Use the library reference */
 Value sexfmt
   1 = "Male"
   2 = "Female";
Run;

Proc format library=library;  
	Value Statefmt
		1 = "Alabama"
		2 = "Alaska"
		4 = "Arizona"
		5 = "Arkansas"
		6 = "California" 
		8 = "Colorado"
		9 = "Connecticut"
		10 = "Delaware" 
		11 = "District Of Columbia" 
		12 = "Florida"
		13 = "Georgia" 
		15 = "Hawaii" 
		16 = "Idaho"
		17 = "Illionis"
		18 = "indiana"
		19 = "Iowa" 
		20 = "Kansas" 
		21 = "Kentucky" 
		22 = "Louisana"
		23 = "Maine"
		24 = "Maryland"
		25 = "Massachusetts"
		26 = "Michigan"
		27 = "Minnesota" 
		28 = "Mississippi" 
		29 = "Missouri" 
		30 = "Montana"
		31 = "Nebraska" 
		32 = "Nevada"
		33 = "New Hampshire" 
		34 = "New Jersey"
		35 = "New Mexico"
		36 = "New York"
		37 = "North Carolina"
		38 = "North Dakota" 
		39 = "Ohio" 
		40 = "Oklahoma" 
		41 = "Oregon"
		42 = "Pennsylvania" 
		44 = "Rhode Island"
		45 = "South Carolina" 
		46 = "South Dakota" 
		47 = "Tennessee"
		48 = "Texas" 
		49 = "Utah" 
		50 = "Vermont"
		51 = "Virginia" 
		53 = "Washington" 
		54 = "West Virginia"
		55 = "Wisconsin" 
		56 = "Wyoming"
		66 = "Guam"
		72 = "Puerto Rico"
		78 = "Virgin Islands"
;
Run;

Proc format library=library; 
 VALUE _3RACEGRfmt                                                                                                                                                                                
           .                   =    "Missing"                                                                                                                                                                                                                                                                                                          
           1                   =    "White only, Non-Hispanic"                                                                                                                                     
           2                   =    "Black only, Non-Hispanic"                                                                                                                                     
           3                   =    "Other race only, Non-Hispanic"                                                                                                                                
           4                   =    "Multiracial, Non-Hispanic"                                                                                                                                    
           5                   =    "Hispanic"       ;                                                                                                                                               
Run;

Proc format library=library;  
 Value AGEfmt
   1 = "18 - 24"
   2 = "25 - 44"
   3 = "45 - 64"
   4 = "65 or Older"
;
Run;

Proc format library=library; 
 Value EDUfmt
   1 = "Less than College/Technical College Graduate"
   2 = "Gradute from College/Techincal School or High School"
;
Run;

Proc format library=library; 
 Value YESandNOwZerofmt
   1 = "yes"
   0 = "No"
;
Run;

Proc format library=library; 
 Value Smoker3fmt
   1 = "Current"
   2 = "Former"
   3 = "Never"
;
Run;

/*************2019************/;

Data BRFSS19_CORE (keep=_RACEGR3 _STATE IYEAR _LLCPWT _PSU _STSTR _SEX  _AGE_G _EDUCAG STOPSMK2 _SMOKER3 _RFSMOK3 USENOW3 MENTHLTH);
set library.Llcp2019; 
run;
Data BRFSS19_CORE_1;
SET BRFSS19_CORE;
RENAME  _LLCPWT=_FINALWT;

if IYEAR = 2020 THEN IYEAR= 2019;
if IYEAR = 2019 THEN IYEAR= 2019;

attrib RACE label="RACE" length=3;
if _RACEGR3 = 9 THEN RACE = .;
	ELSE IF _RACEGR3=1 THEN RACE=1;
	ELSE IF _RACEGR3=2 THEN RACE=2;
	ELSE IF _RACEGR3=3 THEN RACE=3;
	ELSE IF _RACEGR3=4 THEN RACE=4;
	ELSE IF _RACEGR3=5 THEN RACE=5;
format RACE _3RACEGRfmt.;

attrib _STATE label="STATE" length=3;
_STATE=_STATE;
FORMAT _STATE Statefmt.;


attrib AGE label="AGE GROUP" length=3;
if _AGE_G = 1 THEN AGE = 1;
if _AGE_G = 2 THEN AGE = 2;
if _AGE_G = 3 THEN AGE = 2;
if _AGE_G = 4 THEN AGE = 3;
if _AGE_G = 5 THEN AGE = 3;
if _AGE_G = 6 THEN AGE = 4;
format AGE AGEfmt.;

attrib EDU label="EDUCATION LEVEL" length=3;
if _EDUCAG= 1 THEN EDU = 1;
		if _EDUCAG= 2 THEN EDU = 1;
		if _EDUCAG= 3 THEN EDU = 2;
		if _EDUCAG= 4 THEN EDU = 2;
		if _EDUCAG= 9 THEN EDU = .;
format EDU EDUfmt.;

attrib QUITATTEMPT label="QUIT ATTEMPT" length=3;
		if STOPSMK2 = 7 THEN QUITATTEMPT = .;
		IF STOPSMK2 = 1 THEN QUITATTEMPT=1;
		if STOPSMK2 = 9 THEN QUITATTEMPT = .;
		if STOPSMK2 = 2 THEN QUITATTEMPT = 0; /*make "no" a 0 value */
format QUITATTEMPT YESandNOwZerofmt.;

attrib MENTAL label="POOR MENTAL HEALTH DAYS" length=3;
if 1 <= MENTHLTH <= 14 THEN MENTAL = 1;
		if MENTHLTH  = 88 THEN MENTAL = 0 ;
		if MENTHLTH  = 77 THEN MENTAL= . ;
		if MENTHLTH  = 99 THEN MENTAL = . ; 
format MENTAL YESandNOwZerofmt.;

attrib CURRENTUSE label="AT LEAST 100 CIGS LIFETIME" length=3;
if _RFSMOK3 = 1 THEN CURRENTUSE = 0; /*make "no" a 0 value */
		if _RFSMOK3 = 2 THEN CURRENTUSE= 1;
		if _RFSMOK3 = 9 THEN CURRENTUSE = .; 
format CURRENTUSE YESandNOwZerofmt.;

attrib SMOKELESSUSE label="CURRENT SMOKELESS" length=3;
	if USENOW3 = 3 THEN SMOKELESSUSE= 0; /*make "no" a 0 value */
		if USENOW3 = 2 THEN SMOKELESSUSE= 1;
		if USENOW3 = 9 THEN SMOKELESSUSE= .; 
		if USENOW3 = 7 THEN SMOKELESSUSE= .; 
format SMOKELESSUSE YESandNOwZerofmt.;

attrib CIGUSE label="CURRENT CIG USE" length=3;
if _smoker3  = 1 THEN CIGUSE = 1 ;
		if _smoker3  = 2 THEN CIGUSE = 1 ;
		if _smoker3  = 3 THEN CIGUSE = 2 ;
		if _smoker3  = 4 THEN CIGUSE = 3 ;
		if _smoker3  = 9 THEN CIGUSE = 3; 
format CIGUSE Smoker3fmt.;
RUN;
proc freq data=BRFSS19_CORE_1;
table iyear;
run;


/*************2020************/;

Data BRFSS20_CORE ;
set library.Llcp2020 (keep=_STATE IYEAR _LLCPWT _PSU _STSTR _SEX _RACEGR3 _AGE_G _EDUCAG STOPSMK2 _SMOKER3 _RFSMOK3 USENOW3 MENTHLTH ECIGNOW) ;
run;
Data BRFSS20_CORE_1;
SET BRFSS20_CORE;
if IYEAR = 2021 THEN IYEAR= 2020;
if IYEAR = 2020 THEN IYEAR= 2020;


RENAME  _LLCPWT=_FINALWT;
attrib RACE label="RACE" length=3;
if _RACEGR3 = 9 THEN RACE = .;
	ELSE IF _RACEGR3=1 THEN RACE=1;
	ELSE IF _RACEGR3=2 THEN RACE=2;
	ELSE IF _RACEGR3=3 THEN RACE=3;
	ELSE IF _RACEGR3=4 THEN RACE=4;
	ELSE IF _RACEGR3=5 THEN RACE=5;
format RACE _3RACEGRfmt.;

attrib _STATE label="STATE" length=3;
_STATE=_STATE;
FORMAT _STATE Statefmt.;


attrib AGE label="AGE GROUP" length=3;
if _AGE_G = 1 THEN AGE = 1;
if _AGE_G = 2 THEN AGE = 2;
if _AGE_G = 3 THEN AGE = 2;
if _AGE_G = 4 THEN AGE = 3;
if _AGE_G = 5 THEN AGE = 3;
if _AGE_G = 6 THEN AGE = 4;
format AGE AGEfmt.;

attrib EDU label="EDUCATION LEVEL" length=3;
if _EDUCAG= 1 THEN EDU = 1;
		if _EDUCAG= 2 THEN EDU = 1;
		if _EDUCAG= 3 THEN EDU = 2;
		if _EDUCAG= 4 THEN EDU = 2;
		if _EDUCAG= 9 THEN EDU = .;
format EDU EDUfmt.;

attrib QUITATTEMPT label="QUIT ATTEMPT" length=3;
if STOPSMK2 = 7 THEN QUITATTEMPT = .;
		IF STOPSMK2 = 1 THEN QUITATTEMPT=1;
		if STOPSMK2 = 9 THEN QUITATTEMPT = .;
		if STOPSMK2 = 2 THEN QUITATTEMPT = 0; /*make "no" a 0 value */
format QUITATTEMPT YESandNOwZerofmt.;

attrib MENTAL label="POOR MENTAL HEALTH DAYS" length=3;
if 1 <= MENTHLTH <= 14 THEN MENTAL = 1;
		if MENTHLTH  = 88 THEN MENTAL = 0 ;
		if MENTHLTH  = 77 THEN MENTAL= . ;
		if MENTHLTH  = 99 THEN MENTAL = . ; 
format MENTAL YESandNOwZerofmt.;

attrib CURRENTUSE label="AT LEAST 100 CIGS LIFETIME" length=3;
if _RFSMOK3 = 1 THEN CURRENTUSE = 0; /*make "no" a 0 value */
		if _RFSMOK3 = 2 THEN CURRENTUSE= 1;
		if _RFSMOK3 = 9 THEN CURRENTUSE = .; 
format CURRENTUSE YESandNOwZerofmt.;

attrib SMOKELESSUSE label="CURRENT SMOKELESS" length=3;
	if USENOW3 = 3 THEN SMOKELESSUSE= 0; /*make "no" a 0 value */
		if USENOW3 = 2 THEN SMOKELESSUSE= 1;
		if USENOW3 = 9 THEN SMOKELESSUSE= .; 
		if USENOW3 = 7 THEN SMOKELESSUSE= .; 
format SMOKELESSUSE YESandNOwZerofmt.;

attrib CIGUSE label="CURRENT CIG USE" length=3;
if _smoker3  = 1 THEN CIGUSE = 1 ;
		if _smoker3  = 2 THEN CIGUSE = 1 ;
		if _smoker3  = 3 THEN CIGUSE = 2 ;
		if _smoker3  = 4 THEN CIGUSE = 3 ;
		if _smoker3  = 9 THEN CIGUSE = 3; 
format CIGUSE Smoker3fmt.;

attrib ECIGUSE label="CURRENT ECIG USE" length=3;
if ECIGNOW = 1 THEN ECIGUSE= 1;
if ECIGNOW = 2 THEN ECIGUSE= 1;
		if ECIGNOW = 3 THEN ECIGUSE = 0; /*make "no" a 0 value */
		if ECIGNOW = 9 THEN ECIGUSE = .; 
		if ECIGNOW = 7 THEN ECIGUSE = .; 
format ECIGUSE YESandNOwZerofmt.;
RUN;
proc freq data=BRFSS20_CORE_1;
table iyear;
run;


/*************2021************/;
Data BRFSS21_CORE (keep=_STATE IYEAR _LLCPWT _PSU _STSTR _SEX _RACEGR3 _AGE_G _EDUCAG STOPSMK2 _SMOKER3 _RFSMOK3 USENOW3 MENTHLTH _CURECI1);
set library.Llcp2021 ;
run;
Data BRFSS21_CORE_1;
SET BRFSS21_CORE;

if IYEAR = 2022 THEN IYEAR= 2021;
if IYEAR = 2021 THEN IYEAR= 2021;

RENAME  _LLCPWT=_FINALWT;
attrib RACE label="RACE" length=3;
if _RACEGR3 = 9 THEN RACE = .;
	ELSE IF _RACEGR3=1 THEN RACE=1;
	ELSE IF _RACEGR3=2 THEN RACE=2;
	ELSE IF _RACEGR3=3 THEN RACE=3;
	ELSE IF _RACEGR3=4 THEN RACE=4;
	ELSE IF _RACEGR3=5 THEN RACE=5;
format RACE _3RACEGRfmt.;

attrib _STATE label="STATE" length=3;
_STATE=_STATE;
FORMAT _STATE Statefmt.;


attrib AGE label="AGE GROUP" length=3;
if _AGE_G = 1 THEN AGE = 1;
if _AGE_G = 2 THEN AGE = 2;
if _AGE_G = 3 THEN AGE = 2;
if _AGE_G = 4 THEN AGE = 3;
if _AGE_G = 5 THEN AGE = 3;
if _AGE_G = 6 THEN AGE = 4;
format AGE AGEfmt.;

attrib EDU label="EDUCATION LEVEL" length=3;
if _EDUCAG= 1 THEN EDU = 1;
		if _EDUCAG= 2 THEN EDU = 1;
		if _EDUCAG= 3 THEN EDU = 2;
		if _EDUCAG= 4 THEN EDU = 2;
		if _EDUCAG= 9 THEN EDU = .;
format EDU EDUfmt.;

attrib QUITATTEMPT label="QUIT ATTEMPT" length=3;
if STOPSMK2 = 7 THEN QUITATTEMPT = .;
		IF STOPSMK2 = 1 THEN QUITATTEMPT=1;
		if STOPSMK2 = 9 THEN QUITATTEMPT = .;
		if STOPSMK2 = 2 THEN QUITATTEMPT = 0; /*make "no" a 0 value */
format QUITATTEMPT YESandNOwZerofmt.;

attrib MENTAL label="POOR MENTAL HEALTH DAYS" length=3;
if 1 <= MENTHLTH <= 14 THEN MENTAL = 1;
		if MENTHLTH  = 88 THEN MENTAL = 0 ;
		if MENTHLTH  = 77 THEN MENTAL= . ;
		if MENTHLTH  = 99 THEN MENTAL = . ; 
format MENTAL YESandNOwZerofmt.;

attrib CURRENTUSE label="AT LEAST 100 CIGS LIFETIME" length=3;
if _RFSMOK3 = 1 THEN CURRENTUSE = 0; /*make "no" a 0 value */
		if _RFSMOK3 = 2 THEN CURRENTUSE= 1;
		if _RFSMOK3 = 9 THEN CURRENTUSE = .; 
format CURRENTUSE YESandNOwZerofmt.;

attrib SMOKELESSUSE label="CURRENT SMOKELESS" length=3;
	if USENOW3 = 3 THEN SMOKELESSUSE= 0; /*make "no" a 0 value */
		if USENOW3 = 2 THEN SMOKELESSUSE= 1;
		if USENOW3 = 9 THEN SMOKELESSUSE= .; 
		if USENOW3 = 7 THEN SMOKELESSUSE= .; 
format SMOKELESSUSE YESandNOwZerofmt.;

attrib CIGUSE label="CURRENT CIG USE" length=3;
if _smoker3  = 1 THEN _smoker3 = 1 ;
		if _smoker3  = 2 THEN CIGUSE = 1 ;
		if _smoker3  = 3 THEN CIGUSE = 2 ;
		if _smoker3  = 4 THEN CIGUSE = 3 ;
		if _smoker3  = 9 THEN CIGUSE = 3; 
format CIGUSE Smoker3fmt.;

attrib ECIGNOW label="CURRENT ECIG USE" length=3;
if _CURECI1 = 1 THEN ECIGNOW= 0;
		if _CURECI1 = 2 THEN ECIGNOW= 1;
		if _CURECI1 = 9 THEN ECIGNOW= .; 
format ECIGNOW YESandNOwZerofmt.;

RUN;

/*ADD VERSION 1 AND VERSION 2 DATASETS FOR TOBACCO CESSATION MODULE*/

PROC FREQ DATA=LIBRARY.LLCP21V1; *CALCULATE SAMPLE SIZE FOR MD*;
TABLE _STATE; *Sample size 5082 for MD*;
RUN;
PROC FREQ DATA=LIBRARY.LLCP21V2; *CALCULATE SAMPLE SIZE FOR MD and ME*; *NOTE: MAINE DOES NOT APPEAR TO BE IN THIS DATASET!! MAY NEED TO EXCLUDE FROM DATASET*;
TABLE _STATE; *Sample size 5074 for MD*; *Total sample for MD is 10156*;
RUN;
DATA LLCPV211 ; * Maryland(24) used version 1; 
SET LIBRARY.LLCP21V1 (WHERE=(_STATE IN (24))); 
if IYEAR = 2022 THEN IYEAR= 2021;
if IYEAR = 2021 THEN IYEAR= 2021;
_FINALWT=_LCPWTV1*.50; /* Maryland used both v1 & v2, it’s weight need to be djusted */ *_LCPWTV1 times the calculated proportion or simply divided by 2; 
DROP _LCPWTV1; 
RUN;
DATA LLCPV211_f (keep=_STATE IYEAR _FINALWT _PSU _STSTR _SEX _RACEGR3 _AGE_G _EDUCAG STOPSMK2 _SMOKER3 _RFSMOK3 USENOW3 MENTHLTH _CURECI1);
SET WORK.LLCPV211;
if IYEAR = 2022 THEN IYEAR= 2021;
if IYEAR = 2021 THEN IYEAR= 2021;
RUN;
DATA LLCPV212; 
SET LIBRARY.LLCP21V2(WHERE=(_STATE IN (23,24))); *NOTE: MAINE DOES NOT APPEAR TO BE IN THIS DATASET!! MAY NEED TO EXCLUDE FROM DATASET*;
if IYEAR = 2022 THEN IYEAR= 2021;
if IYEAR = 2021 THEN IYEAR= 2021;
IF _STATE =24 THEN _FINALWT=_LCPWTV2*.50; /* Maryland used both v1 & v2, it’s weight need to be djusted */*_LCPWTV2 times the calculated proportion or simply divided by 2; 
ELSE _FINALWT=_LCPWTV2; 
DROP _LCPWTV2; 
RUN; 
DATA LLCPV212_f (keep=_STATE IYEAR _FINALWT _PSU _STSTR _SEX _RACEGR3 _AGE_G _EDUCAG STOPSMK2 _SMOKER3 _RFSMOK3 USENOW3 MENTHLTH _CURECI1);
SET WORK.LLCPV212;
if IYEAR = 2022 THEN IYEAR= 2021;
if IYEAR = 2021 THEN IYEAR= 2021;
RUN;
DATA BRFSS21_FINAL;
set work.BRFSS21_CORE_1 work.LLCPV211_f WORK.LLCPV212_f;
run;
proc freq data=work.BRFSS21_FINAL;
table iyear;
run;



/*************2022************/; 

Data BRFSS22_CORE (keep=_STATE IYEAR _LLCPWT _PSU _STSTR _SEX _RACEGR4 _AGE_G _EDUCAG STOPSMK2 _SMOKER3 _RFSMOK3 USENOW3 MENTHLTH _CURECI2);
set library.Llcp2022 ;
run;
Data BRFSS22_CORE_1;
SET BRFSS22_CORE;
RENAME  _LLCPWT=_FINALWT;

if IYEAR = 2023 THEN IYEAR= 2022;
if IYEAR = 2022 THEN IYEAR= 2022;


attrib RACE label="RACE" length=3;
if _RACEGR4 = 9 THEN RACE = .;
	ELSE IF _RACEGR4=1 THEN RACE=1;
	ELSE IF _RACEGR4=2 THEN RACE=2;
	ELSE IF _RACEGR4=3 THEN RACE=3;
	ELSE IF _RACEGR4=4 THEN RACE=4;
	ELSE IF _RACEGR4=5 THEN RACE=5;
format RACE _3RACEGRfmt.;

attrib _STATE label="STATE" length=3;
_STATE=_STATE;
FORMAT _STATE Statefmt.;


attrib AGE label="AGE GROUP" length=3;
if _AGE_G = 1 THEN AGE = 1;
if _AGE_G = 2 THEN AGE = 2;
if _AGE_G = 3 THEN AGE = 2;
if _AGE_G = 4 THEN AGE = 3;
if _AGE_G = 5 THEN AGE = 3;
if _AGE_G = 6 THEN AGE = 4;
format AGE AGEfmt.;

attrib EDU label="EDUCATION LEVEL" length=3;
if _EDUCAG= 1 THEN EDU = 1;
		if _EDUCAG= 2 THEN EDU = 1;
		if _EDUCAG= 3 THEN EDU = 2;
		if _EDUCAG= 4 THEN EDU = 2;
		if _EDUCAG= 9 THEN EDU = .;
format EDU EDUfmt.;

attrib QUITATTEMPT label="QUIT ATTEMPT" length=3;
if STOPSMK2 = 7 THEN STOPSMK2 = .;
		IF STOPSMK2 = 1 THEN QUITATTEMPT=1;
		if STOPSMK2 = 9 THEN QUITATTEMPT = .;
		if STOPSMK2 = 2 THEN QUITATTEMPT = 0; /*make "no" a 0 value */
format QUITATTEMPT YESandNOwZerofmt.;

attrib MENTAL label="POOR MENTAL HEALTH DAYS" length=3;
if 1 <= MENTHLTH <= 14 THEN MENTAL = 1;
		if MENTHLTH  = 88 THEN MENTAL = 0 ;
		if MENTHLTH  = 77 THEN MENTAL= . ;
		if MENTHLTH  = 99 THEN MENTAL = . ; 
format MENTAL YESandNOwZerofmt.;

attrib CURRENTUSE label="AT LEAST 100 CIGS LIFETIME" length=3;
if _RFSMOK3 = 1 THEN CURRENTUSE = 0; /*make "no" a 0 value */
		if _RFSMOK3 = 2 THEN CURRENTUSE= 1;
		if _RFSMOK3 = 9 THEN CURRENTUSE = .; 
format CURRENTUSE YESandNOwZerofmt.;

attrib SMOKELESSUSE label="CURRENT SMOKELESS" length=3;
	if USENOW3 = 3 THEN USENOW3= 0; /*make "no" a 0 value */
		if USENOW3 = 2 THEN SMOKELESSUSE= 1;
		if USENOW3 = 9 THEN SMOKELESSUSE= .; 
		if USENOW3 = 7 THEN SMOKELESSUSE= .; 
format SMOKELESSUSE YESandNOwZerofmt.;

attrib CIGUSE label="CURRENT CIG USE" length=3;
if _smoker3  = 1 THEN _smoker3 = 1 ;
		if _smoker3  = 2 THEN CIGUSE = 1 ;
		if _smoker3  = 3 THEN CIGUSE = 2 ;
		if _smoker3  = 4 THEN CIGUSE = 3 ;
		if _smoker3  = 9 THEN CIGUSE = 3; 
format CIGUSE Smoker3fmt.;

attrib ECIGNOW label="CURRENT ECIG USE" length=3;
if _CURECI2 = 1 THEN ECIGNOW= 0;
		if _CURECI2 = 2 THEN ECIGNOW= 1;
		if _CURECI2 = 9 THEN ECIGNOW= .; 
format ECIGNOW YESandNOwZerofmt.;
RUN;
PROC FREQ DATA=LIBRARY.LLCP22V1; *CALCULATE SAMPLE SIZE FOR MD and KS*;
TABLE _STATE; *Sample size 5328 for MD and 5433 for KS*;
RUN;
PROC FREQ DATA=LIBRARY.LLCP22V2; *CALCULATE SAMPLE SIZE FOR NE*; *NOTE: MAINE DOES NOT APPEAR TO BE IN THIS DATASET!! MAY NEED TO EXCLUDE FROM DATASET*;
TABLE _STATE; *Sample size 3603 for NE*;
RUN;
/* Extract data for states that used V1 of the module, adjust weights for states that used > 1 version of the module */ 
DATA LLCPV221; 
SET LIBRARY.LLCP22V1 (WHERE=(_STATE IN (20 24))); 
if IYEAR = 2023 THEN IYEAR= 2022;
if IYEAR = 2022 THEN IYEAR= 2022;
RENAME _LCPWTV1=_FINALWT; 
RUN; 
DATA LLCPV221_f (keep=_STATE IYEAR _FINALWT _PSU _STSTR _SEX _RACEGR4 _AGE_G _EDUCAG STOPSMK2 _SMOKER3 _RFSMOK3 USENOW3 MENTHLTH _CURECI2);
SET WORK.LLCPV221;

if IYEAR = 2023 THEN IYEAR= 2022;
if IYEAR = 2022 THEN IYEAR= 2022;
RUN;
DATA LLCPV222; 
SET LIBRARY.LLCP22V2 (WHERE=(_STATE IN (31))); 
if IYEAR = 2023 THEN IYEAR= 2022;
if IYEAR = 2022 THEN IYEAR= 2022;

RENAME _LCPWTV2=_FINALWT; 
RUN; 
DATA LLCPV222_f (keep=_STATE IYEAR _FINALWT _PSU _STSTR _SEX _RACEGR4 _AGE_G _EDUCAG STOPSMK2 _SMOKER3 _RFSMOK3 USENOW3 MENTHLTH _CURECI2);
SET WORK.LLCPV222;
if IYEAR = 2023 THEN IYEAR= 2022;
if IYEAR = 2022 THEN IYEAR= 2022;
RUN;
DATA BRFSS22_FINAL;
set work.BRFSS22_CORE_1 work.LLCPV221_f WORK.LLCPV222_f;
run;
proc freq data=BRFSS22_FINAL;
table iyear;
run;


/*************COMBINE 2019, 2020, 2021, 2022 AND EXPORT OUT************/; 
LIBNAME OUT "C:\Users\rtv3\OneDrive - CDC\Evaluation\NTCP Evaluation Documents\Personal\Long-Term Outcome Analysis\Data";
DATA OUT.BRFSS2019_2022_FINAL;
set BRFSS19_CORE_1 BRFSS20_CORE_1 BRFSS21_FINAL BRFSS22_FINAL ;
run;

/** TESTING ALEX'S COMBINED DATASET WITH V1/V2 MODULES ADDED**/

PROC CONTENTS DATA=out.BRFSS2019_2022_FINAL;
RUN;


proc surveyfreq data=library.Llcp2019 NOMCAR;
weight _LLCPWT;
Strata _STSTR;
*Cluster _PSU;
table _RFSMOK3/ cl(TYPE=LOGIT) row ;
run;


**T-test between baseline (2019) vs most recent year (2022) by sociodemographics**;

/**Quit Attempts**/

proc surveyfreq data=out.BRFSS2019_2022_FINAL NOMCAR;
weight _FINALWT;
Strata _STSTR;
*Cluster _PSU;
table iyear*QuitAttempt /  wchisq cl row ;
run;

proc surveylogistic data=out.BRFSS2019_2022_FINAL nomcar  ;
Strata _STSTR;
cluster _psu;
class quitattempt(ref='No') iyear (ref='2019')  / param=glm;
model quitattempt=iyear ;
Weight _FINALWT;      
lsmeans iyear /  cl diff  e ilink  ;
        ods output coef=coeffs;
        store out=quit_1;
		run;

		/**Cigarette Use**/

proc surveyfreq data=out.BRFSS2019_2022_FINAL NOMCAR;
weight _FINALWT;
Strata _STSTR;
*Cluster _PSU;
table iyear*currentuse/  chisq cl(TYPE=LOGIT) row ;
run;

proc surveylogistic data=out.BRFSS2019_2022_FINAL nomcar ;
Strata _STSTR;
cluster _psu;
class CURRENTUSE(ref='No') iyear (ref='2019')  / param=glm;
model CURRENTUSE=iyear ;
Weight _FINALWT;      
lsmeans iyear /cl diff  e ilink ;
        ods output coef=coeffs;
        store out=currentuse_1;
		run;

		/**Smokeless**/

proc surveyfreq data=out.BRFSS2019_2022_FINAL NOMCAR;
weight _FINALWT;
Strata _STSTR;
*Cluster _PSU;
table iyear*currentuse /  COCHRANQ chisq cl(TYPE=LOGIT) row ;
run;

proc surveylogistic data=out.BRFSS2019_2022_FINAL nomcar ;
Strata _STSTR;
cluster _psu;
class CURRENTUSE(ref='No') iyear (ref='2019') / param=glm;
model CURRENTUSE=iyear ;
Weight _FINALWT;      
lsmeans iyear /cl diff  e ilink ;
        ods output coef=coeffs;
        store out=currentuse_1;
		run;
