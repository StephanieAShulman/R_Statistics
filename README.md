# mechacaR-Analysis
![Bugatti](https://user-images.githubusercontent.com/30667001/160251248-ad46da0a-d9c4-4c3a-ba41-d2ddd9b3edbc.png)

Use R to implement data analytics including multiple linear regression, summary statistics and t-Tests

## Resources
* Data: MechaCar MPG dataset (csv), Suspension Coil dataset (csv)
* Software: R for Windows 4.1.3
* Libraries: dplyr from tidyverse package

## Purpose
With AutosRUs newest prototype – the MechaCar – suffering from manufacturing issues, R statistics were employed to improve production by better understanding:
* Which variables best predict prototype miles per gallon (mpg).
* The summary statistics of pounds per square inch (PSI) of the suspension coils.
* Whether or not statistical differences exist between manufacturing lots and the mean population.
* How to best compare MechaCar vehicle performance to the competition.

## Findings
### Linear Regression to Predict MPG
![Deliverable1](https://user-images.githubusercontent.com/30667001/160253526-9b5acfc7-b1e8-46db-9cb5-bd67fde4fe87.png)

Based on p-values far below an alpha of 0.05, it is fair to reject the null hypothesis. There appears to be a significant, linear relationship between the independent predictors vehicle length and ground clearance and the dependent variable, miles per gallon, given all other variables in the model. The model predicts that for every one-unit change in ground clearance and vehicle length, there will be a 3.5 unit increase and 6.3 unit increase in mpg, respectively. The adjusted R2 of 0.68 indicates that roughly 70% of the variance found in mpg can be explained by the predictor variables. Vehicle weight, spoiler angle and AWD may need to be removed and/or vehicle length and ground clearance transformed to increase the model precision.

