df %>%
    group_by(LEVEL) %>%
    count()

df %>% filter(LEVEL == "Elementary")

