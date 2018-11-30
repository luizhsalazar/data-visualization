Sys.setlocale("LC_ALL", "pt_BR.UTF-8")

seta <- grid::arrow(length = grid::unit(0.2, "cm"), type = "open")
my_theme <- function (base_size = 14, base_family = "Arial") {
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

prouni <- read.csv("todososdados01.csv", sep=";")

server <- function(input, output) {
  
  bolsistas_estados <- prouni %>%
    group_by_(.dots=c("ANO_CONCESSAO_BOLSA", "SIGLA_UF_BENEFICIARIO_BOLSA")) %>% 
    dplyr::summarize(total = n()) %>%
    as.data.frame()
  
  bolsistas_estados_filter <- reactive({
    if (is.null(input$estado))
      bolsistas_estados <- filter(bolsistas_estados, SIGLA_UF_BENEFICIARIO_BOLSA == 'SC')
    else
      bolsistas_estados <- filter(bolsistas_estados, SIGLA_UF_BENEFICIARIO_BOLSA %in% input$estado)
  })
  
  output$plot_bolsistas_estado <- renderPlot({
    datadata <- bolsistas_estados_filter()
    plot_bolsistas_estado <- ggplot() +
      geom_line(data = datadata,
                aes(x = ANO_CONCESSAO_BOLSA, y = total, color = SIGLA_UF_BENEFICIARIO_BOLSA)) +
      geom_point(data = datadata, aes(x = ANO_CONCESSAO_BOLSA, y = total), 
                 pch = 1, alpha = 0.8, size = 3) +
      labs(x = "Ano", y = "Número de bolsistas", col = "Estado") +
      scale_x_continuous(limits = c(2005, 2016), breaks = seq(2005, 2016, 1)) +
      scale_y_continuous(limits = c(0, 70000)) + 
      theme_gray(base_size = 16) +
      my_theme()
    
    return(plot_bolsistas_estado)
  })

  saveRDS(prouni, "dados.rds")

  plotModalidadeDeBolsa <- source("plots/plot_modalidade_e_tipo_bolsa.R", encoding="utf-8")
  output$plotModalidadeDeBolsa <- renderPlot(plotModalidadeDeBolsa)
  
  plotFaixaEtaria1 <- source("plots/plot_faixa_etaria_1.R", encoding="utf-8")
  output$plotFaixaEtaria1 <- renderPlot(plotFaixaEtaria1)
  plotFaixaEtaria2 <- source("plots/plot_faixa_etaria_2.R", encoding="utf-8")
  output$plotFaixaEtaria2 <- renderPlot(plotFaixaEtaria2)
  plotFaixaEtaria3 <- source("plots/plot_faixa_etaria_3.R", encoding="utf-8")
  output$plotFaixaEtaria3 <- renderPlot(plotFaixaEtaria3)
  plotFaixaEtaria4 <- source("plots/plot_faixa_etaria_4.R", encoding="utf-8")
  output$plotFaixaEtaria4 <- renderPlot(plotFaixaEtaria4)
  ##plotRegioes <- source("plots/plot_regioes.R")
  ##plotSexo <- source("plots/plot_sexo.R")
  
  ##output$plotFaixaEtaria <- renderPlot(plotFaixaEtaria)
  ##output$plotRegioes <- renderPlot(plotRegioes)
  ##output$plotSexo <- renderPlot(plotSexo)
}