#RFM ANAYSIS UISNG TRANSACTION DATA

# first: install the package

install.packages("rfm")# please install this package

#second: call the package into the front end
library(rfm)


# third: get the data into R
data <- read.csv ("clipboard", sep = "\t", header = T)
data <- read.csv("transaction.csv")# optional, if you use working directory

str(data)# to examine the structure of my data

#install the package lubridate

install.packages ("lubridate")# first time this execution is needed
library(lubridate)

data$order_date <- dmy(data$order_date)
str(data)

data$order_date <- as.Date(data$order_date, format = "%d-%m-%Y")

str(data$order_date)

#convert the date vector: from chr to date
data$order_date <- dmy(data$order_date)# optional (if you already done using as. Date this is not required)
dmy
str(data)
summary(data$order_date)
max(data$order_date)
#perform the analysis

analysis_date <- as_date("2006-12-31")# this function doesnot require the package
library(rfm)
?rfm_table_customer
?rfm_table_order

rfm_result <- rfm_table_order (data = data,
  customer_id =  customer_id,
  order_date = order_date,
  revenue = revenue,
  analysis_date = analysis_date)

rfmdata <- data.frame (rfm_result$rfm)
# write the date

install.packages ("writexl")
library(writexl)
write_xlsx(rfm_result$rfm, "output.xlsx")

write.csv(rfm_result$rfm, "output.csv")

#developing segments

segment_titles <- c("First Grade", "Loyal", "Likely to be Loyal",
                       "New Ones", "Could be Promising", "Require Assistance", "Getting Less Frequent",
                      "Almost Out", "Can't Lose Them", "Don't Show Up at All")



r_low <- c(4, 2, 3, 4, 3, 2, 2, 1, 1, 1)# minimum value of recency
r_high <- c(5, 5, 5, 5, 4, 3, 3, 2, 1, 2)#maximum value of recency
f_low <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
f_high <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)
m_low <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
m_high  <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)

divisions<-rfm_segment(rfm_result, segment_titles, r_low, r_high, f_low, f_high, m_low, m_high)

write.csv(divisions, "myfile.csv")

install.packages ("dplyr")
library(dplyr) # required for grouping

segments  <- divisions %>% count(segment)%>% arrange(desc(n))%>% rename(SEGMENT = segment, FREQUENCY = n)%>%
  mutate(PERCENTAGE = (FREQUENCY/sum(FREQUENCY)*100))



       

View (segments)
(86/995)*100

  278/995

View (divisions)
158/995
(86/995)*100

myscore <- divisions%>%group_by(segment)%>% summarise (AF = median(transaction_count),
                                                       ARD = median(recency_days),
                                                       AMT = median (amount))%>%
  arrange(desc(AMT))

# making plots

rfm_plot_median_recency(divisions)
rfm_plot_median_frequency(divisions)
rfm_plot_median_monetary(divisions)
(187+176)/995

rfm_histograms(rfm_result)
rfm_order_dist(rfm_result)

?rfm_order_dist
rfm_histograms(rfm_result)
rfm_bar_chart(rfm_result)
