# Kings County House Price

## Overview
Association Rule Mining in R Language is an Unsupervised Non-linear algorithm to uncover how the items are associated with each other. In it, frequent Mining shows which items appear together in a transaction or relation. It’s majorly used by retailers, grocery stores, an online marketplace that has a large transactional database. The same way when any online social media, marketplace, and e-commerce websites know what you buy next using recommendations engines. The recommendations you get on item or variable, while you check out the order is because of Association rule mining boarded on past customer data. There are three common ways to measure association:

* Support
* Confidence
* Lift

Important Terminologies
* Support: 

    Support is an indication of how frequently the itemset appears in the dataset. It is the count of records containing an item ‘x’ divided by the total number of records in the database.

* Confidence: 

    Confidence is a measure of times such that if an item ‘x’ is bought, then item ‘y’ is also bought together. It is the support count of (x U y) divided by the support count of ‘x’.

* Lift: 

    Lift is the ratio of the observed support to that which is expected if ‘x’ and ‘y’ were independent. It is the support count of (x U y) divided by the product of individual support counts of ‘x’ and ‘y’.

## Dataset
This dataset contains house sale prices for King County, which includes Seattle. It includes homes sold between May 2014 and May 2015. 

1. id : A notation for a house
2. date: Date house was sold
3. price: Price is prediction target
4. bedrooms: Number of bedrooms
5. bathrooms: Number of bathrooms
6. sqft_living: Square footage of the home
7. sqft_lot: Square footage of the lot
8. floors :Total floors (levels) in house
9. waterfront :House which has a view to a waterfront
10. view: Has been viewed
11. condition :How good the condition is overall
12. grade: overall grade given to the housing unit, based on King County grading system
13. sqft_above : Square footage of house apart from basement
14. sqft_basement: Square footage of the basement
15. yr_built : Built Year
16. yr_renovated : Year when house was renovated
17. zipcode: Zip code
18. lat: Latitude coordinate
19. long: Longitude coordinate
20. sqft_living15: Living room area in 2015(implies-- some renovations) This might or might not have affected the lotsize area
21. sqft_lot15 : LotSize area in 2015(implies-- some renovations)

## Code Explaination
1. Install the dependency packages.

2. Import the dependency packages

3. Read the data

4. We dropped the `id` column as it is not useful for association rule mining.

5. We transformed the date of house sold into `%Y%m%d` format. Further we decided to calculate the age of the house using house sold year and house built year. And then we dropped the `year built` column and `house sold date` column.

6. We transformed the `price` column and segregated houses into bins (categorical column). 

    Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    min(data$price)| quantile(data$price, prob = .2) |Cheap
    quantile(data$price, prob = .2)|quantile(data$price, prob = .2)|Affordable
    quantile(data$price, prob = .4)|quantile(data$price, prob = .6)|Expensive
    quantile(data$price, prob = .6)|quantile(data$price, prob = .8)|Premium
    quantile(data$price, prob = .8)|max(data$price)|Ultra premium

7. We transformed the `bedrooms` column and segregated houses into bins (categorical column). 

    Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    -Inf|0|No bedroom
    0|3|Equal to or less than 3
    3|6|Equal to or less than 6 but greater than 3
    6|9|Equal to or less than 9 but greater than 6
    9|max(data$bedrooms)|Greater than 9

8. We transformed the `bathrooms` column and segregated houses into bins (categorical column). 

   Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    -Inf|0|No bathroom
    0|3|Equal to or less than 3
    3|6|Equal to or less than 6 but greater than 3
    6|max(data$bathrooms)|Greater than 6

9. We calculated a new column bathroom per bedroom ratio and segregated houses into bins (categorical column). 

    Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    -Inf|min(data$bathroom_to_bedroom_ratio)|No bathroom
    min(data$bathroom_to_bedroom_ratio)|0.5|Less than adequate
    0.5|1|Adequate
    1|max(data$bathroom_to_bedroom_ratio)|More than adequate

10. We dropped the `sqft_living` and `sqft_lot` columns as we decided to consider columns `sqft_living15` and `sqft_lot15`.

11. We transformed the `floors` column and segregated houses into bins (categorical column). 

    Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    0.9|1.9|1
    1.9|2.9|2
    2.9|max(data$floors)|3

12. We transformed the `waterfront` column and segregated houses into bins (categorical column). 

    Bins intervals

    Value|Category|
    |--------|-------|
    0|No
    1|Yes

13. We transformed the `view` column and segregated houses into bins (categorical column). 

    Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    -Inf|min(data$view)|No view
    min(data$view)|1|Single View
    1|max(data$view)|Multiple views

14. We transformed the `condition` column and segregated houses into bins (categorical column). 

    Bins intervals

    Value|Category|
    |--------|-------|
    1|Very Poor
    2|Poor
    3|Decent
    4|Good
    5|Excellent

15. We transformed the `grade` column and segregated houses into bins (categorical column). 

    Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    0|3|Very Poor
    3|6|Poor
    6|9|Decent
    9|12|Good
    12|15|Excellent

16. We transformed the `yr_renovated` column and segregated houses into bins (categorical column). 

    Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    -Inf|min(data$yr_renovated)|Not renovated
    min(data$yr_renovated)|2010|Renovated
    2010|max(data$yr_renovated)|Recently renovated

