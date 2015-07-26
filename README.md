# Getting and Cleaning Data
This is a repository for coursework for the Getting and Cleaning Data course offered on Coursera from John Hopkins University.

## Course Project
The course project includes taking a sample dataset, running an R script called run_analysis.R, and converting the data into a tidy data set that only includes the desired data

The raw data for this project may be found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

A description of the raw data may be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

This sample dataset includes data collected from accelerometers from the Samsung Galaxy S smartphone.

## run_analysis.R
The purpose of this script is to create a tidy data set using the raw data linked above.  To run this script you will need the dplyr and the reshape2 libraries installed in R.  Unzip the raw data and set your current working directory to be the root of the unzipped folder.

The script will perform the following operations:
* Loads datasets from the test and train data
* Uses dplyr to merge the rows from the train and test datasets
* Loads the features definitions
* Uses a dplyr filter to find the columns matching either a mean or a std deviation
* Reduces the X dataset to the desired mean and std deviation columns
* Renames the columns in X to match the measurements taken
* Loads the activity labels and merges those labels onto the Y table
* Adds appropriate column names to the Y and Subjects tables
* Merges all tables together
* Writes out the merged data set to disk (without column headers and quotes) as merged_data.txt
* Uses reshape to melt the merged table by subject and activity
* Uses reshape to dcast the data back together using the mean statistic (our tidy dataset)
* Writes out the tidy data set to disk (without column headers and quotes) as tidy_data.txt

At the end of the script running you will have:
* A file named merged_data.txt containing all merged data for the desired variables
* A data table in memory named merged_data which contains this same data with appropriate column headers
* A file named tidy_data.txt containing our tidy data set with one row for each subject and activity combination with the mean of the measurements
* A data table in memory named shaped_data which contains this tidy data with appropriate column headers

## codebook.md
There is a codebook in this repository that contains information on the variables included along with pertinent information named codebook.md

## data
The resulting tidy data set is included in this repository in the data folder.  The merged data table and the raw data table are not included due to size considerations but the raw data may be easily obtained using the provided link above and the merged data obtained by running the script.
