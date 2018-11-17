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
  guides(size = guide_legend(title = "Densidade as dad sa"),
         colour = guide_legend(title = "Estado")) +
  labs(subtitle="Área Vs População",
       y="População",
       x="Área",
       title="Scatterplot",
       caption = "Fonte: base de dados midwest") +
  my_theme()