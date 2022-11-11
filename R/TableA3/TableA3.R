library(tidyverse)
library(readxl)
library(here)
library(writexl)

ts_target <- read_excel(
    here::here("Data", "Data 2020-21", "TSTargetSchool.xlsx")
)

ts_target <- ts_target %>%
    select(PRNo, NCESID, NumServed) %>% 
    mutate(NCESID_num = as.numeric(NCESID))

nrow(ts_target)
unique(ts_target$NCESID) |> length()

# NA or non-number NCESID's
ts_target %>%
    filter(is.na(NCESID_num)) %>% pull(NCESID)

# Number of NCESIDs in each PRNo
ts_target %>%
    group_by(PRNo) %>%
    summarise(n = length(unique(NCESID))) %>%
    arrange(desc(n))

# Number of PRNo's in each NCESID
ts_target %>%
    group_by(NCESID) %>%
    summarise(n = length(unique(PRNo))) %>%
    arrange(desc(n)) %>%
    filter(n > 1)

ts_target %>% filter(NCESID == "292928002011")
ts_target %>% filter(NCESID == "050711000430")

# PRNo = P044A170086
ts_target %>%
    filter(PRNo == "P044A170086")

# number of unique NCESIDs
ts_target$NCESID |> unique() |> length()

# counts of NCESIDs
ts_target %>%
    count(NCESID) %>%
    arrange(desc(n))

ts_target %>%
    filter(NCESID == 120060000849)






ccd_dir <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD School Directory 2020-21",
        "CCD School Directory 2020-21.csv"
    ),
    col_types = cols_only(
        SCH_NAME = "c",
        NCESSCH = "c",
        SCHID = "d",
        CHARTER_TEXT = "c",
        LEVEL = "c"
    )
)

ccd_dir <- mutate(ccd_dir, NCESSCH = format(ccd_dir$NCESSCH, scientific = FALSE))


ccd_dir %>%
    count(NCESSCH) %>%
    arrange(desc(n))

ccd_dir %>%
    filter(NCESSCH == 720003000000) %>% select(SCHID)

ccd_dir %>%
    filter(NCESSCH == 170993000000) %>% select(SCHID) %>% pull(SCHID) |> unique() |> length()

nrow(ccd_dir)
unique(ccd_dir$SCHID) |> length()
unique(ccd_dir$NCESSCH) |> length()

df <- left_join(ts_target, ccd_dir, by = c("NCESID" = "NCESSCH"))

df |> nrow()
df$SCHID |> unique() |> length()
df %>% filter(is.na(SCHID))




memb <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD Membership 2020-21",
        "ccd_SCH_029_2021_w_1a_080621.csv"
    ),
    col_types = cols_only(
        NCESSCH = "d",
        STUDENT_COUNT = "d"
    )
)

sch_lvl <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD School level 2020-21",
        "ccd_sch_129_2021_w_1a.csv"
    ),
    col_types = cols_only(
        NCESSCH = "d",
        TITLEI_STATUS = "c",
        TITLEI_STATUS_TEXT = "c",
        MAGNET_TEXT = "c",
        VIRTUAL = "c"
    )
)

lunch <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD Lunch Program Eligibility (School level) 2020-21",
        "CCD Lunch Eligibility 20-21.csv"
    ),
    col_types = cols_only(
        NCESSCH = "d",
        STUDENT_COUNT = "d"
    )
)

edge <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "EDGE_SIDE1519_PUBSCHS1819.csv"
    ),
    # col_types = cols_only(
    #     NCESSCH = "d",
    #     IPR_EST = "d"
    # )
)

nrow(edge)
unique(edge$NCESSCH) |> length()

edge %>%
    count(NCESSCH) %>%
    arrange(desc(n))

edge %>%
    filter(NCESSCH == 170993000000)

edge %>%
    count(NCESSCH) %>%
    filter(n == 1)


geo <- read_excel(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "EDGE_GEOCODE_PUBLICSCH_1920.xlsx"
    )
)

geo <- geo %>%
    mutate(
        NCESSCH = as.numeric(NCESSCH),
        urbanicity = fct_collapse(LOCALE, 
            Urban = c("11", "12", "13"),
            Suburban = c("21", "22", "23"),
            Town = c("31", "32", "33"),
            Rural = c("41", "42", "43")
        )
    )

unique(geo$NCESSCH) |> length()
geo %>% count(NCESSCH) %>% arrange(desc(n))

left_join(ts_target, geo, by = c("NCESID" = "NCESSCH"), keep = TRUE) %>%
    filter(is.na(NCESSCH))
inner_join(geo, ccd_dir, by = c("NCESSCH" = "NCESSCH"))



pss <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "PSS 2019-20",
        "pss1920_pu.csv"
    )
)

pss <- pss %>%
    select(
        UCOMMTYP,
        NUMSTUDS,
        LEVEL2
    )
