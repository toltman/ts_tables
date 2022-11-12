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

ts_target <- ts_target %>%
    select(PRNo, NCESID, SchoolNM, NumServed)


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
ccd_mem <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD Membership 2020-21",
        "ccd_SCH_052_2021_l_1a_080621.csv"
    ),
    col_types = cols_only(
        NCESSCH = "c",
        STUDENT_COUNT = "d"
    )
)

ccd_mem <- ccd_mem %>%
    group_by(NCESSCH) %>%
    summarise(STUDENT_COUNT = sum(STUDENT_COUNT, na.rm = TRUE))

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
        LUNCH_PROGRAM = "c",
        STUDENT_COUNT = "d"
    )
)

frpl <- c("Reduced-price lunch qualified", "Free lunch qualified")
ccd_lun <- ccd_lun %>%
    filter(LUNCH_PROGRAM %in% frpl) %>%
    group_by(NCESSCH) %>%
    summarise(FRPL_COUNT = sum(STUDENT_COUNT, na.rm = TRUE))


# Funding data for Sector
fun <- read_excel(here::here("Data", "Data 2020-21", "FY2020TSFundedDetails-MinSecReg.xlsx"))

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

df <- ts_target %>%
    left_join(ccd_dir, by = c("NCESID" = "NCESSCH"), keep = TRUE) %>%
    left_join(ccd_mem, by = c("NCESID" = "NCESSCH")) %>%
    left_join(ccd_sch, by = c("NCESID" = "NCESSCH")) %>%
    left_join(ccd_lun, by = c("NCESID" = "NCESSCH")) %>%
    left_join(fun, by = c("PRNo" = "PRNo"))

missing <- df %>% filter(!complete.cases(.))
write_xlsx(missing, "missing.xlsx")


df <- df %>%
    filter(complete.cases(.)) %>%
    filter(!duplicated(NCESID))

# Number of non-missing, non-duplicated NCESID/NCESSCH
nrow(df)
unique(df$NCESID) |> length()
unique(df$NCESSCH) |> length()