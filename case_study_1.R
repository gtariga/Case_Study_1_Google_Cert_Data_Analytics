library(tidyverse)

##This is the path to my work directory change it to your path where you stored the csv files 
setwd("C:/Users/Glenn/Documents/Case Study 1 Google Certification")

##this will be the initial variable for the loop to work just assign a the first data frame you need to merge
ride_info_2020 <- read_csv("ride_info_2020_1.csv")
  
for(n in 2:9){ 

  df <- paste("ride_2020_",n,sep = "")
  
  ## this to automate creating df to merge them into one because the spreadsheet for some years are separated so I want them to be merged into one year
  ## merge the dataframes by adding row to the existing dataframes is what the rbind is for and the assign is to automate the variable naming  
  
  ride_info_2020 <- rbind(ride_info_2020,assign(df, read_csv(paste("ride_info_2020_",n,".csv",sep=""))))
  
  ##we are trying to save on the space complexity by deleting the dataframes we already merged with the main data frame
  rm(list = paste("ride_2020_",n,sep = ""))
}

str(ride_info_2020)

##this will remove the rows with NULL values
ride_info_2020 <- ride_info_2020 %>%
  drop_na()

##Start of section for adding columns that will be useful for data analysis

##preparing date time format to calculate length of trip
##ride_info_2020$new_started_at <- strptime(ride_info_2020$started_at, format = "%m/%d/%Y %H:%M", tz = "UTC") ignore this
##ride_info_2020$new_ended_at <- strptime(ride_info_2020$ended_at, format = "%m/%d/%Y %H:%M", tz = "UTC") ignore this

##checking if end time is always greater than start time
bad <- filter(ride_info_2020, started_at > ended_at)

##there are bad entries we need to clean instead of excluding them I will swap their column in the bad and rename. then delete their entries in the main datframe and 
##then merge the bad database rows into the main dataframe 

#need temp columns for swap
temp_start <- bad$ended_at
temp_end <- bad$started_at

##using temp columns to swap values
bad$ended_at <- temp_end
bad$started_at <- temp_start

##deleting the bad data from main dataframe
ride_info_2020 <- ride_info_2020 %>%
  filter(started_at <= ended_at)

##addind correct data to the main dataframe
ride_info_2020 <- ride_info_2020 %>%
  rbind(bad)

#deleting not needed variabels for space complexity
rm(bad)
rm(temp_end)
rm(temp_start)

##adding length of ride in the dataframe
ride_info_2020 <- ride_info_2020 %>%
  mutate("time_length_of_ride(mins)" = difftime(ended_at, started_at, units = "mins"))

##adding distance traveled in the dataframe

ride_info_2020 <-mutate(ride_info_2020, "manhattan_dist" = (abs(start_lat - end_lat) + abs(start_lng - end_lng)))

##Checking for bad value on the rest of the column by seeing unique variable stored in dataframe I didn't use pivot because I feel its easier to view them this way
for (n in 1:15) {
  df <- paste("unique_values_col_",n,sep = "")
  assign(df,print(unique(ride_info_2020[n])))
}

##After checking unique values are okay we clean up for space complexity
for (n in 1:15) {
  
  rm(list = paste("unique_values_col_",n,sep = ""))
  
}


##Now even if I didn't really see any extra white spaces it is still good to run trim on the data type chr this will probably run for a while
ride_info_2020 <- ride_info_2020 %>%
  mutate(across(where(is.character),function(x)trimws(x)))



##End of section for cleaning and adding columns that will be useful for data analysis

##2021 Merge
ride_info_2021 <- data.frame()

for(n in 1:10){ 
  
  df <- paste("ride_2021_",n,sep = "")
  
  ## this to automate creating df to merge them into one because the spreadsheet for some years are separated so I want them to be merged into one year
  ## merge the dataframes by adding row to the existing dataframes is what the rbind is for and the assign is to automate the variable naming  
  
  ride_info_2021 <- rbind(ride_info_2021,assign(df, read_csv(paste("ride_info_2021_",n,".csv",sep=""))))
  
  ##we are trying to save on the space complexity by deleting the dataframes we already merged with the main data frame
  rm(list = paste("ride_2021_",n,sep = ""))
}



 

