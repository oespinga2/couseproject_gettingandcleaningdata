
##Set as working directory the location of the folder containing the data (UCI HAR Dataset), i.e. if the folder path is /a/b/c/UCI HAR Dataset the working directory is /a/b/c
setwd("your-path-here")

#load common info
act_labs<-read.table("UCI HAR Dataset/activity_labels.txt")
names(act_labs)<-c("activity_id","activity")
features<-read.table("UCI HAR Dataset/features.txt")
length(unique(features$V2)) ##Not unique column names
features$V2[duplicated(features$V2)]
table(features$V2)

# load test data
test_id<-read.table("UCI HAR Dataset/test/subject_test.txt")
test_data<-read.table("UCI HAR Dataset/test/X_test.txt")
test_labels<-read.table("UCI HAR Dataset/test/y_test.txt")

# load train data
train_id<-read.table("UCI HAR Dataset/train/subject_train.txt")
train_data<-read.table("UCI HAR Dataset/train/X_train.txt")
train_labels<-read.table("UCI HAR Dataset/train/y_train.txt")

#create an unique identifier per subject observation 
test_id2<-cbind(test_id,reading_id= do.call(c,tapply(test_id$V1,test_id$V1,function(x)1:length(x),simplify = T))) 
train_id2<-cbind(train_id,reading_id= do.call(c,tapply(train_id$V1,train_id$V1,function(x)1:length(x),simplify = T)))

#rename variable names to make them more informative  
names(train_id2)[1]<-names(test_id2)[1]<-"subject_id"
names(train_data)<-names(test_data)<-features[,2] #names the data variables with ther corresponding information in the features file
names(train_labels)<-names(test_labels)<-"activity_id"

#put all the information together (per dataset)
test<-cbind(test_id2,test_labels,test_data)
train<-cbind(train_id2,train_labels,train_data)
head(train[,1:10]); head(test[,1:10]) #check cbinded datasets


# merge train and test datasets
merged<-rbind(cbind(dataset="train",train),cbind(dataset="test",test))
#merge the activity label id with ther corresponding (and informative) label
merged1<-merge(merged,act_labs,by="activity_id",sort=F)

head(merged1[,1:10]) ##check merged dataset

# Extracts only the measurements on the mean and standard deviation for each measurement
nam1<-grep("mean[()]",names(merged1))#get the variable names that contain the word mean()
nam2<-grep("std[()]",names(merged1))#get the variable names that contain the word std()
summary(merged1[,nam2])
merged2<-merged1[,c(2:4,566,nam1,nam2)] #extract only the variables with std and mean in theri names along with the variables that identify the record

library(reshape) #package to reformat the data
merged3<-melt(merged2,id.vars=c("dataset", "subject_id", "reading_id", "activity"))

#Create an auxiliary variable that put every variable in format XXX-XX-XX
variable1<-sapply(as.character(merged3$variable),function(x){
  if(!substr(x,nchar(x),nchar(x)) %in% c("X","Y","Z"))return(paste0(x,"-N/A"))
  else return(x)
})

#Create a dataset that contains the splitted variable nam
merged3_covs<-do.call(rbind,strsplit(variable1,"-"))
colnames(merged3_covs)<-c("feature","measure","axis")

#Merge the data to have an unique variable per data type (in accordance to the tidy data principle)
merged4<-data.frame(merged3[,-c(5,6)],merged3_covs,value=merged3$value)

#get some summaries of the data
head(merged4)
summary(merged4)
table(merged4$variable,merged4$feature)

#Obtain the second tidy dataset with average per per activity and subject (long format)
merged5<-cast(merged4,dataset+subject_id+activity+feature+axis~measure,mean)
names(merged5)[6:7]<-paste0("avg_of_",names(merged5)[6:7])

write.table(merged5,"project_dataset_step5.txt",row.name=F)

