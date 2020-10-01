# GettingAndCleaningData-CourseProject
##Accelerometer &amp; Gyro data from phone testing.

This repository contains the UCI HAR dataset, which is the starting point for the analysis.
Executing the run_analysis.R logic above the unzipped UCI HAR dataset will perform the analysis.

## tidydata.txt

tidydata.txt is the end result file.  It represents the averaged means of the original physical data variables, factored over each Test Subject, and the Activity performed by that Test Subject.  It should be noted that this averaged data does not include any variables that were not means or standard deviation data in the original data set.

There are 86 data variables measuring various accelerations, orientations (gyro), jerk accelerations, jerk orientations, etc.
Details of the data variables will be found in the CodeBook.md.

## run_analysis.R

This R program is the logic used to process the original UCI dataset into a combined, tidied subset, which is then further processed by melting, then casting the data into the form found in tidydata.txt. The details of the logic are described in CodeBook.md.

A procedure describing the steps taken to arrive at tidy.txt is provided below and in codebook.txt.

* Loads the data for the specified data set from the original research files.
* The Column names were then processed into a more standard, then a more readable, set of names.
* The Subject, Activity (number), and Activity Data data frames were combined such that the columns proceeded thus:
* The readible Column names vector was then applied to the combined data frame.
* A subset of the column names was created by selecting for those containing "mean" or "stddev".  The column names of "subject" and "activitynbr" were then added to the beginning of the vector.  The end-result was a list of the desired columns in requirement #2.  However, note that the Activity factor remains an integer value at this point.
* The combined data set produced above was then subsetted by selecting on that list of desired column names.
* The next step adds a new "activity" column based on the Activity table (File type "_y") as a character factor.
* The colnames list was then manipulated such that "activity" was the 2nd column name, and the now extraneous training "activity" column was removed.
* A final select of the dataset using the updated desired column names list produces the data with the Activity column as a character factor.
* The combined dataset is then processed by the tidydata function.
* Using the library "reshape2", the function calls the reshape2::melt function to melt the data set.
* Calls acast to cast the molten data into a multidimensional array, using the activity and subject columns as factors against the mean values of the variables. 

## CodeBook.md

CodeBook.md contains the following: 
* a detailed description of the initial dataset, 
* a more detailed description of the processing procedure, and 
* a complete list of variables (along with their units) that are present in tidy.txt.
