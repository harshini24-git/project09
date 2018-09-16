detachAllPackages <- function() {
        
        basic.packages <- c("package:stats","package:graphics","package:grDevices","package:utils","package:datasets","package:methods","package:base")
        
        package.list <- search()[ifelse(unlist(gregexpr("package:",search()))==1,TRUE,FALSE)]
        
        package.list <- setdiff(package.list,basic.packages)
        
        if (length(package.list)>0)  for (package in package.list) detach(package, character.only=TRUE)
        
}

detachAllPackages()


require(data.table)
require(nbastatR)


# Get all the NBA statistics from Basketball Reference.com, from 2000 to 2018

for (i in 2017:2018) {
        var1 <- paste("nba_stats_", i, sep = "")
        var2 <- paste("nba_bios_", i, sep = "")
        
        nba_stats <- 
                as.data.frame(get_bref_players_seasons(seasons = i, 
                                                       tables = c("advanced", "totals")))
        nba_bios <- as.data.frame(
                get_players_profiles(players = nba_stats$namePlayer,
                                     player_ids = NULL))
        
        
        assign(var1, nba_stats)
        assign(var2, nba_bios)
        
        
        
        saveRDS(nba_stats, file = paste("nba_stats_",i,".rds", sep = "") )
        saveRDS(nba_bios, file = paste("nba_bios_",i,".rds", sep = "") )
        
}

for (i in 2017:2018) {
        var <- paste("nba_bios_", i, sep = "")
        nba_bios <- 
                
                assign(var, nba_stats)
        saveRDS(nba_stats, file = paste("nba_stats_",i,".rds", sep = "") )
        
}