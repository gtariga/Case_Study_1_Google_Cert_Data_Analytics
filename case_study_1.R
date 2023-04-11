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

##adding year column
ride_info_2020 <- ride_info_2020 %>%
  mutate("year" = year(ride_info_2020$started_at))

##Checking for bad value on the rest of the column by seeing unique variable stored in dataframe I didn't use pivot because I feel its easier to view them this way
for (n in 1:16) {
  df <- paste("unique_values_col_",n,sep = "")
  assign(df,print(unique(ride_info_2020[n])))
}



##After checking unique values are okay we clean up for space complexity
for (n in 1:16) {
  
  rm(list = paste("unique_values_col_",n,sep = ""))
  
}


##Now even if I didn't really see any extra white spaces it is still good to run trim on the data type chr this will probably run for a while
ride_info_2020 <- ride_info_2020 %>%
  mutate(across(where(is.character),function(x)trimws(x)))



##End of section for cleaning and adding columns that will be useful for data analysis




##Start for 2021 file to be cleaned and prepared

##this will be the initial variable for the loop to work just assign a the first data frame you need to merge
ride_info_2021 <- read_csv("ride_info_2021_1.csv")

for(n in 2:11){ 
  
  df <- paste("ride_2021_",n,sep = "")
  
  ## this to automate creating df to merge them into one because the spreadsheet for some years are separated so I want them to be merged into one year
  ## merge the dataframes by adding row to the existing dataframes is what the rbind is for and the assign is to automate the variable naming  
  
  ride_info_2021 <- rbind(ride_info_2021,assign(df, read_csv(paste("ride_info_2021_",n,".csv",sep=""))))
  
  ##we are trying to save on the space complexity by deleting the dataframes we already merged with the main data frame
  rm(list = paste("ride_2021_",n,sep = ""))
}

str(ride_info_2021)

##this will remove the rows with NULL values
ride_info_2021 <- ride_info_2021 %>%
  drop_na()

##Start of section for adding columns that will be useful for data analysis

##preparing date time format to calculate length of trip


##checking if end time is always greater than start time
bad <- filter(ride_info_2021, started_at > ended_at)

##there are bad entries we need to clean instead of excluding them I will swap their column in the bad and rename. then delete their entries in the main datframe and 
##then merge the bad database rows into the main dataframe 

#need temp columns for swap
temp_start <- bad$ended_at
temp_end <- bad$started_at

##using temp columns to swap values
bad$ended_at <- temp_end
bad$started_at <- temp_start

##deleting the bad data from main dataframe
ride_info_2021 <- ride_info_2021 %>%
  filter(started_at <= ended_at)

##addind correct data to the main dataframe
ride_info_2021 <- ride_info_2021 %>%
  rbind(bad)

#deleting not needed variabels for space complexity
rm(bad)
rm(temp_end)
rm(temp_start)



##adding length of ride in the dataframe
ride_info_2021 <- ride_info_2021 %>%
  mutate("time_length_of_ride(mins)" = difftime(ended_at, started_at, units = "mins"))

##adding distance traveled in the dataframe

ride_info_2021 <-mutate(ride_info_2021, "manhattan_dist" = (abs(start_lat - end_lat) + abs(start_lng - end_lng)))

##adding year column
ride_info_2021 <- ride_info_2021 %>%
  mutate("year" = year(ride_info_2021$started_at))

##Checking for bad value on the rest of the column by seeing unique variable stored in dataframe I didn't use pivot because I feel its easier to view them this way
for (n in 1:16) {
  df <- paste("unique_values_col_",n,sep = "")
  assign(df,print(unique(ride_info_2021[n])))
}

##After checking unique values are okay we clean up for space complexity
for (n in 1:16) {
  
  rm(list = paste("unique_values_col_",n,sep = ""))
  
}


##Now even if I didn't really see any extra white spaces it is still good to run trim on the data type chr this will probably run for a while
ride_info_2021 <- ride_info_2021 %>%
  mutate(across(where(is.character),function(x)trimws(x)))



##End of section for cleaning and adding columns that will be useful for data analysis


##Start for 2022 file to be cleaned and prepared

##this will be the initial variable for the loop to work just assign a the first data frame you need to merge
ride_info_2022 <- read_csv("ride_info_2022_1.csv")

for(n in 2:12){ 
  
  df <- paste("ride_2022_",n,sep = "")
  
  ## this to automate creating df to merge them into one because the spreadsheet for some years are separated so I want them to be merged into one year
  ## merge the dataframes by adding row to the existing dataframes is what the rbind is for and the assign is to automate the variable naming  
  
  ride_info_2022 <- rbind(ride_info_2022,assign(df, read_csv(paste("ride_info_2022_",n,".csv",sep=""))))
  
  ##we are trying to save on the space complexity by deleting the dataframes we already merged with the main data frame
  rm(list = paste("ride_2022_",n,sep = ""))
}

str(ride_info_2022)

##this will remove the rows with NULL values
ride_info_2022 <- ride_info_2022 %>%
  drop_na()

##Start of section for adding columns that will be useful for data analysis

##preparing date time format to calculate length of trip

##checking if end time is always greater than start time
bad <- filter(ride_info_2022, started_at > ended_at)

##there are bad entries we need to clean instead of excluding them I will swap their column in the bad and rename. then delete their entries in the main datframe and 
##then merge the bad database rows into the main dataframe 

#need temp columns for swap
temp_start <- bad$ended_at
temp_end <- bad$started_at

##using temp columns to swap values
bad$ended_at <- temp_end
bad$started_at <- temp_start

##deleting the bad data from main dataframe
ride_info_2022 <- ride_info_2022 %>%
  filter(started_at <= ended_at)

##addind correct data to the main dataframe
ride_info_2022 <- ride_info_2022 %>%
  rbind(bad)



