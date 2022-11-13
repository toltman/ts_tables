library(tidyverse)
library(readxl)
library(here)
library(writexl)


# TS Target Schools
ts_target <- read_excel(
    here::here(
        "Data",
        "Data 2020-21",
        "TSTargetSchool.xlsx"
    )
)

# see dups.xlsx and prno_join.xlsx for details
ncesid_filter <- c(
    "NA",
    "99999999",
    "400552000209",
    "120060000849"
)

ts_target <- ts_target %>%
    select(PRNo, NCESID, NumServed) %>%
    filter(
        !(NCESID %in% ncesid_filter)
    ) %>%
    group_by(NCESID) %>%
    summarise(
        PRNo = first(PRNo),
        NumServed = sum(NumServed)
    )


# CCD Directory of Schools
ccd_dir <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD School Directory 2020-21",
        "ccd_sch_029_1920_w_1a_082120.csv"
    ),
    col_types = cols_only(
        NCESSCH = "c",
        CHARTER_TEXT = "c",
        LEVEL = "c"
    )
)

# CCD Membership
members <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD Membership 2020-21",
        "ccd_SCH_052_2021_l_1a_080621.csv"
    ),
    col_types = cols_only(
        NCESSCH = "c",
        TOTAL_INDICATOR = "c",
        STUDENT_COUNT = "d"
    )
)

ccd_mem <- members %>%
    filter(TOTAL_INDICATOR == "Education Unit Total") %>%
    mutate(enrll_cat = cut(
        STUDENT_COUNT,
        breaks = c(-1, 199, 499, 749, 999, Inf),
        labels = c("Less than 200", "200-499", "500-749", "750-999", "1000 or more")
    ))


# School level
ccd_sch <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD School level 2020-21",
        "ccd_sch_129_2021_w_1a_080621.csv"
    ),
    col_types = cols_only(
        NCESSCH = "c",
        TITLEI_STATUS = "c",
        TITLEI_STATUS_TEXT = "c",
        MAGNET_TEXT = "c",
        VIRTUAL = "c"
    )
)

# Lunch programs
ccd_lun <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD Lunch Program Eligibility (School level) 2020-21",
        "ccd_sch_033_2021_l_1a_080621.csv"
    ),
    col_types = cols_only(
        NCESSCH = "c",
        DATA_GROUP = "c",
        LUNCH_PROGRAM = "c",
        TOTAL_INDICATOR = "c",
        STUDENT_COUNT = "d"
    )
)


# Funding data for Sector
fun <- read_excel(
    here::here("Data", "Data 2020-21", "FY2020TSFundedDetails-MinSecReg.xlsx")
)

fun <- fun %>% select(PRNo, Sector)

fun <- fun %>%
    mutate(
        Sector = factor(
            Sector,
            levels = c("A", "B", "C", "D", "E", "F", "G", "H", "I")
        ),
        Sector = fct_collapse(
            Sector,
            four_year = c("A", "B", "H"),
            two_year = c("C", "D", "I"),
            other = c("E", "F", "G")
        )
    )

# EDGE urban
edge <- read_excel(here::here(
    "Data",
    "Other Data (non-APR)",
    "EDGE_GEOCODE_PUBLICSCH_1920.xlsx"
))



