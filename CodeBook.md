# GettingAndCleaningData-CourseProject

Student:    Jeff Murdoch
Coursera-GettingAndCleaningData-CourseProject:  Accelerometer &amp; Gyro data from phone testing.

Direction: CodeBook.md contains the following: a detailed description of the initial dataset, a procedure similar to the one provided above, and a complete list of variables (along with their units) that are present in tidy.txt.

## Context

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data produced by that research, and used in this data cleaning project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Input Data

### UCI HAR Dataset
This dataset is comprised of sensor readings and calculated data from those readings from a set of 30 individuals who performed a set of defined actions while wearing a device with both accelerators and gyroscopes which can determine direction and intensity of applied forces including gravity.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

Notes:
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

The complete list of variables of each feature vector is available in the UCI HAR Dataset file 'features.txt'
The details of that original data can be found in the UCI HAR Dataset file "README.txt".

## Data Processing

The goal is to prepare tidy data that can be used for later analysis. 

The logic file contains a set of functions to achieve these goals:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    
### run_analysis.R

The functions here are:

#### combineData <- function(data = NA, exportfile = "combined.csv", directory = "./output", debug = FALSE) 

This function begins the processing of the original research data. It:

* makes calls to 'processData' to process the training and test data sets respectively, then 
* combines those data sets, 
* writes the combination out to /output/combined.txt, then 
* returns the combination as an end-product.

#### processData <- function(directory = "./UCI HAR Dataset", datatype = "test", debug = FALSE) 

Processes a specified data set ( test, train) thus:
* Loads the data for the specified data set from the original research files.
** dataSubject: A list of the test subjects.
** dataActivity: The provided raw data set, with no column names.
** dataActivityLabels: The list of 6 activities performed by test subjects.
** datafileColumnNames: The features list of column names for the dataActivity.

* The Column names were then processed into a more standard, then a more readable, set of names.
** Removed dashes
** Removed punctuation symbols
** Set the name into lowercase
** executed the prettyname function on the name to improve readibility.

* The Subject, Activity (number), and Activity Data data frames were combined such that the columns proceeded thus:
** subject, activity, (data)...

* The readible Column names vector was then applied to the combined data frame.

* A subset of the column names was created by selecting for those containing "mean" or "stddev".  The column names of "subject" and "activitynbr" were then added to the beginning of the vector.  The end-result was a list of the desired columns in requirement #2.  However, note that the Activity factor remains an integer value at this point.

* The combined data set produced above was then subsetted by selecting on that list of desired column names.

* The next step adds a new "activity" column based on the Activity table (File type "_y") as a character factor.

* The colnames list was then manipulated such that "activity" was the 2nd column name, and the now extraneous training "activity" column was removed.

* A final select of the dataset using the updated desired column names list produces the data with the Activity column as a character factor.

* The final data set is returned, presumably to the calling function "combineData".

#### prettyname <- function(originalColumnName)

Processes a column name to improve readability according to a set of standard rules.
* replaced leading "t" with "total"
* replaced leading "f" with "frequency"
* replaced "acc" with "acceleration"
* replaced "mag" with "magnitude"
* replaced "std" with "stddev"

#### tidyData <- function(data = NA,  exportfile = "tidy.txt",  directory = "./output",  debug = FALSE) 

* Loads the library "reshape2".
* Checks for empty data input.
* Calls the reshape2::melt function to melt the data set.
* Calls acast to cast the molten data into a multidimensional array, using the activity and subject columns as factors against the mean values of the variables. Note that dcast could not be used, as it cannot handle multidimensionality.
* Writes the array out to the "output/tidy.txt" file.
* Returns array.

## Output Data
Output files are found in the /output directory.

### Averaged Data

#### combined.txt

Data file containing the mean and standard deviation values of both forces detected and calculated taken over the course of testing by the test subjects for a set of 6 types of actions.  Some calculated values are directional in the x, y, and z directions. Only the means and standard deviation values are provided here; the other values observed were deliberately omitted in this dataset.

#### tidy.txt

Data file containing the averaged means and averaged standard deviations for each test subject and their performed activity as a crosstab.

##### Variable List

The complete list of 88 variables provided in each output dataset is available below.

The factor variables are:
subject                             The integer identifier for a given test subject

activity                            The activity performed as character factor: WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING

