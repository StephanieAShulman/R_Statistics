
# mechacaR-Analysis
![Bugatti](https://user-images.githubusercontent.com/30667001/160249501-6391a2c9-3e9d-44b0-8ad5-e730c8093178.jpg)

Using R to implement data analytics including multiple linear regression, summary statistics and t-Tests

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

### Summary Statistics on Suspension Coils
![Deliverable2](https://user-images.githubusercontent.com/30667001/160253858-e48883ed-ebbc-4c20-bfe8-47482c241e5b.png)

Suspension coils for the MechaCar must not exceed a variance of 100 PSI. Total summary statistics indicate that the combined manufacturing lots fall well below this value with an average variance of 62. Inspection of the variance by individual lot, however, indicates an extremely large spread from the mean among the coils that make up Lot 3. While Lot 1 has almost no variance and Lot 2 very little, there is likely a production issue associated with the Lot 3 coils that requires further investigation.

### T-Tests on Suspension Coils
![Deliverable3](https://user-images.githubusercontent.com/30667001/160255035-721ac3c8-e172-4de8-bd83-a8d6aabc0414.png)

To address the issue in Lot 3 uncovered during a review of the summary statistics, multiple t-tests were performed to compare the PSI for the entire coil sample and each individual lot PSI to the population mean of 1,500 PSI. With a p-value of 0.06, there is no evidence for rejecting the null hypothesis that the true PSI sample mean is equal to 1500. The same findings hold for Lots 1 and 2, but for Lot 3 - with a p-value below the threshold of 0.05 - there is evidence to reject the null. Coil PSI values are not equal to the population mean of 1,500, supporting the need to further investigate production of Lot 3 coils.

## Next Steps
### Study Design: MechaCar vs Competition
![car2](https://user-images.githubusercontent.com/30667001/160257263-bdfcc909-e2d4-4992-af70-ba17230f5b84.png)

Driving just became a whole lot safer, according to MechaCar’s promotional details. The high-speed automatic emergency braking (HAEB) and pedestrian detection (PD) systems are the newest safety features to be added to this model. And – based on the latest market research – AutosRUs is sure their technology will outperform the competition, especially with embedded trackers providing real-time feedback. In order to quantify performance, the following analytic approach will be taken:

#### Metric collection
1. Continuous: time-to-stop, speed, distance traveled.
2. Continuous (but could be made categorical): number of events.
3. Ordinal: severity of impact.

#### Hypotheses </br>
H0: There is no difference in number of contact events between MechaCar and the competition.</br>
HA: There is a difference in number of events between MechaCar and the competition.

#### Statistical Tests
As most collected data will be continuous, multiple linear regression can be performed on both the MechaCar data and that of the competition to better predict the difference in number of events between the two groups. Mean number of events for the two different groups can be compared using a two-sample t-test.

#### Necessary Data
Data specific to the MechaCar will be collected by the company through the feedback loop. The same data will have to be collected on the competition. It is most likely that the data will have to be gathered from outside resources that may include national groups (eg: [The United States Department of Transportation, National Center for Statistics and Analysis](https://www.nhtsa.gov/data), [The National Safety Council, Injury Facts](https://injuryfacts.nsc.org/motor-vehicle/road-users/pedestrians/)), from consumer groups (eg: Consumer Reports) and from automotive-specific sites like VAuto (dealer-specific), AutoTrader and CarGuru.
