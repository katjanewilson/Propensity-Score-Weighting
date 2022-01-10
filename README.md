

# Confounding Adjustment with Propensity Score Weighting


### Project Page

[Markdown Link](https://katjanewilson.github.io/Propensity-Score-Weighting/)



### Overview

Matching, a class of observational study methods, links each treatment unit in a study to one or more control units. In a quasi-experimental setting or "natural experiment" (i.e. in the absence of randomization), matching helps to reduce the influence of covariate bias by creating an artificial control group that is comparable to the original treatment group.

Two common issue face researchers when working with a matched sample: first, distributions of important covariates might still be imbalanced after matching, and second, matching discards large amounts of data in an effort to obtain similar groups. 

Weighting by the propensity score is one work around. Using weighting, researchers can obtain better balance on key covariates and retain all observations from the original sample. Such weighting schemes are intimately tied to the survey sampling literature, both in their technical foundations and general limitations.

Using the population of third grade public school classrooms in New York City, we identify the treatment effect of inclusion on total attendance with a propensity score model:

``` r
# propensity score model
m_ps<- glm(treatment ~ PercentBlack + PercentSWD + PercentPoverty + TotalEnrollment +
             ENI, family = binomial(), data = working_data)
summary(m_ps)
```

Balance in the propensity score is diagnosed using the `cobalt` package

``` r
#Checking balance before and after matching:
## Call
##  matchit(formula = treatment ~ ENI + PercentBlack + PercentSWD + 
##     TotalEnrollment + PercentPoverty, data = working_data, method = "nearest", 
##     caliper = 0.25, ratio = 4, family = "binomial")
## 
## Balance Measures
##                     Type Diff.Adj    M.Threshold
## distance        Distance   0.0595 Balanced, <0.1
## ENI              Contin.  -0.0445 Balanced, <0.1
## PercentBlack     Contin.   0.0058 Balanced, <0.1
## PercentSWD       Contin.   0.0148 Balanced, <0.1
## TotalEnrollment  Contin.  -0.0661 Balanced, <0.1
## PercentPoverty   Contin.  -0.0328 Balanced, <0.1
## 
## Balance tally for mean differences
##                    count
## Balanced, <0.1         6
## Not Balanced, >0.1     0
## 
## Variable with the greatest mean difference
##         Variable Diff.Adj    M.Threshold
##  TotalEnrollment  -0.0661 Balanced, <0.1
## 
## Sample sizes
##                      Control Treated
## All                   623.       147
## Matched (ESS)         177.34     102
## Matched (Unweighted)  262.       102
## Unmatched             361.        45
```
IPTW and SW weights can be hard-coded, or assigned using the `PSweight` package:

``` r
working_data$treatment_identifier <- ifelse(working_data$treatment == 1, "inclusion", "non-inclusion")
working_data$iptw <- ifelse(working_data$treatment_identifier == 'inclusion', 1/(working_data$propensity_score),
                            1/(1-working_data$propensity_score))

#stabilized weights
working_data$stable.iptw <- ifelse(working_data$treatment_identifier == 'inclusion',
                                   (mean(working_data$propensity_score))/working_data$propensity_score,
                                   mean(1-working_data$propensity_score)/(1-working_data$propensity_score))

## Weighted Data, using the survey design package
working_data_weighted <- svydesign(ids = ~1, data= working_data, weights= working_data$iptw)
## balance of each in the unweighted sample
data<- working_data_weighted$variables
mod4 <- lm(AllStudents_PA ~ treatment, weights = data$iptw, data = data)
```

### Citations

Ho, D. E., Imai, K., King, G., & Stuart, E. A. (2011). MatchIt:
Nonparametric Preprocessing for Parametric Causal Inference. *Journal of
Statistical Software*, 42(8).
[doi:10.18637/jss.v042.i08](https://doi.org/10.18637/jss.v042.i08)

Li, Fan, Laine E Thomas, and Fan Li. 2019. “Addressing Extreme Propensity Scores via the Overlap Weights.” American Journal of Epidemiology 188 (1): 250–57. https://doi.org/10.1093/aje/kwy201.

* [PSWeight](https://cran.r-project.org/web/packages/PSweight/PSweight.pdf)
* [NYC Open Data](https://opendata.cityofnewyork.us/)

