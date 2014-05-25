# CodeBook - run_analysis.R

### Table of Contents

* INTRODUCTION
* STUDY DESIGN
* STEP 0 - CHECK FOR AND LOAD DATA
* STEP 1 - MERGE TRAINING AND TESTING DATA SETS
* STEP 2 - EXTRACT MEASUREMENTS ON MEAN & STANDARD DEVIATION
* STEP 3 - DESCRIPTIVE ACTIVITY NAMES 
* STEP 4 - LABEL DATA SET WITH DESCRIPTIVE NAMES 
* STEP 5 - 2ND DATA SET WITH AVG OF EACH VAR FOR EACH ACTIVITY & SUBJECT
* DATA VARIABLES - tidyMean & tidy_mean.txt

### INTRODUCTION

>"a code book describes the variables, the data, and any transformations or work that you performed to clean up the data" - Instructions

Hello Courserians and GitHub browsers! Welcome to the CodeBook.md file for repository http://github.com/JoeData/GetData003, which desribes all details and output associated with my process, as coded in run_analysis.R, for successful completion of the Course Project for *Getting & Cleaning Data*.

To simplify code review and hopefully your evaluating experience:

* This CodeBook and run_analysis.R both follow the structure of the 5 Steps outlined in the project instructions.

* Section labels are included in the .R file to allow for code folding, if you prefer to review in RStudio or another editor that supports this. Learn more at [RStudio: Code Folding](https://www.rstudio.com/ide/docs/using/code_folding).

* .R file is styled based on [Google's R Style Guide](https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml). This includes lowerCamelCase variable names -- details and reasoning under "Step 4".

* .md files are styled based on [Adam Pritchard's Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet), which I highly recommend. It was a very useful reference during this project.

### STUDY DESIGN

>"There should be a section called "Study Design" that has a thorough description of how you collected the data" - #Components of Tidy Design# Lecture - Slide 5

Details from the project instructions:

>One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

>http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

>Here are the data for the project: 

>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


### STEP 0 - CHECK FOR AND LOAD DATA

>"The code should have a file run_analysis.R in the main directory that can be run as long as the Samsung data is in your working directory." - Project instructions

As stated in the project instructions and this repo's README.md file, user should verify that both run_analysis.R and the unzipped Samsung data folder "UCI HAR Dataset" are in the working directory before running the code. However, in case "Samsung Data" is interpreted to mean the .zip file, I've included a simple check for the data folder and if not found, will look for the .zip file and unzip.

***

Once unzipped data folder is present in working directory, script reads in all data necessary, resulting in eight dataframes:

| Name| Contents |
|-----------| --------------|
| trainData | All training measurements | 
| trainActivity | Activity performed for each row of training data |
| trainSubject | Subject who performed activity for each row of training data |
| testData | All testing measurements |
| testActivity | Activity performed for each row of testing data |
| testSubject |  Subject who performed activity for each row of testing data |
| activityLabels | ID number and descriptive label for each activity |
| features | Description names for all feature measurements (variables) |

### STEP 1 - MERGE TRAINING AND TESTING DATA SETS
>"Merges the training and the test sets to create one data set." - Project instructions

To prepare data for merging and later manipulation, subject and activity are added, as well as making sure that column variable names are set. Doing both of these at this point is much simpler than later in the script.

I've chosen to add Subject and Activity columns to the front -- columns left to right will be subject, activity, followed by variable measurement columns.
```R
# Prepare Training Data for merge
colnames(trainData) <- features$V2;  # rename columns to features
trainData <- cbind(trainActivity, trainData);  # bind in Actvity data
trainData <- cbind(trainSubject, trainData);  # bind in Subject data
colnames(trainData)[1:2] <- c("subject", "activity"); # name added columns

# Prepare Testing Data for merge
testData <- cbind(testActivity, testData);  # add in Activity data
testData <- cbind(testSubject, testData);  # add in Subject data
colnames(testData) <- colnames(trainData);  # rename columns to match trainData
```
Now that data is prepped, can merge (or more accurately "bind") into new dataframe.

```R
# Combine trainData & testData into new dataframe
mergeData <- trainData;  # create new dataframe from trainData
mergeData <- rbind(mergeData, testData);  # bind in TestData
```

New dataframe "mergeData" (10299 rows | 563 variables) now contains all measurement data.

### STEP 2 - EXTRACT MEASUREMENTS ON MEAN & STANDARD DEVIATION
>"Extracts only the measurements on the mean and standard deviation for each measurement." - Project instructions

The dataset contains numerous measurements (features) related to means or standard deviation.  However, according to the CodeBook for the original data set (features_info.txt) only two are clearly and explicity ONLY mean and standard deviation, rather than a related or second step measurement:

* mean(): Mean value
* std(): Standard deviation

The code successfully identifies the 66 measurements related for mean() or std() and extracts them into a new dataframe, while also preserving our first two ID columns -- subject and activity.

```R
# Identify columns names containing "std" & "mean", excluding "meanFreq"
meanStdColumns <- grep("std|mean[^meanFreq]", colnames(mergeData))

# Extract std & mean data into new dataframe 
extractData <- mergeData[, 1:2];  # create dataframe with subjects & activities 

# Bind in mean & standard devication columns 
extractData <- cbind(extractData, mergeData[,meanStdColumns]) # bind in
```

This results in new dataframe "extractData" ( 10299 rows | 68 variables).

### STEP 3 - DESCRIPTIVE ACTIVITY NAMES 
>"Uses descriptive activity names to name the activities in the data set" - Project instructions

This is most easily accomplished by converting the activity column (integer class) to factors. By doing so each value becomes a level and we can give the six levels new names, rather than attempting to match and update every one of our 10000+ rows

```R
# Convert activity column to factors, defining activity values to levels (1:6)
extractData$activity <- as.factor(extractData$activity);

# Update activity levels to descriptive names from activityLabels
levels(extractData$activity) <- activityLabels[,2]; 
```

### STEP 4 - LABEL DATA SET WITH DESCRIPTIVE NAMES 
>"Appropriately labels the data set with descriptive activity names." - Project instructions

The similar wording of steps #3 & #4 led to confusion and debate in the forums.  Thankfully one of the Community TA's ackowledged the poor wording and clarified:

>"Step 4 is poorly worded...read it as label the data set (the data frame, so we are talking variable names) with names reflecting the activities the variable was capturing" - David Cook (Community TA)

Now that it's clear the variable names are what Step 4 applies to, the next question is how to best format the "descriptive names". I've chosen to user lowerCamelCase to adhere as closely as possibly to the format recommended in the lecture, while improving readability due to the exceptionally long length when using fully descriptive words. Additionally, this adheres to the Google Style R Guide format for "Good" variable names. 

* "V348" - what we started with
* "fBodyAccJerk-std()-Z" - after step #1, having added in provided feature names
* "fourierbodyaccelerationjerkstandarddeviationzaxis" - as recommended in the lectures
* "fourierBodyAccelerationJerkStandardDeviationZAxis" - as coded for increased readability

Fortunately, TA David Cook is again helpful having experienced the same concern, advising... 
>"(I) put a note in the code book (and a comment in my script) that due having names up to x characters I was using Camel Case to aid readability rather than all lower case... both times the project has been through the peer grading process my markers have been generous, feeling that I had addressed the issue in an adequate way."

To get to descriptive and readible variable names, went through numerous steps:

```R
# create new dataframe from extractData for soon to be tidy dataset
tidyData <- extractData;

# remove parentheses and hyphens, temporarily replace with dots
names(tidyData) <- gsub("\\(\\)", "", names(tidyData));
names(tidyData) <- gsub("\\-", "", names(tidyData));

# convert abbreviations to descriptive and readable words
# as defined in original UCI HAR Dataset codebook 
names(tidyData) <- gsub("^t", "time", names(tidyData));
names(tidyData) <- gsub("^f", "fourier", names(tidyData));
names(tidyData) <- gsub("Acc", "Acceleration", names(tidyData));
names(tidyData) <- gsub("Gyro", "Gyroscope", names(tidyData));
names(tidyData) <- gsub("Mag", "Magnitude", names(tidyData));
names(tidyData) <- gsub("mean", "Mean", names(tidyData));
names(tidyData) <- gsub("X$", "XAxis", names(tidyData));
names(tidyData) <- gsub("Y$", "YAxis", names(tidyData));
names(tidyData) <- gsub("Z$", "ZAxis", names(tidyData));
names(tidyData) <- gsub("std", "StandardDeviation", names(tidyData));

#remove duplicate "Body". not in original codebook, appears to be in error
names(tidyData) <- gsub("BodyBody", "Body", names(tidyData));
```

This resulted in a tidyData dataframe, with all of our measurements, for all subjects and activities, containing descriptive variable names as well as descriptive activity names.

### STEP 5 - 2ND DATA SET WITH AVG OF EACH VAR FOR EACH ACTIVITY & SUBJECT
>"Creates a second, independent tidy data set with the average of each variable for each activity and each subject." - Project instructions

Before proceeding into the last manipulations, the script requires that reshape2 package is installed and loaded.

```
# Check for required reshape2 package. If installed, will load into library
# if not yet installed, will install and load into library.
require(reshape2);
```

In order to calculate mean for each measurement for every combo of subject & activity, the dataframe must be melted. Once melted, it is easily recast with ID variables of "subject" & "activity" and function of mean for all remaining columns.

```R
# Melt tidyData into new dataframe using ID variables "subject" & "activity"
tidyMelt <- melt(tidyData, id.vars = c("subject", "activity"));

# Recast data into new dataframe, with all variables averaged (mean)
# for each subject and activity
tidyMean <- dcast(tidyMelt, subject + activity ~ variable, mean );
```

Last step is to write the data to a file. Originally, I utilized the default space-separated format. However, after forum discussions regarding the increased ease and compatibility of tab-delimited, I've opted for tab as separator.
```R
# Write to .txt file, not including row names, since we are utilizng row numbers
write.table(tidyMean, file = "tidy_mean.txt", sep="\t", row.names = FALSE);
```

Step #5 completes the run\_analysis.R script, producing a dataframe "tinyMean" and output a tab-delimited file -- tidy\_mean.txt .

### DATA VARIABLES - tidyMean & tidy_mean.txt

The tidyMean dataframe & the tab-delimited file "tidy_mean.txt" contain:

* 180 rows (30 subjects x 6 activities)
* 68 columns (2 for "subject" & "activity" and 66 for mean measurements [as calculated in step 5]

|Column|Name|
|----|-----
|1|subject|
|2|activity|
|3|timeBodyAccelerationMeanXAxis|
|4|timeBodyAccelerationMeanYAxis|
|5|timeBodyAccelerationMeanZAxis|
|6|timeBodyAccelerationStandardDeviationXAxis|
|7|timeBodyAccelerationStandardDeviationYAxis|
|8|timeBodyAccelerationStandardDeviationZAxis|
|9|timeGravityAccelerationMeanXAxis|
|10|timeGravityAccelerationMeanYAxis|
|11|timeGravityAccelerationMeanZAxis|
|12|timeGravityAccelerationStandardDeviationXAxis|
|13|timeGravityAccelerationStandardDeviationYAxis|
|14|timeGravityAccelerationStandardDeviationZAxis|
|15|timeBodyAccelerationJerkMeanXAxis|
|16|timeBodyAccelerationJerkMeanYAxis|
|17|timeBodyAccelerationJerkMeanZAxis|
|18|timeBodyAccelerationJerkStandardDeviationXAxis|
|19|timeBodyAccelerationJerkStandardDeviationYAxis|
|20|timeBodyAccelerationJerkStandardDeviationZAxis|
|21|timeBodyGyroscopeMeanXAxis|
|22|timeBodyGyroscopeMeanYAxis|
|23|timeBodyGyroscopeMeanZAxis|
|24|timeBodyGyroscopeStandardDeviationXAxis|
|25|timeBodyGyroscopeStandardDeviationYAxis|
|26|timeBodyGyroscopeStandardDeviationZAxis|
|27|timeBodyGyroscopeJerkMeanXAxis|
|28|timeBodyGyroscopeJerkMeanYAxis|
|29|timeBodyGyroscopeJerkMeanZAxis|
|30|timeBodyGyroscopeJerkStandardDeviationXAxis|
|31|timeBodyGyroscopeJerkStandardDeviationYAxis|
|32|timeBodyGyroscopeJerkStandardDeviationZAxis|
|33|timeBodyAccelerationMagnitudeMean|
|34|timeBodyAccelerationMagnitudeStandardDeviation|
|35|timeGravityAccelerationMagnitudeMean|
|36|timeGravityAccelerationMagnitudeStandardDeviation|
|37|timeBodyAccelerationJerkMagnitudeMean|
|38|timeBodyAccelerationJerkMagnitudeStandardDeviation|
|39|timeBodyGyroscopeMagnitudeMean|
|40|timeBodyGyroscopeMagnitudeStandardDeviation|
|41|timeBodyGyroscopeJerkMagnitudeMean|
|42|timeBodyGyroscopeJerkMagnitudeStandardDeviation|
|43|fourierBodyAccelerationMeanXAxis|
|44|fourierBodyAccelerationMeanYAxis|
|45|fourierBodyAccelerationMeanZAxis|
|46|fourierBodyAccelerationStandardDeviationXAxis|
|47|fourierBodyAccelerationStandardDeviationYAxis|
|48|fourierBodyAccelerationStandardDeviationZAxis|
|49|fourierBodyAccelerationJerkMeanXAxis|
|50|fourierBodyAccelerationJerkMeanYAxis|
|51|fourierBodyAccelerationJerkMeanZAxis|
|52|fourierBodyAccelerationJerkStandardDeviationXAxis|
|53|fourierBodyAccelerationJerkStandardDeviationYAxis|
|54|fourierBodyAccelerationJerkStandardDeviationZAxis|
|55|fourierBodyGyroscopeMeanXAxis|
|56|fourierBodyGyroscopeMeanYAxis|
|57|fourierBodyGyroscopeMeanZAxis|
|58|fourierBodyGyroscopeStandardDeviationXAxis|
|59|fourierBodyGyroscopeStandardDeviationYAxis|
|60|fourierBodyGyroscopeStandardDeviationZAxis|
|61|fourierBodyAccelerationMagnitudeMean|
|62|fourierBodyAccelerationMagnitudeStandardDeviation|
|63|fourierBodyAccelerationJerkMagnitudeMean|
|64|fourierBodyAccelerationJerkMagnitudeStandardDeviation|
|65|fourierBodyGyroscopeMagnitudeMean|
|66|fourierBodyGyroscopeMagnitudeStandardDeviation|
|67|fourierBodyGyroscopeJerkMagnitudeMean|
|68|fourierBodyGyroscopeJerkMagnitudeStandardDeviation|
