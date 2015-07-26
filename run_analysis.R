# Getting and Cleaning Data Course Project
#
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
#
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
#  
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
#
# Here are the data for the project: 
#  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
# Note: I am running assuming I am in the base directory of the expanded zip file
#
# Load datasets
#
Xtest <- read.table("test/X_test.txt")
Ytest <- read.table("test/Y_test.txt")
Subtest <- read.table("test/subject_test.txt")

Xtrain <- read.table("train/X_train.txt")
Ytrain <- read.table("train/Y_train.txt")
Subtrain <- read.table("train/subject_train.txt")

# merge train and test datasets to create a single dataset
#
library(dplyr)
X <- bind_rows(list(Xtrain,Xtest))
Y <- bind_rows(list(Ytrain,Ytest))
Subjects <- bind_rows(list(Subtrain,Subtest))

# load features definitions
#
features <- read.table("features.txt")

# we only want the mean and std deviation of each measurement, I am using dplyr filter and a regex
# if we want to exclude to only use -mean() and -std() we can use the top line, was not totally
# sure by the instructions if we were meant to only use those or any case of mean and std
#
#filtered_features <- features %>% filter(grepl('-mean\\(\\)|-std\\(\\)',V2))
filtered_features <- features %>% filter(grepl('mean|Mean|std',V2))

# using the index of the features filter X to only have the wanted columns
#
filteredX <- X[,filtered_features$V1]

# rename our dataset so the column names match the measurement name
#
names(filteredX) <- features[filtered_features$V1,2]

# read in activity labels
#
activities <- read.table("activity_labels.txt")

# add activity labels to Y
#
Y <- merge(Y,activities,onY=V1)

# add better column names to Y and Subjects
# Note: probably could leave off the column names on the Y as when I merge I use a vector with cbind and the vector
#       drops the column names and cbind just uses the name of the vector as the name of the column, leaving this here
#       in case I decide to merge differently at some point
#
names(Y) <- c("activity_code","activity")
names(Subjects) <- c("subject")

# merge all tables together (clean data set)
#
activity = Y$activity
merged_data <- cbind(Subjects,activity,filteredX)

# write my merged data set out without column names
#
write.table(merged_data,"merged_data.txt", row.name = FALSE, quote = FALSE)

# create a tidy data set with the average of each variable for each activity and subject
# Note: using melt and then dcast as show in lecture videos on reshaping data
#
# melt will take all measurement columns and melt them together
#
# 2481        14   WALKING_UPSTAIRS           tBodyAcc-mean()-X  2.692139e-01
# 2482        14   WALKING_UPSTAIRS           tBodyAcc-mean()-X  2.388983e-01
# 2483        14   WALKING_UPSTAIRS           tBodyAcc-mean()-X  2.152555e-01
# 2484        14   WALKING_UPSTAIRS           tBodyAcc-mean()-X  1.813671e-01
# 2485        14   WALKING_UPSTAIRS           tBodyAcc-mean()-X  2.079072e-01
#
library(reshape2)
melted_data <- melt(merged_data,id=c("subject","activity"))

# dcast will then combine them again but using a statistic, in this case we will use the mean
#
shaped_data <- dcast(melted_data,subject + activity ~ variable, mean)

# write our tidy data set out
#
write.table(shaped_data,"tidy_data.txt", row.name = FALSE, quote = FALSE)



