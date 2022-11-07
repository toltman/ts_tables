library(tidyverse)
library(readxl)
library(here)

df1 <- read_excel(here::here("Data", "Data 2020-21", "FY2020TSFundedDetails-MinSecReg.xlsx"))
df2 <- read_excel(here::here("Data", "Data 2020-21", "TS2.xlsx"))
df3 <- read_excel(here::here("Data", "Data 2020-21", "TS3.xlsx"))

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
    full_join(df2, by = c("PRNo" = "PRNO"))

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

totdf2021 <- df %>%
    group_by(Sector) %>%
    summarise(total = sum(TotPNO))

tot2021 <- split(totdf2021$total, totdf2021$Sector)

df_2021 <- df %>%
    group_by(Sector) %>%
    summarise(across(-PRNo, sum)) %>%
    select(-Sector) %>%
    t() %>%
    as.data.frame()

colnames(df_2021) <- c("four_year2021", "two_year2021", "other2021")

df_2021 <- df_2021 %>%
    mutate(pct_four_year2021 = four_year2021 / tot2021$four_year) %>%
    mutate(pct_two_year2021 = two_year2021 / tot2021$two_year) %>%
    mutate(pct_other2021 = other2021 / tot2021$other)

