df <- ts_target %>% 
    left_join(fun) %>%
    left_join(ccd_dir, by = c("NCESID" = "NCESSCH"), keep = TRUE) %>%
    filter(complete.cases(.))

df %>%
    group_by(Sector, LEVEL) %>%
    summarise(value = n()) %>%
    pivot_wider(names_from = Sector, values_from = value, values_fill = 0) %>%
    janitor::adorn_totals("col") %>%
    relocate(Total, .after = LEVEL) %>%
    rename(char = LEVEL)
