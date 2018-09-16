
# Section 1: Preparing the Data and Required Library Dependencies
rm(list = ls())

require(dplyr)
require(plyr)
require(plotly)
require(fmsb)

# 1.A: Load the data used for this analysis

data_2018 <- readRDS(file = "nba_stats_2018.rds")
bios <- readRDS(file = "nba_bios_2018.rds")
data_2018$idPlayer <- data_2018$idPlayerNBA     

# 1.B: Merge the data used for this analysis
bios_main_merge <- merge(data_2018, bios, by = "idPlayer")


# 1.C: Select the variables necessary, drop the rest
# Remove any rows that have NA data in the analysis
# For 'idPosition', if the player has multiple combinations, 
# designate the lower(est) position as the value. [Ex: PG-SG is PG]

myVariables_General <- c("namePlayer.x", "idPosition",
                         "urlPlayerThumbnail.y", 
                         "dateBirth", "heightInches", "weightLBS", "slugTeam",
                         "countGames", "minutesTotals", 
                         "fgmTotals", "fgaTotals",
                         "ftmTotals", "ftaTotals", 
                         "pctFG", "pctFT", "fg3mTotals",
                         "ptsTotals", "trbTotals", "astTotals", 
                         "stlTotals","blkTotals", "tovTotals"
)

data_9cat_general <- bios_main_merge[myVariables_General]

data_9cat_general <- data_9cat_general[complete.cases(data_9cat_general), ]

data_9cat_general$idPosition <- gsub("PG-SG","PG",data_9cat_general$idPosition)
data_9cat_general$idPosition <- gsub("SG-SF","SG",data_9cat_general$idPosition)
data_9cat_general$idPosition <- gsub("SF-PF","SF",data_9cat_general$idPosition)
data_9cat_general$idPosition <- gsub("PF-C","PF",data_9cat_general$idPosition)



# for excel checking
write.csv(data_9cat_general, file = "nba_data_main_2018.csv")

# SECTION 2: TABLE CREATIONS
#
# This section will be used to create the tables for our app.
# All tables will be based off the data_9cat_general tabl
#
# 1/data_9cat_total: Contains season totals
# 2/data_9cat_avg: Contains per game averages
# 3/zscore_9cat_total: Contains z-scores of totals
# 4/zscore_9cat_avg: Contains z-scores of per-game averages


# Table 1 Construction

myVariables.1.1 <- c("namePlayer.x",
                     "minutesTotals", "countGames",
                     "fgmTotals", "fgaTotals",
                     "ftmTotals", "ftaTotals",
                     "pctFG", "pctFT", "fg3mTotals",
                     "ptsTotals", "trbTotals", "astTotals", 
                     "stlTotals","blkTotals", "tovTotals")

data_9cat_total <- NULL
data_9cat_total <- data_9cat_general[myVariables.1.1]
colnames(data_9cat_total) <- c("Player","Minutes", "GP",
                               "FGM","FGA","FTM","FTA",
                               "FGP", "FTP", "PT3",
                               "PTS","REB","AST",
                               "STL","BLK","TOV")

# Table 2 Construction

data_9cat_avg <- NULL
data_9cat_avg <- data_9cat_total
data_9cat_avg$Minutes <- (data_9cat_avg$Minutes / data_9cat_avg$GP)
data_9cat_avg$FGM <- (data_9cat_avg$FGM / data_9cat_avg$GP)
data_9cat_avg$FGA <- (data_9cat_avg$FGA / data_9cat_avg$GP)
data_9cat_avg$FTM <- (data_9cat_avg$FTM / data_9cat_avg$GP)
data_9cat_avg$FTA <- (data_9cat_avg$FTA / data_9cat_avg$GP)

data_9cat_avg$FGP <- data_9cat_avg$FGM / data_9cat_avg$FGA
data_9cat_avg$FTP <- data_9cat_avg$FTM / data_9cat_avg$FTA
data_9cat_avg$PT3 <- (data_9cat_avg$PT3 / data_9cat_avg$GP)

