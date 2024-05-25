#install.packages("arules")
#install.packages("arulesViz")

library("arules")
library("arulesViz")

data <- read.csv(
  file = "./datasets/data.csv", 
  header = TRUE, 
  colClasses = "factor"
)

str(data)

rules <- apriori(
  data = data,
  parameter = list(
    minlen = 2,
    maxlen = 5,
    supp = 0.1,
    conf = 0.5
  ),
  appearance = list(
    rhs = c("Concealer=Yes"),
    lhs = c(
      "Bag=Yes",
      "Blush=Yes",
      "Nail.Polish=Yes",
      "Brushes=Yes",
      "Eyebrow.Pencils=Yes",
      "Bronzer=Yes",
      "Lip.liner=Yes",
      "Mascara=Yes",
      "Eye.shadow=Yes",
      "Foundation=Yes",
      "Lip.Gloss=Yes",
      "Lipstick=Yes",
      "Eyeliner=Yes"
      ),
    default="none"
  )
)

myrules = inspect(rules)
write.csv(myrules, "myrules.csv")

?Reduce
?is.redundant

reduntant <- is.redundant(rules, measure="confidence")
which(reduntant)

inspect(rules[reduntant])
rules.pruned <- rules[!reduntant]
inspect(rules.pruned)

rules.pruned <- sort(rules.pruned, by="lift")
inspect(rules.pruned)

quality(rules.pruned) <- round(quality(rules.pruned), digits = 3)
quality(rules.pruned)

plot(rules.pruned)
