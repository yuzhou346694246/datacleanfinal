### loadData
A general function using to read test or train files,return a data.frame.

- 1.read y_test,subject_test(train).txt
  This is very sample ,just call read.csv
  
- 2.read X_test(train).txt
  The format of the file is complicated,I must parse it by myself.
  First,read content of file.
  Second, split it to a vector.In this step,i earse space in strings
  Third, covert to a matrix nrows X 561
  Forth, convert to a data.frame

### mergett(merge test train)
This function is using to merget test and train data into a data.frame .
- 1. invoke loadData
- 2. call rbind to merge

### getMeanAndStd
  Extracts only the measurements on the mean and standard deviation for each measurement
- 1. using grep to filter column
- 2. delete '()' in columns 

### getAverages
- 1. group_by subject and activity
- 2. summarise using mean function

### saveResult
  save the result returned by getAverages to 'dataset.txt'

### 