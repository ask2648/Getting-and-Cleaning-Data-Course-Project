THIS IS THE README FILE FOR DATA CLEAN - COURSE PROJECT ASSIGNMENT
Please follow the steps listed below to get to tidy data set

Step 1) Download the UCI HAR Dataset and unzip it to extract(unpack) the files to a folder name "UCI HAR Dataset".

For example: D:\BigData\RLWD\data2\UCI HAR Dataset

Step 2) Open R-studio and set your working directory as "UCI HAR Dataset"

Example: "D:/BigData/RLWD/data2/UCI HAR Dataset"

Step 3) Download the "run_analysis.R file from the repo and save it in your working directory.

Step 4) Open the R-scipt file "run_analysis.R" in the R-studio from the file menu to review the R Code to generate the tidydataset for the assignment

Steps 5) Verify your project working directory has the following files and folder before you source the "run_analysis.R" script

test
train
activity_labels.txt
features.txt
features_info.txt
README.txt
run_analysis.R


Lets review the code line by line to explain how to get the tidydataset which has subject and activity means. In all we have 30 subjects and each subject has 6 activities.
So we should have 180 rows of observation plus one additional row for header to list the column variables. Comments for the steps are embedded in the code as we scroll down code line by line.


# Load the R-packages dplyr, tidyr
library(dplyr)
library(tidyr)

# Read the Test Dataset and scope the data
# xtest is the actual data for the corresponding features.txt 
# *test stands for test data
# *train stands for training data
# 'features.txt': List of all features
# 'activity_labels.txt': Links the class labels with their activity name.
# 'train/X_train.txt': Training set.
# 'train/y_train.txt': Training labels.
# 'test/X_test.txt': Test set.
# 'test/y_test.txt': Test labels.
# we are converting all the dataframes to table inorder to help with printing the data dimensions, size etc. which is why you see something like "ytest<- tbl_df(y_test)" in the code


x_test <- read.table("./test/X_test.txt")
xtest <- tbl_df(x_test)

y_test <- read.table("./test/y_test.txt")
ytest <- tbl_df(y_test)


subject_test <- read.table("./test/subject_test.txt")
subjecttest <- tbl_df(subject_test)

# In lines 60-63 of the code, we are joining the two data set to get the activity_labels map to correct activity code like 1 = WALKING, 2 = WALKING_UPSTAIR etc

by_activity <- read.table("./activity_labels.txt")
tp <- join(y_test, by_activity)
tp2 <- select(tp, V2)
activity_test <- tbl_df(tp2)

# This is to just clear the data and values in the environment variables which are not being used anymore.

rm(tp, tp2, y_test, subject_test, x_test)



# Repitition of pervious steps to read the Training Dataset and scope the data

x_train <- read.table("./train/X_train.txt")
xtrain <- tbl_df(x_train)
#rm(x_train)
xtrain


y_train <- read.table("./train/y_train.txt")
ytrain <- tbl_df(y_train)
#rm(y_train)
ytrain


subject_train <- read.table("./train/subject_train.txt")
subjecttrain <- tbl_df(subject_train)
#rm(subject_train)
subjecttrain

# Join the activity_labels to the activity variables for the training dataset
# Note that were are joining the two dataframe with activity V1 column to maintain the order of our observations.

sp <- join(y_train, by_activity)
sp2 <- select(sp, V2)
activity_train <- tbl_df(sp2)

# This is to just clear the data and values in the environment variables which are not being used anymore.

rm(sp, sp2, y_train, subject_train, x_train, by_activity)


# PART -1 MERGE THE TRAINING AND TEST DATASET TO 
# CREATE A SINGLE DATASET
# we want to bind the dataset in order by "subject", "activity", Data"

tptest <- cbind(subjecttest, activity_test, xtest)
tptrain <- cbind(subjecttrain,activity_train, xtrain)
mergeddata <- rbind(tptrain, tptest)
cran <- tbl_df(mergeddata)
rm(tptest, tptrain, mergeddata, activity_test, activity_train)
rm(subjecttrain, subjecttest, xtest, ytest, xtrain, ytrain)

# At this point the "cran" dataset in line 108 has the merged data and dimension of 10299x563

# PART -2 EXTRACT MEAN AND STD.DEV FOR EACH MEASUREMENT
# Determine which column have the mean and std we will first need 
# add the column names to the merged dataset so we need to do PART3
# before we can determine our subset dataset which will have 
# subject, activity, means and std columns

# PART -3 USE Features.txt to generate variable(column) names
# we are using the features.txt data and generating the column names for the merged dataset.

features <- read.table("./features.txt")
feat <- tbl_df(features)
wop1 <- select(feat, V2)
wop2 <- t(wop1)
col_name <- as.character(wop2)
colname_ext <- c( "subject", "activity", c(col_name))
colnames(cran) <- colname_ext

cran

# SELECTING THE CORRECT COLUMNS FOR MEANS, STD.DEV, ACTIVITY, SUBJECT
# This is PART-2 of the assignment were we get the subjec to of the merged data which contains mean and std.dev variables. Basically creating a subset of "cran" with dimensions of 10299x68

final_data <- select(cran, contains("subject"), contains("activity"), contains("\\mean()"), -contains("meanFreq"), contains("std()"))



# The final_data is the one which provides PART-3 of the solution

df <- tbl_df(final_data)

# remove all the temporary data and values from the working environment
rm(final_data, feat, features, wop1, wop2, cran)
rm(col_name, colname_ext)

# "df" is now dataset we need and now we will TIDY it up. So we do the following steps

# step-1) move all the column names to lower case

df3 <- tolower(names(df))

# step-2) Remove all the "-", "()", "()-" in variable
df4 <- gsub("\\()-x", "x", df3)
df5 <- gsub("\\()-y", "y", df4)
df6 <- gsub("\\()-z", "z", df5)
df7 <- gsub("\\()", "", df6)
df8 <- gsub("\\-", "", df7)

# step-3) Apply the new tidy column names to the dataset and store it as "td1"
colnames(df) <- df8

td1 <- tbl_df(df)

# remove all the temporary data and values from the working environment
rm(df3, df4, df5, df6, df7, df8, df)

# PART -5 INDEPENDENT TIDY DATASET with the
# average of each variable for each activity and each subject.

# first group by activity and subject and then find the mean for each 
# of the column variables.


td1$subject <- factor(td1$subject)
td2 <- ddply(td1, .(subject, activity), numcolwise(mean))

# Our final solution is the "tidydata" set
tidydata <- tbl_df(td2)
rm(td1, td2)

# just as a check we do dim to make sure our final result is 180 x 68
dim(tidydata)

# Use write.table to generate a submission text file.
write.table(tidydata, file = "./final_tidydataset.txt", row.name = FALSE)

# you will need to give the following command in R-studio console to read the text file (minus the quotes)
# "x <- read.table("./final_tidydataset.txt")"
# "View(x)"

5a13b3948e050ffacd0b79c349bf898fe65435af
