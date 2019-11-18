# Script file for TNC Software Carpentry Day 1 - Afternoon
# James's Code
# Covers programming: conditional statements, loops, 
# and making functions, 
# Also covers making graphs with ggplot2



### Comments

# Anything that starts with a "#" doesn't get processed
# This includes the end of a line (see the line below this)
str(cats) # show what is inside cats



### Conditional Statements (If... else)
# Have the computer make decisions

# If Else statements
# Make a choice: Only one of the print() statements runs, never both
# The first line is the test.  
# The else part is optional, but runs if the first test doesn't pass
number <- 37
if (number <= 100) {
  print("greater than 100")   
} else {
  print("less than 100")
}
print("finished checking")


### Comparison operators in R
# Less than <
# Greater than >
# Equal to ==
# Not equal to !=
# Less than or equal to <=
# Greater than or equal to >=


# In addition to an else statement, we can also have any number of 
# additional tests in the form of else if
# This code tests the sign of a number
number <- -3
if (number > 0) {
     print(1)
} else if (number < 0) {
     print(-1)
} else {
     print(0)
}

# Combining tests
number1 <- 15
number2 <- 40


# We can do two (or more) tests at once using the logical operator & (and)
# Here, the second test is only evaluated if the first test passes
# Both tests need to pass to print "both numbers are positive"
if (number1 >= 0 & number2 >= 0) {
     print("Both numbers are positive")
} else {
     print("at least one number is negative")
}


### Logical operators in R
# AND (both tests need to be true): &
# OR (only one test needs to be true): | 
     # Example: number1 >= 0 | number2 >= 0
# Not (true if this one statement is not true): !
     # Example: !(number1 >= 0)
# These can be combined in complex ways
     # Example: (number1 < 0 | number2 < 0) & number2 < 50 & !(number1 > 50)


### Loops: for loops
# Automate repetitive tasks


numbers <- 1:10
numbers

# This runs the contents inside the loop for each number in the numbers vector
# we made above
# Each time, it saves the next number to the number variable, and prints it
for (number in numbers) {
     print(number)
}
print(number)


# Often, for loops use an increment variable (usually i or j)
# This lets us keep track of which iteration of the loop we are in
# Often, the increment variable can be used to refer to the row of a dataframe
# if you are trying to do something to each row.
for (i in 1:5) {
     print(i)
}

# After the loop is finished running, the increment variable is still set
# It contains the value of the last number given to it (5 in this case)
print(i)

# For loops can operate on vectors of letters, or anything, not just numbers
letter <- "z"
print(letter)
for (letter in c("a", "b", "c")) {
     print(letter)
}
print(letter)


# Challenge to sum up a vector of numbers using a for loop
numbers <- c(4, 8, 15, 16, 23, 42)
running_sum <- 0

for (number in numbers) {
     running_sum <- running_sum + number
}
print(running_sum)
print(number)


# Using the increment variable to work with a dataset

# Load the gapminder package, which has a dataset named gapminder
library(gapminder)
gapminder

# Save the dataset to gap
gap <- gapminder

# Show the first ten years in the gap dataset
for (i in 1:10) {
     print(gap$year[i])
}


# nested for loops

# First for loop
for (i in 1:3) {
     
     # Second for loop
     for (j in c("a", "b", "c")) {
          print(paste(i, j))
     } # End of the second for loop
     
} # End of the first for loop

# Find years with life expectancy < 35 in the first 10 rows
for (i in 1:10) {
     if (gap$lifeExp[i] < 35) {
          print(gap$year[i])
     }
}

# Compare
head(gap, 10)

# Do this for the whole dataset, and print out the countries as well
for (i in 1:nrow(gap)) {
     if (gap$lifeExp[i] < 35) {
          print(paste(gap$country[i], gap$year[i]))
     }
}


### Functions
# Save bits of code you use frequently for later

# Try running a function without ().  In R, you'll see the underlying code
read.table


# Let's make a function to convert fahrenheit to kelvin
# A function is a variable too, so we store it to a name
# Everything inside the curly braces {} is part of the function
# This fuction has an argument, temp.  
# When we run the function, we have to give it this argument to convert
fahr_to_kelvin <- function(temp) {
     kelvin <- ((temp - 32) * (5 / 9)) + 273.15
     return(kelvin)
}

# It's a good idea to test your functions with some known cases
# Make sure you run the function code first before testing so that the function
# exists

# Freezing point
fahr_to_kelvin(32)

# Boiling poin
new_temp <- fahr_to_kelvin(212)
new_temp



# Make another function to convert kelvin to celsius
kelvin_to_celsius <- function(temp) {
     celsius <- temp - 273.15
     return(celsius)
}

