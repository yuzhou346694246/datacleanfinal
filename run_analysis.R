library(readr)
library(stringr)
loadData <-function(type){
  if( type %in% c("test","train")){
    xfile <- switch(type,test="./test/X_test.txt",train="./train/X_train.txt")
    yfile <- switch(type,test="./test/y_test.txt",train="./train/y_train.txt")
    sfile <- switch(type,test="./test/subject_test.txt",train="./train/subject_train.txt")
    feature_names <- read.table("features.txt",header = F,stringsAsFactors = F,col.names = c("n","name"))
    y <- read.csv(yfile,header = F,stringsAsFactors = F,col.names = c("activity"))
    subject <- read.csv(sfile,header = F,stringsAsFactors = F,col.names = c("subject"))
    x <- read_file(xfile)
    x <- str_trim(x)
    x <- strsplit(x," +")
    x <- x[[1]]
    rownum <- length(x) / 561
    x <- matrix(as.numeric(x),ncol = 561,nrow = rownum ,byrow = T)
    x <- as.data.frame(x)
    # Appropriately labels the data set with descriptive variable names
    colnames(x) <- feature_names$name
    return(list(x=x,y=y,subject=subject))
  }
  stop("invalid input")
}

# load test and train data ,merge them!
# Merges the training and the test sets to create one data set
mergett <- function(){
  test <- loadData("test")
  train <- loadData("train")
  test <- with(test,cbind(x,y,subject))
  train <- with(train,cbind(x,y,subject))
  tt <- rbind(train,test)
  nameActivity(tt)
}
#tt data.frame format
# +++++++++++++++++++++++++++++++++++++++
# + variables | y       | subject       +
# + ----------------------------------- +
# + X_train   | y_train | subject_train |
# + ----------------------------------- +
# + X_test    | y_test  | subject_test  |
# + ----------------------------------- +
#name label y using activity name
# Uses descriptive activity names to name the activities in the data set
nameActivity <- function(tt){
  #tt <- mergett()
  activities <- read.table("activity_labels.txt",header = F,
                           col.names = c("no","name"),stringsAsFactors = F)
  tt$activity <- factor(tt$activity)
  levels(tt$activity) <- activities$name
  return(tt)
}

#Extracts only the measurements on the mean and standard deviation for each measurement
getMeanAndStd <- function(tt){
  #tt <- mergett()
  #tt <- nameActivity(tt)
  #return(tt[,grep("mean|std",names(tt))])
  tt <- tt[,grep("mean|std",names(tt))]
  names(tt) <- sub("()","",names(tt),fixed = T)#delete '()' in columns' name
  return(tt)
}

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
getAverages <- function(){
  tt <- mergett()
  ms <- getMeanAndStd(tt)
  ms$subject <- tt$subject
  ms$activity <- tt$activity
  group_by(ms,activity,subject) %>%summarise_all(mean)
}

#save averages result
saveResult <- function(){
  dataset <- getAverages()
  write.table(dataset,row.name=FALSE,"dataset.txt")
}