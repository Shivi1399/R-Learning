# install.packages("readxl")
# install.packages("lubridate")
# install.packages("janitor")
# install.packages("rfm")
# install.packages("dplyr")
# install.packages ("writexl")

library("readxl")
library("lubridate")
library("janitor")
library("rfm")
library("dplyr")
library("writexl")

data <- read_xls("London Jets, Spreadsheet Supplement.xls")
data <- clean_names(data)
str(data)

required_data <- select(
  data, 
  "cust_id", 
  "num_games", 
  "tot_sales", 
  "last_trans_year", 
  "last_trans_month"
)

required_data <- rename(required_data, customer_id = cust_id)

required_data$last_trans_date <- make_date(
  year = required_data$last_trans_year, 
  month = required_data$last_trans_month,
  day = "1"
)

required_data$recency <- as.numeric (
  difftime(
  as_date("2002-01-01"), 
  required_data$last_trans_date
))

View(required_data)

str(required_data)
?rfm_table_customer
rfm_result <- rfm_table_customer(
  required_data, 
  customer_id = customer_id, 
  n_transactions = "num_games",
  recency = "recency", 
  total_revenue = "tot_sales", 
  analysis_date = as_date("2002-01-01"),
  recency_bins = 10,
  frequency_bins = 10,
  monetary_bins = 10
)

output <- rfm_result$rfm
write_xlsx(output, "output.xlsx")

segment_titles <- c(
  "First Grade", 
  "Loyal", 
  "Likely to be Loyal",
  "New Ones", 
  "Could be Promising", 
  "Require Assistance", 
  "Getting Less Frequent",
  "Almost Out", 
  "Can't Lose Them", 
  "Don't Show Up at All"
)

receny_low      <- c(9,7,5,6,7,1,1,1,1,1)
receny_high     <- c(10,10,9,10,7,6,4,4,6,3)
frequency_low   <- c(9,7,5,1,4,2,1,1,3,1)
frequency_high  <- c(10,10,9,10,8,6,8,5,9,3)
monetary_low    <- c(9,7,5,1,4,1,2,1,6,1)
monetary_high   <- c(10,10,9,8,8,6,7,6,10,3)

output <-rfm_segment(
  rfm_result, 
  segment_titles, 
  receny_low, 
  receny_high, 
  frequency_low, 
  frequency_high, 
  monetary_low, 
  monetary_high
)

write_xlsx(output, "output.xlsx")

segment_summary  <- output %>% 
  count(segment) %>% 
  arrange(desc(n))%>% 
  rename(Frequency = n) %>%
  mutate(Percentage = Frequency/sum(Frequency)*100) %>%
  mutate(Percentage = round(Percentage, digits = 2)
)

write_xlsx(segment_summary, "segment_summary.xlsx")

rfm_plot_median_frequency(output)
