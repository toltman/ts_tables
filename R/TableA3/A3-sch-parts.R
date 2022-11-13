df <- ts_target %>% left_join(fun)

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
