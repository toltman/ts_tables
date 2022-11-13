df <- ts_target %>% 
    left_join(fun) %>%
    left_join(ccd_mem, by = c("NCESID" = "NCESSCH"), keep = TRUE) %>%
    filter(complete.cases(.))


df %>%
    group_by(Sector, enrll_cat) %>%
    summarise(enrll = n()) %>%
    pivot_wider(names_from = Sector, values_from = enrll) %>%
    janitor::adorn_totals("col") %>%
    relocate(Total, .after = enrll_cat) %>%
    rename(char = enrll_cat)

