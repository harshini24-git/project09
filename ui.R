#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(fmsb)
library(plotly)
avg <- readRDS("data/data_9cat_avg_2018.rds")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("2017-2018 NBA Season: Average Player Statistics Per Game"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
          
    sidebarPanel(
       selectInput("player", "Player:", choices = avg$Player),
       
       hr(),
       
       htmlOutput("playerImage"),
       
       hr(),
        
       htmlOutput("text1"),
       hr()            
       
       
    
     
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        h3("Player Statistics"),
        tableOutput("average_stats"),
        h3("Player Strength Chart", align = "left"),
        plotOutput("radarchart"),
        htmlOutput("text2")
        
    )
  )
))
