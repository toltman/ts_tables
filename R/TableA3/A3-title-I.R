relevel <- c(
    "Title I schoolwide eligible" = "Title I schoolwide school",
    "Title I targeted assistance" = "Title I schoolwide eligible-Title I targeted assistance program",
    "Title I targeted assistance" = "Title I targeted assistance school",
    "Title I schoolwide eligible - no program" = "Title I schoolwide eligible school-No program",
    "Title I targeted assistance - no program" = "Title I targeted assistance eligible school-No program",
    "Not a Title I school" = "Not a Title I school",
    "Not reported" = "Not reported",
    "Missing" = "Missing"
)

df <- ts_target %>%
    left_join(fun) %>%
    left_join(ccd_sch, by = c("NCESID" = "NCESSCH"), keep = TRUE) %>%
    filter(complete.cases(.)) %>%
    mutate(
        title_i = fct_recode(fct_relevel(TITLEI_STATUS_TEXT, !!!relevel), !!!relevel)
    )

a3_titlei <- df %>%
    group_by(Sector, title_i) %>%
    summarise(value = n(), .groups = "drop") %>%
    pivot_wider(names_from = Sector, values_from = value, values_fill = 0) %>%
    janitor::adorn_totals("col") %>%
    relocate(Total, .after = title_i) %>%
    rename(char = title_i)

