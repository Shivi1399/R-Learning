install.packages("dplyr")
library("dplyr")

storms <- read.csv("storms/dataset/storms.csv")

# storms of 1980's
storm_of_1980s <- storms %>%
                  filter(year >= 1980 & year <= 1989) %>%
                  select(name, year)

# number of storms per year
number_of_storms_per_year <- storms %>%
                              group_by(year) %>%
                              summarize(number_of_storms = n())

# storms record per year
storm_record_per_year <- storms %>%
                          group_by(year, name) %>%
                          summarize(number_of_storms = n())

# Unquie types of storms status
storm_statuses <- storms %>%
                  distinct(status)

# Different types of storm categories
storm_categories <- storms %>%
                    distinct(category)

# Storms of category 5
storm_of_category_5 <- storms %>%
                        filter(category == 5) %>%
                        select(name, year)

# Storm summery for each type of storm category
storm_summery <- storms %>%
                  group_by(category, status) %>%
                  summarize(
                    avg_pressure = mean(pressure, na.rm = TRUE),
                    avg_wind = mean(wind, na.rm = TRUE)
                  )

# Max wind per storm per year
max_wind_per_storm_per_year <- storms %>%
                                group_by(year, name) %>%
                                summarize(
                                  max_wind = max(wind, na.rm = TRUE)
                                )

# Max wind per year
max_wind_storm_per_year <- storms %>%
                            group_by(year) %>%
                            summarize(
                              name = name[which.max(wind)],
                              max_wind = max(wind, na.rm = TRUE)
                            ) %>%
                            arrange(desc(max_wind))

# Top 5 storm ategories with the highest avg wind speeds
top_5_highest_avg_wind_speeds <- storms %>%
                                  group_by(category) %>%
                                  summarize(avg_wind = mean(wind, na.rm = TRUE)) %>%
                                  arrange((desc(avg_wind))) %>%
                                  head(5)

# Number of storms recoreded in each category for each year
storms_per_year_per_category <- storms %>%
                                group_by(year, category) %>%
                                summarize(number_of_storms = n())

# Each storm category summary
storm_category_summary <- storms %>%
                          group_by(category) %>%
                          summarize(
                            avg_pressure = mean(pressure, na.rm = TRUE),
                            avg_wind = mean(wind, na.rm = TRUE)
                          )

# Storm Category that had the highest number of records in each year
storm_category_with_max_freq_each_year <- storms %>%
                                          group_by(year, category) %>%
                                          summarize(number_of_storms = n ()) %>%
                                          slice(which.max(number_of_storms))
