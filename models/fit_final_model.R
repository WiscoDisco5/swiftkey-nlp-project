## Fit final model
library(sbo)
# get data
rm(list = ls()); gc()
source("process_data.R")

# sample
set.seed(451)
train <- rbernoulli(nrow(en_us_text), .75)

train_text <- en_us_text[train,]
test_text <- en_us_text[!train,]

rm(en_us_text); gc()

# fit
ngram_model <- sbo_predtable(object = train_text$text,
                             N = 3,
                             dict = target ~ 0.75, # cover 75% of training corpus
                             .preprocess = sbo::preprocess, # Preprocessing transformation 
                             EOS = ".?!:;",
                             lambda = 0.4,
                             L = 3L, # Number of predictions for input
                             filtered = c("<UNK>")) # Exclude the <UNK> token from predictions

save(ngram_model, file = "shiny-app/ngram_model.Rda")

# check final error
rm(train_text); gc()
ngram_model <- sbo_predictor(ngram_model)
set.seed(451)
eval_model <- eval_sbo_predictor(ngram_model, sample_n(test_text,10000)$text)
mean(eval_model$correct) # .314


