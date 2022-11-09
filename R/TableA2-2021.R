# By sector and year...
# Secondary School Persistance
# By Sector and year...

# Secondary School Persistence Rate: percentage in grades 6-11 completing
# the current year and continuing into the next year at the next grade level.

# Denominator: at time of first service: middle school students or non-senior
# highschool students (including 4th year in 5 year program) ->
# Section III: A1, A2, A3, A4, and A7
# minus deceased, Section IV, A4
# 


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
        PSE_TotC1C2
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
        TOCalc_SecSchPersPct = PersistedNextNo / Denom_SecSchPersPct,
        TOCalc_SecSchGradRegPct = (RcvdRSDipNo + RcvdRSdipRigPgmNo) / 
            (HighSchSNo + HighSch5yrDEnrlNo - Part4ADeceasedNo),
        TOCalc_SecSchGradRigPct = (RcvdRSdipRigPgmNo) /
            (HighSchSNo + HighSch5yrDEnrlNo - Part4ADeceasedNo),
        TOCalc_FAFSA = (SenrCompFASFAPNO + SenrCompFASFAenrlCollgPNO) / TotKPNO,
        TOCalc_PostSecEnrllPct = PSE_TotC1C2 / 
            (RcvdRSDipNo + RcvdRSdipRigPgmNo - Part4ADeceasedNo)
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

df %>%
    select(
        PRNo, Sector,
        TSObj_SecSchPersPct, TS4_SecSchPersPct, TOCalc_SecSchPersPct,
        TSObj_SecSchGradRegPct, TS4_SecSchGradPctI, TOCalc_SecSchGradRegPct,
        TSObj_SecSchGradRigPct, TS4_SecSchGradPctII, TOCalc_SecSchGradRigPct,
        TOCalc_FAFSA,
        TSObj_PostSecEnrllPct, TOCalc_PostSecEnrllPct
    ) %>%
    glimpse()
