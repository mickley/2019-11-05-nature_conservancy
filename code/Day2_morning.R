# Script file for TNC Software Carpentry Day 2 - Morning
# James's Code
# Data Wrangling in R with dplyr and tidyr

### dplyr to subset and manipulate data

# Load the dplyr and gapminder packages
library(dplyr)
library(gapminder)

# Get our data
gap <- gapminder

# Check the first few rows of our dataset
head(gap)

# Subset columns with select(), keeping only 3 columns
yr_country_gdp <- select(.data = gap, year, country, gdpPercap)

# Look at the new dataset
head(yr_country_gdp)
yr_country_gdp

# Subset rows with filter, keeping only Europe data
str(gap)
gap_eu <- filter(.data = gap, continent == "Europe")
head(gap_eu)
str(gap_eu)

# stack subsetting rows and columns
# This code is harder to read, especially with more stacking
gap_eu_subset <- filter(.data = select(.data = gap, continent, year, country, gdpPercap), 
     continent == "Europe")
head(gap_eu_subset)

# Use pipes %>% to make it easier to read
# Pipes take the output of the left side and send it to the right side as
# the first argument
yr_country_gdp <- gap %>% select(year, country, gdpPercap)
head(yr_country_gdp)

# Stack pipes, doing the two things we did previously
# Note that we always filter first, then select
# If we did the reverse, we might try to filter on a column that's gone
gap_eu_subset <- gap %>%
     
     # filter the rows to only be Europe
     filter(continent == "Europe") %>%
     
     # Subset the columns to keep the data columns
     select(year, country, gdpPercap)

head(gap_eu_subset)

# dplyr challenge
# Pull out the data from 2007 in Africa and select three columns

# One way to do it
africa_07_lifeExp <- gap %>%
     filter(continent == "Africa") %>%
     filter(year == 2007) %>%
     select(country, year, lifeExp)

nrow(africa_07_lifeExp)

# Or, we can combine filters into one line
africa_07_lifeExp <- gap %>%
     filter(continent == "Africa", year == 2007) %>%
     select(country, year, lifeExp)

# The summarize function lets us create data summaries
mean_gdp <- gap %>% summarize(meanGDP = mean(gdpPercap))

head(mean_gdp)
mean(gap$gdpPercap)

# Usually, we combine summarize() with group_by() to get summaries by group
# Get the mean GDP, standard deviation of GDP and mean lifeexp
gdp_by_cont <- gap %>%
     group_by(continent, country) %>%
     summarize(meanGDP = mean(gdpPercap), 
          sdGDP = sd(gdpPercap), 
          meanLifeExp = mean(lifeExp))

head(gdp_by_cont)

# Average life expectancy across all african countries by year
gap %>%
     filter(continent == "Africa") %>%
     
     # Good way to check the intermediate data, just put in head()
     #head()
     
     group_by(year) %>%
     summarize(avg_life = mean(lifeExp), 
          sample_size = n()) %>%
     data.frame()

# Use mutate to make new columns based in some way on existing columns
bill_gdp_country <- gap %>%
     mutate(billion_gdp = gdpPercap * pop / 10^9, 
          pop_billion = pop / 10^9)
head(bill_gdp_country)



# combine dplyr and ggplot to make plots
# Note that dplyr uses pipe "%>%" and ggplot uses "+"
library(ggplot2)
gap %>% filter(continent == "Americas") %>%
     ggplot(aes(x = year, y = lifeExp, color = country)) +
          geom_line() + 
          geom_point()
          

### tidyr to transition between wide and long format
# NOTE: tidyr is still being improved
# Recently, they've created pivot functions to replace what we teach below
# See: https://cran.r-project.org/web/packages/tidyr/vignettes/pivot.html


# Wide vs Long format data & tidyr
# Load tidyr package
library(tidyr)

# Read in the gapminder data from csv
gap <- read.csv(file = "data/gapminder_data.csv", 
     stringsAsFactors = FALSE)

# Look at the structure
str(gap)
head(gap)

# Read in the same data in wide format
gap_wide <- read.csv(file = "data/gapminder_wide.csv", 
     stringsAsFactors = FALSE)

# Compare the structure
head(gap_wide) 
str(gap_wide)

# Going from wide to long using gather()
gap_long <- gap_wide %>% 
     gather(key = obstype_year, 
            value = obs_values, 
            starts_with("pop"),
            starts_with("lifeExp"), 
            starts_with("gdpPercap"))

str(gap_long)
head(gap_long)
tail(gap_long)


# Another way to write the same thing
gap_long <- gap_wide %>%
     gather(obstype_year, obs_values, 
          -continent, -country)

# We've made the wide dataset long, but we have two types of data
# in the same column: observation type and year
# Use separate to split
# Note: we're re-saving into gap_long here.
# Once we do that, we can't run this bit of code again, the input has changed
gap_long <- gap_long %>%
     separate(col = obstype_year, 
          into = c("obstype", "year"), 
          sep = "_") %>%
     mutate(year = as.integer(year))

head(gap_long)

# Summarize mean life expectancy by continent using the long dataset
gap_long %>%
     filter(obstype == "lifeExp") %>%
     group_by(continent) %>%
     summarize(meanLifeExp = mean(obs_values)) %>%
     data.frame()

# Reverse gather with spread
gap_normal <- gap_long %>%
     spread(key = obstype, value = obs_values)

head(gap_normal)
head(gap)

# We can go from long to wide by reversing the gather/separate process
# unite as the opposite of separate, spread as the opposite of gather
gap_wide_new <- gap_long %>%
     unite(obstype_year, obstype, year, 
          sep = "_") %>%
     spread(obstype_year, obs_values)

str(gap_wide_new)
