# Load Packages -----

library(brandr)
library(downlit)
library(ggplot2)
library(here)
library(knitr)
library(magrittr)
library(ragg)
library(showtext)
library(sysfonts)
library(xml2)

# Set Options -----

options(
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  scipen = 10,
  digits = 10,
  stringr.view_n = 6,
  pillar.bold = TRUE,
  width = 77 # 80 - 3 for #> Comment
)

# Set Variables -----

set.seed(2025)

# Set `knitr` -----

clean_cache() |> suppressWarnings()

opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  root.dir = here(),
  dev = "ragg_png",
  fig.showtext = TRUE
)

# Set `brandr` -----

options(BRANDR_BRAND_YML = here("_brand.yml"))

# Set and Load Fonts -----

font_paths(here("ttf"))

font_add(
  family = "inter",
  regular = here("ttf", "inter-24pt-regular.ttf"),
  bold = here("ttf", "inter-24pt-bold.ttf"),
  italic = here("ttf", "inter-24pt-italic.ttf"),
  bolditalic = here("ttf", "inter-24pt-bolditalic.ttf"),
  symbol = NULL
)

showtext_auto()

# Set `ggplot2` Theme -----

theme_set(
  theme_bw() +
    theme(
      text = element_text(
        color = get_brand_color("black"),
        family = "inter",
        face = "plain"
      ),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      legend.frame = element_blank(),
      legend.ticks = element_line(color = "white")
    )
)
