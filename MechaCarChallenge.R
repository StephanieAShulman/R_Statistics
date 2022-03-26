# CHALLENGE: AutosRUs' Prototype - MechaCar
# With production troubles hindering manufacturing progress, it's time to review the data.

# Check default working directory
getwd()
# Set new working directory, if needed
#setwd("C:/...")
# Verify update, if needed
#getwd()

# Load the dplyr package
library(dplyr)

# DELIVERABLE 1: Create a linear model to Predict MPG
# Import and read in the MechaCar_mpg.csv as a data frame
mechacar_df<- read.csv(file='MechaCar_mpg.csv', check.names=FALSE, stringsAsFactors=FALSE)

# Review some of the data
head(mechacar_df)

# Perform multiple linear regression EXCEPT NOT EVERYTHING IS SAME LENGTH
lm(mpg ~ ., mechacar_df)

# Determine the p-value and R2 value for the model
summary(lm(mpg ~ ., mechacar_df))

# DELIVERABLE 2: Create a visualization of coil consistency
# Create a summary statistics table to show:
#  * The suspension coil's PSI continuous variable across all manufacturing lots.
#  * PSI metrics for each lot: mean, median, variance, and standard deviation.

# Import and read in the Suspension_Coil.csv as a table
coils_data <- read.csv(file='Suspension_Coil.csv', check.names=FALSE, stringsAsFactors=FALSE)

# Review some of the data
head(coils_data)

# Create a total_summary df with summarize() fxn to get mean, median, variance, standard deviation
#  of the suspension coils' PSI
total_summary <- coils_data %>% summarize(Mean=mean(PSI),Median=median(PSI),Variance=var(PSI),SD=sd(PSI), .groups = 'keep')
# View data
total_summary

# Create a lot_summary df with groupby() and summarize() fxns to group each manufacturing lot
lot_summary <- data.frame(coils_data %>% group_by(Manufacturing_Lot) %>% summarize(Mean=mean(PSI),Median=median(PSI),Variance=var(PSI),SD=sd(PSI), .groups = 'keep'))
# View data
lot_summary
