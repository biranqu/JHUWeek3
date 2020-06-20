#You should create one R script called run_analysis.R that does the following.

#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.



library(tidyr)
library(dplyr)
#TRAIN DATA

X_train <- read.table('C:/Users/Timon/Documents/School 2019-2020/Coding/Getting and Cleaning data/UCI HAR Dataset/train/X_train.txt')
#X_train contains the mean and st_dev of all data (raw data found above)
#according to the exercise, we want to extract the mean() and the st.dev for all measurements (the files above)
#According to features.txt, these correspond to columns 1-6, 41-46, 81,86 121-126, 161-166 201-202, 214-215, 227-228, 240-241, 253,254, 266-271, 345-350, 424-429, 503-504, 516-517, 529-530, 542-543.
X_trainfilt <- X_train[,c(1:6, 41:46, 81:86, 121:126, 161:166, 201, 202, 214, 215, 227,228,240,241,253,254, 266:271, 345:350, 424:429, 503,504, 516,517,529,530,542,543)]
names(X_trainfilt) <- c('V1', 'V2', 'V3', 'V4', 'V5', 'V6', 'V7', 'V8', 'V9', 'V10', 'V11', 'V12', 'V13', 'V14', 'V15', 'V16', 'V17', 'V18', 'V19', 'V20', 'V21', 'V22', 'V23', 'V24', 'V25', 'V26', 'V27', 'V28', 'V29', 'V30',  'V31', 'V32', 'V33',
                        'V34', 'V35', 'V36', 'V37', 'V38', '39', '40', 'V41', 'V42', 'V43', 'V44', 'V45', 'V46', 'V47', 'V48', 'V49', 'V50', 'V51', 'V52', 'V53', 'V54', 'V55', 'V56', 'V57', 'V58', 'V59', 'V60', 'V61', 'V62', 'V63', 'V64', 'V65', 'V66')
#I renamed the columns above in order to make the column names more clear. Number definitions are in the readme file.
#Note that this is not exactly what the question asked of us. But I found that naming all 66 columns made the abbreviations very unclear, which is why I simply renamed it to numbers.
source <- replicate(7352, 'train')
X_trainfilt <- cbind(source, X_trainfilt)


#ACTIVITY
ActivityTrain <- read.table('C:/Users/Timon/Documents/School 2019-2020/Coding/Getting and Cleaning data/UCI HAR Dataset/train/y_train.txt')
names(ActivityTrain) <- 'Activity'
X_trainfilt <- cbind(ActivityTrain,X_trainfilt)

# Now we repeat the exact same for test
X_test <- read.table('C:/Users/Timon/Documents/School 2019-2020/Coding/Getting and Cleaning data/UCI HAR Dataset/test/X_test.txt')
X_testfilt <- X_test[,c(1:6, 41:46, 81:86, 121:126, 161:166, 201, 202, 214, 215, 227,228,240,241,253,254, 266:271, 345:350, 424:429, 503,504, 516,517,529,530,542,543)]
names(X_testfilt) <- c('V1', 'V2', 'V3', 'V4', 'V5', 'V6', 'V7', 'V8', 'V9', 'V10', 'V11', 'V12', 'V13', 'V14', 'V15', 'V16', 'V17', 'V18', 'V19', 'V20', 'V21', 'V22', 'V23', 'V24', 'V25', 'V26', 'V27', 'V28', 'V29', 'V30',  'V31', 'V32', 'V33',
                        'V34', 'V35', 'V36', 'V37', 'V38', '39', '40', 'V41', 'V42', 'V43', 'V44', 'V45', 'V46', 'V47', 'V48', 'V49', 'V50', 'V51', 'V52', 'V53', 'V54', 'V55', 'V56', 'V57', 'V58', 'V59', 'V60', 'V61', 'V62', 'V63', 'V64', 'V65', 'V66')
source <- replicate(2947, 'test') #alternatively, you could use nrow(X_testfilt) instead of the number, or something of the like
ActivityTest <- read.table('C:/Users/Timon/Documents/School 2019-2020/Coding/Getting and Cleaning data/UCI HAR Dataset/test/y_test.txt')
names(ActivityTest) <- 'Activity'

X_testfilt <- cbind(source, X_testfilt)
X_testfilt <- cbind(ActivityTest,X_testfilt)
X_testfilt

#Now combine the two datasets
#according to the exercise, we next replace the activity numbers with what it correspond with according to activitylabels.txt
X_merge <- rbind(X_trainfilt, X_testfilt)
X_merge$Activity <- gsub(1, 'Walking', X_merge$Activity)
X_merge$Activity <- gsub(2, 'Walking Upstairs', X_merge$Activity)
X_merge$Activity <- gsub(3, 'Walking Downstairs', X_merge$Activity)
X_merge$Activity <- gsub(4, 'Sitting', X_merge$Activity)
X_merge$Activity <- gsub(5, 'Standing', X_merge$Activity)
X_merge$Activity <- gsub(6, 'Laying', X_merge$Activity)

#Next, lets easily add the subject numbers

SubjectTest <- read.table('C:/Users/Timon/Documents/School 2019-2020/Coding/Getting and Cleaning data/UCI HAR Dataset/test/subject_test.txt')
SubjectTrain <- read.table('C:/Users/Timon/Documents/School 2019-2020/Coding/Getting and Cleaning data/UCI HAR Dataset/train/subject_train.txt')
AllSubjects <- rbind(SubjectTrain, SubjectTest)
names(AllSubjects) <- 'Subjects'
Fulldata <- cbind(AllSubjects, X_merge)
#Lets make sure Subjects is always 2 characters (i.e. 01 instead of 1)

Fulldata$Subjects <- sprintf('%02d', Fulldata$Subjects)
#And take a look at the final dataset
View(Fulldata)

#Finally...
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#alright, now we need to split the data based on subject and activity, and then take an average of all of the columns, from which we then take make a new df

allsubjects <- c('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30')
activities <- c('Walking','Walking Upstairs','Walking Downstairs','Sitting','Standing','Laying')



df <- data.frame()
for(S in allsubjects) {
  test <- filter(Fulldata, Subjects == S)
    for(A in activities) {
    stuff <- filter(test, Activity == A)
    means <- select(stuff, -c('Subjects', 'Activity', 'source')) %>%
          colMeans()
    means <- as.data.frame.list(means)
    df <- rbind(df,data.frame(S, A, means))
    }
}
df
#The above fucntion take the column means of all Activities(A) per subject(S), for all 66 variables.
finalassignment <- capture.output(write.table(df, row.name = F))
cat('step5', finalassignment, file = 'step5.txt', sep='n', append = T)
finalassignment
