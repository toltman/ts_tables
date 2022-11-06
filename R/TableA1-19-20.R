library(tidyverse)
library(readxl)
library(here)

# Sector data
df_1920 <- read_excel(here::here(
    "Data",
    "Data 2019-20",
    "FY2019TSFundedDetails-MinSecReg.xlsx"
))

df2_1920 <- read_excel(here::here(
    "Data",
    "Data 2019-20",
    "TS2 2019-20.xlsx"
))
