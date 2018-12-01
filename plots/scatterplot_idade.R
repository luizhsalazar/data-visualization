library(ggplot2)
library(ggcorrplot)
library(ggalt)
library(ggExtra)
library(ggthemes)
library(ggplotify)
library(treemapify)
library(plyr)
library(dplyr)
library(scales)
library(zoo)
library(lubridate)

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

prouni <- readRDS("dados.rds")

por_idade_quantidade <- prouni %>%
  group_by_(.dots=c("IDADE")) %>% 
  summarize(total = n()) %>%
  filter(IDADE > 16) %>%
  filter(IDADE < 81) %>%
  as.data.frame()

### idade x número de bolsistas

plot_scatter_idade <- ggplot(por_idade_quantidade, aes(x = IDADE, y = total)) + 
  geom_jitter(width = 0.8, height = 0.8, pch = 21, colour = "black",
              fill = "white", size = 4) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(subtitle = "",
       y = "Número de bolsistas",
       x = "Idade",
       title = "Idade x número de bolsistas (2005 - 2016)",
       caption = "Fonte: ") +
  my_theme()

ggMarginal(plot_scatter_idade, type = "boxplot", fill = "transparent")

plot_scatter_idade
