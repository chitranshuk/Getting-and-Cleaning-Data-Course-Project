## Read the Following Files
## features.txt: List of all features.
## activity_labels.txt: Links the class labels with their activity name.
## train/X_train.txt: Training set.
## train/y_train.txt: Training labels which identifies the activity type
## test/X_test.txt: Test set.
## test/y_test.txt: Test labels.
## train/subject_train.txt: Each row identifies the subject who 
## performed the activity for each window sample. Its range is from 1 to 30. 
## test/subject_test.txt

Features <- read.table("UCI HAR Dataset/features.txt")
names(Features) <- c("Sequence Number","Measurement")


ActivityLabel <- read.table("UCI HAR Dataset/activity_labels.txt")
ActivityName <- c("Sequence Number","Activity Name")
names(ActivityLabel) <- ActivityName

TrainData <- read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE)
TrainLabel <- read.table("UCI HAR Dataset/train/y_train.txt")
TrainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
names(TrainLabel) <- c("Activity_Name")
names(TrainSubject) <- c("Subject_Number")

TestData <- read.table("UCI HAR Dataset/test/X_test.txt")
TestLabel <- read.table("UCI HAR Dataset/test/y_test.txt")
TestSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
names(TestLabel) <- c("Activity_Name")
names(TestSubject) <- c("Subject_Number")

## Step 2: 
##  All the features were extracted into a vector and they were added as the column 
## names for both the training and test data set

DataLabel <- as.vector(t(Features$Measurement))
names(TrainData) <- DataLabel
names(TestData) <- DataLabel

## Step 3: 
## A subset of the training and test dataset was created excuding the columns that do not 
## contain the mean and the standard deviation which gave the tidy dataset

forMatch <- c("mean","std")
Matched <- unique (grep(paste(forMatch,collapse="|"),Features$Measurement, value=TRUE))
TrainData <- TrainData[, names(TrainData) %in% Matched, drop = F]
TestData <- TestData[, names(TestData) %in% Matched, drop = F]

## Step 4: 
## The Activity Type from the Y_train.txt & Y_test.txt was then added as a column in the training and test data set 
## Step 5: 
## The subject data identifying the subject who performed the activity from the subject_train.txt 
## and subject_test.txt was added as a column to the training and the test dataset

TrainData <- cbind(TrainLabel,TrainSubject,TrainData)
TestData <- cbind(TestLabel,TestSubject,TestData)

## Step 6: 
## The training and test dataset was combined into a single dataset

TidyData <- rbind(TrainData,TestData)


## Step 7: 
## The final dataset was was created from the tidy dataset to have the average 
## of the each activity for each subject

FinalData = ddply(TidyData, c("Activity_Name","Subject_Number"), numcolwise(mean))
write.table(FinalData,file="FinalData.txt",sep=",")