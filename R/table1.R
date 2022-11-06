library(tidyverse)
library(readxl)
library(here)

df <- read_excel(here::here("Data", "Data 2020-21", "TS2.xlsx"))

df %>%
    mutate(
        FedFundPgmNone = TotPNO - (UpwardBoundPNO + UpwardBoundMathSciPNO +
        VetUpwardBoundPNO + GEARUPPNO + FedFundPgmMorePNO +
        FedFundPgmOtherPNO)
    ) %>%
    select(
        PRNO,
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
    ) %>%
    summarise(across(-PRNO, sum)) %>%
    pivot_longer(everything(), names_to = "char", values_to = "2020-21")
