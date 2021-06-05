## Process Data
library(tidyverse)
library(tidytext)
library(stringi)

# Read data ----
twitter <- read_lines("data/coursera-swiftkey/final/en_us/en_US.twitter.txt")
news <- read_lines("data/coursera-swiftkey/final/en_us/en_US.news.txt")
blogs <- read_lines("data/coursera-swiftkey/final/en_us/en_US.blogs.txt")

en_us_text <- bind_rows(
  bind_cols(source = "Twitter", text = twitter),
  bind_cols(source = "News", text = news),
  bind_cols(source = "Blogs", text = blogs)
  ) %>% 
  group_by(source) %>%
  mutate(document = row_number()) %>%
  select(source, document, text) %>%
  ungroup

rm(twitter, news, blogs); gc()

pryr::object_size(en_us_text)

# Get a Hold Out Dataset
set.seed(451)

train <- rbernoulli(nrow(en_us_text), 0.75)

en_us_text_train <- en_us_text[train,]
en_us_text_test <- en_us_text[!train,]

rm(en_us_text); gc()

# Tokenize ngrams
format_modeling_text <- function(data, prior_words = 4, sample_rows = NULL) {
  
  data %>%
    { if (is.null(sample_rows)) {
      . } else {
        sample_n(., sample_rows)
      }
    } %>%
    unnest_tokens(input = text, output =  ngram, token = "ngrams", n = prior_words + 1) %>%
    separate(col = ngram, 
             into = c(paste0("previous_word", 1:prior_words), "next_word"), 
             sep = " ",
             extra = "merge")
}

# this doesnt seem to scale well...
format_modeling_text(data = en_us_text_train, sample_rows = 10000)

# Tokenize words
format_modeling_text <- function(data, sample_rows = NULL) {
  
  data %>%
    { if (is.null(sample_rows)) {
      . } else {
        sample_n(., sample_rows)
      }
    } %>%
    unnest_tokens(input = text, output =  ngram, token = "words")
}

format_modeling_text(en_us_text_train, 100)
