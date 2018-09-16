Shiny Application and Reproducible Pitch:

Average NBA Player Statistics of the 2017-2018 Regular Season 
========================================================
author: Joseph Fabia
date: September 16, 2018
autosize: true
transition: 

Overview
========================================================
<font size = "5">
This presentation serves as pitch for a Shiny App that was created for the Developing Data Products online course in Coursera. The application is available at this [link], while the source code of the app is available at this [link](google.com). 

The inspiration for this project was my interest in Fantasy Basketball, which is based on statistical performance of NBA players. The shiny application is designed to provide the user a statistical overview of the an NBA player's performance during the 2017-2018 regular season. The app will prompt the user t select a player from a drop-down list of players who played. Once the user selects, the app will list out the following information:
- biographical information of the player (team, position, date of birth, height, weight)
- his per-game statistical averages across nine stat categories
- his rank relative to the players who were active during the 2017-2018 regular season
- a radar chart representing that player's statistical strengths relative to all other players
</font>

The Data
========================================================
<font size = "5">
Data is based on the 2017-2018 regular season total statistics data, which was retrieved from  [Basketball Reference](https://www.basketball-reference.com/). 

In order to scrape this data, the nbastatR package by [Alex Bresler](https://www.rdocumentation.org/collaborators/name/Alex%20Bresler) was used. Documentation to use this package is found [here](https://www.rdocumentation.org/packages/nbastatR/versions/0.1.110202031), and the actual code to retrieve this data is found [here](github link) for reference.

Because the data is based on total statistics in the season, it had to be transformed into average statistics. Some data cleanup was required to remove duplicates or NA values. 

In order to rank a player's statistical strength, a player's Standard Score for each stat category was calculated. More information on the Standard Score approach can be found [here](https://en.wikipedia.org/wiki/Standard_score). Also, in order to apply Standard Scoring to Field Goal Efficiency and Free Throw Efficiency, these had to be transformed into counting variables, the methods which are described in this [blog post](http://statdance.blogspot.com/2014/01/how-do-espn-and-yahoo-rank-fantasy.html) by [Michael Muskett](https://plus.google.com/117257364176035644864), and this [reddit link](https://www.reddit.com/r/fantasybball/comments/71bdq0/how_to_calculate_weighted_zscore_for_fg/dn9javm/) by reddit user [nwsy96](https://www.reddit.com/user/nwsy96).

The actual code used to transform, clean and rank the data is found [here](insert link)

</font>

Slide With Code
========================================================

```{r}
avg <- readRDS("data/data_9cat_avg_2018.rds")
zscore_avg <- readRDS("data/zscore_9cat_avg_2018.rds")
summary(avg)
```

Slide With Plot
========================================================

```{r, echo=FALSE}
plot(cars)
```
