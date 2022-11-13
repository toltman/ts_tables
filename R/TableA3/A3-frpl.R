ccd_lun <- ccd_lun %>% 
    filter(
        TOTAL_INDICATOR == "Education Unit Total",
        DATA_GROUP == "Free and Reduced-price Lunch Table"
    ) %>%
    rename(FRPL_COUNT = STUDENT_COUNT)

df <- ts_target %>%
    left_join(fun) %>%
    left_join(ccd_mem, by = c("NCESID" = "NCESSCH"), keep = TRUE) %>%
    left_join(ccd_lun, by = c("NCESID" = "NCESSCH")) %>%
    mutate(FRPL_COUNT = replace_na(FRPL_COUNT, 0)) %>%
    filter(complete.cases(.)) %>%
    mutate(frpl_pct = FRPL_COUNT / STUDENT_COUNT)

summary(df$frpl_pct)
df %>% filter(frpl_pct > 1)
df %>% filter(is.na(frpl_pct))


a3_frpl <- df %>% 
    filter(!is.na(frpl_pct)) %>%
    mutate(
        frpl_cat = cut(
            frpl_pct,
            breaks = c(0, .25, .50, .75, 1.11),
            labels = c(
                "Less than 25 percent",
                "25.01 - 50 percent",
                "50.01 - 75 percent",
                "Over 75 percent"
            ),
            include.lowest = TRUE
        )
    ) %>%
    group_by(Sector, frpl_cat) %>%
    summarise(value = n(), .groups = "drop") %>%
    pivot_wider(names_from = Sector, values_from = value, values_fill = 0) %>%
    janitor::adorn_totals("col") %>%
    relocate(Total, .after = frpl_cat) %>%
    rename(char = frpl_cat)
