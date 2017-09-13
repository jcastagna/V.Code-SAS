libname glm v9 'e:\glm';


/* frequency table */
proc freq data=Glm.Bmd_baseline;
tables bmi_cat;
run;

/* combine underweight*/

data Bmd_baseline;
set Glm.Bmd_baseline;
if bmi_cat=1 then bmi_cat=2;
run;

/* bpxplots */
proc sgplot data=Bmd_baseline;
vbox bmd /category=bmi_cat;
run;

/* scatterplot */ 
proc sgplot data = bmd_baseline;
scatter x= age y=bmd;
run;
 
proc glm data=bmd_baseline;
class bmi_cat;
model bmd=age bmi_cat / solution;
run;
