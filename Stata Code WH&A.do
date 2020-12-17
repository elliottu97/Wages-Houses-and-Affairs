*Elliot Tu 
*Applied Econometric Analysis (ECON216)
*Assignment 6

*cd "C:\Users\eugen\Desktop\Test"

/*
TO MAKE THIS FILE REPLICABLE: 
1. set your directory using the above command cd "[insert your file path here]" 
2. download the datasets and add them to the file path you chose.
3. Install (command ssc [package]) the package [outreg2] 
After completing the above steps, you can run this do file in one go. 

See pdf in repository for regression tables and the evaluation of results. 
*/

*Use a dataset of wages
use wages.dta, clear

*1a Estimate the effects of education on the natural log of wage
regress lwage educ
outreg2 using hw6q1a.xls, replace

*1b Estimate the effect of education and IQ on the natural log of wage
regress lwage educ IQ
outreg2 using hw6q1b.xls, replace

*1c Estimate the effect of education on IQ
regress IQ educ 
outreg2 using hw6q1c.xls, replace

*Make a nice regression table containing the top 3 regressions 
regress lwage educ
outreg2 using hw6q1.xls, replace sdec(3) bdec(3) title ("Effects of Education and IQ on Wage") ctitle("IQ Omitted")
regress lwage educ IQ
outreg2 using hw6q1.xls, append sdec(3) bdec(3)title ("Effects of Education and IQ on Wage") ctitle("IQ Controlled")
regress IQ educ 
outreg2 using hw6q1.xls, append sdec(3) bdec(3) title ("Effects of Education and IQ on Wage") ctitle("IQ on Education")

*Use a dataset on affairs
clear all
use affairs.dta, clear

*2a Determine how many people are in each happiness category
tab ratemarr 

*2b Estimate the effect of the years married, gender, and education on the quality of marriage. Account for heteroskedasticity (robust)
reg ratemarr yrsmarr male educ, robust
outreg2 using hw6q2b.xls, replace title("Effects on the Quality of Marriage") ctitle("Standard Regression")

*2c Since we have ordered data with arbitrary numbers assigned, we want to use an ordered probit model instead of the above standard OLS model. 
oprobit ratemarr yrsmarr male educ 
outreg2 using hw6q2b.xls, append title("Effects on the Quality of Marriage") ctitle("Ordered Probit Model")

*2d Compute the marginal effects of the explanatory variables for being in the highest happiness group.
mfx compute, predict (outcome(5))
*Couldn't figure out how to export mfx table properly, attaching screenshot in word doc

*Use a dataset of house prices
clear all
use houseprices1.dta, clear

*3a Estimate the effect of hosue characteristics on the sale price
regress price bdrms lotsize sqrft
outreg2 using hw6q3a.xls, replace title("House Characteristics and Sale Price") ctitle("Standard Regression")

*3b Determine whether or not there's any censoring on the data 
tab price 
tab bdrms
tab lotsize
tab sqrft
*Probably better to graph data next time but with so few variables and #'s of observations, I figured I could get away with spamming tab 

*3c Use a tobit model instead since there's censorship at the price beyond $310,000
tobit price bdrms lotsize sqrft, ul(310000)
outreg2 using hw6q3a.xls, append title("House Characteristics and Sale Price") ctitle("Tobit Model")


*Use another dataset on house prices
clear all 
use houseprices2.dta, clear

*4a Estimate the effects of room, square footage, and square footage of the lot on the sale price
regress price rooms land area, robust
outreg2 using hw6q4a.xls, replace title("Effects on House Sale Price") ctitle("Standard Regression")

*4b Estimate the above regression while also including fixed effects for neighborhoods since it's likely that the neighborhoods have houses with similar characteristics
xi: regress price rooms land area i.nbh, robust
outreg2 using hw6q4a.xls, append title("Effects on House Sale Price") ctitle("Neighborhood Fixed Effect")

*4f Estimate the regression while also including neighborhood by year fixed effects, since it's likely that different years change the overall house prices. 
gen nbhyear = (nbh*y81)
xi: regress price rooms land area i.nbh i.nbhyear, robust
outreg2 using hw6q4a.xls, append title("Effects on House Sale Price") ctitle("Year Fixed Effect")