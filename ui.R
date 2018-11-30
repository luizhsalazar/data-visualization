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
          menuSubItem("Bolsas por faixa etária", tabName = "graficoFaixaEtaria"),
          menuSubItem("Beneficiários acima dos 40", tabName = "graficoAcima40")
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
                                           ), multiple = TRUE, selected = 'SC'),
        
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
        h2(class = "text-bold", "Análise da proporção de bolsas por tipo de bolsas (Parcial e integral)"),
        br(),
        p("Texto a fazer")
        # TODO
      ),
      
      tabItem(tabName = "graficoFaixaEtaria",
              h2(class="text-bold","Quantidade de bolsas por faixa etária"),
              br(),
              p("Comparativo entre a quantidade de bolsas agrupadas por faixa etária ao longo dos anos. Para isso, as idades foram dividas em quatro classes. A primeira classe de 17 a 20 anos, depois temos as classes intermediárias das faixas de 21 a 30 anos e de 31 a 40 anos, e temos a considerada 'terceira idade', de 41 a 80 anos."),
              br(),
              fluidRow(
                box(status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotFaixaEtaria1", height = "250px")
                ),
                box(status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotFaixaEtaria2", height = "250px")
                ),
                box(status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotFaixaEtaria3", height = "250px")
                ),
                box(status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotFaixaEtaria4", height = "250px")
                )
              )
        ),
      
      tabItem(tabName = "graficoAcima40",
              h2(class="text-bold", "Informações de beneficiários acima dos 40 anos"),
              br(),
              p("Algumas informações sobre os beneficiários com idade acima dos 40 anos."),
              br(),
              fluidRow(
                box(status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotAcima401", height = "250px")
                )
              )
      )
      
    )
  )
)
