# 1. Merge the test and training datasets
###########################################

# Read test dataset
test = read.csv("UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="")
test[,ncol(test)+1] = read.csv("UCI HAR Dataset/test/y_test.txt", header=FALSE)
test[,ncol(test)+1] = read.csv("UCI HAR Dataset/test/subject_test.txt", header=FALSE)

# Read training dataset
training = read.csv("UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="")
training[,ncol(training)+1] = read.csv("UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="")
training[,ncol(training)+1] = read.csv("UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="")

# Combine the test and training datasets
traintest = rbind(training, test)


# 2. Extract only the measures on mean and standard deviation
#############################################################

# Read features (these become the columns of traintest)
features = read.csv("UCI HAR Dataset/features.txt", header=FALSE, sep="")

# Copy names to dataset, and make lowercase
colnames(traintest) = c(as.character(features$V2), "activity", "subject")
colnames(traintest) = tolower(colnames(traintest))

# Extract mean and standard deviation variables
columns = grep("-(mean|std)\\(\\)", colnames(traintest))
subset = traintest[, columns]


# 3. Name variables using descriptive activity
#############################################################

# Read activity labels
activitylabels = read.csv("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="")

# Merge activity labels to dataset using activity column
traintest = merge(traintest, activitylabels, by.x="activity", by.y="V1")
table(traintest[,1], traintest[,564])	# check if merged correctly


# 4. Label the data set with descriptive variable names
#############################################################

# Replace old activity variable with new activity variable and drop extra variable
traintest$activity = traintest$V2
traintest$V2 = NULL


# 5. Create a second, tidy data set with the average of each variable for each activity and each subject
#########################################################################################################
library(reshape2)

# Make the data long
melt = melt(traintest, id=c("activity", "subject"))

# Make the data wide again, but group by activity + subject and take the mean
tidy = dcast(melt, activity + subject ~ variable, mean)

# Output the tidy dataset
write.table(tidy, "tidy.txt", row.name=FALSE)




