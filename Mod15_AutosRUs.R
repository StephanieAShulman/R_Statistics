# MODULE 15 - R ANALYTICS / AUTOSRUS
# Exercises as part of module; supports Challenge

# 15.2.4 Select Data
# Vector - indexing wtih []
# NOTE: R starts with 1
z <- c(3, 3, 2, 2, 5, 5, 8, 8, 9)
z[3]

# Select the third row of the Year column
demo_table[3,"Year"]  # 2019

# Can also use just indces for row and column
# R keeps track under the hood
demo_table[3,3]  # 2019

# Can also use $ to get any column from 2D
demo_table$"Vehicle_Class"
# Compact Sedan  Pickup  SUV  Subcompact Sedan

# With a single vector, can use brackets to select a single value
demo_table$"Vehicle_Class"[2]  # Pickup

# Use brackets to filter data
# EG: demo2 - rows where price > 10K
#  Need comma to subset by rows; adding columns after comma indicates which to select
filter_table <- demo_table2[demo_table2$price > 10000,]
# From 10 obs to 5 obs (still 22 variables)

# With more complicated filtering, need subset()
?subset()

# EG: Filter by price and drivetrain
filter_table2 <- subset(demo_table2, price > 10000 & 
                          drive == "4wd" &
                          "clean" %in% title_status)
# 2 obs/22 variables
# This is cleaner than brackets:
# filter_table3 <- demo_table2[("clean" %in% demo_table2$title_status) &
#  (demo_table2$price > 10000) & (demo_table2$drive == "4wd"),]

# Sometimes need to generate random samples to reduce bias
?sample()

# To sample a large vector and create a smaller one, can set the vector to "x"
sample(c("cow", "deer", "pig", "chicken", "duck", "sheep", "dog"), 4)
# sheep pig dog chicken ????????

# To sample a 2D data structure, need to supply row index - 3 steps
# 1. Create numerical vector of same length as # of rows in df with :
# 2. Use sample() fxn to sample list of indices from first vector
# 3. Use bracket notation to retrieve df rows from sample list

# Capture the number of rows in demo_table; use nrow() fxn to count # in df
num_rows <- 1:nrow(demo_table)
# Sample three of the rows
sample_rows <- sample(num_rows, 3)
# Retrieve the requested data
demo_table[sample_rows, ]

# To combine into a single R statement:
demo_table[sample(1:nrow(demo_table), 3),]

# After successfully loading and selecting data, time to
#  group, transform and shape data as prep for visualization and mdoeling

# 12.2.5 - Transform, Group and Reshape Data - Tidyverse Pkg
# % > % - can pipe for chaining
# mutate() fxn to transform a df and include new calculated data columns

library(tidyverse)
# Notes said ignore errors ... I got 3 conflicts "masks ... filter, flatten, lag"
?mutate()
# Confusing documentation ... think of it as a series of smaller assignment statements,
#  separated by commas; each new name appears as a new column in the raw df

# Add columns to original data frame
demo_table <- demo_table %>% mutate(Mileage_per_Year=Total_Miles/(2020-Year),IsActive=TRUE) 

# Grouping to summarize data
# Grouping across a factor: "character vector" R vs "list of strings" Python
# dplyr's group_by() fxn to tell dplyr which factor (or list of factors) to group by

# Create a summary table that groups used car data by vehicle condition
#  and determines the avg miles per condition
summarize_demo <- demo_table2 %>% group_by(
  condition) %>% summarize(Mean_Mileage=mean(odometer), .groups = 'keep')

# summarize() fxn is similar to mutate() fxn
# will use for stats - mean(), median(), sd(), min(), max(), n() - but has
#  more comprehensive list

# Create a summary table with multiple columns
summarize_demo <- demo_table2 %>% group_by(
  condition) %>% summarize(Mean_Mileage=mean(odometer),
                           Maximum_Price=max(price),
                           Num_Vehicles=n(), .groups = 'keep')

