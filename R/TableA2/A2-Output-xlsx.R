SecSchPersPctQdf <- df %>%
    select(
        PRNo, TSObj_SecSchPersPct, TS4_SecSchPersPct, TOCalc_SecSchPersPct,
        MidSchNo, HighSchFshNo, HighSchSophNo, HighSchJrNo, HighSch4yrDEnrlNo,
        Part4ADeceasedNo, PersistedNextNo
    )
write_xlsx(SecSchPersPctQdf, "SecSchPersPct.xlsx")

SecSchRegPctQdf <- df %>%
    select(
        PRNo, TSObj_SecSchGradRegPct, TS4_SecSchGradPctI,
        TOCalc_SecSchGradRegPct, RcvdRSDipNo, RcvdRSdipRigPgmNo,
        HighSchSNo, HighSch5yrDEnrlNo, Part4ADeceasedNo
    )
write_xlsx(SecSchRegPctQdf, "SecSchRegPct.xlsx")

SecSchRigPctQdf <- df %>%
    select(
        PRNo, TSObj_SecSchGradRigPct, TS4_SecSchGradPctII,
        TOCalc_SecSchGradRigPct, RcvdRSdipRigPgmNo,
        HighSchSNo, HighSch5yrDEnrlNo, Part4ADeceasedNo
    )
write_xlsx(SecSchRigPctQdf, "SecSchRigPct.xlsx")

FAFSAdf <- df %>%
    select(
        SenrCompFASFAPNO, SenrCompFASFAenrlCollgPNO, TotKPNO,
        TOCalc_FAFSA
    )
write_xlsx(FAFSAdf, "FAFSA.xlsx")

PostSecEnrllPctDf <- df %>%
    select(
        TSObj_PostSecEnrllPct, TOCalc_PostSecEnrllPct,
        RcvdRSDipNo, RcvdRSdipRigPgmNo, Part4BRcvdRSDipNotStdNo,
        RcvdAltAwdNo, tot_RcvdRDipNO, tot_RcvdRDipRigPgmNo, 
        tot_Part4CRcvdRSDipNotStdNo, tot_RcvdHSEquCredNO
    )
write_xlsx(PostSecEnrllPctDf, "PostSecEnrllPct.xlsx")
