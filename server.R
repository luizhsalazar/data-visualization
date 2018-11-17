server <- function(input, output) {
  # Importação dos gráficos com source
  plot1 <- source("plots/plot1.R")
  
  # Render de cada gráfico na janela
  output$plot1 <- renderPlot(plot1)
}