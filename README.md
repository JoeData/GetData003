 
GetData003
==========

Course Project - Getting and Cleaning Data

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

###################

### Files contained in Repo

* README.md - Analysis & Project overview
* CodeBook.md - Detailed information about all data transformations & variables
* run_analysis.R - The R script for completing all 5 required steps & output
* tidy\_mean.txt - the output of run\_analysis.R

### Manual Steps

Before running script, make sure that:
* the above linked "UCI HAR Dataset.zip" has been downloaded and unzipped into the working directory.
* the run_analysis.R file is in the working directory


### How the script works

The script contains six parts -- a Step 0 that checks for the data folder (or if missing - the .zip file) and loads in all necessary data. This is followed by five parts (one for each of the required steps above), that progressively build upon on the step before it. 

As all "data transformation" process details are required to be in the CodeBook, please see the CodeBook.md file for detailed information about script steps and functions.


### Script Outputs

The run\_analysis.R script outputs a tab-delimited file (named "tidy\_mean.txt") into the working directory. This file contains the final tidy dataset resulting from successful completing of all required steps and data manipulations.

Data variable information can be found in CodeBook.md
