setwd("/your/path/to/UCI HAR Dataset")

## 1. Merges the training and the test sets to create one data set.

# read files
subjectTest <- read.table("test/subject_test.txt")
xTest <- read.table("test/X_test.txt")
yTest <- read.table("test/y_test.txt")
subjectTrain <- read.table("train/subject_train.txt")
xTrain <- read.table("train/X_train.txt")
yTrain <- read.table("train/y_train.txt")
# merge data
subject <- rbind(subjectTest, subjectTrain)
x <- rbind(xTest, xTrain)
y <- rbind(yTest, yTrain)
data <- data.frame(subject=subject, y=y, x=x)
colnames(data)[1] <- "subject"
colnames(data)[2] <- "activityId"

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

extract <- data[c("subject", "activityId", "x.V1", "x.V2", "x.V3", "x.V4", "x.V5", "x.V6", "x.V41", "x.V42", "x.V43", "x.V44", "x.V45", "x.V46", "x.V81", "x.V82", "x.V83", "x.V84", "x.V85", "x.V86", "x.V121", "x.V122", "x.V123", "x.V124", "x.V125", "x.V126", "x.V161", "x.V162", "x.V163", "x.V164", "x.V165", "x.V166", "x.V201", "x.V202", "x.V214", "x.V215", "x.V227", "x.V228", "x.V240", "x.V241", "x.V253", "x.V254", "x.V266", "x.V267", "x.V268", "x.V269", "x.V270", "x.V271", "x.V345", "x.V346", "x.V347", "x.V348", "x.V349", "x.V350", "x.V424", "x.V425", "x.V426", "x.V427", "x.V428", "x.V429", "x.V503", "x.V504", "x.V516", "x.V517", "x.V529", "x.V530", "x.V542", "x.V543")]

## 3. Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table("activity_labels.txt")
colnames(activityLabels)  <- c("id", "activity")
library(plyr)
for(i in seq_along(extract$activityId)){
    extract[activityId==i,69] <- activityLabels[i,]$activity
}

## 4. Appropriately labels the data set with descriptive activity names. 

colnames(extract) <- c("subject", "activityId", "x1", "x2", "x3", "x4", "x5", "x6", "x41", "x42", "x43", "x44", "x45", "x46", "x81", "x82", "x83", "x84", "x85", "x86", "x121", "x122", "x123", "x124", "x125", "x126", "x161", "x162", "x163", "x164", "x165", "x166", "x201", "x202", "x214", "x215", "x227", "x228", "x240", "x241", "x253", "x254", "x266", "x267", "x268", "x269", "x270", "x271", "x345", "x346", "x347", "x348", "x349", "x350", "x424", "x425", "x426", "x427", "x428", "x429", "x503", "x504", "x516", "x517", "x529", "x530", "x542", "x543", "activity")

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

options(gsubfn.engine = "R")
library(sqldf)
averages <- sqldf("SELECT subject, activityId, activity, AVG(x1), AVG(x2), AVG(x3), AVG(x4), AVG(x5), AVG(x6), AVG(x41), AVG(x42), AVG(x43), AVG(x44), AVG(x45), AVG(x46), AVG(x81), AVG(x82), AVG(x83), AVG(x84), AVG(x85), AVG(x86), AVG(x121), AVG(x122), AVG(x123), AVG(x124), AVG(x125), AVG(x126), AVG(x161), AVG(x162), AVG(x163), AVG(x164), AVG(x165), AVG(x166), AVG(x201), AVG(x202), AVG(x214), AVG(x215), AVG(x227), AVG(x228), AVG(x240), AVG(x241), AVG(x253), AVG(x254), AVG(x266), AVG(x267), AVG(x268), AVG(x269), AVG(x270), AVG(x271), AVG(x345), AVG(x346), AVG(x347), AVG(x348), AVG(x349), AVG(x350), AVG(x424), AVG(x425), AVG(x426), AVG(x427), AVG(x428), AVG(x429), AVG(x503), AVG(x504), AVG(x516), AVG(x517), AVG(x529), AVG(x530), AVG(x542), AVG(x543) FROM extract GROUP BY subject, activityId")
write.table(averages, "tidy_data_set.csv", sep=",", row.names = FALSE)