library(tidyverse)
library(dplyr)
library(ggplot2)
#1. Read the 1992 data in
data <-read.csv("/Users/wangyuening/Desktop/McDaniel /Data Storage/Assignment 3/StormEvents_details-ftp_v1.0_d1992_c20220425.csv")
head(data,6)
#2. Limit the data frame into vertail columnes 
myvars<- c("BEGIN_YEARMONTH","EPISODE_ID","STATE","STATE_FIPS","CZ_NAME","CZ_TYPE","CZ_FIPS","EVENT_TYPE")
newdata<-data[myvars]
head(newdata,6)

#3 arrange the data by the state name(STATE)
newdata<-arrange(newdata,STATE)


#4.change state and county names to title case
newdata$STATE <- str_to_title(newdata$STATE)
newdata$CZ_NAME <- str_to_title(newdata$CZ_NAME)

#5.	Limit to the events listed by county FIPS (CZ_TYPE of “C”) and then remove the CZ_TYPE column

newdata2 <-filter(newdata,CZ_TYPE=="C")
newdata2 <- select(newdata2, -CZ_TYPE)

#6.	Pad the state and county FIPS with a “0” at the beginning (hint: there’s a function in stringr to do this) and then unite the two columns to make one FIPS column with the new state-county FIPS code 

newdata2$STATE_FIPS <- str_pad(newdata2$STATE_FIPS,width = 3,side = "left",pad = "0")
newdata2$CZ_FIPS <- str_pad(newdata2$CZ_FIPS,width = 3, side = "left",pad = "0")

newdata2 <- unite(newdata2,"FIPS",CZ_FIPS,STATE_FIPS,sep = "")

#7.	Change all the column names to lower case
newdata2 <- rename_all(newdata2,tolower)

#8.	There is data that comes with base R on U.S. states (data("state")). Use that to create a dataframe with these three columns: state name, area, and region
us_state_info <- data.frame(state = state.name,region=state.region,area=state.area)

#9.	Create a dataframe with the number of events per state. Merge in the state information dataframe you just created in step 8. Remove any states that are not in the state information dataframe.
fre_by_state <- data.frame(table(newdata2$state))
fre_by_state <- fre_by_state %>% rename(state = Var1)

mergerd_data <-merge(x=fre_by_state,y=us_state_info,by.x = "state",by.y = "state")

#10. crate visual 
storm_plot <- ggplot(mergerd_data,aes(x=area,y=Freq)) + geom_point(aes(color = region)) + labs(x="Land area (square miles)", y ="# of storm events in 1992")
storm_plot

