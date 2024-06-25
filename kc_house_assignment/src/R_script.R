#install packages
#install.packages("arules")
#install.packages("dpylr")
#install.packages("mice")

#load packages
library("arules")
library("dplyr")
library("mice")

#import the csv data
data <- read.csv("dataset/kc_house_data.csv", header = TRUE)

summary(data)

##############################
#dropping id column
##############################
data <- select(data, -id)

##############################
#calculate house age and adding age column
##############################
data$age <- as.numeric(
  format(
    as.Date(
      data$date, 
      format = "%Y%m%dT000000"
      ), 
    "%Y")
  ) - data$yr_built

temp <- unique(data$age)
temp[order(temp, decreasing = FALSE)]
summary(as.factor(if_else(data$age == -1, "Not Possible", "Possible")))

data <- filter(as.data.frame(data), age != -1)
summary(as.factor(if_else(data$age == -1, "Not Possible", "Possible")))

apriori_data <- data.frame(
  age = cut(
    data$age, 
    breaks=c(
      min(data$age),
      quantile(data$age, prob = .2),
      quantile(data$age, prob = .4),
      quantile(data$age, prob = .6),
      quantile(data$age, prob = .8),
      quantile(data$age, prob = .99),
      max(data$age)
    ), 
    labels=c(
      "New",
      "Moderately New",
      "Average",
      "Moderately Old",
      "Old",
      "Very Old"
    ),
    include.lowest = TRUE
  ))

summary(apriori_data$age)
##############################
#dropping date and yr_built column
##############################
data <- select(
  data, 
  -c(
    date,
    yr_built
    )
  )

##############################
#understanding the price column
##############################
summary(data$price)

apriori_data$price <- cut(
    data$price, 
    breaks=c(
      min(data$price),
      quantile(data$price, prob = .2),
      quantile(data$price, prob = .4),
      quantile(data$price, prob = .6),
      quantile(data$price, prob = .8),
      max(data$price)
    ), 
    labels=c(
      "Cheap",
      "Affordable",
      "Expensive",
      "Premium",
      "Ultra premium"
    ),
    include.lowest = TRUE
  )

summary(apriori_data$price)

##############################
#understanding the bedrooms column
##############################
temp <- unique(data$bedrooms)
temp[order(temp, decreasing = FALSE)]
summary(as.factor(data$bedrooms))
apriori_data$bedrooms <- as.factor(data$bedrooms)

summary(apriori_data$bedrooms)

##############################
#understanding the bathrooms column
##############################
temp <- unique(data$bathrooms)
temp[order(temp, decreasing = FALSE)]
summary(data$bathrooms)
apriori_data$bathrooms <- as.factor(data$bathrooms)

summary(apriori_data$bathrooms)

##############################
#extra bathroom per bedroom ratio
##############################
data$bathroom_to_bedroom_ratio <- if_else(
  data$bedrooms != 0, 
  data$bathrooms/data$bedrooms, 
  Inf
  ) %>% round(digits = 3)
temp <- unique(data$bathroom_to_bedroom_ratio)
temp[order(temp, decreasing = FALSE)]
summary(data$bathroom_to_bedroom_ratio)

apriori_data$bathroom_to_bedroom_ratio <- cut(
    data$bathroom_to_bedroom_ratio, 
    breaks=c(
      -Inf,
      min(data$bathroom_to_bedroom_ratio),
      0.5,
      1,
      max(data$bathroom_to_bedroom_ratio)
    ), 
    labels=c(
      "No bathroom",
      "Less than adequate",
      "Adequate",
      "More than adequate"
    )
  )

summary(apriori_data$bathroom_to_bedroom_ratio)

##############################
#dropping the sqft_living and sqft_lot columns
##############################
data <- select(
  data, 
  -c(
    sqft_living,
    sqft_lot
    )
  )

##############################
#understanding the floors column
##############################
temp <- unique(data$floors)
temp[order(temp, decreasing = FALSE)]
summary(as.factor(data$floors))

apriori_data$floors <- cut(
  data$floors, 
  breaks=c(
    0.9,
    1.9,
    2.9,
    max(data$floors)
  ), 
  labels=c(
    "1",
    "2",
    "3"
  ),
  include.lowest = TRUE
)

summary(apriori_data$floors)

##############################
#understanding the waterfront column
##############################
temp <- unique(data$waterfront)
temp[order(temp, decreasing = FALSE)]
summary(as.factor(data$waterfront))

apriori_data$waterfront <- as.factor(if_else(data$waterfront == 0, "No", "Yes"))

summary(apriori_data$waterfront)

##############################
#understanding the view column
##############################
temp <- unique(data$view)
temp[order(temp, decreasing = FALSE)]
summary(as.factor(data$view))

