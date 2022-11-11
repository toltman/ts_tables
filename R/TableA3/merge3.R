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
    mutate(NCESSCH = sprintf("%012.0f", NCESSCH))

nrow(ts_target)
unique(ts_target$NCESID) |> length()

nrow(ccd_dir)
unique(ccd_dir$NCESSCH) |> length()

inner_join(ts_target, memb, by = c("NCESID" = "NCESSCH"), keep = TRUE) %>% pull(NCESID)
inner_join(ts_target, ccd_sch, by = c("NCESID" = "NCESSCH"), keep = TRUE)
merged <- inner_join(ts_target, ccd_dir, by = c("NCESID" = "NCESSCH"), keep = TRUE)

anti <- anti_join(ts_target, ccd_dir, by = c("NCESID" = "NCESSCH"), keep = TRUE)


write_xlsx(merged, here("merged.xlsx"))
write_xlsx(anti, here("no_join.xlsx"))

ts_target %>% filter(SchoolNM == "GRAETTINGER-TERRIL MIDDLE SCHOOL")
ccd_dir %>% filter(SCH_NAME == "GRAETTINGER-TERRIL MIDDLE SCHOOL")
 
ts_target %>% filter(NCESID == 191281002118)
ccd_dir %>% filter(NCESSCH == 191281002118)

write_xlsx(ccd_dir, "ccd_dir.xlsx")

ts_target %>% filter(NCESID == 10000500870)
ts_target %>% filter(SchoolNM == "Albertville Middle School")

albert <- ts_target %>% arrange(SchoolNM)
albert[40:100,]

ccd_dir %>% filter(NCESSCH == 273051002427)
ccd_dir %>% filter(SCH_NAME == 273051002427)
