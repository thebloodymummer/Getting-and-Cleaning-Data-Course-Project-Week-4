library(reshape2, data.table, plyr) #Loading appropriate libraries

#Read in relevent raw data files(Working directory set to UCI HAR Dataset)
activity <- read.table("./activity_labels.txt") 
features <- read.table("./features.txt") 
subject_train <- read.table("./train/subject_train.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
y_train[[1]] <- factor(y_train[[1]], labels = activity[[2]]) # rename factors
subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
y_test[[1]] <- factor(y_test[[1]], labels = activity[[2]])# rename factors

#add column headers
names(subject_train) <- "Subject"
names(subject_test) <- "Subject"
names(y_train) <- "Activity"
names(y_test) <- "Activity"
names(X_train) <- features[,2]
names(X_test) <- features[,2]

#Merge into a single dataset
Merged <- rbind(cbind(subject_train, y_train, X_train), cbind(subject_test, y_test, X_test))

#Extract columns w/ mean or standard dev
Merged2 <- grepl("std\\(\\)", names(Merged)) |  grepl("mean\\(\\)", names(Merged))
Merged2[c(1,2)] <- T
Meanstd <- Merged[,Merged2]

#Create a tidy dataset using melt and cast
labels   = c("Subject", "Activity")
labels2 = setdiff(colnames(Meanstd), labels)
Meanstd2 = melt(Meanstd, id = labels, measure.vars = labels2)
tidy   = dcast(Meanstd2, Subject + Activity ~ variable, mean)

write.table(tidy, file = "./tidy_data.txt")