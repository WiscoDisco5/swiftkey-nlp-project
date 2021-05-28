#q1

file.info("data/coursera-swiftkey/final/en_us/en_US.blogs.txt")

#q2
library(tidyverse)

twitter <- read_lines("data/coursera-swiftkey/final/en_us/en_US.twitter.txt")

length(twitter)

# q3
news <- read_lines("data/coursera-swiftkey/final/en_us/en_US.news.txt")
blogs <- read_lines("data/coursera-swiftkey/final/en_us/en_US.blogs.txt")

max(nchar(twitter))
max(nchar(news))
max(nchar(blogs))

# q4
sum(grepl("love", twitter)) / sum(grepl("hate", twitter))

sum(str_detect(twitter, "love")) /sum(str_detect(twitter, "hate"))

#q5
twitter[str_detect(twitter, "biostats")]

#q6
sum(str_detect(twitter, "A computer once beat me at chess, but it was no match for me at kickboxing"))

twitter[str_detect(twitter, "A computer once beat me at chess, but it was no match for me at kickboxing")]