data_9cat_avg$PTS <- (data_9cat_avg$PTS / data_9cat_avg$GP)
data_9cat_avg$REB <- (data_9cat_avg$REB / data_9cat_avg$GP)
data_9cat_avg$AST <- (data_9cat_avg$AST / data_9cat_avg$GP)

data_9cat_avg$STL <- (data_9cat_avg$STL / data_9cat_avg$GP)
data_9cat_avg$BLK <- (data_9cat_avg$BLK / data_9cat_avg$GP)
data_9cat_avg$TOV <- (data_9cat_avg$TOV / data_9cat_avg$GP)


colnames(data_9cat_avg) <- c("Player","Minutes", "GP",
                             "FGM","FGA","FTM","FTA",
                             "FGP", "FTP", "PT3",
                             "PTS","REB","AST",
                             "STL","BLK","TOV")

# That completes the table; write the data for reference
write.csv(data_9cat_avg, file = "nba_data_avg_2018.csv")

# Table 3 Construction


# To create the Totals Zscore table, we need first to calculate some global variables

# Set the global parameters for the Z-score tables
# There are X teams and Y players per team, so we need the top Z = X * Y players

No_Teams = 12
No_Players = 13
No_Top_Players = No_Teams * No_Players

# Let LFGM_total, LFGA_total, and LFGP_total denote the League's total
# Field Goals Made, Field Goals Attempted, and Field Goal Percentage, respectively
# Likewise, Let LFTM_total, LFTA_total, and LFTP_total denote the League's total
# Free throws Made, Free throws Attempted, and Free throw Percentage, respectively

ColSum_9cat_total <- as.matrix(colSums(data_9cat_total[,2:16]))
LFGM_total <- as.numeric(ColSum_9cat_total[3,1])
LFGA_total <- as.numeric(ColSum_9cat_total[4,1])
LFGP_total <- LFGM_total / LFGA_total
LFTM_total <- as.numeric(ColSum_9cat_total[5,1])
LFTA_total <- as.numeric(ColSum_9cat_total[6,1])
LFTP_total <- LFTM_total / LFTA_total

# Create two columns that respectively calculate:
# FGOP, the percentage points which a player's Field Goal is Over the League Percentage
# FTOP, the percentage points which a player's Free Throw Percentage is over the League Percentage

data_9cat_total$FGOP <- as.numeric(data_9cat_total$FGP - LFGP_total)
data_9cat_total$FTOP <- as.numeric(data_9cat_total$FTP - LFTP_total)

# To calculate the _impact_ of each difference, multiply the respective
# "Over Percentage" to the number of attempts

data_9cat_total$FGOPxA <- data_9cat_total$FGOP * data_9cat_total$FGA
data_9cat_total$FTOPxA <- data_9cat_total$FTOP * data_9cat_total$FTA

# Initially we rank the data by total number of minutes played
data_9cat_total$Rank <- rank(-data_9cat_total$Minutes, ties.method = 'first')
data_9cat_total <- data_9cat_total[order(data_9cat_total$Rank),]

# Create a dummy table, data_9cat_total_rank, that will store the ranking of the top players

data_9cat_total_top <- data_9cat_total[
        which(data_9cat_total$Rank <= No_Top_Players),
        c("Rank","Player")]

temp_total_top <- NULL

