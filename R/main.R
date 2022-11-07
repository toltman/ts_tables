library(writexl)

df_all <- cbind(df_2021, df_1920, df_1819, df_1718, df_1617)

df_all$char <- rownames(df_all)

df_all <- df_all %>%
    rowwise() %>%
    mutate(overall = sum(c_across(!starts_with(c("pct_", "char")))))

df_all <- df_all %>%
    mutate(pct_overall = overall / df_all$overall[1])

df_all<- df_all %>% select(
    char,
    overall, pct_overall,
    four_year1617, pct_four_year1617,
    four_year1718, pct_four_year1718,
    four_year1819, pct_four_year1819,
    four_year1920, pct_four_year1920,
    four_year2021, pct_four_year2021,
    two_year1617, pct_two_year1617,
    two_year1718, pct_two_year1718,
    two_year1819, pct_two_year1819,
    two_year1920, pct_two_year1920,
    two_year2021, pct_two_year2021,
    other1617, pct_other1617,
    other1718, pct_other1718,
    other1819, pct_other1819,
    other1920, pct_other1920,
    other2021, pct_other2021
)

write_xlsx(df_all, "TableA1.xlsx")
