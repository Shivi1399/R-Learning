# install packages
install.packages('rfm')
install.packages('lubridate')
install.packages('dplyr')
install.packages('readxl')

# import packages
library(rfm)
library(dplyr)
library(lubridate)
library(readxl)

data <- read_excel('rfm_transaction.xlsx')
str(data)

data$order_date <- as.Date(data$order_date, format = "%Y/%m%d")
str(data)

rfm_result <-rfm_table_order(
  data = data,
  customer_id = customer_id,
  order_date = order_date,
  revenue = revenue,
  analysis_date = as.Date("2006-12-31")
)
rfm_score <- rfm_result$rfm

rfm_score

write.csv(rfm_score, "rfm_score.csv")

segment_titles <- c(
  "First Grade", #1                          
  "Loyal", #2
  "Likely to be Loyal", #3
  "New Ones", #4
  "Could be Promising", #5
  "Require Assistance", #6
  "Getting less Frequent", #7
  "Almost Out", #8
  "Can't lose them", #9
  "Dont'show up at all" #10
)
#           1, 2, 3, 4, 5, 6, 7, 8, 9, 10
r_low  <- c(4, 2, 3, 4, 3, 2, 2, 1, 1, 1)# minimum value of recency
r_high <- c(5, 5, 5, 5, 4, 3, 3, 2, 1, 2)#maximum value of recency
f_low  <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
f_high <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)
m_low  <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
m_high <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)

devisions <- rfm_segment(rfm_result, segment_titles, r_low, r_high, f_low, f_high, m_low, m_high)
devisions
write.csv(devisions, "rfm_segment.csv")

segments <- dev