# This is where the loop will start
while(!identical(temp_total_top, data_9cat_total_top)){
        
        temp_total_top <- data_9cat_total_top
        
        data_9cat_total_means <- 
                sapply(
                        data_9cat_total[which(data_9cat_total$Rank <= No_Top_Players), 4:21],
                        mean
                        
                )
        
        data_9cat_total_sd <-
                sapply(
                        data_9cat_total[which(data_9cat_total$Rank <= No_Top_Players), 4:21],
                        sd
                )
        
        
        zscore_9cat_total <- 
                data_9cat_total[,c("Player",
                                   "FGOPxA","FTOPxA",
                                   "PT3","PTS","REB","AST",
                                   "STL","BLK","TOV")]
        
        zscore_9cat_total$FGOPxA <- (zscore_9cat_total$FGOPxA - data_9cat_total_means[c("FGOPxA")]) / data_9cat_total_sd[c("FGOPxA")]
        zscore_9cat_total$FTOPxA <- (zscore_9cat_total$FTOPxA - data_9cat_total_means[c("FTOPxA")]) / data_9cat_total_sd[c("FTOPxA")]
        zscore_9cat_total$PT3 <- (zscore_9cat_total$PT3 - data_9cat_total_means[c("PT3")]) / data_9cat_total_sd[c("PT3")]
        zscore_9cat_total$PTS <- (zscore_9cat_total$PTS - data_9cat_total_means[c("PTS")]) / data_9cat_total_sd[c("PTS")]
        zscore_9cat_total$REB <- (zscore_9cat_total$REB - data_9cat_total_means[c("REB")]) / data_9cat_total_sd[c("REB")]
        zscore_9cat_total$AST <- (zscore_9cat_total$AST - data_9cat_total_means[c("AST")]) / data_9cat_total_sd[c("AST")]
        zscore_9cat_total$STL <- (zscore_9cat_total$STL - data_9cat_total_means[c("STL")]) / data_9cat_total_sd[c("STL")]
        zscore_9cat_total$BLK <- (zscore_9cat_total$BLK - data_9cat_total_means[c("BLK")]) / data_9cat_total_sd[c("BLK")]
        zscore_9cat_total$TOV <- -(zscore_9cat_total$TOV - data_9cat_total_means[c("TOV")]) / data_9cat_total_sd[c("TOV")]
        
        
        zscore_9cat_total$ZTotal <- rowSums(zscore_9cat_total[,2:10])
        
        data_9cat_total$Rank <-  rank(-zscore_9cat_total$ZTotal, ties.method = 'first')
        data_9cat_total <- data_9cat_total[order(data_9cat_total$Rank),]
        
        data_9cat_total_top <- data_9cat_total[
                which(data_9cat_total_top$Rank <= No_Top_Players),
                c("Rank","Player")]
        
        
        
}
# End the loop here

# Table 4 Construction

# Let LFGM_avg, LFGA_avg, and LFGP_avg denote the League's average
# Field Goals Made, Field Goals Attempted, and Field Goal Percentage, respectively
# Likewise, Let LFTM_avg, LFTA_avg, and LFTP_avg denote the League's average
# Free throws Made, Free throws Attempted, and Free throw Percentage, respectively

ColSum_9cat_avg <- as.matrix(colSums(data_9cat_avg[,2:16]))
LFGM_avg <- as.numeric(ColSum_9cat_avg[3,1])
LFGA_avg <- as.numeric(ColSum_9cat_avg[4,1])
LFGP_avg <- LFGM_avg / LFGA_avg
LFTM_avg <- as.numeric(ColSum_9cat_avg[5,1])
LFTA_avg <- as.numeric(ColSum_9cat_avg[6,1])
LFTP_avg <- LFTM_avg / LFTA_avg

# Create two columns that respectively calculate:
# FGOP, the percentage points which a player's Field Goal is Over the League Percentage
# FTOP, the percentage points which a player's Free Throw Percentage is over the League Percentage

data_9cat_avg$FGOP <- as.numeric(data_9cat_avg$FGP - LFGP_avg)
data_9cat_avg$FTOP <- as.numeric(data_9cat_avg$FTP - LFTP_avg)

# To calculate the _impact_ of each difference, multiply the respective
# "Over Percentage" to the number of attempts

data_9cat_avg$FGOPxA <- data_9cat_avg$FGOP * data_9cat_avg$FGA
data_9cat_avg$FTOPxA <- data_9cat_avg$FTOP * data_9cat_avg$FTA

# Initially we rank the data by total number of minutes played
data_9cat_avg$Rank <- rank(-data_9cat_avg$Minutes, ties.method = 'first')
data_9cat_avg <- data_9cat_avg[order(data_9cat_avg$Rank),]

