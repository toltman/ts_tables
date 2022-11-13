df <- ts_target %>%
    left_join(fun) %>%
    left_join(edge, by = c("NCESID" = "NCESSCH"), keep = TRUE) %>%
    filter(!is.na(NCESSCH)) %>%
    mutate(
        urban = fct_collapse(
            LOCALE,
            Urban = c("11", "12", "13"),
            Suburban = c("21", "22", "23"),
            Town = c("31", "32", "33"),
            Rural = c("41", "42", "43")
        )
    )

a3_urban <- df %>%
    group_by(Sector, urban) %>%
    summarise(value = n(), .groups = "drop") %>%
    pivot_wider(names_from = Sector, values_from = value, values_fill = 0) %>%
    janitor::adorn_totals("col") %>%
    relocate(Total, .after = urban) %>%
    rename(char = urban)
