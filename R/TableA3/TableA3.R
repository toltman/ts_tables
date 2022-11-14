library(tidyverse)
library(readxl)
library(here)
library(writexl)

source(here::here("R", "TableA3", "A3-read-data.R"))
source(here::here("R", "TableA3", "A3-sch-parts.R"))
source(here::here("R", "TableA3", "A3-urbanicity.R"))
source(here::here("R", "TableA3", "A3-enroll.R"))
source(here::here("R", "TableA3", "A3-level.R"))
source(here::here("R", "TableA3", "A3-sch-type.R"))
source(here::here("R", "TableA3", "A3-title-I.R"))
source(here::here("R", "TableA3", "A3-frpl.R"))

a3 <- rbind(
    a3_schparts,
    a3_urban,
    a3_enrll,
    a3_level,
    a3_sch_type,
    a3_titlei,
    a3_frpl
)

final_a3 <- a3 %>%
    mutate(
        four_year_pct = four_year / Total,
        two_year_pct = two_year / Total,
        other_pct = other / Total
    ) %>%
    select(
        char, Total, four_year, four_year_pct,
        two_year, two_year_pct, other_pct
    )

write_xlsx(final_a3, "TableA3.xlsx")
