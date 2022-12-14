library(tidyverse)
library(dplyr)
library(ggplot2)

alcohol_consumption_by_country <- read.csv("https://raw.githubusercontent.com/info201b-au2022/project-vtrisha/main/data/drinks.csv")

country_life_expectancy <- read.csv("https://raw.githubusercontent.com/info201b-au2022/project-vtrisha/main/data/lifeexpectancy.csv")


life_expectancy_with_alcohol_use <- country_life_expectancy %>%
  select(CountryDisplay, Numeric, YearCode) %>%
  group_by(CountryDisplay, YearCode) %>%
  summarize("life_expectancy_mean" = mean(Numeric)) %>%
  drop_na() %>%
  rename_at('CountryDisplay', ~'country') %>%
  left_join(alcohol_consumption_by_country, by = "country") %>%
  drop_na() %>%
  group_by(country) %>%
  select(country, life_expectancy_mean, total_litres_of_pure_alcohol, YearCode)
life_expectancy_with_alcohol_use
life_expectancy_vs_alcohol_consumption <- ggplot(life_expectancy_with_alcohol_use, aes(y = total_litres_of_pure_alcohol, x = life_expectancy_mean, color = YearCode)) + 
  stat_smooth(method = 'loess', formula = 'y ~ x') + 
  geom_point() + 
  coord_cartesian() +
  labs(x = 'Life Expectancy by Country', y = 'Total Pure Alcohol Consumption (in Liters)', title = 'Mapping Life Expectancy vs Total Alcohol Consumption in Liters by Country')  
life_expectancy_vs_alcohol_consumption

#This chart once again shows, albeit inadvertently, a trend that we will come to hate. The fact that there are more factors than we can actually definitively study nd draw a conclusion from that are affecting our perception of this chart. There are a variety of reasons why a country like Spain would have such high alcohol use while still having a high life expectancy, from cultural reasons as well as population statistics and even the quality of their healthcare. However, there is something important to note here: countries with incredibly high level of alcohol consumption, in excess of 11 liters, are not those with the highest life expectancy. Countries like Lithuania, Belarus, Grenada, these countries can have the best healthcare in the world and that still cannot fight the effects of alcoholism. 



