if (!require("pacman")) install.packages("pacman")

pacman::p_load(
  rvest,
  readr,
  here, 
  quanteda, 
  ggplot2, 
  tidyverse, 
  purrr, 
  dplyr, 
  tm, 
  RCurl,
  httr, 
  R.utils
)

news_data <- read_csv(getURL("https://raw.githubusercontent.com/marisaasmith/SICSS-Project---Immigrants-in-STEM/main/news_data/STEM%20stories%20-%202015.csv"))


scrape <- function(x){
  text <- tryCatch(read_html(x) %>%
    html_nodes(css = 'p') %>%
    html_text(trim = T) %>%
      trimws() %>%
      paste0(collapse = " "), error = function(e){NA})
  return(text)
}

scrape_wrapper <- function(x){
  withTimeout(expr = scrape(x), timeout = 60) 
}


news_data_2015 <- news_data[5:10,] %>%
  mutate(text_raw = map(url, scrape_wrapper) %>%
           map_chr(1L))

saveRDS(news_data_2015, "news_data_2015.rds")   
