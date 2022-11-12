df %>%
    group_by(Sector, TITLEI_STATUS_TEXT) %>%
    summarise(value = n())

df %>%
    group_by(Sector, TITLEI_STATUS) %>%
    summarise(value = n())

df %>%
    mutate(titleI = fct_cross(TITLEI_STATUS, TITLEI_STATUS_TEXT)) %>%
    group_by(titleI) %>%
    summarise(count = n())


df %>%
    mutate(title_i = fct_recode(TITLEI_STATUS_TEXT,
        "Title I schoolwide eligible" = "Title I schoolwide school",
        "Title I targeted assistance" = "Title I schoolwide eligible-Title I targeted assistance program",
        "Title I schoolwide eligible - no program" = "Title I schoolwide eligible school-No program",
        "Title I targeted assistance - no program" = "Title I targeted assistance eligible school-No program",
        "Not a Title I school" = "Not a Title I school",
        "Not reported" = "Not reported",
        "Missing" = "Missing"
    )) %>%
    group_by(Sector, title_i) %>%
    summarise(value = n()) %>%
    pivot_wider(names_from = Sector, values_from = value, values_fill = 0) %>%
    janitor::adorn_totals("col") %>%
    relocate(Total, .after = title_i) %>%
    rename(char = title_i)

