library(tidyverse)
library(readxl)
library(here)
library(writexl)

# Funding data for Sector
fun <- read_excel(here::here("Data", "Data 2020-21", "FY2020TSFundedDetails-MinSecReg.xlsx"))

fun <- fun %>% select(PRNo, Sector)

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



df <- ts_target %>%
    left_join(fun, by = c("PRNo" = "PRNo")) %>% 
    left_join(ccd_dir, by = c("NCESID" = "NCESSCH"), keep = TRUE) %>%
    left_join(ccd_mem, by = c("NCESID" = "NCESSCH")) %>%
    left_join(ccd_sch, by = c("NCESID" = "NCESSCH")) %>%
    left_join(ccd_lun, by = c("NCESID" = "NCESSCH"))

df <- df %>%
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



df %>% 
    select(NCESID, STUDENT_COUNT, FRPL_COUNT) %>%
    mutate(frpl_pct = FRPL_COUNT / STUDENT_COUNT) %>% 
    filter(frpl_pct != Inf) %>%
    summary()

plot(x = df$STUDENT_COUNT, y = df$FRPL_COUNT)

ggplot(df, aes(x = STUDENT_COUNT, y = FRPL_COUNT)) +
    geom_point() +
    geom_abline(slope = .2, intercept = 0, color = "red")

ts_target %>% count(NCESID) %>% arrange(desc(n)) %>% filter(n != 1)
df %>% filter(is.na(NCESSCH))
df %>% filter(is.na(NCESSCH.dir))
df %>% filter(is.na(NCESSCH.mem))
df %>% filter(is.na(NCESSCH.sch))

df %>% filter(is.na(NCESSCH.x) & is.na(NCESSCH.y))
df %>% filter(is.na(NCESSCH.x) | is.na(NCESSCH.y))