# .groups allos you to control the grouping of the results

# Reshape Data
# gather() fxn - transforms wide dataset into a long dataset
# spread() fxn - can use to spread out a variable column of multiple measures
#  into columns for each variable
# ALSO: pivot_longer() - increases rows/decreases columns; pivot_wider() - opposite

?gather()
# Gather columns into key-value pairs

# Demo3 = survey results from 250 vehicles collected by a rental company
#  7 metrics rated low (1) to high (5)
demo_table3 <- read.csv('demo2.csv', check.names = FALSE, stringsAsFactors = FALSE)

# Convert the wide format to long
long_table <- gather(demo_table3,key="Metric",value="Score",buying_price:popularity)
# ALT VERSION:
# long_table <- demo_table3 %>% gather(key="Metric",value="Score",buying_price:popularity)

# gather() collapsed all survey metrics into one Metric column and all values
#  into one Score column with Vehicle column (not included in arguments)
#  treated as an identifier column (added as a unique identifier)

?spread()
# Spread a key-value pair across multiple columns
# Spread previous long-format data frame back to original format
wide_table <- long_table %>% spread(key="Metric",value="Score")

# all.equal() to verify wide_table matches demo_table3
all.equal(demo_table3, wide_table) # see course pix (matches)
# But these don't appear to be equal ... 
#  Maybe sorting is off? Let's check with order() fxn, colnames() fxn & []
table <- demo_table3[,order(colnames(wide_table))]
# OR - sort the columns using colnames() fxn and [] only
#table <- demon_table3[,(colnames(wide_table))]

# DID IT TELL US THEY'RE THE SAME?? DO I HAVE TO RUN all.equal() again??

# On to visualization
# 15.3.1 Introduction to ggplot2
?ggplot()
# Establish a base ggplot object, then add aesthetics with "+"

# mpg dataset already loaded into library
head(mpg)

# Create a bar plot to represent the frequency of each category of vehicle class
# Import dataset into ggplot2
plt <- ggplot(mpg, aes(x=class))
# Plot a bar plot
plt + geom_bar()
# NOTE: Visualizing univariate data so need x only in aes() fxn

?geom_bar()
# Two types - geom_bar() - proportional; geom_col() - represents data

# Can also compare/contrast 
# Create a summary table
mpg_summary <- mpg %>% group_by(
  manufacturer) %>% summarize(
    Vehicle_Count=n(), .groups = 'keep')
# Import dataset into ggplot2
plt2 <- ggplot(mpg_summary, aes(
  x=manufacturer, y=Vehicle_Count))
# Plot a bar plot
plt2 + geom_col()

# 15.3.3 Formatting
# Add titles to x-axis and y-axis with xlab(), ylab() fxns
plt2 + geom_col() + 
  xlab("Manufacturing Company") + 
  ylab("Number of Vehicles in Dataset")

# Now rotate the x-axis labets 45 degrees so that they don't overlap
plt2 + geom_col() + 
  xlab("Manufacturing Company") + 
  ylab("Number of Vehicles in Dataset") + 
  theme(axis.text.x=element_text(angle=45,hjust=1))

# 15.3.4 Build a Line Plot in ggplot2
# Line plots - visualize relationship between categorical var & continuous numbers
# Have to set categorical to x and continuous to y with aes() fxn

# EG: Compare fuel economy (hwy) of Toyota by cylinder size (cyl)
# Create the summary table
mpg_summary <- subset(mpg,manufacturer=="toyota") %>% group_by(cyl) %>% summarize(Mean_Hwy=mean(hwy), .groups = 'keep')
# Import the dataset into ggplot2
plt3 <- ggplot(mpg_summary,aes(x=cyl,y=Mean_Hwy))
# Plot the data
plt3 + geom_line()
# Adjust x-axis/y-axis ticks to scale
plt3 + geom_line() + 
  scale_x_discrete(limits=c(4,6,8)) + 
  scale_y_continuous(breaks = c(15:30))

