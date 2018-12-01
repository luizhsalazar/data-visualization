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
prouni <- prouni[prouni$SIGLA_UF_BENEFICIARIO_BOLSA != '', ]

### por curso

bolsistas_por_curso <- prouni %>%
  group_by_(.dots=c("ANO_CONCESSAO_BOLSA", "NOME_CURSO_BOLSA_NOVO")) %>% 
  summarize(total = n()) %>%
  filter(NOME_CURSO_BOLSA_NOVO %in% 
           c("Administração", "Direito", "Ciência Da Computação", "Pedagogia", "Medicina", "Engenharia Civil", "Enfermagem", "Ciências Contábeis", "Educação Física", "Psicologia", "Recursos Humanos")) %>%
  as.data.frame()

plot_por_curso <- ggplot() +
  geom_line(data = bolsistas_por_curso,
            aes(x = ANO_CONCESSAO_BOLSA, y = total, color = NOME_CURSO_BOLSA_NOVO)) +
  labs(x = "Ano", y = "Número de bolsistas", col = "Curso") +
  scale_x_continuous(limits = c(2005, 2016), breaks = seq(2005, 2016, 1)) +
  scale_y_continuous(limits = c(0, 30000)) + 
  theme_gray(base_size = 16) +
  my_theme()

plot_por_curso
