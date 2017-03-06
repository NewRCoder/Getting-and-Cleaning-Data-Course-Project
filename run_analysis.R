## Step 1: Set the downloaded filename of the dataset.
dataset.filename <- "FUCI_HAR_Dataset.zip"

## Step 2: Download dataset from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists(dataset.filename)) {
    dataset.filelink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    
    ## Step 3: Save downloaded file as "FUCI_HAR_Dataset.zip"
    download.file(dataset.filelink, dataset.filename)
}

## Step 4: Check if the file "FUCI_HAR_Dataset.zip" is present and in case the unzip folder ("UCI HAR Dataset") is absent
## then, unzip "FUCI_HAR_Dataset.zip". 
if(file.exists(dataset.filename) & !file.exists("UCI HAR Dataset")) {
    unzip(dataset.filename)
}

## Step 5: Read training files
training.x <- read.table("./UCI HAR Dataset/train/X_train.txt")
training.y <- read.table("./UCI HAR Dataset/train/y_train.txt")
training.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## Step 6: Read testing files
testing.x <- read.table("./UCI HAR Dataset/test/X_test.txt")
testing.y <- read.table("./UCI HAR Dataset/test/y_test.txt")
testing.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Step 7: Reading feature
features <- read.table('./UCI HAR Dataset/features.txt')

## Step 8: Reading activity labels
activity.labels <- read.table('./UCI HAR Dataset/activity_labels.txt')

## Step 9: Assigning columns name
colnames(training.x) <- features[,2] 
colnames(training.y) <- "ActivityId"
colnames(training.subject) <- "SubjectId"

colnames(testing.x) <- features[,2] 
colnames(testing.y) <- "ActivityId"
colnames(testing.subject) <- "SubjectId"

colnames(activity.labels) <- c('ActivityId','ActivityType')

## Step 10: Merging all data in a single dataset
training <- cbind(training.y, training.subject, training.x)
testing <- cbind(testing.y, testing.subject, testing.x)
merged.dataset <- rbind(training, testing)

## Step 11: Read columns name
name.columns <- colnames(merged.dataset)

## Step 12: Vector for "ActivityId", "SubjectId", "mean..", "std.."
mean_std <- (grepl("ActivityId" , name.columns) | grepl("SubjectId" , name.columns) | grepl("mean.." , name.columns) | grepl("std.." , name.columns))

## Step 13: Sub set merged.dataset
subset.mean_std <- merged.dataset[, mean_std == TRUE]

subset.activity.names <- merge(subset.mean_std, activity.labels, by='ActivityId', all.x=TRUE)

## Step 14: Create tidy dataset
tidy.dataset <- aggregate(. ~SubjectId + ActivityId, subset.activity.names, mean)
tidy.dataset <- tidy.dataset[order(tidy.dataset$SubjectId, tidy.dataset$ActivityId),]

## Step 15: Output data to "tidy_dataset.txt" file
write.table(tidy.dataset, "tidy_dataset.txt", row.name=FALSE)