# Test with absolute zero
kelvin_to_celsius(0)

# Variable Scope: variables inside functions only exist inside functions
# So, this won't work, celsius only existed inside the function
print(celsius)

# Store the current temperature in F into a variable that's the same as the one
# inside fahr_to_kelvin()
temp <- 73

# Get the temperature in kelvin
kelvin_temp <- fahr_to_kelvin(temp)

# Print the temperature.  It's still 73. fahr_to_kelvin() left it alone
print(temp)


# Combining functions
fahr_to_celsius <- function(temp) {
     temp_k <- fahr_to_kelvin(temp)
     temp_c <- kelvin_to_celsius(temp_k)
     return(temp_c)
}

# Test function
fahr_to_celsius(32)

# Or we could nest functions
kelvin_to_celsius(fahr_to_kelvin(32))


# Make a function to convert celsius to fahrenheit
celsius_to_fahr <- function(temp) {
     fahr <- temp * 9 / 5 + 32
     return(fahr)
}

# Test with the freezing point
celsius_to_fahr(0)


### Graphs in R
# learning how to use the ggplot package

# The plot function is NOT from ggplot. Sometimes you will see this
# These "base R" graphs are not as easily customized, however
# ggplot is preferred by most
plot(x = gap$gdpPercap, y = gap$lifeExp)

# Load the ggplot library
library(ggplot2)

# Ggplot with year vs life expectancy
# Not the most informative graph
# The aes() function lets us set an x and y variable
# The geom_point() function tells the graph to add a scatterplot
ggplot(data = gap, aes(x = year, y = lifeExp)) + 
     geom_point()

# This graph might be better with changes over time
# So we use geom_line() to make a line graph instead
# Adding a by argument to aes() lets us have a line for each country
# Adding a color argument lets us color by group (continent)
ggplot(data = gap, aes(x = year, y = lifeExp, by = country,
     color = continent)) + 
     geom_line()

# We could color the points and lines differently by adding 
# aes() to just the geom_line() layer
ggplot(data = gap, aes(x = year, y = lifeExp, by = country)) + 
     geom_line(aes(color = continent)) + 
     geom_point()

# Color by group for lines, specific color for points (outside aes())
ggplot(data = gap, aes(x = year, y = lifeExp, by = country)) + 
     geom_line(aes(color = continent)) + 
     geom_point(color = "blue")

# Make the points semi-transparent to see density
# Log-transform the x-axis
ggplot(data = gap, aes(x = gdpPercap, y = lifeExp, 
     color = continent)) + 
     geom_point(alpha = 0.5) + 
     scale_x_log10()

# Add a trendline (linear regression/model) using geom_smooth()
ggplot(data = gap, aes(x = gdpPercap, y = lifeExp)) + 
     geom_point(alpha = 0.5) + 
     scale_x_log10() + 
     geom_smooth(method = "lm", size = 2)

# Make the points bigger, and give them a different shape for each continent
# Good for colorblind accessibility
ggplot(data = gap, aes(x = gdpPercap, y = lifeExp, 
     color = continent)) +
     geom_point(size = 2.5, aes(shape = continent)) + 
     scale_x_log10() + 
     geom_smooth(method = "lm")


# Modify the graph to make it look good
# Also, save it to a variable
lifeExp_plot <-  ggplot(data = gap, aes(x = gdpPercap, y = lifeExp, 
     color = continent)) +
     geom_point(size = 2.5, aes(shape = continent)) + 
     scale_x_log10() + 
     geom_smooth(method = "lm") + 
     
     # change the theme to black and white
     theme_bw() +
     
     # Add axis and legend labels
     labs(title = "Effects of per-capita GDP", 
          x = "GDP per Capita ($)", 
          y = "Life Expectancy (yrs)", 
          color = "Continent", 
          shape = "Continent")

# Show the plot by calling the variable
lifeExp_plot

# Save as png
ggsave(file = "results/life_expectancy.png", plot = lifeExp_plot)

# Save as pdf
ggsave(file = "results/life_expectancy.pdf", plot = lifeExp_plot)

# Save as png high resolution
ggsave(file = "results/life_expectancy.png", plot = lifeExp_plot, 
     width = 8, height = 6, units = "in", dpi = 300)


# Facets for 3-dimensional data
# This splits the graph into multiple graphs in a panel
ggplot(data = gap, aes(x = gdpPercap, y = lifeExp, 
     color = continent)) + 
     facet_wrap(~ year) + # Makes a different graph for each year
     geom_point(size = 2.5, aes(shape = continent)) + 
     scale_x_log10() + 
     geom_smooth(method = "lm")




