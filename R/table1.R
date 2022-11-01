library(tidyverse)
library(readxl)
library(here)

df <- read_excel(here::here("Data", "Data 2020-21", "TS2.xlsx"))

head(df)