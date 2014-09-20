library(dplyr)
library(tidyr)

# Read the Test Dataset and scope the data

x_test <- read.table("./test/X_test.txt")
xtest <- tbl_df(x_test)
xtest

y_test <- read.table("./test/y_test.txt")
ytest <- tbl_df(y_test)
ytest

subject_test <- read.table("./test/subject_test.txt")
subjecttest <- tbl_df(subject_test)
subjecttest

by_activity <- read.table("./activity_labels.txt")
tp <- join(y_test, by_activity)
tp2 <- select(tp, V2)
activity_test <- tbl_df(tp2)

rm(tp, tp2, y_test, subject_test, x_test)
# Read the Training Dataset and scope the data

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

sp <- join(y_train, by_activity)
sp2 <- select(sp, V2)
activity_train <- tbl_df(sp2)

rm(sp, sp2, y_train, subject_train, x_train, by_activity)
# PART -1 MERGE THE TRAINING AND TEST DATASET TO 
# CREATE A SINGLE DATASET
# we want to bind the dataset in order by "Activity, Subject, Data"

tptest <- cbind(subjecttest, activity_test, xtest)
tptrain <- cbind(subjecttrain,activity_train, xtrain)
mergeddata <- rbind(tptrain, tptest)
cran <- tbl_df(mergeddata)
rm(tptest, tptrain, mergeddata, activity_test, activity_train)
rm(subjecttrain, subjecttest, xtest, ytest, xtrain, ytrain)


# PART -2 EXTRACT MEAN AND STD.DEV FOR EACH MEASUREMENT


# Determine which column have the mean and std we will first need 
# add the column names to the merged dataset so we need to do PART3
# before we can determine our subset dataset which will have 
# subject, activity, means and std columns

# PART -3 USE Features.txt to generate variable(column) names
features <- read.table("./features.txt")
feat <- tbl_df(features)
wop1 <- select(feat, V2)
wop2 <- t(wop1)
col_name <- as.character(wop2)
colname_ext <- c( "subject", "activity", c(col_name))
colnames(cran) <- colname_ext

cran

# SELECTING THE CORRECT COLUMNS FOR MEANS, STD.DEV, ACTIVITY, SUBJECT

final_data <- select(cran, contains("subject"), contains("activity"), contains("\\mean()"), -contains("meanFreq"), contains("std()"))



# The final_data is the one which provides PART-3 of the solution.
df <- tbl_df(final_data)

# remove all the temporary data and values from the working environment
rm(final_data, feat, features, wop1, wop2, cran)

# PART -4 Change the Activity Column to provide Activity Description


# remove all the temporary data and values from the working environment
rm(col_name, colname_ext)

# "clean_dataset is now dataset we need and now we will TIDY it up

# 1) move all the column names to lower case
#df <- clean_dataset
df3 <- tolower(names(df))

# 3) Remove all the "-", "()", "()-" in variable
df4 <- gsub("\\()-x", "x", df3)
df5 <- gsub("\\()-y", "y", df4)
df6 <- gsub("\\()-z", "z", df5)
df7 <- gsub("\\()", "", df6)
df8 <- gsub("\\-", "", df7)

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

tidydata <- tbl_df(td2)
rm(td1, td2)

dim(tidydata)
write.table(tidydata, file = "./final_tidydataset.txt", row.name = FALSE)
