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

prouni <-          read.csv("todososdados01.csv", sep=";", encoding = 'UTF-8')
nivel_instrucao <- read.csv("nivelinstrucao.csv", sep=",", encoding = 'UTF-8')
nivel_instrucao$Completo <- as.numeric(gsub(pattern = ",", replacement = ".", x = nivel_instrucao$Completo))
nivel_instrucao$Incompleto <- as.numeric(gsub(pattern = ",", replacement = ".", x = nivel_instrucao$Incompleto))

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

  nivel_instrucao_filter <- reactive({
    if (is.null(input$estado))
      nivel_instrucao <- filter(nivel_instrucao, Estado == 'SC')
    else
      nivel_instrucao <- filter(nivel_instrucao, Estado %in% input$estado_instrucao)
  })
  
  output$plot_nivel_instrucao_completo <- renderPlot({
    data <- nivel_instrucao_filter()
    plot_nivel_instrucao_completo <- ggplot() +
      geom_line(data = data,
                aes(x = Ano, y = Completo, color = Estado)) +
      geom_point(data = data, aes(x = Ano, y = Completo), 
                 pch = 1, alpha = 0.8, size = 3) +
      labs(x = "Ano", y = "% População", col = "Estado") +
      scale_x_continuous(limits = c(2012, 2018), breaks = seq(2012, 2018, 1)) +
      scale_y_continuous(limits = c(0, 30)) + 
      theme_gray(base_size = 16) +
      my_theme()
    
    return(plot_nivel_instrucao_completo)
  })
  
  output$plot_nivel_instrucao_incompleto <- renderPlot({
    data <- nivel_instrucao_filter()
    plot_nivel_instrucao_incompleto <- ggplot() +
      geom_line(data = data,
                aes(x = Ano, y = Incompleto, color = Estado)) +
      geom_point(data = data, aes(x = Ano, y = Incompleto), 
                 pch = 1, alpha = 0.8, size = 3) +
      labs(x = "Ano", y = "% População", col = "Estado") +
      scale_x_continuous(limits = c(2012, 2018), breaks = seq(2012, 2018, 1)) +
      scale_y_continuous(limits = c(0, 30)) + 
      theme_gray(base_size = 16) +
      my_theme()
    
   return(plot_nivel_instrucao_incompleto)
  })
  
  saveRDS(prouni, "dados.rds")

  plotModalidadeDeBolsa <- source("plots/plot_modalidade_bolsa.R", encoding="utf-8")
  output$plotModalidadeDeBolsa <- renderPlot(plotModalidadeDeBolsa)
  plotTipoDeBolsa <- source("plots/plot_tipo_bolsa.R", encoding="utf-8")
  output$plotTipoDeBolsa <- renderPlot(plotTipoDeBolsa)
  
  ## FAIXA ETARIA
  plotFaixaEtaria1 <- source("plots/faixa_etaria/plot_faixa_etaria_1.R", encoding="utf-8")
  output$plotFaixaEtaria1 <- renderPlot(plotFaixaEtaria1)
  plotFaixaEtaria2 <- source("plots/faixa_etaria/plot_faixa_etaria_2.R", encoding="utf-8")
  output$plotFaixaEtaria2 <- renderPlot(plotFaixaEtaria2)
  plotFaixaEtaria3 <- source("plots/faixa_etaria/plot_faixa_etaria_3.R", encoding="utf-8")
  output$plotFaixaEtaria3 <- renderPlot(plotFaixaEtaria3)
  plotFaixaEtaria4 <- source("plots/faixa_etaria/plot_faixa_etaria_4.R", encoding="utf-8")
  output$plotFaixaEtaria4 <- renderPlot(plotFaixaEtaria4)
 
  
  plotRegioes <- source("plots/plot_regioes.R", encoding="utf-8")
  plotSexo <- source("plots/plot_sexo.R", encoding="utf-8")
  output$plotRegioes <- renderPlot(plotRegioes)
  output$plotSexo <- renderPlot(plotSexo)
  
  ### CURSO ###

  bolsistas_por_curso <- prouni %>%
    group_by_(.dots=c("ANO_CONCESSAO_BOLSA", "NOME_CURSO_BOLSA_NOVO")) %>% 
    summarize(total = n()) %>%
    filter(NOME_CURSO_BOLSA_NOVO %in% 
             c("Administração", "Direito", "Ciência Da Computação", "Pedagogia", "Medicina", "Engenharia Civil", "Enfermagem", "Ciências Contábeis", "Educação Física", "Psicologia", "Recursos Humanos", "Engenhraia Elétrica")) %>%
    as.data.frame()
  
  bolsistas_curso_filter <- reactive({
    bolsistas_por_curso <- filter(bolsistas_por_curso, NOME_CURSO_BOLSA_NOVO %in% input$cursos)
  })
  
  output$plotCursos <- renderPlot({
    filteredData <- bolsistas_curso_filter()
    plot_por_curso <- ggplot() +
      geom_line(data = filteredData,
                aes(x = ANO_CONCESSAO_BOLSA, y = total, color = NOME_CURSO_BOLSA_NOVO)) +
      labs(x = "Ano", y = "Número de bolsistas", col = "Curso") +
      scale_x_continuous(limits = c(2005, 2016), breaks = seq(2005, 2016, 1)) +
      scale_y_continuous(limits = c(0, 30000)) + 
      theme_gray(base_size = 16) +
      my_theme()
    
    return(plot_por_curso)
  })

  ### DEFICIÊNCIA ###
  plotDeficiencia <- source("plots/plot_bolsistas_deficiencia.R")
  output$plotDeficienciaHistorico <- plotDeficienciaHistorico
  output$plotDeficienciaBubble <- plotDeficienciaBubble
  output$plotDeficienciaDatatable <- plotDeficienciaDatatable
  
  ### RAÇA ###
  bolsistas_raca <- prouni %>%
  group_by_(.dots=c("ANO_CONCESSAO_BOLSA", "RACA_BENEFICIARIO_BOLSA")) %>% 
  dplyr::summarize(total = n()) %>%
  as.data.frame()

  bolsistas_raca_filter <- reactive({
    bolsistas_raca <- filter(bolsistas_raca, RACA_BENEFICIARIO_BOLSA %in% input$racas)
  })

  output$plotRaca <- renderPlot({
    filteredData <- bolsistas_raca_filter()
    plot_bolsistas_raca <- ggplot() +
      geom_line(data = filteredData,
                aes(x = ANO_CONCESSAO_BOLSA, y = total, color = RACA_BENEFICIARIO_BOLSA)) +
      geom_point(data = filteredData, aes(x = ANO_CONCESSAO_BOLSA, y = total), 
                pch = 1, alpha = 0.8, size = 3) +
      labs(x = "Ano", y = "Número de bolsistas", col = "Raça") +
      scale_x_continuous(limits = c(2005, 2016), breaks = seq(2005, 2016, 1)) +
      scale_y_continuous(limits = c(0, 125000)) + 
      theme_gray(base_size = 16) +
    my_theme()
    return(plot_bolsistas_raca)
  })
  
  bolsistas_por_curso_sexo <- prouni %>%
    filter(NOME_CURSO_BOLSA_NOVO %in% c("Administração", "Direito", "Ciência Da Computação", "Pedagogia", "Medicina", "Engenharia Civil", "Enfermagem", "Ciências Contábeis", "Educação Física", "Psicologia", "Recursos Humanos", "Engenhraia Elétrica")) %>%
    group_by_(.dots=c("SEXO_BENEFICIARIO_BOLSA", "ANO_CONCESSAO_BOLSA", "NOME_CURSO_BOLSA_NOVO")) %>%
    summarize(total = n()) %>%
    as.data.frame()
  
  bolsistas_curso_sexo_filter <- reactive({
    bolsistas_por_curso_sexo <- filter(bolsistas_por_curso_sexo, NOME_CURSO_BOLSA_NOVO %in% input$cursos_sexo)
  })
  
  output$plot_curso_sexo <- renderPlot({
    filtered_data <- bolsistas_curso_sexo_filter()
    plot_por_curso_sexo <- ggplot() +
      geom_line(data = filtered_data,
                aes(x = ANO_CONCESSAO_BOLSA, y = total, color = SEXO_BENEFICIARIO_BOLSA)) +
      labs(title = "Administração", x = "Ano", y = "Número de bolsistas", col = "Sexo") +
      scale_x_continuous(limits = c(2005, 2016), breaks = seq(2005, 2016, 1)) +
      scale_y_continuous(limits = c(0, 30000)) + 
      theme_gray(base_size = 16) +
      my_theme()
    return(plot_por_curso_sexo)
  })

}