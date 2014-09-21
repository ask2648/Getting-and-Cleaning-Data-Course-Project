Code Book - Human Activity Recognition Using Smartphones Data Set
Human Activity Recognition database was built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.


Data Set Characteristics:  Multivariate, Time-Series
Number of Instances: 10299
Area: Computer
Number of Attributes: 561
Date Donated:  2012-12-10
Associated Tasks: Classification, Clustering, Tidy Dataset
Missing Values: N/A

Source:
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. 
Smartlab - Non Linear Complex Systems Laboratory 
DITEN - Universit√  degli Studi di Genova, Genoa I-16145, Italy. 
activityrecognition '@' smartlab.ws 
www.smartlab.ws 


DataSet Location: The dataset is available at following URL

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip



TidyDataSet R Script: run_analysis.R

Once you unpack the dataset in the R-studio working directory. Copy over the R-script "run_analysis.R" in the project working directory. Source the script and it will create a tidydataset for each of the subject's activities and their respective average for mean and standard deviation observations.

Notes: Refer to section on "Description of R-script" for details on work performed to clean up the data.

Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

The dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.


Description of Variables :

All the variables and there description used in the tidy data are same as the original UCI dataset except for minor modifications to the variable names to make them TIDY. Refer to the Original Codebook for details on the variable descriptions

The minor modification that were made for the tidy data set are

1) Added descriptive activity names to the names for the activities in the data set
The original data set had six different activities such as 1, 2, 3, 4, 5, & 6. In the tidy dataset these activities were replace by WALKING, WALKING_UPSTAIRS, WALING_DOWNSTAIRS, SITTING, STANDING and LAYING in the same order. so, 1 = WALKING and 6 being LAYING.

2) All the column names for the tidy data set were changed to be all lower case, remove "-", remove "() added "subject" and "activity" column names to the first two columns 

for example : tBodyACC-mean()-X  gets changed to "tbodyaccmeanx"


Steps to get to tidydataset:

1) Load the "plyr", "dplyr" packages
2) Read X_test.txt which is  2947 obs. 561 variables for data observations, call it "xtest"
3) Read y_test.txt which is  2947 obs. 561 variables for 6 different activities, call it "ytest"
4) Read subject_test.txt which is  2947 obs. 561 variables for the 30 subjects, call it "subjecttest"
5) Read activity_labels.txt to transfer the 6 different activity names like WALKING, WALKING_UP etc to 
y-test by using Join function. So, now will have activity names instead of levels between 1 and 6. The new dataframe is called "activity_test"
6) Repeat the above five steps to do the similar exercise for the training data and you will get dataframes "xtrain", "ytrain", "subjecttrain" and "activity_train".
7) Column bind subjecttest, activity_test, xtest to get a data frame "tptest" which is 2947 obs of 563 variables
8) Column bind subjecttrain, activity_train, xtrain to get a data frame "tptrain" which is 7352 obs of 563 variables
9) Merge "tptest" and "tptrain" to get the final dataset called "cran" which is 10299 obs of 563 variables.
10) Next you tidy the merged data to add the columnames
11) Select the columns you need to reduce the dataset to 10299 by 68 variables
12) Group the reduced dataset by subject and activity and then calculate column means to get the final data which is 180x 68.  This corresponds to 30 subject times 6 activities.
13) use write.table to export the results as a text file.



