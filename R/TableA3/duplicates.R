ts_target %>%
    filter(NCESID == "NA") %>%
    group_by(NCESID) %>%
    mutate(n = n()) %>%
    arrange(desc(n))

ts_target %>% 
    filter(
        NCESID != "NA",
        duplicated(NCESID)
    )

ts_target %>% 
    filter(
        NCESID != "NA",
        !duplicated(NCESID)
    )

ts_target %>%
    filter(
        NCESID != "NA",
    ) %>%
    group_by(NCESID) %>%
    mutate(n = n()) %>%
    filter(n > 1) %>%
    arrange(desc(n))


dups <- ts_target %>%
    filter(NCESID != "NA") %>%
    group_by(NCESID) %>%
    mutate(
        cnt_NCESID = n(),
        cnt_PRNo = length(unique(PRNo))
    ) %>%
    filter(cnt_NCESID != cnt_PRNo) %>%
    arrange(desc(NCESID))

write_xlsx(dups, "dups.xlsx")


# there are mulitple PRNo's per duplicated NCESID
ts_target %>%
    filter(
        NCESID != "NA",
    ) %>%
    group_by(NCESID) %>%
    summarise(
        cnt_NCESID = n(),
        cnt_PRNo = length(unique(PRNo))
    ) %>%
    filter(cnt_NCESID != cnt_PRNo)



# maybe I should sum these num_served before I even get started?!?!

dups %>% left_join(fun)
dups %>% left_join(ccd_dir, by = c("NCESID" = "NCESSCH"))
write_xlsx(dups %>% left_join(fun), "prno_join.xlsx")

# Drop NCESID = 99999999
# Aggregate NumServed to the PRNo X NCESID level
dups %>% 
    filter(cnt_PRNo > 1) %>%
    pull(NCESID) %>%
    unique()
