fun <- read_excel(here::here("Data", "Data 2020-21", "FY2020TSFundedDetails-MinSecReg.xlsx"))
ts2 <- read_excel(here::here("Data", "Data 2020-21", "TS2.xlsx"))
ts3 <- read_excel(here::here("Data", "Data 2020-21", "TS3.xlsx"))
ts4 <- read_excel(here::here("Data", "Data 2020-21", "TS4.xlsx"))

fun <- fun %>%
    select(PRNo, Sector)

ts2 <- ts2 %>%
    select(PRNO, SenrCompFASFAPNO, SenrCompFASFAenrlCollgPNO, TotKPNO)

ts3 <- ts3 %>%
    select(
        PRNo, MidSchNo, HighSchFshNo, HighSchSophNo, HighSchJrNo, 
        HighSchSNo, HighSch4yrDEnrlNo, HighSch5yrDEnrlNo
    )

ts4 <- ts4 %>%
    select(
        PRNo, Part4ADeceasedNo, PersistedNextNo, SecSchPersistPct,
        RcvdRSDipNo, RcvdRSdipRigPgmNo, SecSchGradPctI, SecSchGradPctII,
        Part4BRcvdRSDipNotStdNo, RcvdAltAwdNo, tot_RcvdRDipNO,
        tot_RcvdRDipRigPgmNo, tot_Part4CRcvdRSDipNotStdNo, tot_RcvdHSEquCredNO
    ) %>%
    mutate(
        TS4_SecSchPersPct = SecSchPersistPct,
        TS4_SecSchGradPctI = SecSchGradPctI,
        TS4_SecSchGradPctII = SecSchGradPctII
    )

df <- fun %>%
    left_join(ts3) %>% 
    left_join(ts4) %>%
    left_join(ts2, by = c("PRNo" = "PRNO"))

df <- df %>%
    mutate(
        Denom_SecSchPersPct = MidSchNo + HighSchFshNo + HighSchSophNo + 
            HighSchJrNo + HighSch4yrDEnrlNo - Part4ADeceasedNo,
        Numer_SecSchPersPct = PersistedNextNo,
        TOCalc_SecSchPersPct = Numer_SecSchPersPct / Denom_SecSchPersPct,

        Denom_SecSchGradRegPct = HighSchSNo + HighSch5yrDEnrlNo - Part4ADeceasedNo,
        Numer_SecSchGradRegPct = RcvdRSDipNo + RcvdRSdipRigPgmNo,
        TOCalc_SecSchGradRegPct = Numer_SecSchGradRegPct / Denom_SecSchGradRegPct,

        Denom_SecSchGradRigPct = HighSchSNo + HighSch5yrDEnrlNo - Part4ADeceasedNo,
        Numer_SecSchGradRigPct = RcvdRSdipRigPgmNo,
        TOCalc_SecSchGradRigPct = Numer_SecSchGradRigPct / Denom_SecSchGradRigPct,

        Denom_fafsa = TotKPNO,
        Numer_fafsa = SenrCompFASFAPNO + SenrCompFASFAenrlCollgPNO,
        TOCalc_FAFSA = Numer_fafsa / Denom_fafsa,

        Denom_PostSecEnrllPct = RcvdRSDipNo + RcvdRSdipRigPgmNo +
            Part4BRcvdRSDipNotStdNo + RcvdAltAwdNo,
        Numer_PostSecEnrllPct = tot_RcvdRDipNO + tot_RcvdRDipRigPgmNo +
            tot_Part4CRcvdRSDipNotStdNo + tot_RcvdHSEquCredNO,
        TOCalc_PostSecEnrllPct = Numer_PostSecEnrllPct / Denom_PostSecEnrllPct
    )

ts_obj <- read_excel(here::here("Data", "Data 2020-21", "TSObjective.xlsx"))

ts_obj <- ts_obj %>%
    select(PRNO, SecSchPersPct, SecSchGradRegPct, SecSchGradRigPct, PostSecEnrllPct) %>%
    mutate(
        TSObj_SecSchPersPct = SecSchPersPct,
        TSObj_SecSchGradRegPct = SecSchGradRegPct,
        TSObj_SecSchGradRigPct = SecSchGradRigPct,
        TSObj_PostSecEnrllPct = PostSecEnrllPct
    )

df <- left_join(df, ts_obj, by = c("PRNo" = "PRNO"))

# df %>%
#     select(
#         PRNo, Sector,
#         TSObj_SecSchPersPct, TS4_SecSchPersPct, TOCalc_SecSchPersPct,
#         TSObj_SecSchGradRegPct, TS4_SecSchGradPctI, TOCalc_SecSchGradRegPct,
#         TSObj_SecSchGradRigPct, TS4_SecSchGradPctII, TOCalc_SecSchGradRigPct,
#         TOCalc_FAFSA,
#         TSObj_PostSecEnrllPct, TOCalc_PostSecEnrllPct
#     ) %>%
#     glimpse()

a2_2021 <- df %>%
    select(
        PRNo, Sector, 
        Denom_SecSchPersPct, Numer_SecSchPersPct,
        Denom_SecSchGradRegPct, Numer_SecSchGradRegPct,
        Denom_SecSchGradRigPct, Numer_SecSchGradRigPct,
        Denom_fafsa, Numer_fafsa,
        Denom_PostSecEnrllPct, Numer_PostSecEnrllPct
    )

a2_2021 <- a2_2021 %>%
    mutate(
        Sector = factor(
            Sector,
            levels = c("A", "B", "C", "D", "E", "F", "G", "H", "I")
        ),
        Sector = fct_collapse(
            Sector,
            four_year = c("A", "B", "H"),
            two_year = c("C", "D", "I"),
            other = c("E", "F", "G")
        )
    )

a2_2021 <- a2_2021 %>%
    group_by(Sector) %>%
    summarise(across(-PRNo, sum)) %>%
    mutate(
        SecSchPersPct = Numer_SecSchPersPct / Denom_SecSchPersPct,
        SecSchGradRegPct = Numer_SecSchGradRegPct / Denom_SecSchGradRegPct,
        SecSchGradRigPct = Numer_SecSchGradRigPct / Denom_SecSchGradRigPct,
        fafsa = Numer_fafsa / Denom_fafsa,
        PostSecEnrllPct = Numer_PostSecEnrllPct / Denom_PostSecEnrllPct
    )

colnames(a2_2021) <- paste0(colnames(a2_2021), '_2021')
