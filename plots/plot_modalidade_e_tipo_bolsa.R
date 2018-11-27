## importando pacotes
library(ggplot2)
library(dplyr)
library(lubridate)

Sys.setlocale("LC_ALL", "pt_BR.UTF-8")

detach("package:plyr", unload=TRUE) 

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

todososdados01 <- readRDS("dados.rds")

tab_tipo_bolsa <- todososdados01 %>%
  group_by_(.dots=c("ANO_CONCESSAO_BOLSA","TIPO_BOLSA")) %>% 
  summarize(total = n()) %>%
  as.data.frame()

tab_modalidade_bolsa <- todososdados01 %>%
  group_by_(.dots=c("ANO_CONCESSAO_BOLSA","MODALIDADE_ENSINO_BOLSA")) %>% 
  summarize(total = n()) %>%
  as.data.frame()

#View(tab_tipo_bolsa)

plot_tipo_bolsa <- ggplot() +
  geom_line(data = tab_tipo_bolsa, aes(x= ANO_CONCESSAO_BOLSA,
                              y = total, 
                              color = TIPO_BOLSA)) +
  geom_point(data = tab_tipo_bolsa, aes(x= ANO_CONCESSAO_BOLSA, y = total),
            pch = 21, fill = "white", color = "black",
             alpha = 0.8, size = 4)+
  labs (x = "Ano", y="Número Bolsistas", col="Tipo de Bolsa") +
  scale_x_continuous(limits = c(2005, 2017),
                     breaks = seq(2005, 2017, 1)) +
  scale_y_continuous(limits = c (0,200000))+
  my_theme()
#theme_gray(base_size = 16) 
plot_tipo_bolsa

plot_modalidade_bolsa <- ggplot() +
  geom_line(data = tab_modalidade_bolsa, aes(x= ANO_CONCESSAO_BOLSA,
                                       y = total, 
                                       color = MODALIDADE_ENSINO_BOLSA)) +
  geom_point(data = tab_modalidade_bolsa, aes(x= ANO_CONCESSAO_BOLSA, y = total),
             pch = 21, fill = "white", color = "black",
             alpha = 0.8, size = 4)+
  labs (x = "Ano", y="Número Bolsistas", col="Modalidade da Bolsa") +
  scale_x_continuous(limits = c(2005, 2017),
                     breaks = seq(2005, 2017, 1)) +
  scale_y_continuous(limits = c (0,210000))+
  my_theme()
#theme_gray(base_size = 16) 
##plot_modalidade_bolsa





