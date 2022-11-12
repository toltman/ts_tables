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
