library(janitor)

# total schools by PRNo
df %>%
    count(PRNo) %>%
    arrange(desc(n))

# total participants
df %>% summarise(sum(NumServed))


# total schools by Sector
df %>%
    group_by(Sector) %>%
    summarise(Schools = n()) %>%
    janitor::adorn_totals("row") %>%
    pivot_wider(names_from = Sector, values_from = Schools) %>%
    relocate(Total)

# total participants by Sector
df %>%
    group_by(Sector) %>%
    summarise(
        schools = n(),
        parts = sum(NumServed),
    ) %>%
    janitor::adorn_totals("row") %>%
    mutate(avg_part = parts / schools) %>%
    pivot_longer(-Sector, names_to = "char", values_to = "value") %>%
    pivot_wider(names_from = Sector, values_from = value) %>%
    relocate(Total, .after = char)

# Students enrolled
df %>%
    group_by(Sector, enrll_cat) %>%
    summarise(enrll = n()) %>%
    pivot_wider(names_from = Sector, values_from = enrll) %>%
    janitor::adorn_totals("col") %>%
    relocate(Total, .after = enrll_cat) %>%
    rename(char = enrll_cat)

# LEVEL
df %>%
    group_by(Sector, LEVEL) %>%
    summarise(value = n()) %>%
    pivot_wider(names_from = Sector, values_from = value, values_fill = 0) %>%
    janitor::adorn_totals("col") %>%
    relocate(Total, .after = LEVEL) %>%
    rename(char = LEVEL)

# School type
df %>%
    group_by(Sector, sch_type) %>%
    summarise(value = n()) %>%
    pivot_wider(names_from = Sector, values_from = value, values_fill = 0) %>%
    janitor::adorn_totals("col") %>%
    relocate(Total, .after = sch_type) %>%
    rename(char = sch_type)

# Title I eligibility
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


