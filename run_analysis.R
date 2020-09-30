#
# Student:    Jeff Murdoch
# Date:       2020-09-28
# Course:     Getting and Cleaning Data
# Assignment: Course Project
#
# Summary:  This project analyzes the accelerometer and gyrometerdata produced 
#           from a smartphone.
#
###############################################################################

prettyname <- function(originalColumnName = "tbodyaccmeanx") {
  if(length(originalColumnName)>0) {
    newname <- originalColumnName
    if( as.integer(regexpr("^[t]",originalColumnName))>0 ) {
      newname <- sub("t","total",newname)
    }
    if( as.integer(regexpr("^[f]",originalColumnName))>0 ) {
      newname <- sub("f","frequency",newname)
    }
    if( as.integer(regexpr(".+[acc].+",originalColumnName))>0 ) {
      newname <- sub("acc","acceleration",newname)
    }
    if( as.integer(regexpr(".+[mag].+",originalColumnName))>0 ) {
      newname <- sub("mag","magnitude",newname)
    }
    if( as.integer(regexpr(".+[std].+",originalColumnName))>0 ) {
      newname <- sub("std","stddev",newname)
    }
  } else {
    print("prettyname: No data passed; default string used.")
  }
}

processData <- function(directory = "./UCI HAR Dataset", 
                        datatype = "test",
                        debug = FALSE) 
{
  # Libraries
  library(readr)
  library(dplyr)

  # Constants
  if( debug ) print(paste("directory=",directory))
  dirData <- paste0(directory,"/",datatype)
  fileSubject <- paste0(dirData,"/subject_",datatype,".txt")
  fileActivity <- paste0(dirData,"/y_",datatype,".txt")
  fileData <- paste0(dirData,"/X_",datatype,".txt")
  fileColumnNames <- paste0(directory,"/features.txt")
  fileActivityLabels <- paste0(directory,"/activity_labels.txt")

  # Load Data Files
  if( debug ) print(paste("fileSubject=",fileSubject))
  dataSubject <- read.table(fileSubject)
  if( debug ) print(paste("fileActivity=",fileActivity))
  dataActivity <- read.table(fileActivity)
  if( debug ) print(paste("fileActivityLabels=",fileActivityLabels))
  dataActivityLabels <- read.table(fileActivityLabels)
  if( debug ) print(paste("fileData=",fileData))
  dataData <- read.table(fileData)
  
  # Assemble Intelligent Column Names vector.
  if( debug ) print(paste("fileDataColumnNames=",fileDataColumnNames))
  dfColumnNamesTable <- read.table(fileColumnNames)
  vectorColumnNames <- dfColumnNamesTable[,2]
  if( debug ) print(paste("length(vectorColumnNames)=",length(vectorColumnNames)))
  if( debug ) print(paste("length(unique(vectorColumnNames))=",length(unique(vectorColumnNames))))
  
  # Substitute comma with "n"to" to preserve ranges in names.
  vectorColumnNames2 <- gsub(x = vectorColumnNames,",","to")
  vectorColumnNames3 <- stringr::str_replace(vectorColumnNames2, "[()-]([0-9])","from\\1")
  # remove punctuation marks 
  vectorColumnNames4 <- stringr::str_remove_all(vectorColumnNames3, "([.-])|[[:punct:]]")
  # simply to lower case.
  vectorColumnNames5 <- tolower(vectorColumnNames4)
  # Apply descriptive variable names
  vectorColumnNames6 <- unlist(lapply(vectorColumnNames5,prettyname))
  if( debug ) print(vectorColumnNames6)
  vectorColumnNames <- c("subject","activitynbr",vectorColumnNames6)
  
  # Assemble Data by adding columns.
  if( debug ) print("Assemble Data by adding columns.")
  data <- data.frame(dataSubject,dataActivity,dataData)
  
  # Apply column names vector.
  colnames(data) <- vectorColumnNames
  
  # Filter out non-mean/stddev columns
  if( debug ) print("Filter out non-mean and non-stddev columns.")
  vectorColumnNames <- colnames(data)
  if( debug ) print(paste("vectorColumnNames count=",length(vectorColumnNames)))
  colnames_list <- vectorColumnNames[regexpr("mean|stddev",vectorColumnNames) >= 0]
  if( debug ) print(paste("colnames_list count=",length(colnames_list)))
  colnames_list <- c("subject","activitynbr",colnames_list)
  
  if( debug ) print("data: select all_of(colnames_list)")
  data2 <- select(data,all_of(colnames_list))
  
  if( debug ) print("Create new Activity column at end.")
  data3 <- mutate(data2, activity = dataActivityLabels[activitynbr,2])
  colnames_list <- colnames(data3)
  colnames_list[2] <- "activity"
  colnames_list <- colnames_list[1:length(colnames_list)-1]
  
  # Select only the mean and stddev variables for each observation.
  if( debug ) print(paste("colnames_list count=",length(colnames_list)))
  data_final <- select(data3, all_of(colnames_list))
  data_final
}

combineData <- function(data = NA, 
                        exportfile = "combined.csv", 
                        directory = "./output", 
                        debug = FALSE) 
{
    print("combineData begins.")
    dataTrain <- processData(datatype = "train",debug=TRUE)
    dataTest <- processData(datatype = "test")
    dataCombined <- rbind(dataTrain,dataTest)
    print("combineData: write file.")
    if(!file.exists(directory)) { dir.create(directory)}
    write.table(dataCombined, file=paste0(directory,"/",exportfile))
    print("combineData: done.")
    dataCombined
}

tidyData <- function(data = NA, 
                     exportfile = "tidy.csv", 
                     directory = "./output", 
                     debug = FALSE) 
{
  library(reshape2)
  dataAveraged <- NA
  if(length(data)>0) {
    print("tidyData: begins.")
    #Melt the data.
    dataMolten <- reshape2::melt(data =data, id.vars=c("subject","activity"))
    #Cast it into a multidimensional array:  Activity-Subject by Variable.
    dataAveraged <- acast(dataMolten, activity + subject ~ variable,  mean)
    #Export data
    if(!file.exists(directory)) { dir.create(directory)}
    write.table(dataAveraged,file=paste0(directory,"/",exportfile), row.name=FALSE)
  } else {
    print("tidyData: No data provided.")
  }
  dataAveraged
}