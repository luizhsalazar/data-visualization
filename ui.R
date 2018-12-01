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
library(bubbles)
library(DT)

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
                 menuSubItem("Cursos", tabName = "graficoCursos"),
                 menuSubItem("Modalidades de ensino", tabName = "graficoModalidadeEnsino"),
                 menuSubItem("Tipos de bolsa", tabName = "graficoTipoBolsas")
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
              p("Foram extraidas informações do período entre 2005 a 2016. O intuíto dessa aplicação é visualizar as informações a nível de que se possa obter conhecimento das mesmas para tomada de decisão."),
              br(),
              fluidRow(
                valueBox(value = "dados.gov", subtitle = "Informações oficiais disponibilizadas pelo MEC.", icon = icon("download"), color = "green"),
                valueBox(value = "2005 a 2016",subtitle = "Período de captura das informações.",icon = icon("calendar"),color = "blue"),
                valueBox(value = "2 m.", subtitle = "Aproximadamente 2 milhões de registros apurados.",icon = icon("area-chart"),color = "yellow")
              )
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
        p("Texto a fazer"),
        fluidRow(
          box(title = "", width = 12, status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotRegioes")
          )
        )
      ),
      
      tabItem(
        tabName = "graficoRendaFamiliar" ,
        h2(class = "text-bold", "Análise da renda familiar comparando com a quantidade de bolsas fornecidas")
        # TODO
      ),
      
      tabItem(
        tabName = "graficoSexo" ,
        h2(class = "text-bold", "Análise de proporção de bolsistas por sexo"),
        fluidRow(
          box(title = "", width = 12, status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotSexo")
          )
        )
      ),
      
      tabItem(
        tabName = "graficoRaca" ,
        h2(class = "text-bold", "Análise de proporção de bolsistas por raça"),
         checkboxGroupInput("racas", label = "", 
          choices = list( "Amarela" = "Amarela",
                          "Branca" = "Branca",
                          "Indígena" = "Indígena",
                          "Não Informada" = "Não Informada",
                          "Parda" = "Parda",
                          "Preta" = "Preta"),
          selected = c("Amarela", "Branca", "Indígena", "Não Informada", "Parda", "Preta"),
          inline = TRUE),
          fluidRow(
            box(title = "", width = 12, status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotRaca")
            )
          )
      ),
      
      tabItem(
        tabName = "graficoInclusaoSocial" ,
        h2(class = "text-bold", "Portadores de deficiência"),
        br(),
        fluidRow(
            box(title = "Histórico da quantidade de bolsistas portadores de deficiência", width = 12, status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotDeficienciaHistorico")
          )
        ),
         fluidRow(
          box(
            width = 7, status = "primary", 
            title = "Instituições que tiveram maior quantidade de bolsistas portadores de deficiência",
            bubblesOutput("plotDeficienciaBubble", width = "100%", height = 800)
          ),
          box(
            width = 5, status = "primary",
            title = "Relação de bolsistas por Instituição",
            DT::dataTableOutput("plotDeficienciaDatatable")
          )
        )
      ),
      
      tabItem(
        tabName = "graficoCursos" ,
        h2(class = "text-bold", "Evolução das bolsas oferecidas por curso"),
        checkboxGroupInput("cursos", label = "", 
                           choices = list( "Administração" = "Administração",
                                           "Direito" = "Direito",
                                           "Ciência Da Computação" = "Ciência Da Computação",
                                           "Pedagogia" = "Pedagogia",
                                           "Medicina" = "Medicina",
                                           "Engenharia Civil" = "Engenharia Civil",
                                           "Enfermagem" = "Enfermagem",
                                           "Ciências Contábeis" = "Ciências Contábeis",
                                           "Educação Física" = "Educação Física",
                                           "Psicologia" = "Psicologia",
                                           "Recursos Humanos" = "Recursos Humanos"
                                           ),
                           c("Ciências Contábeis", "Educação Física", "Psicologia", "Recursos Humanos"),
                           selected = c("Ciência Da Computação"),
                           inline = TRUE),
        br(),
        p("Texto a fazer"),
        fluidRow(
          box(title = "", width = 12, status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotCursos")
          )
        )
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
        p("Texto a fazer"),
        fluidRow(
          box(title = "", width = 12, status = "primary", solidHeader = FALSE, collapsible = FALSE, plotOutput("plotTipoDeBolsa"))
          )
      ),
      
      tabItem(tabName = "graficoFaixaEtaria",
              h2(class="text-bold","Quantidade de bolsas por faixa etária"),
              br(),
              p("Comparativo entre a quantidade de bolsas agrupadas por faixa etária ao longo dos anos. Para isso, as idades foram dividas em quatro classes. A primeira classe de 17 a 20 anos, depois temos as classes intermediárias das faixas de 21 a 30 anos e de 31 a 40 anos, e temos a considerada 'terceira idade', de 41 a 80 anos."),
              br(),
              fluidRow(
                box(solidHeader = FALSE, collapsible = FALSE, plotOutput("plotFaixaEtaria1", height = "250px")),
                box(solidHeader = FALSE, collapsible = FALSE, plotOutput("plotFaixaEtaria2", height = "250px")),
                box(solidHeader = FALSE, collapsible = FALSE, plotOutput("plotFaixaEtaria3", height = "250px")),
                box(solidHeader = FALSE, collapsible = FALSE, plotOutput("plotFaixaEtaria4", height = "250px"))
              )
        ),
      
      tabItem(tabName = "graficoAcima40",
              h2(class="text-bold", "Informações de beneficiários acima dos 40 anos"),
              br(),
              p("Algumas informações sobre os beneficiários com idade acima dos 40 anos."),
              br(),
              fluidRow(
                valueBox(value = "74 mil", subtitle = "pessoas com mais de 40 anos foram beneficiadas. Isso representa 3,72% do total", icon = icon("infinity"), color = "blue"),
                valueBox(value = "Pedagogia",subtitle = "é o curso mais ingressado nessa faixa etária. Cerca de 14.500 bolsas foram disponibilizadas.",icon = icon("school"),color = "green"),
                valueBox(value = "53%", subtitle = "de pessoas acima de 40 anos são do sexo feminino. Esse valor é semelhante ao percentual geral. ",icon = icon("female"),color = "red")
              ),
              fluidRow(
                box(width=7, title = "Instituições com maior participação", "Entre as instituições que cederam bolsas ao ProUni, destacamos a Faculdade Educacional da Lapa, na cidade de Lapa no Paraná, que no geral teve 13% dos beneficiados pessoas com mais de 40 anos (das 8686 bolsas, 1141 foram para essas pessoas). ", br(), br(), "Também tem destaque a Faculdade de São Paulo (São Paulo - SP),  Faculdade de tecnologia Internacional (Curitiba - PR) e o Centro Universitário Claretiano (Blumenau - SC) com 10% dos beneficiados."),
                box(width=4, status = "warning", title="Pessoas com mais de 40 anos voltam às salas de aula", "Dados do Instituto Nacional de Estudos e Pesquisas Educacionais (INEP) de 2011 apontam que, no Brasil, quase 550 mil pessoas com mais de 40 anos estão cursando faculdade. E nos últimos quatro anos houve um aumento de 4.018 universitários a partir desta faixa etária.")
              )
      )
      
    )
  )
)
