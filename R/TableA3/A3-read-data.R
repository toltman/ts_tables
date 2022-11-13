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

ccd_lun <- ccd_lun %>% 
    filter(
        TOTAL_INDICATOR == "Education Unit Total",
        DATA_GROUP == "Free and Reduced-price Lunch Table"
    ) %>%
    rename(FRPL_COUNT = STUDENT_COUNT) %>%
    select(NCESSCH, FRPL_COUNT)


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

# df <- ts_target %>%
#     left_join(ccd_dir, by = c("NCESID" = "NCESSCH"), keep = TRUE) %>%
#     left_join(ccd_mem, by = c("NCESID" = "NCESSCH")) %>%
#     left_join(ccd_sch, by = c("NCESID" = "NCESSCH")) %>%
#     left_join(ccd_lun, by = c("NCESID" = "NCESSCH")) %>%
#     left_join(fun, by = c("PRNo" = "PRNo"))



# missing <- df %>% filter(!complete.cases(.))
# write_xlsx(missing, "missing.xlsx")


# df <- df %>%
#     filter(complete.cases(.)) %>%
#     filter(!duplicated(NCESID))

# df <- df %>%
#     mutate(
#         CHARTER_TEXT = fct_collapse(CHARTER_TEXT,
#             No = c("No", "Not applicable")
#         ),
#         MAGNET_TEXT = fct_collapse(MAGNET_TEXT,
#             No = c("No", "Missing", "Not applicable", "Not reported")
#         ),
#         VIRTUAL = fct_collapse(VIRTUAL,
#             Yes = "FULLVIRTUAL",
#             No = c("FACEVIRTUAL", "MISSING", "Not reported", "NOTVIRTUAL", "SUPPVIRTUAL")
#         ),
#         sch_type = fct_cross(CHARTER_TEXT, MAGNET_TEXT, VIRTUAL),
#         sch_type = fct_recode(sch_type,
#             "Regular school" = "No:No:No",
#             "Charter school" = "Yes:No:No",
#             "Magnet school" = "No:Yes:No",
#             "Virtual school" = "No:No:Yes",
#             "Charter-Magnet school" = "Yes:Yes:No",
#             "Charter-Virtual school" = "Yes:No:Yes"
#         )
#     )

# Number of non-missing, non-duplicated NCESID/NCESSCH
# nrow(df)
# unique(df$NCESID) |> length()
# unique(df$NCESSCH) |> length()


# complete.cases getting rid of some stuff we want to keep?
# - the problem is probably missing FRPL_COUNTs are missing
# need to get the CHARTER stuff back in