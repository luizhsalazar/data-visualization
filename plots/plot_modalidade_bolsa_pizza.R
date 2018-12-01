## importando pacotes
library(ggplot2)
library(plyr)
library(dplyr)
library(lubridate)

Sys.setlocale("LC_ALL", "pt_BR.UTF-8")

todososdados01 <- readRDS("dados.rds")

#todososdados01 <- read.csv("~/Desktop/data-visualization/todososdados01.csv", sep=";")



##tema dor ggplot2
seta <- grid::arrow (length = grid::unit(0.2, "cm"), type = "open")
my_theme <- function(base_size = 14, base_family = "Arial") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(axis.ticks = element_blank(),
          axis.line = element_line(arrow = seta, color = "white"),
          legend.background = element_blank(),
          legend.key = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank(),
          strip.background = element_blank(),
          plot.background = element_blank(),
          plot.title = element_text(hjust =),
          panel.grid = element_blank(),
          complete = TRUE)
} 



df <- as.data.frame(table(todososdados01$MODALIDADE_ENSINO_BOLSA))
df$porcentagem = round(df$Freq*100/sum(df$Freq),1)
rotulos<-paste("(",df$porcentagem,"%)",sep=" ")
colnames(df) <- c("Modalidade_Ensino", "Total", "Porcentagem")

## Etapa 01...
pie_modalidade_bolsa <- ggplot(df, aes(x = "", y=Porcentagem, fill = factor(Modalidade_Ensino))) +
  geom_bar(width = 1, stat = "identity") +
  theme(axis.line = element_blank(),
        plot.title = element_text()) +
  labs(fill = "",
       x = NULL,
       y = NULL,
       title = "Modalidade de Ensino de 2005 à 2016",
       caption = "Fonte: http://dados.gov.br/dataset/mec-prouni") 

pie_modalidade_bolsa + coord_polar(theta = "y", start = 0) +
  my_theme()
