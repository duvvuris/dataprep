#run_analysis.R Porject for courserera Data Cleaning

#set the working directory for loading the Data 
setwd("c:/work/dataprep/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

#read and merge the subject vector
subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")
subject <- rbind(subject_test, subject_train)
colnames(subject) <- c("subject")
subject$subject <- as.factor(subject$subject)

# read activity codes into vector
activity_y_test <- read.table("./test/y_test.txt")
activity_y_train <- read.table("./train/y_train.txt")
activity <- rbind(activity_y_test, activity_y_train)
colnames(activity) <- c("activity")

#read activity labels
temp_labels <- scan("./activity_labels.txt", what = "character", sep=" ")
label_indexes <- seq(2, length(temp_labels), by= 2)
activity_labels <- temp_labels[label_indexes]
activity$activity <-factor(activity$activity, labels = activity_labels)

# feature names
temp_features <- scan("./features.txt", what = "character", sep = " ")
feature_indexes <- seq(2,length(temp_features), by= 2)
features <- temp_features[feature_indexes]


# read in feature data X to data frames
X_test <- read.table("./test/X_test.txt")
X_train <- read.table("./train/X_train.txt")
X_merged <- rbind(X_test, X_train)

# add labels for features columns data
names(X_merged) <- features

# column bind subject code, activity code and feature data 
subject_activity <- cbind(subject, activity)
all_data <- cbind(subject_activity, X_merged)

#extract max and std data from the merged data 
col_meanandstddev <- grep("([Mm][Ee][Aa][Nn])|([Ss][Tt][Dd])", names(all_data))  # select mean and std dev col names
subject_activity_colno <- c(1,2)
final_collist <- append(subject_activity_colno, col_meanandstddev, after = length(subject_activity_colno))
cleaned_data <- all_data[, final_collist]

# install needed and extra libraries
library(plyr)
library(reshape)
library(reshape2)

#melt the data by subject and activity

final_data <- melt(cleaned_data)

#summmarize the data 

summarybysubjectactivity <-cast(final_data, ... ~ variable, mean)

# write the tidy data to a file
write.csv(summarybysubjectactivity, file= "tidy_data.txt", row.names=FALSE)









