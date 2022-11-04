library(tidyverse)
library(readxl)
library(here)

df <- read_excel(here::here("Data", "Data 2020-21", "TS2.xlsx"))

head(df)

df %>%
    summarise(PartFundNO = sum(PartFundNO))

status <- df %>%
    summarise(
        NewPNO = sum(NewPNO),
        ConPNO = sum(ConPNO),
    )

status <- df %>%
    summarise(across(NewPNO:ConPNO, sum))
status

gender <- df %>%
    summarise(across(MalePNO:FemalePNO, sum))
gender

raceth <- df %>%
    summarise(across(AmIndPNO:UnknownPNO, sum))
raceth

eligib <- df %>%
    summarise(across(LowFirstPNO:OtherPNO, sum))
eligib