Observation variables:
     These data values represent the _Average_ of the collected/calculated values for a given Subject performing a given Activity.

     The time- prefixed data values come from the accelerometer and gyroscope 3-axial raw signals timebody-XYZ and timebodygryo-XYZ. The acceleration signal was then separated into body and gravity acceleration signals.

     The body linear acceleration and angular velocity were derived in time to obtain Jerk signals (timebodyaccelerationjerk-XYZ and timebodygyrojerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (timebodyaccelerationmagnitudemean, timegravityaccelerationmagnitudemean, timebodyaccelerationjerkmagnitude, timebodygyromagnitude, timebodygyrojerkmagnitude). 

     The averaged values produced via Fast Fourier Transform (FFT) are here as frequencybodyacceleration-XYZ, frequencybodyaccelerationjerk-XYZ, frequencybodygyro-XYZ, frequencybodyaccelerationjerkmagnitude, frequencybodygyromagnitude, frequencybodygyrojerkmagnitude. (Note the frequency domain signals). 

     These signals were used to estimate variables of the feature vector for each pattern:  
     '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

     Data are normalized and bounded within [-1,1]; hence, dimensionless.

timebodyaccelerationmeanx                    Time-domain feature, Body Acceleration in the X direction
timebodyaccelerationmeany                    Time-domain feature, Body Acceleration in the Y direction
timebodyaccelerationmeanz                    Time-domain feature, Body Acceleration in the Z direction
timebodyaccelerationstddevx                  Time-domain feature, Standard Deviation of Body Acceleration in the X direction
timebodyaccelerationstddevy                  Time-domain feature, Standard Deviation of Body Acceleration in the Y direction
timebodyaccelerationstddevz                  Time-domain feature, tandard Deviation of Body Acceleration in the Z direction
timegravityaccelerationmeanx                 Time-domain feature, Gravity Acceleration in the X direction 
timegravityaccelerationmeany                 Time-domain feature, Gravity Acceleration in the Y direction 
timegravityaccelerationmeanz                 Time-domain feature, Gravity Acceleration in the Z direction 
timegravityaccelerationstddevx               etc., per above.
timegravityaccelerationstddevy
timegravityaccelerationstddevz
timebodyaccelerationjerkmeanx
timebodyaccelerationjerkmeany
timebodyaccelerationjerkmeanz
timebodyaccelerationjerkstddevx
timebodyaccelerationjerkstddevy
timebodyaccelerationjerkstddevz
timebodygyromeanx
timebodygyromeany
timebodygyromeanz
timebodygyrostddevx
timebodygyrostddevy
timebodygyrostddevz
timebodygyrojerkmeanx
timebodygyrojerkmeany
timebodygyrojerkmeanz
timebodygyrojerkstddevx
timebodygyrojerkstddevy
timebodygyrojerkstddevz
timebodyaccelerationmagnitudemean
timebodyaccelerationmagnitudestddev
timegravityaccelerationmagnitudemean
timegravityaccelerationmagnitudestddev
timebodyaccelerationjerkmagnitudemean
timebodyaccelerationjerkmagnitudestddev
timebodygyromagnitudemean
timebodygyromagnitudestddev
timebodygyrojerkmagnitudemean
timebodygyrojerkmagnitudestddev
frequencybodyaccelerationmeanx
frequencybodyaccelerationmeany
frequencybodyaccelerationmeanz
frequencybodyaccelerationstddevx
frequencybodyaccelerationstddevy
frequencybodyaccelerationstddevz
frequencybodyaccelerationmeanfreqx
frequencybodyaccelerationmeanfreqy
frequencybodyaccelerationmeanfreqz
frequencybodyaccelerationjerkmeanx
frequencybodyaccelerationjerkmeany
frequencybodyaccelerationjerkmeanz
frequencybodyaccelerationjerkstddevx
frequencybodyaccelerationjerkstddevy
frequencybodyaccelerationjerkstddevz
frequencybodyaccelerationjerkmeanfreqx
frequencybodyaccelerationjerkmeanfreqy
frequencybodyaccelerationjerkmeanfreqz
frequencybodygyromeanx
frequencybodygyromeany
frequencybodygyromeanz
frequencybodygyrostddevx
frequencybodygyrostddevy
frequencybodygyrostddevz
frequencybodygyromeanfreqx
frequencybodygyromeanfreqy
frequencybodygyromeanfreqz
frequencybodyaccelerationmagnitudemean
frequencybodyaccelerationmagnitudestddev
frequencybodyaccelerationmagnitudemeanfreq
frequencybodybodyaccelerationjerkmagnitudemean
frequencybodybodyaccelerationjerkmagnitudestddev
frequencybodybodyaccelerationjerkmagnitudemeanfreq
frequencybodybodygyromagnitudemean
frequencybodybodygyromagnitudestddev
frequencybodybodygyromagnitudemeanfreq
frequencybodybodygyrojerkmagnitudemean
frequencybodybodygyrojerkmagnitudestddev
frequencybodybodygyrojerkmagnitudemeanfreq
angletbodyaccelerationmeantogravity
angletbodyaccelerationjerkmeantogravitymean
angletbodygyromeantogravitymean
angletbodygyrojerkmeantogravitymean
anglextogravitymean
angleytogravitymean
angleztogravitymean


# Acknowledgement
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