# Create a dummy table, data_9cat_avg_rank, that will store the ranking of the top players

data_9cat_avg_top <- data_9cat_avg[
        which(data_9cat_avg$Rank <= No_Top_Players),
        c("Rank","Player")]

temp_avg_top <- NULL

# This is where the loop will start
while(!identical(temp_avg_top, data_9cat_avg_top)){
        
        temp_avg_top <- data_9cat_avg_top
        
        data_9cat_avg_means <- 
                sapply(
                        data_9cat_avg[which(data_9cat_avg$Rank <= No_Top_Players), 4:21],
                        mean
                        
                )
        
        data_9cat_avg_sd <-
                sapply(
                        data_9cat_avg[which(data_9cat_avg$Rank <= No_Top_Players), 4:21],
                        sd
                )
        
        
        zscore_9cat_avg <- 
                data_9cat_avg[,c("Player",
                                 "FGOPxA","FTOPxA",
                                 "PT3","PTS","REB","AST",
                                 "STL","BLK","TOV")]
        
        zscore_9cat_avg$FGOPxA <- (zscore_9cat_avg$FGOPxA - data_9cat_avg_means[c("FGOPxA")]) / data_9cat_avg_sd[c("FGOPxA")]
        zscore_9cat_avg$FTOPxA <- (zscore_9cat_avg$FTOPxA - data_9cat_avg_means[c("FTOPxA")]) / data_9cat_avg_sd[c("FTOPxA")]
        zscore_9cat_avg$PT3 <- (zscore_9cat_avg$PT3 - data_9cat_avg_means[c("PT3")]) / data_9cat_avg_sd[c("PT3")]
        zscore_9cat_avg$PTS <- (zscore_9cat_avg$PTS - data_9cat_avg_means[c("PTS")]) / data_9cat_avg_sd[c("PTS")]
        zscore_9cat_avg$REB <- (zscore_9cat_avg$REB - data_9cat_avg_means[c("REB")]) / data_9cat_avg_sd[c("REB")]
        zscore_9cat_avg$AST <- (zscore_9cat_avg$AST - data_9cat_avg_means[c("AST")]) / data_9cat_avg_sd[c("AST")]
        zscore_9cat_avg$STL <- (zscore_9cat_avg$STL - data_9cat_avg_means[c("STL")]) / data_9cat_avg_sd[c("STL")]
        zscore_9cat_avg$BLK <- (zscore_9cat_avg$BLK - data_9cat_avg_means[c("BLK")]) / data_9cat_avg_sd[c("BLK")]
        zscore_9cat_avg$TOV <- -(zscore_9cat_avg$TOV - data_9cat_avg_means[c("TOV")]) / data_9cat_avg_sd[c("TOV")]
        
        
        zscore_9cat_avg$ZTotal <- rowSums(zscore_9cat_avg[,2:10])
        
        data_9cat_avg$Rank <-  rank(-zscore_9cat_avg$ZTotal, ties.method = 'first')
        data_9cat_avg <- data_9cat_avg[order(data_9cat_avg$Rank),]
        
        data_9cat_avg_top <- data_9cat_avg[
                which(data_9cat_avg_top$Rank <= No_Top_Players),
                c("Rank","Player")]
        
        
        
}

# Rename the row names for the tables

rownames(data_9cat_avg) <- 1:nrow(data_9cat_avg)
rownames(zscore_9cat_avg) <- 1:nrow(zscore_9cat_avg)
rownames(data_9cat_total) <- 1:nrow(data_9cat_total)
rownames(zscore_9cat_total) <- 1:nrow(zscore_9cat_total)


# Let's save the tables in a separate RDS
saveRDS(data_9cat_general, 'data_9cat_general_2018.rds')
saveRDS(data_9cat_total, 'data_9cat_total_2018.rds')
saveRDS(data_9cat_avg, 'data_9cat_avg_2018.rds')
saveRDS(zscore_9cat_total, 'zscore_9cat_total_2018.rds')
saveRDS(zscore_9cat_avg, 'zscore_9cat_avg_2018.rds')

