#install the packages
#install.packages("readxl")
#install.packages("janitor")
#install.packages("dplyr")

#importing the packages
library(readxl)
library(janitor)
library(dplyr)

#importing the data
data <- read_excel("dataset/IMB733-XLS-ENG.xlsx", sheet="Data Sheet")
data <- clean_names(data)

View(data)
str(data)

str(data$month_year)
data$month_year <- as.Date(data$month_year, format="%Y-%m-%d")
str(data$month_year)

#Q1. Anand, the cofounder of JAT, claims that disease 6 (leaf curl) information 
# was accessed at least 60 times every week on average since October 2017 due to 
# this disease outbreak. Test this claim at a significance level of 0.05 using 
# an appropriate hypothesis test.

ans_1 <- t.test(
  select(
    filter(
      data, 
      month_year >= "2017-10-1"
      ), c("d6")
    ), 
  mu = 60, 
  alternative = 'greater'
)
ans_1

#Q2. JAT believes that over the years, the average number of app users have 
# increased significantly. Is there statistical evidence to support that the 
# average number of users in year 2017-2018 is more than average number of 
# users in year 2015-2016 at a=0.05? Support your answer with all necessary 
# tests.

data$year_group <- cut(
  data$month_year, 
  breaks=c(
    as.Date("2015-01-01"),
    as.Date("2016-01-01"),
    as.Date("2017-01-01"),
    as.Date("2018-01-01"),
    as.Date("2019-01-01")
  ), 
  labels=c(
    "2015-16",
    "2016-17",
    "2017-18",
    "2018-19"
  ),
  include.lowest = TRUE
)
View(data)

filtered_data <- select(
  filter(
    data, 
    year_group == "2015-16" | year_group == "2017-18"
    ), c(
      "month_year", 
      "no_of_users", 
      "year_group"
      )
  )
filtered_data$year_group <- relevel(filtered_data$year_group, ref = "2017-18")
ans_2 <- t.test(
  filtered_data$no_of_users ~ filtered_data$year_group, 
  alternative = "greater", 
  var.equal = F
  )
ans_2

# Q6. If a disease is likely to spread in particular weather condition (data 
# given in the disease index sheet), then the access of that disease should
# be more in the months having suitable weather conditions. Help the analyst in 
# coming up with a statistical test to support the claim for two districts for 
# which the sample of weather and disease access data is provided in the data 
# sheet. Identify the diseases for which you can support this claim. Test this 
# claim both for temperature and relative humidity at 95% confidence. 
cal_fav_condition <- function(
    x, 
    dont_check_humidity = FALSE,
    min_humidity=0, 
    max_humidity=Inf, 
    min_temp=0, 
    max_temp=Inf
){
  if (!dont_check_humidity) {
    return(
      factor(
        ifelse(
          (x$humidity > min_humidity & x$humidity < max_humidity) & (x$temperature >= min_temp & x$temperature <= max_temp),
          "favourable",
          "unfavourable"
        )
      )
    )
  }
  else {
    return(
      factor(
        ifelse(
          x$temperature >= min_temp & x$temperature <= max_temp,
          "favourable",
          "unfavourable"
        )
      )
    )
  }
  
}
##############################
# Belagavi
##############################
belagavi_data <- read_excel("dataset/IMB733-XLS-ENG.xlsx", sheet="Belagavi_weather")
belagavi_data <- clean_names(belagavi_data)

belagavi_data$d1_fav <- cal_fav_condition(
  belagavi_data, 
  min_humidity = 80, 
  min_temp = 20, 
  max_temp = 24
)
belagavi_data$d2_fav <- cal_fav_condition(
  belagavi_data, 
  min_humidity = 83, 
  min_temp = 21.5, 
  max_temp = 24.5
)
belagavi_data$d3_fav <- cal_fav_condition(
  belagavi_data, 
  dont_check_humidity = TRUE, 
  min_temp = 22, 
  max_temp = 24
)
belagavi_data$d4_fav <- cal_fav_condition(
  belagavi_data, 
  min_humidity = 85, 
  min_temp = 22, 
  max_temp = 26
)
belagavi_data$d5_fav <- cal_fav_condition(
  belagavi_data, 
  min_humidity = 77, 
  max_humidity = 85,
  min_temp = 22, 
  max_temp = 24.5
)
belagavi_data$d7_fav <- cal_fav_condition(
  belagavi_data, 
  min_humidity = 80, 
  min_temp = 25,
)
str(belagavi_data)

t.test(belagavi_data$d1 ~ belagavi_data$d1_fav, alternative = "greater")
t.test(belagavi_data$d2 ~ belagavi_data$d2_fav, alternative = "greater")
t.test(belagavi_data$d3 ~ belagavi_data$d3_fav, alternative = "greater")
t.test(belagavi_data$d4 ~ belagavi_data$d4_fav, alternative = "greater")
t.test(belagavi_data$d5 ~ belagavi_data$d5_fav, alternative = "greater")
t.test(belagavi_data$d1 ~ belagavi_data$d7_fav, alternative = "greater")

##############################
# Dharwad
##############################
dharwad_data <- read_excel("dataset/IMB733-XLS-ENG.xlsx", sheet="Dharwad_weather")
dharwad_data <- clean_names(dharwad_data)
dharwad_data <- rename(dharwad_data, c("humidity"="relative_humidity"))
dharwad_data$d1_fav <- cal_fav_condition(
  dharwad_data, 
  min_humidity = 80, 
  min_temp = 20, 
  max_temp = 24
)
dharwad_data$d2_fav <- cal_fav_condition(
  dharwad_data, 
  min_humidity = 83, 
  min_temp = 21.5, 
  max_temp = 24.5
)
dharwad_data$d3_fav <- cal_fav_condition(
  dharwad_data, 
  dont_check_humidity = TRUE, 
  min_temp = 22, 
  max_temp = 24
)
dharwad_data$d4_fav <- cal_fav_condition(
  dharwad_data, 
  min_humidity = 85, 
  min_temp = 22, 
  max_temp = 26
)
dharwad_data$d5_fav <- cal_fav_condition(
  dharwad_data, 
  min_humidity = 77, 
  max_humidity = 85,
  min_temp = 22, 
  max_temp = 24.5
)
dharwad_data$d7_fav <- cal_fav_condition(
  dharwad_data, 
  min_humidity = 80, 
  min_temp = 25,
)
str(dharwad_data)

t.test(dharwad_data$d1 ~ dharwad_data$d1_fav, alternative = "greater")
t.test(dharwad_data$d2 ~ dharwad_data$d2_fav, alternative = "greater")
t.test(dharwad_data$d3 ~ dharwad_data$d3_fav, alternative = "greater")
t.test(dharwad_data$d4 ~ dharwad_data$d4_fav, alternative = "greater")
t.test(dharwad_data$d5 ~ dharwad_data$d5_fav, alternative = "greater")
t.test(dharwad_data$d1 ~ dharwad_data$d7_fav, alternative = "greater")
