### Quantidade de bolsas por faixa etária 
### Quantidade de bolsas agrupadas pela faixa e por ano, no Brasil inteiro.

### Remover essas librarys ao incluir no principal
library(shinydashboard)
library(ggplot2)
library(ggcorrplot)
library(ggExtra)
library(ggthemes)
library(ggplotify)
library(treemapify)
library(plyr)
library(dplyr)
library(scales)
library(zoo)

library(ggplot2)
library(dplyr)
library(lubridate)
detach("package:plyr", unload=TRUE) 

dados <- read.csv("c:\\temp\\todososdados01.csv", sep=";")
dados$FAIXA_ETARIA <- vapply(dados$IDADE, funcaoFaixaEtaria, 1)

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

#######################################################################

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

tabelaFaixaEtaria2 <- tabelaQuantidadePorAnoEFaixa %>%
  filter(FAIXA_ETARIA == 2)

tabelaFaixaEtaria2 <- tabelaQuantidadePorAnoEFaixa %>%
  filter(FAIXA_ETARIA == 3)

tabelaFaixaEtaria2 <- tabelaQuantidadePorAnoEFaixa %>%
  filter(FAIXA_ETARIA == 4)






