library(ggplot2)
library(countrycode)
library(ggflags)
library(dplyr)
library(spData)
elo <- read.csv("elo_blatter.csv")

elo$ccode <- tolower(countrycode(elo$country, 'country.name', 'iso2c'))
p.elo_popu <- ggplot(aes(x=elo15, y=log(popu06)), data=elo) +
  geom_flag(country=elo$ccode)

p.elo_popu
