# School type

df %>% select(NCESID, CHARTER_TEXT, MAGNET_TEXT, VIRTUAL) %>%
    group_by(CHARTER_TEXT) %>%
    summarise(count = n())

df %>% select(NCESID, CHARTER_TEXT, MAGNET_TEXT, VIRTUAL) %>%
    group_by(MAGNET_TEXT) %>%
    summarise(count = n())

df %>% select(NCESID, CHARTER_TEXT, MAGNET_TEXT, VIRTUAL) %>%
    group_by(VIRTUAL) %>%
    summarise(count = n())


df %>% select(NCESID, CHARTER_TEXT, MAGNET_TEXT, VIRTUAL) %>%
    group_by(CHARTER_TEXT, MAGNET_TEXT, VIRTUAL) %>%
    summarise(count = n()) %>%
    print(n = 27)


df %>% select(NCESID, CHARTER_TEXT, MAGNET_TEXT, VIRTUAL) %>%
    group_by(CHARTER_TEXT, MAGNET_TEXT, VIRTUAL) %>%
    summarise(count = n()) %>%
    print(n = 27)


df %>% select(NCESID, CHARTER_TEXT, MAGNET_TEXT, VIRTUAL) %>%
    group_by(CHARTER_TEXT, MAGNET_TEXT, VIRTUAL) %>%
    summarise(count = n())

df %>% select(NCESID, CHARTER_TEXT, MAGNET_TEXT, VIRTUAL) %>%
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
    ) %>%
    group_by(sch_type) %>%
    summarise(count = n())



