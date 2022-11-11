library(tidyverse)
library(readxl)
library(here)
library(writexl)

ts_target <- read_excel(
    here::here("Data", "Data 2020-21", "TSTargetSchool.xlsx")
)

ts_target <- ts_target %>%
    select(PRNo, NCESID, SchoolNM, NumServed)

ccd_dir <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD School Directory 2020-21",
        "CCD School Directory 2020-21.csv"
    ),
    col_types = cols_only(
        SCH_NAME = "c",
        NCESSCH = "d",
        SCHID = "d",
        CHARTER_TEXT = "c",
        LEVEL = "c"
    )
)

ccd_dir <- ccd_dir %>%
    mutate(NCESSCH = sprintf("%012.0f", NCESSCH))

