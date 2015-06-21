library("data.table")
library("reshape2")

# load all lables
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[, 2]

# load all names of features
features <- read.table("./UCI HAR Dataset/features.txt")[, 2]

# filter std and mean in name of feature
extracted_features_logical_vector <- grepl("mean\\(|std\\(", features)

# export feature name
extrected_features_names <- features[extracted_features_logical_vector]

# load train
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(x_train) <- features
y_train_id_and_name <- cbind(y_train, activity_labels[y_train[, 1]])
names(y_train_id_and_name) <- c("activity_id", "activity_name")
x_train_extracted <- x_train[, extracted_features_logical_vector]
names(subject_train) <- c("subject")
train_data <- cbind(subject_train, x_train_extracted, y_train_id_and_name)

# load test
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(x_test) <- features
y_test_id_and_name <- cbind(y_test, activity_labels[y_test[, 1]])
names(y_test_id_and_name) <- c("activity_id", "activity_name")
x_test_extracted <- x_test[, extracted_features_logical_vector]
names(subject_test) <- c("subject")
test_data <- cbind(subject_test, x_test_extracted, y_test_id_and_name)

all_data <- rbind(train_data, test_data)

#tidy data
id_labels <- c("subject", "activity_id", "activity_name")
data_labels <- setdiff(colnames(all_data), id_labels)
melt_data <- melt(all_data, id = id_labels, measure.vars = data_labels)
tidy_data <- dcast(melt_data, subject + activity_name ~ variable, mean)

# View(tidy_data)
write_table(tidy_data, file = "./result_data.txt")
