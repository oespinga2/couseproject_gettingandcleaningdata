# CodeBook
This document contains all the information required to understand the R script run_analysis.R

## Steps to process and generate a tidy dataset

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Steps taken to process the data
After loading all the data into R (files "activity_labels.txt", "features.txt", "subject_test.txt", "X_test.txt", "y_test.txt","subject_train.txt","X_train.txt", and "y_train.txt"), I proceded to create an unique identifier per subject reading "reading_id". After we labeled the variable with the subject number "subject_id" and  all the columns in files "X_train.txt" and "X_test.txt"  with their corresponding name (from file "features.txt"). However, the column names were not unique which would have caused problems if we were not only interested only in the "mean" and "std" variables".

I then put all the information together for the "train" and "test" data adding a label "dataset" to clearly identify which subjects belong to which data set. Once a single data set was produced we added the activity label from file "activity_labels.txt" for a more informative activity description.

After, to keep only variables for the mean and std I used function *grep* to locate the corresponding variables and selected them (along with the labels, and subject ids) into a new data set. Furthermore, since oftentimes a long format dataset is clearer, we proceded to maniulate our dataset to a long format. to do so, I used package **reshape**. To preserve the tidy dataset principle of one column per variable, I used function *strsplit* to clearly make a difference between the type of variable -mean, std- the feature name, and the axis. 

Finally, to generate the independent tiny dataset I used the function *cast* to manipulate the dataset into a more readable format making a distinction between the different variables analyzed - average of mean- and -average of std- variables.

## Out file (step 5)
The scrip generates a final dataset "project_dataset_step5.txt" which contains the following variables:

* "dataset": An identificator of the type of dataset where the subject belongs. Values "train" or "test"       
* "subject_id": An unique identifier for the subject, ranges from 1 to 30    
* "activity": activity label of the activity from which the data were recorded from. It has values laying, sitting, standing, walking, walking downstairs, and walking upstairs      
* "feature": the features that come from the accelerometer and gyroscope. For more information consult the file features_info.txt that comes along with the data.      
* "axis": one of the three axis for a determined feature, it has values "X", "Y", "Z", and "NA" the latter for features where no axis was recorded
* "avg_of_mean()" average of each "mean" variable per activity and subject. Ranges from -1 to 1
* "avg_of_std()" average of each "std" variable per activity and subject. Ranges from -1 to 1
 

Note that the files contains quoted strings and headers and it is space delimited.