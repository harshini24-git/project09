#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(fmsb)
library(plotly)

general <- readRDS("data/data_9cat_general_2018.rds")
avg <- readRDS("data/data_9cat_avg_2018.rds")
zscore_avg <- readRDS("data/zscore_9cat_avg_2018.rds")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
        
    
  
  
  output$playerImage <- renderText({
          bio <- general[which(general$namePlayer == input$player),]
          
          src <- gsub("http","https",bio$urlPlayerThumbnail.y)
          
          c('<img src="',src,'">')
          })
        
  
  output$text1 <- renderUI({
          bio <- general[which(general$namePlayer == input$player),]
          textName <- paste("<b>", bio$namePlayer, "</b>",
                            bio$slugTeam, ", " , bio$idPosition, "<br>",
                            "<b>Date of Birth: </b>", bio$dateBirth, "<br>",
                            "<b>Height: </b>", bio$heightInches, "in.", 
                            "<br>",
                            "<b>Weight: </b>", bio$weightLBS, "lbs")
          HTML(paste(textName))
          
  })
  
  
  output$average_stats <- renderTable({
          display <- avg[which(avg$Player == input$player),]
          columns <- c("Rank", "GP", "Minutes", "FGP","FTP","PT3","PTS","REB","AST","STL","BLK","TOV")
          
          display[,columns]
          
  })
  
  output$radarchart <- renderPlot({
          
          zscore_min <- 
                  data.frame(matrix(unlist(lapply(zscore_avg[,2:10], min)),nrow = 1))
          
          colnames(zscore_min) <- c("FGP","FTP","3PM","PTS","REB","AST","STL","BLK","TOV")
          
          
          zscore_max <- 
                  data.frame(matrix(unlist(lapply(zscore_avg[,2:10], max)),nrow = 1))
          colnames(zscore_max) <- c("FGP","FTP","3PM","PTS","REB","AST","STL","BLK","TOV")
          
          zscore_player <- 
                  zscore_avg[which(zscore_avg$Player == input$player),2:10]
          colnames(zscore_player) <- c("FGP","FTP","3PM","PTS","REB","AST","STL","BLK","TOV")
          
          data <- NULL
          data <- rbind(
                  zscore_max,
                  zscore_min,
                  zscore_player
          )
          
          # Spider Charting

          radarchart(data)
  })
  
  output$text2 <- renderUI({
          
          textName <- paste("<b> Notes: </b>",
                            "<br> ", 
                            "<i>GP = Games Played; </i>",
                            "<i>FGP = Field Goal Percentage; </i>",
                            "<i>FTP = Free Throw Percentage; </i>",
                            "<i>PT3 = 3-Pointers Made; </i>",
                            "<i>PTS = Points; </i>",
                            "<i>REB = Rebounds; </i>",
                            "<i>AST = Assists; </i>",
                            "<i>STL = Steals; </i>",
                            "<i>BLK = Blocks; </i>",
                            "<i>TOV = Turnovers; </i>")
                            
          HTML(paste(textName))
          
  })

  output$text3 <- renderUI({
          
          textName <- paste("<b>Documentation</b>",
                            "<br> ", 
                            "This shiny app is used to evaluate an NBA Player's
                            average statistics per game across nine categories. Six of
                                these categories are counting stats - Points, Rebounds,
                                Assists, Steals, Blocks and Three-pointers made. The
                                remaining categores are Efficiency stats - Field Goal
                                Percentage, Free Throw Percentage and Turnovers. The
                            user should select the NBA player from the drop down menu.
                            <br><br>
                            Once the user selects a player from the drop down menu,
                            the following are displayed:<br>
                            - Some biographical information of the NBA player, including 
                            team, position, date of birth, height and weight;<br>
                            - Average statistics per game, including overall rank relative to
                            the league; <<br>
                            - A radar chart that determines the player's strengths based on his
                            statistics."
                           )
          
          HTML(paste(textName))
          
  })
  
  
})
