library(ggplot2)
library(ggcorrplot)
library(ggalt)
library(ggExtra)
library(ggthemes)
library(ggplotify)
library(treemapify)
library(dplyr)
library(scales)
library(plyr)
library(zoo)
library(lubridate)
detach("package:plyr", unload=TRUE) 

Sys.setlocale("LC_ALL", 'pt_BR.UTF-8')

##tema dor ggplot2
seta <- grid::arrow (length = grid::unit(0.2, "cm"), type = "open")
my_theme <- function(base_size = 14, base_family = "Arial") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(axis.ticks = element_blank(),
          axis.line = element_line(arrow = seta, color = "gray20"),
          legend.background = element_blank(),
          legend.key = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank(),
          strip.background = element_blank(),
          plot.background = element_blank(),
          plot.title = element_text(hjust =1),
          panel.grid = element_blank(),
          complete = TRUE)
} 

prouni <- read.csv("../todososdados01.csv", sep=";")
prouni <- prouni[prouni$SIGLA_UF_BENEFICIARIO_BOLSA != '', ]

bolsistas_por_sexo <- prouni %>%
  group_by_(.dots=c("ANO_CONCESSAO_BOLSA", "SEXO_BENEFICIARIO_BOLSA")) %>% 
  summarize(total = n()) %>%
  as.data.frame()

plot_sexo_por_ano <- ggplot() +
  geom_line(data = bolsistas_por_sexo,
            aes(x = ANO_CONCESSAO_BOLSA, y = total, color = SEXO_BENEFICIARIO_BOLSA)) +

  geom_point(data = bolsistas_por_sexo, aes(x = ANO_CONCESSAO_BOLSA, y = total), 
             pch = 1, alpha = 0.8, size = 3) +
  labs(x = "Ano", y = "Número de bolsistas", col = "Sexo") +
  scale_x_continuous(limits = c(2005, 2016), breaks = seq(2005, 2016, 1)) +
  scale_y_continuous(limits = c(0, 150000)) + 
  theme_gray(base_size = 16) +
  my_theme()

plot_sexo_por_ano