#deleting not needed variabels for space complexity
rm(bad)
rm(temp_end)
rm(temp_start)

##adding length of ride in the dataframe
ride_info_2022 <- ride_info_2022 %>%
  mutate("time_length_of_ride(mins)" = difftime(ended_at, started_at, units = "mins"))



##adding distance traveled in the dataframe

ride_info_2022 <-mutate(ride_info_2022, "manhattan_dist" = (abs(start_lat - end_lat) + abs(start_lng - end_lng)))

##adding year column
ride_info_2022 <- ride_info_2022 %>%
  mutate("year" = year(ride_info_2022$started_at))

##Checking for bad value on the rest of the column by seeing unique variable stored in dataframe I didn't use pivot because I feel its easier to view them this way
for (n in 1:16) {
  df <- paste("unique_values_col_",n,sep = "")
  assign(df,print(unique(ride_info_2022[n])))
}

##After checking unique values are okay we clean up for space complexity
for (n in 1:16) {
  
  rm(list = paste("unique_values_col_",n,sep = ""))
  
}


##Now even if I didn't really see any extra white spaces it is still good to run trim on the data type chr this will probably run for a while
ride_info_2022 <- ride_info_2022 %>%
  mutate(across(where(is.character),function(x)trimws(x)))



##End of section for cleaning and adding columns that will be useful for data analysis






##Start for 2023 file to be cleaned and prepared

##this will be the initial variable for the loop to work just assign a the first data frame you need to merge
ride_info_2023 <- read_csv("ride_info_2023_1.csv")

for(n in 2:3){ 
  
  df <- paste("ride_2023_",n,sep = "")
  
  ## this to automate creating df to merge them into one because the spreadsheet for some years are separated so I want them to be merged into one year
  ## merge the dataframes by adding row to the existing dataframes is what the rbind is for and the assign is to automate the variable naming  
  
  ride_info_2023 <- rbind(ride_info_2023,assign(df, read_csv(paste("ride_info_2023_",n,".csv",sep=""))))
  
  ##we are trying to save on the space complexity by deleting the dataframes we already merged with the main data frame
  rm(list = paste("ride_2023_",n,sep = ""))
}

str(ride_info_2023)

##this will remove the rows with NULL values
ride_info_2023 <- ride_info_2023 %>%
  drop_na()

##Start of section for adding columns that will be useful for data analysis

##preparing date time format to calculate length of trip

##checking if end time is always greater than start time
bad <- filter(ride_info_2023, started_at > ended_at)

##there are bad entries we need to clean instead of excluding them I will swap their column in the bad and rename. then delete their entries in the main datframe and 
##then merge the bad database rows into the main dataframe 

#need temp columns for swap
temp_start <- bad$ended_at
temp_end <- bad$started_at

##using temp columns to swap values
bad$ended_at <- temp_end
bad$started_at <- temp_start

##deleting the bad data from main dataframe
ride_info_2023 <- ride_info_2023 %>%
  filter(started_at <= ended_at)

##addind correct data to the main dataframe
ride_info_2023 <- ride_info_2023 %>%
  rbind(bad)

##adding year column
ride_info_2023 <- ride_info_2023 %>%
  mutate("year" = year(ride_info_2023$started_at))

#deleting not needed variabels for space complexity
rm(bad)
rm(temp_end)
rm(temp_start)

##adding length of ride in the dataframe
ride_info_2023 <- ride_info_2023 %>%
  mutate("time_length_of_ride(mins)" = difftime(ended_at, started_at, units = "mins"))

##adding distance traveled in the dataframe

ride_info_2023 <-mutate(ride_info_2023, "manhattan_dist" = (abs(start_lat - end_lat) + abs(start_lng - end_lng)))

##adding year column
ride_info_2023 <- ride_info_2023 %>%
  mutate("year" = year(ride_info_2023$started_at))

##Checking for bad value on the rest of the column by seeing unique variable stored in dataframe I didn't use pivot because I feel its easier to view them this way
for (n in 1:16) {
  df <- paste("unique_values_col_",n,sep = "")
  assign(df,print(unique(ride_info_2023[n])))
}

##After checking unique values are okay we clean up for space complexity
for (n in 1:16) {
  
  rm(list = paste("unique_values_col_",n,sep = ""))
  
}


##Now even if I didn't really see any extra white spaces it is still good to run trim on the data type chr this will probably run for a while
ride_info_2023 <- ride_info_2023 %>%
  mutate(across(where(is.character),function(x)trimws(x)))



##End of section for cleaning and adding columns that will be useful for data analysis
 

##Merging All the dataframes together
ride_info <- ride_info_2020

df_list <- list(ride_info_2021,ride_info_2022,ride_info_2023)

for (df in df_list) {
  
  ride_info <- rows_insert(ride_info,df)
  
}

##cleaning up for space complexity
rm(df)
rm(df_list)
rm(list = c("ride_info_2020","ride_info_2021","ride_info_2022","ride_info_2023"))



##saving the ride_info dataframe as a csv
library(data.table)

fwrite(ride_info, "C:\\Users\\Glenn\\Documents\\Case Study 1 Google Certification\\ride_info.csv")

###using r to analyze
ride_info_summarry <- ride_info %>%
  group_by(member_casual, year) %>%
  summarise(average_ride_time_in_min = mean(`time_length_of_ride(mins)`), 
            count_of_rides = n(),
            average_dist = mean(manhattan_dist),
            count_of_riders = n_distinct(ride_id))

###scatter plot
ride_info %>%
  ggplot() + geom_bar(mapping = aes(x=rideable_type,fill = member_casual)) +
  labs(title = "Count of Rider Who Uses the Type of Bike") +
  facet_wrap("~year")

