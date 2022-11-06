library(tidyverse)
library(readxl)
library(here)

df_edu <- read_excel(here::here(
    "Data",
    "Data 2020-21",
    "TS3.xlsx"
))

df_edu <- df_edu %>%
  select(
    MidSchNo,
    HighSchFshNo,
    HighSchSophNo,
    HighSchJrNo,
    HighSchSNo,
    PartAltProgNo,
    HighSch4yrDE,
    HighSch5yrDE,
    SecSchDropNo,
    Part3AOtherNo,
    Part3AUnknownNo)

