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

ccd_dir <- read_csv(here::here(
    "Data",
    "Other Data (non-APR)",
    "CCD School Directory 2020-21",
    "CCD School Directory 2020-21.csv"
))

ccd_dir <- ccd_dir %>%
    select(SCH_NAME, NCESSCH, SCHID, CHARTER_TEXT, LEVEL) %>%
    mutate(NCESSCH_12 = sprintf("%012.0f", NCESSCH))

ts_target %>% arrange(NCESID)
ccd_dir %>% arrange(NCESSCH)

merge <- left_join(ts_target, ccd_dir, by = c("NCESID" = "NCESSCH_12"), keep = TRUE)

merge %>%
    filter(!is.na(NCESSCH_12))

merge %>% filter(is.na(NCESSCH_12))



geo_merge <- left_join(ts_target, geo, by = c("NCESID_num" = "NCESSCH"), keep = TRUE)

tar_geo_merged <- geo_merge %>% filter(!is.na(NCESSCH))

tar_geo_no_join <- geo_merge %>% filter(is.na(NCESSCH))

write_xlsx(tar_geo_merged, "tar_geo_merged.xlsx")
write_xlsx(tar_geo_no_join, "tar_geo_no_join.xlsx")



merge_dir_geo <- left_join(ccd_dir, geo, by = c("NCESSCH" = "NCESSCH"), keep = TRUE)

dir_geo_merged <- merge_dir_geo %>%
    filter(!is.na(NCESSCH.y))

dir_geo_no_join <- merge_dir_geo %>%
    filter(is.na(NCESSCH.y))

write_xlsx(dir_geo_merged, "CCD-Directory EDGE-geo merged.xlsx")
write_xlsx(dir_geo_no_join, "CCD-Directory EDGE-geo no_join.xlsx")


ccd_counts <- ccd_dir %>%
    count(NCESSCH) %>%
    arrange(desc(n))

write_xlsx(ccd_counts, "CCD-Directory-NCESSCH-Counts.xlsx")

ccd_counts_str <- ccd_dir %>%
    count(NCESSCH_12) %>%
    arrange(desc(n))

write_xlsx(ccd_counts_str, "CCD-Directory-NCESSCH-Counts-as-strings-v2.xlsx")
