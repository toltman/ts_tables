
ccd_sch <- read_csv(
    here::here(
        "Data",
        "Other Data (non-APR)",
        "CCD School level 2020-21",
        "ccd_sch_129_2021_w_1a.csv"
    )
)


nrow(ccd_sch)
unique(ccd_sch$NCESSCH) |> length()
sch_counts <- ccd_sch %>%
    count(NCESSCH) %>%
    arrange(desc(n))

write_xlsx(sch_counts, "CCD-School-Level-Counts.xlsx")

sch_lvl_72e11 <- ccd_sch %>%
    filter(NCESSCH == 720003000000)

write_xlsx(sch_lvl_72e11, "sch_lvl_72e11.xlsx")
