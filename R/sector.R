library(tidyverse)
library(readxl)
library(here)

# Sector data
df1 <- read_excel(here::here(
    "Data",
    "Data 2020-21",
    "FY2020TSFundedDetails-MinSecReg.xlsx"
))

df1 <- df1 %>%
  select(PRNo, Sector)

# Most data for Table A1
df2 <- read_excel(here::here("Data", "Data 2020-21", "TS2.xlsx"))

df2 <- df2 %>%
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
    )

# Ed status data
df_edu <- read_excel(here::here(
    "Data",
    "Data 2020-21",
    "TS3.xlsx"
))

df_edu <- df_edu %>%
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
  full_join(df_edu, by = c("PRNO" = "PRNo"))


df <- df1 %>%
    full_join(df2, by = c("PRNo" = "PRNO"))

df_sec <- df %>%
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

t_df <- df_sec %>%
  group_by(Sector) %>%
  summarise(across(-PRNo, sum)) %>%
  select(-Sector) %>%
  t() %>%
  as.data.frame()

colnames(t_df) <- c("four_year", "two_year", "other")


