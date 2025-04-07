data cancer_admissions;
  call streaminit(123); /* Ensures reproducibility */
  format Admission_Date date9.;

  do Patient_ID = 1 to 1000;
    Age = rand("integer", 10, 90);

    if rand("bernoulli", 0.5) = 1 then Gender = "Male";
    else Gender = "Female";

    Region_ID = rand("integer", 1, 4);
    if Region_ID = 1 then Region = "North";
    else if Region_ID = 2 then Region = "South";
    else if Region_ID = 3 then Region = "East";
    else Region = "West";

    Cancer_ID = rand("integer", 1, 4);
    if Cancer_ID = 1 then Cancer_Type = "Lung";
    else if Cancer_ID = 2 then Cancer_Type = "Breast";
    else if Cancer_ID = 3 then Cancer_Type = "Colon";
    else Cancer_Type = "Prostate";

    Admission_Date = '01JAN2023'd + rand("integer", 0, 364);
    Hospital_Stay_Days = rand("integer", 1, 20);

    if rand("bernoulli", 0.2) = 1 then Readmission = "Yes";
    else Readmission = "No";

    drop Region_ID Cancer_ID;
    output;
  end;
run;


proc print data=cancer_admissions (obs=10);
run;


proc means data=cancer_admissions mean std min max;
  var Age Hospital_Stay_Days;
run;


proc freq data=cancer_admissions;
  tables Gender Region Cancer_Type Readmission;
run;


data cancer_admissions;
  set cancer_admissions;
  Month_Num = month(Admission_Date);              /* Numeric month (1–12) */
  Month_Label = put(Month_Num, monname3.);        /* Character month name (Jan, Feb, etc.) */
run;




proc sgplot data=cancer_admissions;
  vbar Cancer_Type / datalabel;
  title "Distribution of Cancer Types";
run;


proc sgplot data=cancer_admissions;
  vbar Region / datalabel;
  title "Cancer Admissions by Region";
run;


proc sgplot data=cancer_admissions;
  vbar Gender / datalabel;
  title "Cancer Admissions by Gender";
run;


proc sgplot data=cancer_admissions;
  vbar Month_Num / response=Patient_ID stat=sum datalabel categoryorder=respasc;
  xaxis values=(1 to 12 by 1) label="Month";
  yaxis label="Number of Admissions";
  title "Monthly Cancer Admissions in 2023";
run;


proc sgplot data=cancer_admissions;
  scatter x=Age y=Hospital_Stay_Days;
  title "Age vs Length of Hospital Stay";
run;
