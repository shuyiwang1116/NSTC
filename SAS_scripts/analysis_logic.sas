/*-----------------------------------------------------------------------------
   PROJECT: Pancreatic Cancer Multi-Exposure Analysis (2005-2018)
   FILE: analysis_logic.sas (Core Methodology Snippets)
   
   NOTE: This script contains the primary statistical procedures used for 
   normality testing, comparative analysis, and interaction modeling. 
   Full data cleaning and merging scripts are withheld for privacy.
-----------------------------------------------------------------------------*/

/* 1. Exploratory Data Analysis (EDA) */
/* Assessing the normality of cancer incidence rates to select appropriate tests */
PROC univariate DATA=A.PGIRL2 normal plot;
    VAR STAND_RATE;
RUN;

/* 2. Comparative Analysis: Gender Disparity */
/* Using T-Test and Wilcoxon (Non-parametric) to validate sex-based differences */
proc ttest data=a.pancreatic_nsex2;
    class sex;
    var stand_rate;
run;

PROC NPAR1WAY WILCOXON DATA=a.pancreatic_nsex2;
    CLASS sex;
    VAR STAND_RATE;
RUN;

/* 3. Regional Variance Analysis */
/* Comparing standard incidence rates across different townships/districts */
proc anova data=a.pboy2;
    class tname;
    model stand_rate = tname;
run;

/* 4. Multi-Exposure Modeling (PROC REG) */
/* Analyzing atmospheric pollutants (O3) and dietary intake (Meat) on incidence */
proc sort data=a.pboy1; by strid1; run;
PROC reg DATA=A.Pboy1 PLOTS(maxpoints=none);
    MODEL SRATE = pcookwt_AVG o3_mean / STB CLB; 
    by strid1; 
RUN;

/* 5. Interaction Effect Analysis (PROC GLM) */
/* Testing for synergistic effects between Diet and PM2.5 (e.g., pcookwt_AVG*pm25_mean) */
proc glm data=a.pgirl1;
    model SRATE = pcookwt_AVG pm25_mean pcookwt_AVG*pm25_mean / ss3; 
run;
quit;