# Scatterplots are just as easy to implement
# x = independent, y = dependent within aes() fxn
# EG: Visualize relationship between car engine size (displ) vs city fuel eff (city)
plt4 <- ggplot(mpg, aes(x=displ,y=cty))
plt4 + geom_point() + xlab("Engine Size (L)") + ylab("City Fuel Efficiency (MPG)")

# Can use aesthetics to convey more information, especially about groups of data
# alpha (transparency), color, shape, size
# EG: Relationship between city fuel efficiency and engine size grouped also by car class
plt5 <- ggplot(mpg,aes(x=displ,y=cty,color=class))
plt5 + geom_point() + 
  labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", 
       color="Vehicle Class")

# ALTERNATIVE - labs() fxn - can customize axis labels and any group variable labels

# Can create a scatterplot with multiple aesthetics
# Import dataset into ggplot2
plt6 <- ggplot(mpg,aes(x=displ,y=cty,color=class,shape=drv))
# Plot the data
plt6 + geom_point() + 
  labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)",
       color="Vehicle Class",
       shape="Type of Drive")

# 15.3.5 Create Advanced Boxplots in ggplot2
# geom_boxplot() for box-and-whisker plots
# geom_tile() for heatmaps
# Continuous data - summary stats - boxplot!
# Must supply a vector of numeric values
# Import dataset into ggplot2
plt7 <- ggplot(mpg, aes(y=hwy))
# Add a boxplot
plt7 + geom_boxplot()

# ggplot actually expects multiple figures
# can supply cat grouping to x (type of car)
# EG: Hwy fuel efficiency for each car manufacturer
# Import dataset
plt8 <- ggplot(mpg, aes(x=manufacturer, y=hwy))
# Create boxplot and rotate x-axis labels 45 degrees
plt8 + geom_boxplot() + theme(axis.text.x=element_text(angle=45,hjust=1))

# 15.3.6 Create Heatmap Plots
# Good for seeing intensity across time
# Good for visualizing relationship of 1 cont num :: two others (cat or num)
# Get a 2D grid where clusters and trends are easily identifiable
# Create the summary table based on class
mpg_summary <- mpg %>% group_by(class,year) %>% summarize(Mean_Hwy=mean(hwy), .groups='keep')
# Import the dataset into ggplot2
plt9 <- ggplot(mpg_summary, aes(x=class,y=factor(year),fill=Mean_Hwy))
# Create heatmap with labels
plt9 + geom_tile() + labs(
  x="Vehicle Class", y="Vehicle Year", fill= "Mean Highway (MPG)")

# Heatmaps allow us to visualize variables with a large # of values/categories
# EG: Difference in avg hwy fuel efficiency across each model (1999-2008)
# Create the summary table based on model
mpg_summary <- mpg %>% group_by(model,year) %>% summarize(Mean_Hwy=mean(hwy), .groups='keep')
# Import the dataset into ggplot2
plt10 <- ggplot(mpg_summary, aes(x=model,y=factor(year),fill=Mean_Hwy))
# Create the heatmap; rotate x-axis 90 degrees
plt10 + geom_tile() + labs(x="Model",y="Vehicle Year",fill="Mean Highway (MPG)") + theme(axis.text.x = element_text(angle=90,hjust=1,vjust=.5))

# 15.3.7 Add Layers to Plots
# Faceting - Combining similar plots into single plot (showing small versions of each)
# Layering (a) same variable data as original plot; (b) different but complimentary data
#  good for adding context to initial visualization

# EG: Prior boxplot - Hwy fuel efficiency :: Manufacturers
# Overlay a scatterplot to get general distribution (YUCKY)
# Import dataset into ggplot2
plt11 <- ggplot(mpg, aes(x=manufacturer, y=hwy))
# Create the boxplot with scatterplot overlay
plt11 + geom_boxplot() + theme(axis.text.x=element_text(angle=45,hjust=1)) + geom_point()

