#-----------------------------------------------------------------------------#
#                   Coursera - GetData 003 - Course Project                   #
#                        code by: github.com/JoeData                          #
#-----------------------------------------------------------------------------#
#               Review README.md and CodeBook.md before running               #
#-----------------------------------------------------------------------------#

#
# STEP 0 - CHECK FOR AND LOAD DATA  -------------------------------------------
#

# If "UCI HAR Dataset" folder not present in working directory,
# looks for filename containing "UCI HAR Dataset.zip" and unzip
if(!file.exists("UCI HAR Dataset")){
  
  if(length(grep("UCI HAR Dataset.zip", dir())) > 0){
    unzip(grep("UCI HAR Dataset.zip", dir(), value = TRUE)[[1]]);
  };
  
};

# read.table URL structure may vary by Operating System or User machine.
# structured used here tested on Windows 7 machine

# Read in Training data 
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt");
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt");
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt");

# Read in Testing data 
testData <- read.table("./UCI HAR Dataset/test/X_test.txt");
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt");
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt");
  
# Read in variable names for Activity & Features
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt"); 
features <- read.table("./UCI HAR Dataset/features.txt");  

#
# STEP 1 - MERGE TRAINING AND TESTING DATA SETS  ------------------------------
#

# Prepare Training Data for merge
colnames(trainData) <- features$V2;  # rename columns to features
trainData <- cbind(trainActivity, trainData);  # bind in Actvity data
trainData <- cbind(trainSubject, trainData);  # bind in Subject data
colnames(trainData)[1:2] <- c("subject", "activity"); # name added columns
         
# Prepare Testing Data for merge
testData <- cbind(testActivity, testData);  # add in Activity data
testData <- cbind(testSubject, testData);  # add in Subject data
colnames(testData) <- colnames(trainData);  # rename columns to match trainData

# Combine trainData & testData into new dataframe
mergeData <- trainData;  # create new dataframe from trainData
mergeData <- rbind(mergeData, testData);  # bind in TestData

#
# STEP 2 - EXTRACT MEASUREMENTS ON MEAN & STANDARD DEVIATION ------------------
#

# Identify columns names containing "std" & "mean", excluding "meanFreq"
meanStdColumns <- grep("std|mean[^meanFreq]", colnames(mergeData))

# Extract std & mean data into new dataframe 
extractData <- mergeData[, 1:2];  # create dataframe with subjects & activities 

# Bind in mean & standard devication columns 
extractData <- cbind(extractData, mergeData[,meanStdColumns]) # bind in

#
# STEP 3 - DESCRIPTIVE ACTIVITY NAMES -----------------------------------------
#

# Convert activity column to factors, defining activity values to levels (1:6)
extractData$activity <- as.factor(extractData$activity);

# Update activity levels to descriptive names from activityLabels
levels(extractData$activity) <- activityLabels[,2];  

#
# STEP 4 - LABEL DATA SET WITH DESCRIPTIVE NAMES ------------------------------
# variables styled in lowerCamelCase for safe, standard and readable names 
# See CodeBook.md for additional details regarding variable naming convention

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

#
# STEP 5 - 2ND DATA SET WITH AVG OF EACH VAR FOR EACH ACTIVITY & SUBJECT ------
#

# Check for required reshape2 package. If installed, will load into library
# if not yet installed, will install and load into library.
require(reshape2);

# Melt tidyData into new dataframe using ID variables "subject" & "activity"
tidyMelt <- melt(tidyData, id.vars = c("subject", "activity"));

# Recast data into new dataframe, with all variables averaged (mean)
# for each subject and activity
tidyMean <- dcast(tidyMelt, subject + activity ~ variable, mean );

# Write to .txt file, not including row names, since we are utilizng row numbers
write.table(tidyMean, file = "tidy_mean.txt", row.names = FALSE);