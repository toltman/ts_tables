df <- ts_target %>%
    left_join(fun) %>%
    left_join(ccd_dir, by = c("NCESID" = "NCESSCH"), keep = TRUE) %>%
    left_join(ccd_sch, by = c("NCESID" = "NCESSCH")) %>%
    filter(complete.cases(.)) %>%
    mutate(
        CHARTER_TEXT = fct_collapse(CHARTER_TEXT,
            No = c("No", "Not applicable")
        ),
        MAGNET_TEXT = fct_collapse(MAGNET_TEXT,
            No = c("No", "Missing", "Not applicable", "Not reported")
        ),
        VIRTUAL = fct_collapse(VIRTUAL,
            Yes = "FULLVIRTUAL",
            No = c("FACEVIRTUAL", "MISSING", "Not reported", "NOTVIRTUAL", "SUPPVIRTUAL")
        ),
        sch_type = fct_cross(CHARTER_TEXT, MAGNET_TEXT, VIRTUAL),
        sch_type = fct_recode(sch_type,
            "Regular school" = "No:No:No",
            "Charter school" = "Yes:No:No",
            "Magnet school" = "No:Yes:No",
            "Virtual school" = "No:No:Yes",
            "Charter-Magnet school" = "Yes:Yes:No",
            "Charter-Virtual school" = "Yes:No:Yes"
        )
    )

a3_sch_type <- df %>%
    group_by(Sector, sch_type) %>%
    summarise(value = n(), .groups = "drop") %>%
    pivot_wider(names_from = Sector, values_from = value, values_fill = 0) %>%
    janitor::adorn_totals("col") %>%
    relocate(Total, .after = sch_type) %>%
    rename(char = sch_type)
