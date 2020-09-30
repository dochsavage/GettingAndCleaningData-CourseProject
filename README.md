# GettingAndCleaningData-CourseProject
Coursera-GettingAndCleaningData-CourseProject:  Accelerometer &amp; Gyro data from phone testing.

# Variables

## Input Data

### UCI HAR Dataset
This dataset is comprised of sensor readings and calculated data from those readings from a set of 30 individuals who performed a set of defined actions while wearing a device with both accelerators and gyroscopes which can determine direction and intensity of applied forces including gravity.
The details of that original data can be found in the UCI HAR Dataset file "README.txt".


## Output Data
Output files are found in the /output directory.

### Averaged Data
#### combined.csv
Data file containing the mean and standard deviation values of both forces detected and calculated taken over the course of testing by the test subjects for a set of 6 types of actions.  Some calculated values are directional in the x, y, and z directions. Only the means and standard deviation values are provided here; the other values observed were deliberately omitted in this dataset.

#### tidy.csv
Data file containing the averaged means and averaged standard deviations for each test subject and their performed activity as a crosstab.

### Variable List
The complete list of 88 variables provided in each output dataset is available in
- 'VariableDescriptions-AveragedData.txt'

The first 9 variables are:
- 'subject'
- 'activity'
- 'totalbodyaccelerationmeanx'
- 'totalbodyaccelerationmeany'
- 'totalbodyaccelerationmeanz'
- 'totalbodyaccelerationstddevx'
- 'totalbodyaccelerationstddevy'
- 'totalbodyaccelerationstddevz'
- 'totalgravityaccelerationmeanx'


## Raw Data from UCI HAR Dataset

The raw data originally collected and used in this project is described in the UCI HAR Dataset is found in that directory or in the associated ZIP file within the files:

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

## Notes: 
- Data are normalized and bounded within [-1,1].

# Acknowledgement
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