# Can also be used with complimentary data
# EG: Avg engine size :: Vehicle Class
# Create summary table
mpg_summary <- mpg %>% group_by(class) %>% summarize(Mean_Engine=mean(displ), .groups = 'keep')
# Import dataset with ggplot2
plt12 <- ggplot(mpg_summary,aes(x=class,y=Mean_Engine))
# Create scatterplot
plt12 + geom_point(size=4) + labs(x="Vehicle Class",y="Mean Engine Size")

# This plot needs more context; add SD with summarize(), geom_errorbar()
# Create summary table
mpg_summary <- mpg %>% group_by(class) %>% summarize(Mean_Engine=mean(displ),
    SD_Engine=sd(displ), .groups = 'keep')
# Import the dataset into ggplot2
plt13 <- ggplot(mpg_summary,
              aes(x=class,y=Mean_Engine))
# Create the plot with point that have standard deviation
plt13 + geom_point(size=4) + 
  labs(x="Vehicle Class",y="Mean Engine Size") + 
  geom_errorbar(aes(ymin=Mean_Engine-SD_Engine,ymax=Mean_Engine+SD_Engine))

# head(mpg,3)
# summary (mpg)

# FACETING - Allows you to plot all measurements, but grouped by level or category
# Convert to long format
mpg_long <- mpg %>% gather(key="MPG_Type", value="Rating", c(cty,hwy))
head(mpg_long,3)
#head(mpg,3) # for comparison
# To visualize the different vehicle fuel efficiency ratings by manufacturer,
#  import the dataset into ggplot2
plt14 <- ggplot(mpg_long,aes(x=manufacturer,y=Rating,color=MPG_Type))
# Add a boxplot with labels rotated 45 degrees
plt14 + geom_boxplot() + theme(axis.text.x=element_text(angle=45,hjust=1))

# This plot - despite giving details - is difficult to compare city vs hwy
#  efficiency across all manufacturers ... need side-by-side
# One option: facet_wrap() fxn
?facet_wrap()
# Wrap a 1d ribbon of panels into 2d
#  Argument expects a list of grouping variables to facet by using vars() fxn
plt15 <- ggplot(mpg_long,aes(x=manufacturer,y=Rating,color=MPG_Type))
plt15 + geom_boxplot() + facet_wrap(vars(MPG_Type)) + theme(axis.text.x=element_text(angle=45,hjust=1), legend.position = "none") + xlab("Manufacturer")

# 15.4.5 Testing for Normality
# The qualitative test is a visual assessment - classic bell curve?
# Visualize the distribution with a density plot
ggplot(mtcars, aes(x=wt)) + geom_density()

# Most commonly used: Shapiro-Wilk test for normality (quantitative)
?shapiro.test
shapiro.test(mtcars$wt)
# W = 0.94326, p-value = 0.09265
# Most tests assume approximating normality so H0 = Normal; HA = Not; 
#  no reason to reject null

# But what if data aren't normal? SKEW
# ...
# 15.6.1 Sample vs Population Dataset
# Random sampling - R base - sample() fxn; dplyr - sample_n() fxn
?sample_n()

# Used vehicle data - distribution of driven miles
# Import used car data
population_table <- read.csv('used_car_data.csv', check.names=F, stringsAsFactors=F)
# Import dataset into ggplot2
plt16 <- ggplot(population_table, aes(x=log10(Miles_Driven)))
# Visualize distribution using density plot
plt16 + geom_density()

# Create a random sample dataset from the population data
sample_table <- population_table %>% sample_n(50)
plt17 <- ggplot(sample_table, aes(x=log10(Miles_Driven)))
plt17 + geom_density()

# 15.6.2
# Student t-test
?t.test()

# Compare sample versus population means
t.test(log10(sample_table$Miles_Driven),mu=mean(log10(population_table$Miles_Driven)))

