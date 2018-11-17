library(shinydashboard)
library(ggplot2)
library(ggcorrplot)
library(ggExtra)
library(ggthemes)
library(ggplotify)
library(treemapify)
library(dplyr)
library(scales)
library(plyr)
library(zoo)

ui <- dashboardPage(
  dashboardHeader(title = "Análise PROUNI"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Gráfico 1", tabName = "grafico1", icon = icon("th")),
      menuItem("Gráfico 2", tabName = "grafico2", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              fluidRow(
                box(
                  title = "Exemplo",
                  width = 12,
                  status = "primary",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  plotOutput("plot1")
                )
              )
      ),
      
      tabItem(tabName = "grafico1",
              h2("Widgets tab content")
      ),
      
      tabItem(tabName = "grafico2",
              h2("Widgets tab content")
      )
    ),
    fluidRow(
      tabBox(
        title = "First tabBox",
        # The id lets us use input$tabset1 on the server to find the current tab
        id = "tabset1", height = "250px",
        tabPanel("Tab1", "First tab content"),
        tabPanel("Tab2", "Tab content 2")
      ),
      tabBox(
        side = "right", height = "250px",
        selected = "Tab3",
        tabPanel("Tab1", "Tab content 1"),
        tabPanel("Tab2", "Tab content 2"),
        tabPanel("Tab3", "Note that when side=right, the tab order is reversed.")
      )
    )
  )
)
