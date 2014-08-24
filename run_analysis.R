
##################################
##  Local settings. Please specify 
##################################

#setwd("")

##################################
##  Load script requirements
##################################

list.of.packages <- c("plyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

##################################
##   Load general information
##################################

# Load The Activity labels
labels = read.table(file = "activity_labels.txt")
colnames(labels) = c("ActivityId","Activity")

# Load The column/variable names
colnames = read.table(file = "features.txt")


##################################
##   Perform Test set analysis
##################################

# Load Test Row labels
test_row_labels = read.table(file = "test/y_test.txt")
colnames(test_row_labels) = "ActivityId"

# Load Test Subject ID
test_id = read.table(file = "test/subject_test.txt")
colnames(test_id) = "SubjectId"

# Load the final test dataset
test_df = read.table(file = "test/X_test.txt", header = FALSE,dec = ".", col.names = colnames[,2])

# Attach the Activity columns
test_df = cbind(test_row_labels, test_df)

# Attach the ID column
test_df = cbind(SubjectId = test_id, test_df)

# Merge the Activity Labels with test dataset
test_df2 = merge.data.frame(x = labels, y = test_df, by.x = "ActivityId", by.y = "ActivityId", all = TRUE)


##################################
##   Perform Train set analysis
##################################

# Load Train Row labels
Train_row_labels = read.table(file = "Train/y_Train.txt")
colnames(Train_row_labels) = "ActivityId"

# Load Train Subject ID
Train_id = read.table(file = "Train/subject_Train.txt")
colnames(Train_id) = "SubjectId"

# Load the final Train dataset
Train_df = read.table(file = "Train/X_Train.txt", header = FALSE,dec = ".", col.names = colnames[,2])

# Attach the Activity columns
Train_df = cbind(Train_row_labels, Train_df)

# Attach the ID column
Train_df = cbind(SubjectId = Train_id, Train_df)

# Merge the Activity Labels with Train dataset
Train_df2 = merge.data.frame(x = labels, y = Train_df, by.x = "ActivityId", by.y = "ActivityId", all = TRUE)

##################################
## Combine both Test and Train sets
##################################

# Union rows
df = rbind(test_df2,Train_df2)

##################################
## Get the variables we need for further analysis
##################################

# Get variables with "mean"
columns = grep("mean",colnames(df))

# Get variables with "Std"
columns = append(columns,grep("std",colnames(df)))

# Get the grouping variables
columns = append(columns,c(1,3))

# Sort the new vector
columns = sort(columns)

# Extract only the wanted variables/columns
df = df[,columns]

##################################
## Create tidy dataset
##################################

# Apply mean to all columns, except the grouping columns
df_new = ddply(df,.(ActivityId, Activity,SubjectId), numcolwise(mean))

# Write tidy dataset to file
write.table(x = df_new, file = "tidy-dataset.txt", row.names=FALSE)