# 15.6.3 Use the Two-Sample t-Test
# Produce two samples
# 50 Randomly sampled data points
sample_table <- population_table %>% sample_n(50)
# Another 50 randomly sampled data points
sample_table2 <- population_table %>% sample_n(50)
# Compare the means of the two samples
t.test(log10(sample_table$Miles_Driven),log10(sample_table2$Miles_Driven))
# Fail to reject the null

# Use Two-Sample t-Test to Compare Samples
# Generate two data samples (1999 vs 2008)
mpg_data <- read.csv('mpg_modified.csv')
mpg_1999 <- mpg_data %>% filter(year==1999)
mpg_2008 <- mpg_data %>% filter(year==2008)
# Compare the mean difference between the two samples
t.test(mpg_1999$hwy,mpg_2008$hwy,paired = T)

# 15.6.5 Use the ANOVA Test
# ANOVA compares means of continuous values; must convert to factor if not continuous
mtcars_filt <- mtcars[,c("hp","cyl")] #filter columns from mtcars dataset
mtcars_filt$cyl <- factor(mtcars_filt$cyl) #convert numeric column to factor

aov(hp ~ cyl,data=mtcars_filt) #compare means across multiple levels

summary(aov(hp ~ cyl,data=mtcars_filt)) #use summary to get p-value

# 15.7.1 Correlation
head(mtcars)
plt18 <- ggplot(mtcars,aes(x=hp,y=qsec)) #import dataset into ggplot2
plt18 + geom_point() #create scatter plot
# Qualitatively, there appears to be a negative correlation
# Check it quantitatively
cor(mtcars$hp,mtcars$qsec) #calculate correlation coefficient
# Strong, negative correlation according to R2 (-0.71)

# Check out the used car data
used_cars <- read.csv('used_car_data.csv',stringsAsFactors = F) #read in dataset
head(used_cars)

plt19 <- ggplot(used_cars,aes(x=Miles_Driven,y=Selling_Price)) #import dataset into ggplot2
plt19 + geom_point() #create a scatter plot
# clumpy

cor(used_cars$Miles_Driven,used_cars$Selling_Price) #calculate correlation coefficient
# 0.02 Nope

# Can also produce a correlation matrix (aka: lookup table)
used_matrix <- as.matrix(used_cars[,c("Selling_Price","Present_Price","Miles_Driven")]) #convert data frame into numeric matrix
cor(used_matrix)

# 15.7.2 Return to Linear Regression
lm(qsec ~ hp,mtcars) #create linear model
summary(lm(qsec~hp,mtcars)) #summarize linear model
# Once calculated, we can visualize the linear model
model <- lm(qsec ~ hp,mtcars) #create linear model
yvals <- model$coefficients['hp']*mtcars$hp + model$coefficients['(Intercept)'] #determine y-axis values from linear model
# Plot linear model over scatterplot
plt20 <- ggplot(mtcars,aes(x=hp,y=qsec)) #import dataset into ggplot2
plt20 + geom_point() + geom_line(aes(y=yvals), color = "red") #plot scatter and linear model

# 15.7.3 Multiple Linear Regression
lm(qsec ~ mpg + disp + drat + wt + hp,data=mtcars) #generate multiple linear regression model
summary(lm(qsec ~ mpg + disp + drat + wt + hp,data=mtcars)) #generate summary statistics
# Although the multiple linear regression model is far better at
#  predicting our current dataset, the lack of significant variables
#  is evidence of overfitting.
# Because multiple linear regression models use multiple variables and dimensions,
#  they are almost impossible to plot and visualize.

# 15.8.1 Category Complexities - Chi-Squared Test
# Here for statistical difference testing (vs test of independence)
# Generate a contingency table (aka: frequency table)
table(mpg$class,mpg$year)
# Pass the table to chisq.test() fxn
tbl <- table(mpg$class,mpg$year) #generate contingency table
chisq.test(tbl) #compare categorical distributions