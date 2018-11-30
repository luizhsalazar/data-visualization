### Informações sobre bolsistas com idade maior que 40
###
### Tabela com ordenação de % de participação de estudantes com idade maior que 40 anos
### ordenado pelas instituições de ensino com maior participação e com mais de 1000 alunos.

library(ggplot2)
library(dplyr)
library(lubridate)

Sys.setlocale("LC_ALL", "pt_BR.UTF-8")

### FUNCTIONS
#######################################################################

funcaoQuantidadeAlunos <- function(temp_univ){
  return ((tabelaAlunosPorUniversidade %>%
             filter(NOME_IES_BOLSA == temp_univ))$QUANTIDADE_TOTAL)
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

dados <- read.csv("c:\\Temp\\todososdados01.csv", sep=";", encoding = 'UTF-8')
#dados <- readRDS("dados.rds")

### PERC de PARTICIPACAO POR UNIVERSIDADE
#######################################################################

tabelaAlunosPorUniversidade <- dados %>% 
  group_by(NOME_IES_BOLSA) %>% 
  summarise(QUANTIDADE_TOTAL = n())

tabelaAlunosPorUniversidadeAcima40 <- dados %>% 
  filter(IDADE > 40) %>%
  group_by(NOME_IES_BOLSA) %>% 
  summarise(QUANTIDADE_ACIMA_40 = n()) 

tabelaAlunosPorUniversidadeAcima40$QUANTIDADE_TOTAL <- vapply(tabelaAlunosPorUniversidadeAcima40$NOME_IES_BOLSA, funcaoQuantidadeAlunos, 1)
tabelaAlunosPorUniversidadeAcima40$PERCENTUAL_REPRES <- tabelaAlunosPorUniversidadeAcima40$QUANTIDADE_ACIMA_40 / tabelaAlunosPorUniversidadeAcima40$QUANTIDADE_TOTAL * 100

tabelaAlunosPorUniversidadeAcima40 <- tabelaAlunosPorUniversidadeAcima40 %>%
  filter(QUANTIDADE_TOTAL > 1000) %>%
  arrange(desc(PERCENTUAL_REPRES))

View(tabelaAlunosPorUniversidadeAcima40)

### QUANTIDADE DE ALUNOS BENEFICIADOS
#######################################################################

quantidadePessoasBeneficiadas <- dados %>%
  filter(IDADE > 40) %>%
  summarise(QUANTIDADE_TOTAL = n())

quantidadePessoasBeneficiadas

### QUAL CURSO MAIS PROCURADO
#######################################################################

tabelaCursos <- dados %>% 
  filter(IDADE > 40) %>%
  group_by(NOME_CURSO_BOLSA_NOVO) %>% 
  summarise(QUANTIDADE_TOTAL = n()) %>%
  arrange(desc(QUANTIDADE_TOTAL))

View(tabelaCursos)

### PARTICIPACAO FEMININA
#######################################################################

View(dados)

quantidadeTotalBeneficiados <- dados %>%
  filter(IDADE > 40) %>%
  summarise(QUANTIDADE_TOTAL = n())

quantidadeTotalMulheresBeneficiados <- dados %>%
  filter(IDADE > 40 , SEXO_BENEFICIARIO_BOLSA == 'Feminino') %>%
  summarise(QUANTIDADE_TOTAL = n())

quantidadeTotalBeneficiados
quantidadeTotalMulheresBeneficiados


quantidadeTotalBeneficiados <- dados %>%
  summarise(QUANTIDADE_TOTAL = n())

quantidadeTotalMulheresBeneficiados <- dados %>%
  filter(SEXO_BENEFICIARIO_BOLSA == 'Feminino') %>%
  summarise(QUANTIDADE_TOTAL = n())




