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

memb <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD Membership 2020-21",
        "ccd_SCH_052_2021_l_1a_080621.csv"
    ),
    # col_types = cols_only(
    #     NCESSCH = "d",
    #     STUDENT_COUNT = "d"
    # )
)

memb$SCHID |> unique() |> length()


ccd_sch <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD School level 2020-21",
        "ccd_sch_129_2021_w_1a.csv"
    ),
    col_types = cols_only(
        NCESSCH = "d",
        SCHID = "d",
        TITLEI_STATUS = "c",
        TITLEI_STATUS_TEXT = "c",
        MAGNET_TEXT = "c",
        VIRTUAL = "c"
    )
)

ccd_sch <- ccd_sch %>%
    mutate(NCESSCH = sprintf("%012.0f", NCESSCH))

left_join(ccd_dir, ccd_sch, by = c("SCHID" = "SCHID"))

lunch <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD Lunch Program Eligibility (School level) 2020-21",
        "CCD Lunch Eligibility 20-21.csv"
    ),
    # col_types = cols_only(
    #     SCHID = "d",
    #     NCESSCH = "d",
    #     SCH_NAME = "c",
    #     LUNCH_PROGRAM = "c",
    #     STUDENT_COUNT = "d"
    # )
)


ts_target
ccd_dir

nrow(ccd_sch)
unique(ccd_sch$SCHID) |> length()


nrow(lunch)
unique(lunch$SCHID) |> length()
