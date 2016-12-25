# Downlading files
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="Dataset", method="curl")
unzip(zipfile="Dataset", exdir=".")

# Rading training tables
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
names(x_train)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
names(y_train)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
names(subject_train)

# Reading testing tables
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
names(x_test)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
names(y_test)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
names(subject_test)

# Reading features vector
features <- read.table("UCI HAR Dataset/features.txt")

# Reading activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Assigning column names
colnames(x_train) <- features[,2] 
colnames(x_train)
colnames(y_train) <- "activityId"
colnames(y_train)
colnames(subject_train) <- "subjectId"
colnames(subject_train)

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <- c("activityId","activityType")
colnames(activity_labels)

# Merging data
merge_train <- cbind(x_train, y_train, subject_train)
names(merge_train)
merge_test <- cbind(x_test, y_test, subject_test)
names(merge_test)
mergeAll <- rbind(merge_train, merge_test)
names(mergeAll)

# Extracts only the measurements on the mean and standard deviation for each measurement.
colNames <- colnames(mergeAll)
mean_and_std <- (grepl("activityId" , colNames) | 
                 grepl("subjectId" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) 
)

AllMeanAndStd <- mergeAll[ , mean_and_std == TRUE]
AllMeanAndStd

# Uses descriptive activity names to name the activities in the data set.
ActivityNames <- merge(AllMeanAndStd, activity_labels, 
                       by='activityId',
                       all.x=TRUE)
ActivityNames

# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
secTidySet <- aggregate(. ~subjectId + activityId, ActivityNames, mean)
secTidySet
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
secTidySet

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)


