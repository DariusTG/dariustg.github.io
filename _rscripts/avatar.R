library(magrittr)
library(dplyr)
library(tidyr)
library(ggthemes)
av = readPNG("img/avatar-icon2.png")[,,1]
n_r = NROW(av)
n_c = NCOL(av)

#modinator = 2

#av = av[ifelse(1:n_r %% modinator ==1, T, F), ifelse(1:n_c %% modinator ==1, T, F)]

n_r = NROW(av)
n_c = NCOL(av)

av = cbind(1:n_r, av)
df.av = av %>% as.data.frame() %>% gather("rows", "cols", 2:(n_c+1))

df.av$rows = as.integer(gsub("V", "", df.av$rows))
colnames(df.av) = c("Y", "X", "COL")
df.av$COL = round(df.av$COL, 3)

lm_sum = df.av %>% filter(COL < .1) %$% lm(Y ~ X) %>% summary()

eq = substitute(~italic(r)^2~"="~r2, list(r2 = format(lm_sum$r.squared, digits = 3)))
eq_lab = as.character(as.expression(eq));  

ggplot(df.av) +
  geom_point(aes(x=X, y=Y, color=COL)) +
  annotate("text", label=eq_lab, x = n_c*.9, y = 10, color="white", parse=T, size=5.5)+
  scale_y_reverse() + 
  labs(title="", x="x", y="y", color="Col") +
  theme_classic() +
  theme(plot.title = element_text(size = rel(1.25), hjust = 0, face = "bold"))
  


