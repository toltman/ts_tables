nrow(ccd_lun)
ccd_lun$NCESSCH |> unique() |> length()
ccd_lun %>% filter(is.na(FRPL_COUNT))
df %>% filter(is.na(FRPL_COUNT))