apriori_data$view <- cut(
  data$view, 
  breaks=c(
    -Inf,
    min(data$view),
    1,
    max(data$view)
  ), 
  labels=c(
    "No view",
    "Single View",
    "Multiple views"
  )
)

summary(apriori_data$view)

##############################
#understanding the condition column
##############################
temp <- unique(data$condition)
temp[order(temp, decreasing = FALSE)]
summary(as.factor(data$condition))

apriori_data$condition <- cut(
  data$condition, 
  breaks=c(0,1,2,3,4,5), 
  labels=c(
    "Very Poor",
    "Poor",
    "Decent",
    "Good",
    "Excellent"
  ),
  include.lowest = TRUE
)

summary(apriori_data$condition)

##############################
#understanding the grade column
##############################
temp <- unique(data$grade)
temp[order(temp, decreasing = FALSE)]
summary(as.factor(data$grade))

apriori_data$grade <- cut(
  data$grade, 
  breaks=c(0,3,6,9,12,15), 
  labels=c(
    "Very Poor",
    "Poor",
    "Decent",
    "Good",
    "Excellent"
  ),
  include.lowest = TRUE
)

summary(apriori_data$grade)

##############################
#understanding the sqft_above column
##############################
summary(data$sqft_above)

#since there is some missing data we will address sqft_above after all
#other columns

##############################
#understanding the sqft_basement column
##############################
summary(data$sqft_basement)

#since there is some relation btw sqft_above and sqft_basement
#we will address sqft_basement after all other columns

##############################
#understanding the yr_renovated column
##############################
temp <- unique(data$yr_renovated)
temp[order(temp, decreasing = FALSE)]
summary(as.factor(data$yr_renovated))

apriori_data$yr_renovated <- cut(
  data$yr_renovated,
  breaks = c(
    -Inf,
    min(data$yr_renovated),
    2010,
    max(data$yr_renovated)
  ),
  labels = c(
    "Not renovated",
    "Renovated",
    "Recently renovated"
  )
)

summary(apriori_data$yr_renovated)

##############################
#dropping the zipcode, lat and long columns
##############################
data <- select(
  data,
  -c(
    zipcode,
    lat,
    long,
    )
  )

##############################
#understanding the sqft_living15 column
##############################
summary(data$sqft_living15)

apriori_data$sqft_living15 <- cut(
  data$sqft_living15, 
  breaks=c(
    min(data$sqft_living15),
    quantile(data$sqft_living15, prob = .2),
    quantile(data$sqft_living15, prob = .4),
    quantile(data$sqft_living15, prob = .6),
    quantile(data$sqft_living15, prob = .8),
    max(data$sqft_living15)
  ), 
  labels=c(
    "Very small",
    "Small",
    "Average",
    "Large",
    "Very large"
  ),
  include.lowest = TRUE
)

summary(apriori_data$sqft_living15)

##############################
#understanding the sqft_lot15 column
##############################
summary(data$sqft_lot15)

apriori_data$sqft_lot15 <- cut(
  data$sqft_lot15, 
  breaks=c(
    min(data$sqft_lot15),
    quantile(data$sqft_lot15, prob = .2),
    quantile(data$sqft_lot15, prob = .4),
    quantile(data$sqft_lot15, prob = .6),
    quantile(data$sqft_lot15, prob = .8),
    max(data$sqft_lot15)
  ), 
  labels=c(
    "Very small",
    "Small",
    "Average",
    "Large",
    "Very large"
  ),
  include.lowest = TRUE
)

summary(apriori_data$sqft_lot15)

##############################
#understanding the sqft_above column
##############################
summary(data$sqft_above)
imputed_data <- complete(mice(data, m = 10, method = "pmm", seed = 1999))

summary(imputed_data$sqft_above)

apriori_data$sqft_above <- cut(
  imputed_data$sqft_above, 
  breaks=c(
    min(imputed_data$sqft_above),
    quantile(imputed_data$sqft_above, prob = .2),
    quantile(imputed_data$sqft_above, prob = .4),
    quantile(imputed_data$sqft_above, prob = .6),
    quantile(imputed_data$sqft_above, prob = .8),
    max(imputed_data$sqft_above)
  ), 
  labels=c(
    "Very small",
    "Small",
    "Average",
    "Large",
    "Very large"
  ),
  include.lowest = TRUE
)

summary(apriori_data$sqft_above)

##############################
#understanding the sqft_basement column
##############################
summary(imputed_data$sqft_basement)

imputed_data$basement_to_ground_floor_sqft_ratio = if_else(
    imputed_data$sqft_above != 0, 
    imputed_data$sqft_basement/imputed_data$sqft_above, 
    NA
    ) %>% round(digits = 2)
  
