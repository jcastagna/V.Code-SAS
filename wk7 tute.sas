libname glm v9 'e:\glm';

data "e:/glm/birth";
set glm.birth;


/* mod1 and lect viz */
proc genmod data=glm.birth descending;
ods output obstats =birthobs;
ods listing exclude obstats;
model admit_nc=weight /dist =bin obstats type3;
run;

data birthobs;
set birthobs;
admit=admit_nc/1;
run;

proc sgplot data=birthobs;
scatter x=weight y=admit;
pbspline x=weight y=admit /nknots=6;
pbspline x=weight y=pred /nomarkers ledgendlabel = "fitted values" lineattrs=(pattern=2);
run;



/* mod2 */

proc genmod data=glm.birth descending;
ods output obstats =birthobs1;
ods listing exclude obstats;
model admit_nc=gestage /dist =bin obstats type1 type3;
run;




