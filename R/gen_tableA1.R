library(tidyverse)
library(readxl)
library(here)

gen_table <- function(sector_file, ts2_file, ts3_file) {
    df1 <- read_excel(sector_file)
    df2 <- read_excel(ts2_file)
    df3 <- read_excel(ts3_file)

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

    t_df <- df %>%
        group_by(Sector) %>%
        summarise(across(-PRNo, sum)) %>%
        select(-Sector) %>%
        t() %>%
        as.data.frame()

    colnames(t_df) <- c("four_year", "two_year", "other")

    return(t_df)
}

gen_file_names <- function(dir, file1, file2, file3) {
    f1 <- here::here("Data", dir, file1)
    f2 <- here::here("Data", dir, file2)
    f3 <- here::here("Data", dir, file3)
    return (c(f1, f2, f3))
}

files_2021 <- gen_file_names(
    "Data 2020-21",
    "FY2020TSFundedDetails-MinSecReg.xlsx",
    "TS2.xlsx",
    "TS3.xlsx"
)

files_1920 <- gen_file_names(
    "Data 2019-20",
    "FY2019TSFundedDetails-MinSecReg.xlsx",
    "TS2 2019-20.xlsx",
    "TS3 2019-20.xlsx"
)

files_1819 <- gen_file_names(
    "Data 2018-19",
    "FY2018TSFundingDetails-MinSecReg.xlsx",
    "TS2 2018-19.xlsx",
    "TS3 2018-19.xlsx"
)

files_1718 <- gen_file_names(
    "Data 2017-18",
    "FY2017TSFundedDetails-MinSecReg.xlsx",
    "tblTS2 2017-18.xlsx",
    "tblTS3 2017-18.xlsx"
)

files_1617 <- gen_file_names(
    "Data 2016-17",
    "FY2016TSFundedDetails-MinSecReg.xlsx",
    "tblTS2 2016-17.xlsx",
    "tblTS3 2016-17.xlsx"
)

df_2021 <- gen_table(files_2021[1], files_2021[2], files_2021[3])
df_1920 <- gen_table(files_1920[1], files_1920[2], files_1920[3])
df_1819 <- gen_table(files_1819[1], files_1819[2], files_1819[3])
df_1718 <- gen_table(files_1718[1], files_1718[2], files_1718[3])
df_1617 <- gen_table(files_1617[1], files_1617[2], files_1617[3])
