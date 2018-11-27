### Quantidade de bolsas por faixa et?ria 
### Quantidade de bolsas agrupadas pela faixa e por ano, no Brasil inteiro.

### Carrega pacotes necess?rios


library(ggplot2)
library(dplyr)
library(lubridate)
detach("package:plyr", unload=TRUE) 

dados <- read.csv("todososdados01.csv", sep=";")

dados$FAIXA_ETARIA <- vapply(dados$IDADE, funcaoFaixaEtaria, 1)

tabela <- todososdados01 %>% 
  group_by(FAIXA_ETARIA) %>% 
  summarise(n = n()) ###%>%
  ###filter(IDADE >= 17,IDADE <= 80)

View(tabela)

### Function que volta as classes de faixa et?ria
funcaoFaixaEtaria <- function (temp_idade){
  if(temp_idade >= 17 & temp_idade <= 20) return(1)
  if(temp_idade >= 21 & temp_idade <= 30) return(2)
  if(temp_idade >= 31 & temp_idade <= 40) return(3)
  if(temp_idade >= 41 & temp_idade <= 80) return(4)
  return (0)
}