summary(imputed_data$basement_to_ground_floor_sqft_ratio)
temp <- unique(imputed_data$basement_to_ground_floor_sqft_ratio)
temp[order(temp, decreasing = FALSE)]

apriori_data$sqft_basement <- cut(
  imputed_data$basement_to_ground_floor_sqft_ratio, 
  breaks=c(
    -Inf,
    0.00,
    0.25,
    0.50,
    0.75,
    1.00,
    max(imputed_data$basement_to_ground_floor_sqft_ratio)
  ), 
  labels=c(
    "No basement",
    "Very Small",
    "Small",
    "Medium",
    "Large",
    "Very large"
  ),
  include.lowest = TRUE
)

summary(apriori_data$sqft_basement)

##############################
#Final look at the data
##############################
str(apriori_data)
summary(apriori_data)
write.csv(apriori_data, "outputs/apriori_data.csv")

############################################################
#Apriori Rules

##############################
#Rules for cheap houses
##############################
rules <- apriori(
  data = apriori_data,
  parameter = list(
    minlen = 5,
    maxlen = 14,
    supp = 0.1,
    conf = 0.2
  ),
  appearance = list(
    rhs = c("price=Cheap"),
    default="lhs"
  )
)

inspect(rules)
reduntant <- is.redundant(rules, measure="confidence")
which(reduntant)
inspect(rules[reduntant])
rules.pruned <- rules[!reduntant]
rules.pruned <- sort(rules.pruned, by="lift")
rules_for_cheap_house <- inspect(rules.pruned)

write.csv(
  rules_for_cheap_house, 
  "outputs/rules_for_cheap_house.csv",
  row.names = FALSE
  )

##############################
#Rules for affordable houses
##############################
rules <- apriori(
  data = apriori_data,
  parameter = list(
    minlen = 5,
    maxlen = 14,
    supp = 0.1,
    conf = 0.2
  ),
  appearance = list(
    rhs = c("price=Affordable"),
    default="lhs"
  )
)

inspect(rules)
reduntant <- is.redundant(rules, measure="confidence")
which(reduntant)
inspect(rules[reduntant])
rules.pruned <- rules[!reduntant]
rules.pruned <- sort(rules.pruned, by="lift")
rules_for_affordable_house <- DATAFRAME(rules.pruned)

write.csv(
  rules_for_affordable_house, 
  "outputs/rules_for_affordable_house.csv",
  row.names = FALSE
  )

##############################
#Rules for expensive houses
##############################
rules <- apriori(
  data = apriori_data,
  parameter = list(
    minlen = 5,
    maxlen = 14,
    supp = 0.1,
    conf = 0.2
  ),
  appearance = list(
    rhs = c("price=Expensive"),
    default="lhs"
  )
)

inspect(rules)
reduntant <- is.redundant(rules, measure="confidence")
which(reduntant)
inspect(rules[reduntant])
rules.pruned <- rules[!reduntant]
rules.pruned <- sort(rules.pruned, by="lift")
rules_for_expensive_house <- DATAFRAME(rules.pruned)

write.csv(
  rules_for_expensive_house, 
  "outputs/rules_for_expensive_house.csv", 
  row.names = FALSE
  )

##############################
#Rules for premium houses
##############################
rules <- apriori(
  data = apriori_data,
  parameter = list(
    minlen = 5,
    maxlen = 14,
    supp = 0.1,
    conf = 0.2
  ),
  appearance = list(
    rhs = c("price=Premium"),
    default="lhs"
  )
)

inspect(rules)
reduntant <- is.redundant(rules, measure="confidence")
which(reduntant)
inspect(rules[reduntant])
rules.pruned <- rules[!reduntant]
rules.pruned <- sort(rules.pruned, by="lift")
rules_for_premium_house <- DATAFRAME(rules.pruned)

write.csv(
  rules_for_premium_house, 
  "outputs/rules_for_premium_house.csv",
  row.names = FALSE
  )

##############################
#Rules for Ultra premium houses
##############################
rules <- apriori(
  data = apriori_data,
  parameter = list(
    minlen = 2,
    maxlen = 14,
    supp = 0.1,
    conf = 0.5
  ),
  appearance = list(
    rhs = c("price=Ultra premium"),
    default="lhs"
  )
)

reduntant <- is.redundant(rules, measure="confidence")
which(reduntant)
inspect(rules[reduntant])
rules.pruned <- rules[!reduntant]
rules.pruned <- sort(rules.pruned, by="lift")
rules_for_ultra_premium_house <- inspect(rules.pruned)

write.csv(rules_for_ultra_premium_house, "outputs/rules_for_ultra_premium_house.csv")
