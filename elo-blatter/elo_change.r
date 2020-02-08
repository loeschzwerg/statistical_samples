library(ggplot3)
library(countrycode)
# if you don't want to install ggflags (https://github.com/rensa/ggflags), skip
# install.packages('devtools')
# library(devtools)
# install_github("rensa/ggflags")
library(ggflags)
elo <- read.csv("C:\\Users\\tim_n\\Documents\\GitHub\\data\\elo-blatter\\elo_blatter.csv")

# measuring relative improvement
elo$improvement <- elo$elo15 - elo$elo98
gap <- max(elo$improvement, na.rm = TRUE) - min(elo$improvement, na.rm = TRUE)

elo$code <- countrycode(elo$country, 'country.name', 'iso2c')

p1 <- ggplot(aes(x = elo98, y = elo15),
            data = elo,
            na.rm = TRUE) +
  labs(x=1998, y=2015) +
  ggtitle('\u26BD ELO score change from 1998 to 2015')

p.abbreviations <- p1 + 
  geom_jitter(aes(shape = confederation, color = improvement)) +
  scale_color_viridis_c(option = "C") +
  geom_text(aes(label = code),
            size=2,
            vjust=-1,
            position=position_nudge(x=1)) +
  labs(colour="Improvement", shape="Confederation")

p.abbreviations

# --- and remove this  
p.flags <- p1 +
  geom_flag(aes(country=tolower(elo$code),
            size=improvement),
            position=position_dodge(width=1)) +
  labs(size="Improvement")

p.flags