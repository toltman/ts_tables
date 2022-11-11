library(tidyverse)
library(readxl)
library(here)
library(writexl)


ts_target <- read_excel(
    here::here("Data", "Data 2020-21", "TSTargetSchool.xlsx")
)

ts_target <- ts_target %>%
    mutate(NCESID_num = as.numeric(NCESID)) %>%
    select(PRNo, NCESID, NCESID_num, SchoolNM, NumServed)

ccd_dir <- read_excel(here::here(
    "Data",
    "Other Data (non-APR)",
    "CCD School Directory 2020-21",
    "XLSX_ccd_sch_029_1920_w_1a_082120.xlsx"
))

ccd_dir <- ccd_dir %>%
    select(SCH_NAME, NCESSCH, SCHID, CHARTER_TEXT, LEVEL)

nrow(ccd_dir)
unique(ccd_dir$NCESSCH) |> length()
ccd_dir %>% count(NCESSCH) %>% arrange(desc(n))

ccd_dir <- ccd_dir %>%
    select(SCH_NAME, NCESSCH, SCHID, CHARTER_TEXT, LEVEL) %>%
    mutate(NCESSCH_12 = sprintf("%012.0f", NCESSCH))

merge_tar_dir <- left_join(ts_target, ccd_dir, by = c("NCESID_num" = "NCESSCH"), keep = TRUE)

nrow(merge_tar_dir)
merge_tar_dir %>% filter(!is.na(NCESSCH))
merge_tar_dir %>% filter(is.na(NCESSCH))

write_xlsx(merge_tar_dir %>% filter(!is.na(NCESSCH)), "tar_dir_merged.xlsx")
write_xlsx(merge_tar_dir %>% filter(is.na(NCESSCH)), "tar_dir_no_join.xlsx")
