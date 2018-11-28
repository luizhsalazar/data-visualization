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

ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "Informações PROUNI", titleWidth = 260),
  
  dashboardSidebar(
    width = 260,
      sidebarMenu(
        menuItem("Principal", tabName = "principal", icon = icon("home")),
        
        menuItem("Região", icon = icon("map-marker"), startExpanted = TRUE,
                 menuSubItem("Bolsistas por estado", tabName = "graficoEstado"),
                 menuSubItem("Bolsistas por região", tabName = "graficoRegiao"),
                 menuSubItem("Renda familiar x bolsas fornecidas", tabName = "graficoRendaFamiliar")
        ),
        
        menuItem("Diversidade", icon = icon("certificate"), startExpanted = TRUE,
                 menuSubItem("Bolsas por sexo", tabName = "graficoSexo"),
                 menuSubItem("Bolsas por raça", tabName = "graficoRaca"),
                 menuSubItem("Inclusão social", tabName = "graficoInclusaoSocial")
        ),
        
        menuItem("Características do ensino", icon = icon("book"), startExpanted = TRUE,
                 menuSubItem("Modalidade de ensino", tabName = "graficoModalidadeEnsino"),
                 menuSubItem("Tipos de bolsas", tabName = "graficoTipoBolsas")
        ),
        
        menuItem("Faixa etária", icon = icon("user"), startExpanted = TRUE,
          menuSubItem("Bolsas por faixa etária", tabName = "graficoFaixaEtaria")
        )
      )
  ),
  
  dashboardBody(
    tabItems(
      
      tabItem(tabName = "principal",
              h2(class="text-bold", "Análise de informações da base de dados do PROUNI"),
              br(),
              p("Dados referentes ao detalhamento quantitativo das bolsas concedidas por ano, segmentadas por região, unidade federativa e município, instituição de educação superior, nome do curso, modalidade de ensino (presencial ou a distância), turno e tipo de bolsa."),
              br(),
              p("Foram extraidas informações do período entre 2005 a 2016. O intuíto dessa aplicação é visualizar as informações a nível de que se possa obter conhecimento das mesmas para tomada de decisão."),
              p(class="text-muted", "Dados disponiveis em: http://dados.gov.br/dataset/mec-prouni")
      ),
      
      tabItem(
        tabName = "graficoEstado" ,
        h2(class = "text-bold", "Quantidade de bolsistas por Estado"),
        sidebarPanel(
          selectInput('estado', 'Estado',  c("Santa Catarina" = "SC",
                                             "Rio Grande do Sul" = "RS",
                                             "Paraná" = "PR",
                                             "São Paulo" = "SP",
                                             "Rio de Janeiro" = "RJ",
                                             "Minas Gerais" = "MG",
                                             "Mato Grosso do Sul" = "MS",
                                             "Mato Grosso" = "MT",
                                             "Tocantins" = "TO",
                                             "Bahia" = "BA",
                                             "Sergipe" = "SE",
                                             "Alagoas" = "AL",
                                             "Pernambuco" = "PE",
                                             "Maranhão" = "MA",
                                             "Rio Grande do Norte" = "RN",
                                             "Ceará" = "CE",
                                             "Paraíba" = "PB",
                                             "Pará" = "PA",
                                             "Amapá" = "AP",
                                             "Acre" = "AC",
                                             "Rondônia" = "RO",
                                             "Roraima" = "RR",
                                             "Amazonas" = "AM",
                                             "Distrito Federal" = "DF",
                                             "Goiás" = "GO",
                                             "Espírito Santo" = "ES"
                                             )
                      )
        ),
        fluidRow(
          box(title = "", width = 12, status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plot_bolsistas_estado")
          )
        )
      ),
      
      tabItem(
        tabName = "graficoRegiao" ,
        h2(class = "text-bold", "Quantidade de bolsistas por Região"),
        br(),
        p("Texto a fazer")
        ##fluidRow(
        ##  box(title = "", width = 12, status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotRegioes")
        ##  )
        ##)
      ),
      
      tabItem(
        tabName = "graficoRendaFamiliar" ,
        h2(class = "text-bold", "Análise da renda familiar comparando com a quantidade de bolsas fornecidas")
        # TODO
      ),
      
      tabItem(
        tabName = "graficoSexo" ,
        h2(class = "text-bold", "Análise de proporção de bolsistas por sexo nos cursos")
        # TODO
      ),
      
      tabItem(
        tabName = "graficoRaca" ,
        h2(class = "text-bold", "Análise de proporção de bolsistas por raça")
        # TODO
      ),
      
      tabItem(
        tabName = "graficoInclusaoSocial" ,
        h2(class = "text-bold", "Instituições com maior inclusão de pessoas com deficiência")
        # TODO
      ),
      
      tabItem(
        tabName = "graficoModalidadeEnsino" ,
        h2(class = "text-bold", "Evolução das bolsas oferecidas por modalidade de ensino"),
        br(),
        p("Texto a fazer"),
        fluidRow(
            box(title = "", width = 12, status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotModalidadeDeBolsa")
          )
        )
      ),
      
      tabItem(
        tabName = "graficoTipoBolsas" ,
        h2(class = "text-bold", "Análise da proporção de bolsas por tipo de bolsas (Parcial e integral)")
        # TODO
      ),
      
      tabItem(tabName = "graficoFaixaEtaria",
              h2(class="text-bold","Quantidade de bolsas por faixa etaria"),
              br(),
              p("Comparativo entre a quantidade de bolsas agrupadas por faixa etaria ao longo dos anos. Para isso, as idades foram dividas em quatro classes."),
              p("- Idade 1 (17 a 20 anos)"),
              p("- Idade 2 (21 a 30 anos)"),
              p("- Idade 3 (31 a 40 anos)"),
              p("- Idade 4 (41 a 80 anos)")
              ##fluidRow(
               ## box(title = "", width = 12, status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotFaixaEtaria")
               ## )
        )
      
    )
  )
)
