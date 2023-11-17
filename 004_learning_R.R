# Libraries
## install.packages('tidyverse') if necessary
library(tidyverse)
library(scales)

# Importing the data ----
## url where the data is stored
url <- "https://raw.githubusercontent.com/luifrancgom/learning_R_ifpe/main/pernambuco_good_exports_2022.csv"
## Use read_csv because is a comma separated value (csv) file
pernambuco_exports_2022 <- read_csv(file = url)

# Inspect your data ----
pernambuco_exports_2022 |> 
  glimpse()
pernambuco_exports_2022 |> 
  View()

# DATA: date
# SG_UF_MUN: Federative Unit Code
## PE: Pernambuco
# CO_MUN: Code municipality
# NO_MUN_MIN: Name municipality
# CO_PAIS: Code country of destination
# NO_PAIS_ING: Name country of destination
# SH4: Harmonized system 4 digits of the product exported
# SH4_DESC: description of the product according to SH4
# KG_LIQUIDO: net weight of the product in kilograms
# VL_FOB: value of the product is US dollars (Free on board)

# Pernambuco is divided into 184 municipalities
# but not all the municipalities export goods on
# the year 2022
pernambuco_exports_2022 |> 
  distinct(NO_MUN_MIN)

# Aggregate data ----
pernambuco_exports_2022_by_municipality <- pernambuco_exports_2022 |> 
  group_by(NO_MUN_MIN) |> 
  summarise(VL_FOB = sum(VL_FOB))
pernambuco_exports_2022_by_municipality

# Select top 15 exporting municipalities
pernambuco_top_15 <- pernambuco_exports_2022_by_municipality |> 
  slice_max(order_by = VL_FOB, n = 15)
pernambuco_top_15

# Visualize the data ----
## The plot is difficult to understand
pernambuco_top_15 |> 
  ggplot(aes(x = NO_MUN_MIN, y = VL_FOB)) + 
  geom_col()

## Lets change axis
pernambuco_top_15 |> 
  ggplot(aes(x = VL_FOB, y = NO_MUN_MIN)) + 
  geom_col()

## Reorder the data
pernambuco_top_15 |> 
  ggplot(aes(x = VL_FOB, y = fct_reorder(NO_MUN_MIN, VL_FOB))) + 
  geom_col()

## Rename labels
pernambuco_top_15 |> 
  ggplot(aes(x = VL_FOB, y = fct_reorder(NO_MUN_MIN, VL_FOB))) + 
  geom_col() + 
  labs(x = 'Exports in USD (FOB)',
       y = NULL,
       title = 'Top 15 exporting municipalities in Pernambuco',
       subtitle = 'Year: 2022')

## Improve the labels of the x-axis
pernambuco_top_15 |> 
  ggplot(aes(x = VL_FOB, y = fct_reorder(NO_MUN_MIN, VL_FOB))) + 
  geom_col() + 
  scale_x_continuous(labels = label_dollar()) +
  labs(x = 'Exports in USD (FOB)',
       y = NULL,
       title = 'Top 15 exporting municipalities in Pernambuco',
       subtitle = 'Year: 2022')

## Reduce the number of zero's
pernambuco_top_15 |> 
  ggplot(aes(x = VL_FOB, y = fct_reorder(NO_MUN_MIN, VL_FOB))) + 
  geom_col() + 
  scale_x_continuous(labels = label_dollar(scale = 1e-6, suffix = 'M')) +
  labs(x = 'Exports in USD (FOB)',
       y = NULL,
       title = 'Top 15 exporting municipalities in Pernambuco',
       subtitle = 'Year: 2022')
