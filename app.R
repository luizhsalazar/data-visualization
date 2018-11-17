#install.packages("shinydashboard")

library(shiny)
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
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              fluidRow(
                  box(
                    title = "Exemplo",
                    width = NULL,
                    plotOutput("plot1")
                  )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "widgets",
              h2("Widgets tab content")
      )
    )
  )
)

server <- function(input, output) {
  
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
  
  ### carregando algumas bases de dados para compreender...
  data("midwest", package = "ggplot2")
  data("mpg", package = "ggplot2")
  
  ### Relação entre Area e População...
  options(scipen = 15)
  gg <- ggplot(midwest, aes(x = area, y = poptotal)) +
    geom_point(aes(col = state, size = popdensity)) +
    geom_smooth(method = "loess", se = TRUE) +
    xlim(c(0, 0.1)) +
    ylim(c(0, 500000)) +
    guides(size = guide_legend(title = "Densidade"),
           colour = guide_legend(title = "Estado")) +
    labs(subtitle="Área Vs População",
         y="População",
         x="Área",
         title="Scatterplot",
         caption = "Fonte: base de dados midwest") +
    my_theme()
  
  output$plot1 <- renderPlot(gg)
}

shinyApp(ui, server)
