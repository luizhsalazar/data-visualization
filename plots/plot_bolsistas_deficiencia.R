#install.packages("devtools")
#install.packages("DT")
#devtools::install_github("rstudio/shinydashboard")
#devtools::install_github("jcheng5/bubbles")

library(RColorBrewer)

#print("Carregando CSV ...")
#prouni <- read.csv("c://todososdados01.csv", sep=";", encoding = 'UTF-8')
#prouni <- prouni[prouni$ANO_CONCESSAO_BOLSA != '', ]
#print("CSV carregado ...")

bolsistas_deficiencia <- prouni %>%
  group_by_(.dots=c("ANO_CONCESSAO_BOLSA", "BENEFICIARIO_DEFICIENTE_FISICO")) %>% 
  dplyr::summarize(total = n()) %>%
  as.data.frame()

bolsistas_deficiencia_filter <- filter(bolsistas_deficiencia, BENEFICIARIO_DEFICIENTE_FISICO == "SIM")

plotDeficienciaHistorico <- renderPlot({
  filteredData <- bolsistas_deficiencia_filter
  plot_bolsistas_deficiencia <- ggplot() +
    geom_line(data = filteredData,
              aes(x = ANO_CONCESSAO_BOLSA, y = total, color = BENEFICIARIO_DEFICIENTE_FISICO)) +
    geom_point(data = filteredData, aes(x = ANO_CONCESSAO_BOLSA, y = total), 
              pch = 1, alpha = 0.8, size = 3) +
    labs(x = "Ano", y = "Número de bolsistas", col = "Portador") +
    scale_x_continuous(limits = c(2005, 2016), breaks = seq(2005, 2016, 1)) +
    scale_y_continuous(limits = c(0, 2500)) + 
    theme_gray(base_size = 16) +
  my_theme()
  return(plot_bolsistas_deficiencia)
})


bolsistas_deficiencia_instituicao <- prouni %>%
  group_by(NOME_IES_BOLSA) %>% 
  summarise(BOLSISTAS_NORMAIS = n(), BOLSISTAS_DEFICIENTES = sum(BENEFICIARIO_DEFICIENTE_FISICO == "SIM")) 

plotDeficienciaBubble <- renderBubbles({
  order <- unique(bolsistas_deficiencia_instituicao$NOME_IES_BOLSA)
  df <- bolsistas_deficiencia_instituicao %>%
    arrange(desc(BOLSISTAS_DEFICIENTES), tolower(NOME_IES_BOLSA)) %>%
    head(8)
  bubbles(
    df$BOLSISTAS_DEFICIENTES,
    df$NOME_IES_BOLSA,
    key = df$NOME_IES_BOLSA,
    tooltip = df$BOLSISTAS_DEFICIENTES,
    color = rev(brewer.pal(n = 8, name = "GnBu"))
  )
})

plotDeficienciaDatatable <- DT::renderDataTable({
  bolsistas_deficiencia_instituicao %>%
    mutate(PORCENTAGEM = round(BOLSISTAS_DEFICIENTES / BOLSISTAS_NORMAIS * 100, digits = 2)) %>%
    filter(BOLSISTAS_NORMAIS > 100) %>%
    arrange(desc(PORCENTAGEM), tolower(NOME_IES_BOLSA)) %>%
    select("IES" = NOME_IES_BOLSA, "Total de bolsistas" = BOLSISTAS_NORMAIS, "Portadores" = BOLSISTAS_DEFICIENTES, "%" = PORCENTAGEM) %>%
    as.data.frame() 
}, options = list(
      pageLength = 15,
      language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json')
    )
)
