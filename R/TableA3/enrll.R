nrow(ccd_mem)
unique(ccd_mem$NCESSCH) |> length()
ccd_mem %>% filter(is.na(NCESSCH))
ccd_mem %>% filter(is.na(STUDENT_COUNT))
df %>% filter(is.na(STUDENT_COUNT))
df %>% filter(STUDENT_COUNT == 0)

df %>% 
    mutate(enrll_cat = cut(
        STUDENT_COUNT,
        breaks = c(-1, 199, 499, 749, 999, Inf),
        labels = c("Less than 200", "200-499", "500-749", "750-999", "1000 or more")
    )) %>%
    group_by(Sector, enrll_cat) %>%
    summarise(enrll = n())

