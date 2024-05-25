# install.packages("rfm")
# install.packages("lubridate")
# install.packages("dplyr")
# install.packages("janitor")

library("rfm")
library("lubridate")
library("dplyr")
library("janitor")

data <- read.csv("./dataset/customer.csv")
data <- rename(data, "n_transactions" = "number_of_orders")
data <- rename(data, "total_revenue" = "revenue")
data <- rename(data, "recency" = "recency_days")
str(data)



required_data <- select(
  data,
  "customer_id",
  "n_transactions",
  "total_revenue",
  "recency"
)

str(required_data)
View(required_data)

?rfm_table_customer
rfm_result <- rfm_table_customer(
  data = required_data,
  customer_id = "customer_id",
  n_transactions = "n_transactions",
  recency = "recency",
  total_revenue = "total_revenue",
  analysis_date = as_date("2007-01-01"),
  recency_bins = 10,
  frequency_bins = 10,
  monetary_bins = 10
)

output <- rfm_result$rfm
write.csv(output, file = "rfm_result.csv")

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

receny_low      <- c(9, 7, 5, 6, 7, 1, 1, 1, 1, 1)
receny_high     <- c(10, 10, 9, 10, 7, 6, 4, 4, 6, 3)
frequency_low   <- c(9, 7, 5, 1, 4, 2, 1, 1, 3, 1)
frequency_high  <- c(10, 10, 9, 10, 8, 6, 8, 5, 9, 3)
monetary_low    <- c(9, 7, 5, 1, 4, 1, 2, 1, 6, 1)
monetary_high   <- c(10, 10, 9, 8, 8, 6, 7, 6, 10, 3)

output <- rfm_segment(
  rfm_result,
  segment_titles,
  receny_low,
  receny_high,
  frequency_low,
  frequency_high,
  monetary_low,
  monetary_high
)

write.csv(output, "rfm_segment.csv")

segment_summary  <- output %>%
  count(segment) %>%
  arrange(desc(n)) %>%
  rename(Frequency = n) %>%
  mutate(Percentage = Frequency/sum(Frequency) * 100) %>%
  mutate(Percentage = round(Percentage, digits = 2))

write.csv(segment_summary, "segment_summary.csv")