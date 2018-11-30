### Informações sobre quantidade de bolsistas por faixa etária 1 (17 a 20 anos)
###
### Plot que gera gráfico de barras com a quantidade de bolsistas da faixa etária 1 (17 a 20 anos)
### ao longo dos anos (2005 a 2016)

library(ggplot2)
library(dplyr)
library(lubridate)

Sys.setlocale("LC_ALL", "pt_BR.UTF-8")

### FUNCTIONS
#######################################################################

funcaoPercentualRepres <- function(temp_ano){
  return ((tabelaQuantidadeTotal %>%
             filter(ANO_CONCESSAO_BOLSA == temp_ano))$QUANTIDADE_TOTAL)
}

funcaoFaixaEtaria <- function (temp_idade){
  if(temp_idade >= 17 & temp_idade <= 20) return(1)
  if(temp_idade >= 21 & temp_idade <= 30) return(2)
  if(temp_idade >= 31 & temp_idade <= 40) return(3)
  if(temp_idade >= 41 & temp_idade <= 80) return(4)
  return (0)
}

detach_package <- function(pkg, character.only = FALSE)
{
  if(!character.only)
  {
    pkg <- deparse(substitute(pkg))
  }
  search_item <- paste("package", pkg, sep = ":")
  while(search_item %in% search())
  {
    detach(search_item, unload = TRUE, character.only = TRUE)
  }
}


### EXTRAÇÃO DOS DADOS
#######################################################################

detach_package("plyr")

dados <- readRDS("dados.rds")
dados$FAIXA_ETARIA <- vapply(dados$IDADE, funcaoFaixaEtaria, 1)

## Tabela com ANO x Quantidade total de alunos
tabelaQuantidadeTotal <- dados %>%
    filter(between(IDADE,17,80)) %>%
    group_by(ANO_CONCESSAO_BOLSA) %>% 
    summarise(QUANTIDADE_TOTAL = n())

## Tabela com Ano x Faixa x Quantidade de alunos
tabelaQuantidadePorAnoEFaixa <- dados %>% 
  filter(between(IDADE,17,80)) %>%
  group_by(ANO_CONCESSAO_BOLSA, FAIXA_ETARIA) %>% 
  summarise(QUANTIDADE = n())

tabelaQuantidadePorAnoEFaixa$QUANTIDADE_TOTAL <- vapply(tabelaQuantidadePorAnoEFaixa$ANO_CONCESSAO_BOLSA, funcaoPercentualRepres, 1)
tabelaQuantidadePorAnoEFaixa$PERCENTUAL_REPRES <- tabelaQuantidadePorAnoEFaixa$QUANTIDADE / tabelaQuantidadePorAnoEFaixa$QUANTIDADE_TOTAL * 100

## Tabelas por faixa etária
tabelaFaixaEtaria1 <- tabelaQuantidadePorAnoEFaixa %>%
  filter(FAIXA_ETARIA == 1)

### GRÁFICOS
#######################################################################

seta <- grid::arrow(length = grid::unit(0.2, "cm"), type = "open")
my_theme <- function (base_size = 10, base_family = "Arial") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(axis.ticks = element_blank(),
          axis.line = element_line(arrow = seta),
          legend.background = element_blank(),
          legend.key = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank(),
          strip.background = element_blank(),
          plot.background = element_blank(),
          complete = TRUE)
}

grafico <- ggplot(tabelaFaixaEtaria1, aes(x = ANO_CONCESSAO_BOLSA, y = PERCENTUAL_REPRES)) +
    geom_bar(stat = "identity", width = 0.7, fill = "#006400") +
    labs(title = "% de participação da faixa etária (17 a 20 anos)",
         x = "Ano",
         y = "% de participação") +
    scale_x_continuous(breaks = seq(2005, 2016, 1)) +
    scale_y_continuous(limits=c(0, 70), breaks = seq(0, 70, 10)) +
    my_theme() +
    theme(axis.text.x = element_text(angle = 65, vjust = 0.6))

grafico


