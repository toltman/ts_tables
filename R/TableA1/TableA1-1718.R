library(tidyverse)
library(readxl)
library(here)

df1 <- read_excel(here::here("Data", "Data 2017-18", "FY2017TSFundedDetails-MinSecReg.xlsx"))
df2 <- read_excel(here::here("Data", "Data 2017-18", "tblTS2 2017-18.xlsx"))
df3 <- read_excel(here::here("Data", "Data 2017-18", "tblTS3 2017-18.xlsx"))

df1 <- df1 %>%
    select(PRNo, Sector)

df2 <- df2 %>%
    mutate(
        FedFundPgmNone = TotPNO - (UpwardBoundPNO + UpwardBoundMathSciPNO +
        VetUpwardBoundPNO + GEARUPPNO + FedFundPgmMorePNO +
        FedFundPgmOtherPNO)
    ) %>%
    select(
        PRNO,
        TotPNO,
        NewPNO, ConPNO,
        FemalePNO, MalePNO,
        AmIndPNO, AsianPNO, AfrAmPNo, HispPNO, HawPNO,
        WhitePNO, MorePNO, UnknownPNO,
        LowFirstPNO, LowPNO, FirstPNO, OtherPNO,
        Age10_13PNO, Age14_18PNO, Age19_27PNO, Age28UpPNO, AgeUnknowPNO,
        VetPNO,
        LimEngPNO,
        DualEnrlPNO,
        UpwardBoundPNO, UpwardBoundMathSciPNO, VetUpwardBoundPNO, GEARUPPNO,
        FedFundPgmMorePNO, FedFundPgmOtherPNO, FedFundPgmNone
    )

df3 <- df3 %>%
    select(
        PRNo,
        MidSchNo,
        HighSchFshNo,
        HighSchSophNo,
        HighSchJrNo,
        HighSchSNo,
        PartAltProgNo,
        HighSch4yrDEnrlNo,
        HighSch5yrDEnrlNo,
        SecSchDropNo,
        Part3AOtherNo,
        Part3AUnknownNo
    )

df2 <- df2 %>%
    full_join(df3, by = c("PRNO" = "PRNo"))

df <- df1 %>%
    right_join(df2, by = c("PRNo" = "PRNO"))

df <- df %>%
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

totdf1718 <- df %>%
    group_by(Sector) %>%
    summarise(total = sum(TotPNO))

tot1718 <- split(totdf1718$total, totdf1718$Sector)

df_1718 <- df %>%
    group_by(Sector) %>%
    summarise(across(-PRNo, sum)) %>%
    select(-Sector) %>%
    t() %>%
    as.data.frame()

colnames(df_1718) <- c("four_year1718", "two_year1718", "other1718")

df_1718 <- df_1718 %>%
    mutate(pct_four_year1718 = four_year1718 / tot1718$four_year) %>%
    mutate(pct_two_year1718 = two_year1718 / tot1718$two_year) %>%
    mutate(pct_other1718 = other1718 / tot1718$other)
