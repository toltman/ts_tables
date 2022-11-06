library(tidyverse)
library(readxl)
library(here)

df <- read_excel(here::here("Data", "Data 2020-21", "TS2.xlsx"))

head(df)

df %>%
    summarise(PartFundNO = sum(PartFundNO))

status <- df %>%
    summarise(
        NewPNO = sum(NewPNO),
        ConPNO = sum(ConPNO),
    )

status <- df %>%
    summarise(across(NewPNO:ConPNO, sum))
status %>%
    pivot_longer(NewPNO:ConPNO, names_to = "char", values_to = "value")

gender <- df %>%
    summarise(across(MalePNO:FemalePNO, sum))
gender

raceth <- df %>%
    summarise(across(AmIndPNO:UnknownPNO, sum))
raceth

eligib <- df %>%
    summarise(across(LowFirstPNO:OtherPNO, sum))
eligib


status <- df %>%
    select(PRNO, NewPNO:ConPNO) %>%
    pivot_longer(
        NewPNO:ConPNO,
        names_to = "variable",
        values_to = "value"
    )

status %>%
    group_by(variable) %>%
    summarise(total = sum(value))

df %>%
    select(
        PRNO,
        NewPNO:ConPNO,
        MalePNO:FemalePNO,
        AmIndPNO:UnknownPNO,
        LowFirstPNO:OtherPNO,
        Age10_13PNO:AgeUnknowPNO,
        VetPNO,
        LimEngPNO,
        DualEnrlPNO,
        UpwardBoundPNO:FedFundPgmMorePNO
    ) %>%
    pivot_longer(
        -PRNO,
        names_to = "char",
        values_to = "value"
    ) %>%
    group_by(char) %>%
    summarise(total = sum(value))


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
