library(tidyverse)
library(readxl)
library(here)
library(writexl)

source(here::here("R", "TableA2-1617.R"))
source(here::here("R", "TableA2-1718.R"))
source(here::here("R", "TableA2-1819.R"))
source(here::here("R", "TableA2-1920.R"))
source(here::here("R", "TableA2-2021.R"))

df_all <- cbind(a2_1617, a2_1718, a2_1819, a2_1920, a2_2021)

df_denom <- df_all %>%
    select(Sector_2021, starts_with("Denom_")) %>%
    pivot_longer(
        cols = starts_with("Denom_"),
        names_to = "outcome",
        names_prefix = "Denom_",
        values_to = "denom"
    ) %>% rename(
        Sector = Sector_2021
    ) %>%
    pivot_wider(
        names_from = Sector,
        values_from = denom
    ) %>%
    separate(
        col = outcome,
        into = c("outcome", "year"),
        sep = "_"
    ) %>%
    pivot_wider(
        names_from = year,
        values_from = c(four_year, two_year, other)
    )


df_numer <- df_all %>%
    select(Sector_2021, starts_with("Numer_")) %>%
    pivot_longer(
        cols = starts_with("Numer_"),
        names_to = "outcome",
        names_prefix = "Numer_",
        values_to = "numer"
    ) %>% rename(
        Sector = Sector_2021
    ) %>%
    pivot_wider(
        names_from = Sector,
        values_from = numer
    ) %>%
    separate(
        col = outcome,
        into = c("outcome", "year"),
        sep = "_"
    ) %>%
    pivot_wider(
        names_from = year,
        values_from = c(four_year, two_year, other)
    )

df_pcts <- df_numer %>% select(-outcome) / df_denom %>% select(-outcome)

overall_numer <- df_numer %>%
    rowwise() %>%
    mutate(numer = sum(c_across(-outcome))) %>%
    pull(numer)

overall_denom <- df_denom %>%
    rowwise() %>%
    mutate(denom = sum(c_across(-outcome))) %>%
    pull(denom)

overall <- overall_numer / overall_denom

df_final <- cbind(outcome = df_numer$outcome, overall, df_pcts)


write_xlsx(df_final, "TableA2.xlsx")