17. We dropped `zipcode`, `lat` and `long` columns it is not useful for kc house assignment association rule mining.

18. We transformed the `sqft_living15` column and segregated houses into bins (categorical column). 

    Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    min(data$sqft_living15)|quantile(data$sqft_living15, prob = .2)|Very small
    quantile(data$sqft_living15, prob = .2)|quantile(data$sqft_living15, prob = .4)|Small
    quantile(data$sqft_living15, prob = .4)|quantile(data$sqft_living15, prob = .6)|Average
    quantile(data$sqft_living15, prob = .6)|quantile(data$sqft_living15, prob = .8)|Large
    quantile(data$sqft_living15, prob = .8)|max(data$sqft_living15)|Very large

19. We transformed the `sqft_lot15` column and segregated houses into bins (categorical column). 

    Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    min(data$sqft_lot15)|quantile(data$sqft_lot15, prob = .2)|Very small
    quantile(data$sqft_lot15, prob = .2)|quantile(data$sqft_lot15, prob = .4)|Small
    quantile(data$sqft_lot15, prob = .4)|quantile(data$sqft_lot15, prob = .6)|Average
    quantile(data$sqft_lot15, prob = .6)|quantile(data$sqft_lot15, prob = .8)|Large
    quantile(data$sqft_lot15, prob = .8)|max(data$sqft_lot15)|Very large

20. In `sqft_above` column there were 2 missing rows. We imputed the column and later transformed the `sqft_above` column, segregated houses into bins (categorical column). 

    Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    min(data$sqft_above)|quantile(data$sqft_above, prob = .2)|Very small
    quantile(data$sqft_above, prob = .2)|quantile(data$sqft_above, prob = .4)|Small
    quantile(data$sqft_above, prob = .4)|quantile(data$sqft_above, prob = .6)|Average
    quantile(data$sqft_above, prob = .6)|quantile(data$sqft_above, prob = .8)|Large
    quantile(data$sqft_above, prob = .8)|max(data$sqft_above)|Very large

21. We calculated `basement_to_ground_floor_sqft_ratio` and based on that transformed the `sqft_basement` column, segregated houses into bins (categorical column). 

    Bins intervals

    Min|Max|Category|
    |--------|-------|-------|
    0.00|0.25|Very small
    0.25|0.50|Small
    0.50|0.75|Average
    0.75|1|Large
    1|max(data$basement_to_ground_floor_sqft_ratio)|Very large

22. We saved the imputed data for apriori algorithm's input data at [data location](outputs/apriori_data.csv)

23. We calculated rules for various price category houses.

## Assignement Result
[Association Rules for ultr premium houses](outputs/rules_for_ultra_premium_house.csv)
|LHS|RHS|support|confidence|coverage|lift|count|
|--------|-------|-------|-------|-------|-------|-------|
sqft_living15=Very large|price=Ultra premium|0.115457618|0.581351981|0.198601917|2.908240887|2494|
sqft_above=Very large|price=Ultra premium|0.109763437|0.550371402|0.199435211|2.753259068|2371
bedrooms=Equal to or less than 6 but greater than 3,bathroom_to_bedroom_ratio=Adequate|price=Ultra premium|0.106985788|0.419723938|0.254895607|2.099688924|2311
bedrooms=Equal to or less than 6 but greater than 3|price=Ultra premium|0.135734457|0.335085714|0.405073839|1.676282194|2932
floors=2|price=Ultra premium|0.124114624|0.31935676|0.388639415|1.597597353|2681


[Association Rules for premium houses](outputs/rules_for_premium_house.csv)
|LHS|RHS|support|confidence|coverage|lift|count|
|--------|-------|-------|-------|-------|-------|-------|
bathroom_to_bedroom_ratio=Adequate,waterfront=No,grade=Decent,yr_renovated=Not renovated|price=Premium|0.131938336|0.240080869|0.549557891|1.202129545|2850
bathroom_to_bedroom_ratio=Adequate,grade=Decent,yr_renovated=Not renovated|price=Premium|0.132308689|0.239926125|0.551455951|1.201354711|2858
bathrooms=Equal to or less than 3,bathroom_to_bedroom_ratio=Adequate,waterfront=No,grade=Decent|price=Premium|0.131660571|0.239192599|0.55043748|1.19768181|2844
bathroom_to_bedroom_ratio=Adequate,waterfront=No,grade=Decent|price=Premium|0.137123281|0.239083058|0.573538262|1.197133316|2962
bathrooms=Equal to or less than 3,bathroom_to_bedroom_ratio=Adequate,grade=Decent|price=Premium|0.132216101|0.238955823|0.553307717|1.196496231|2856
bathroom_to_bedroom_ratio=Adequate,grade=Decent|price=Premium|0.137678811|0.23874127|0.576686265|1.195421922|2974
waterfront=No,grade=Decent,yr_renovated=Not renovated|price=Premium|0.181102727|0.23202847|0.78051942|1.161809684|3912
grade=Decent,yr_renovated=Not renovated|price=Premium|0.181565668|0.231851502|0.783111893|1.160923571|3922
waterfront=No,grade=Decent|price=Premium|0.188232026|0.231456709|0.813249387|1.158946769|4066
grade=Decent|price=Premium|0.188926439|0.231152648|0.817323272|1.157424281|4081

