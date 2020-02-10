library(ggplot2)
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

# dot plot flags: make discrete with estimate flag size, set height manually
elo$d.improve <- sapply(elo$improvement, function(x)(x%/%50)*50)
elo$height <- vector(mode='integer', length(elo$improvement))
d.table <- table(elo$d.improve)
for (i in seq_along(elo$d.improve)){
  if (!is.na(elo$d.improve[i])){
    d.table[[toString(elo$d.improve[i])]] - 1 ->
      d.table[[toString(elo$d.improve[i])]] ->
      elo$height[i]
  }
}
p.distribution <- ggplot(aes(x=factor(d.improve), y=height), data=elo) +
  geom_flag(country=tolower(elo$code)) +
  xlab("ELO Score Change") +
  ylab("Count")

p.distribution
