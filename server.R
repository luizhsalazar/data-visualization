server <- function(input, output) {
  
  todososdados01 <- read.csv("todososdados01.csv", sep=";")
  
  saveRDS(todososdados01, "dados.rds")
  
  plotModalidadeDeBolsa <- source("plots/plot_modalidade_e_tipo_bolsa.R")
  output$plotModalidadeDeBolsa <- renderPlot(plotModalidadeDeBolsa)
  
  ##plotFaixaEtaria <- source("plots/plot_faixa_etaria.R")
  ##plotRegioes <- source("plots/plot_regioes.R")
  ##plotSexo <- source("plots/plot_sexo.R")
  
  ##output$plotFaixaEtaria <- renderPlot(plotFaixaEtaria)
  ##output$plotRegioes <- renderPlot(plotRegioes)
  ##output$plotSexo <- renderPlot(plotSexo)
}