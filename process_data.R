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

# Tokenize ngrams
format_modeling_ngrams <- function(data, prior_words = 4, sample_rows = NULL) {
  
  data %>%
    { if (is.null(sample_rows)) {
      . } else {
        sample_n(., sample_rows)
      }
    } %>%
    unnest_tokens(input = text, output =  ngram, token = "ngrams", n = prior_words + 1) %>%
    mutate(ngram = stri_reverse(ngram)) %>%
    separate(ngram, c("next_word", "prior_words"), sep = " ",extra = "merge") %>%
    mutate(next_word = stri_reverse(next_word), prior_words = stri_reverse(prior_words)) %>%
    select(source, document, prior_words, next_word)
}

# this doesnt seem to scale well...
#format_modeling_text(data = en_us_text_train, sample_rows = 10000)

# Tokenize words
format_modeling_text <- function(data, sample_rows = NULL) {
  
  data %>%
    { if (is.null(sample_rows)) {
      . } else {
        sample_n(., sample_rows)
      }
    } %>%
    unnest_tokens(input = text, output =  words, token = "words")
}

#format_modeling_text(en_us_text_train, 100)

# Tokenize letters
format_modeling_characters <- function(data, sample_rows = NULL) {
  
  data %>%
    { if (is.null(sample_rows)) {
      . } else {
        sample_n(., sample_rows)
      }
    } %>%
    unnest_tokens(input = text, 
                  output =  characters, 
                  token = "characters",
                  strip_non_alphanum = FALSE,
                  to_lower = FALSE)
}

#format_modeling_characters(en_us_text_train, 10000)
