source("process_data.R")

library(sbo)
set.seed(451)
# get training and testing data
train_en_us_text <- sample_n(en_us_text, 30000)
test_en_us_text <- sample_n(en_us_text, 1000)

# eval function
eval_model <- function(n, lambda) {
  
  set.seed(451)
  
  start <- Sys.time()
  
  p <- sbo_predictor(object = train_en_us_text$text, # preloaded example dataset
                     N = n, # Train a 3-gram model
                     dict = target ~ 0.75, # cover 75% of training corpus
                     .preprocess = sbo::preprocess, # Preprocessing transformation 
                     EOS = ".?!:;", # End-Of-Sentence tokens
                     lambda = lambda, # Back-off penalization in SBO algorithm
                     L = 3L, # Number of predictions for input
                     filtered = "<UNK>" # Exclude the <UNK> token from predictions
  )
  
  end <- Sys.time()
  
  eval <- eval_sbo_predictor(p, test_en_us_text$text)
  
  result <- mean(eval$correct)
  
  list(model = p, accuracy = result, fit_time = end - start)
}

# what is the best lambda?
n_options <- c(3)
lambda <- seq(.2, .8, .2)

parameters <- expand.grid(n_options, lambda)
results <- list()

for (i in 1:nrow(parameters)) {
  results[[i]] <- eval_model(n = parameters[i,1], lambda = parameters[i,2])
  print(paste("Model", i, "done"))
}

results

# lambda of 0.4 seems best
# time is pretty much the same across the board

# What is the best n_gram?
n_options <- 3:6
lambda <- 0.4

parameters <- expand.grid(n_options, lambda)
results <- list()

for (i in 1:nrow(parameters)) {
  results[[i]] <- eval_model(n = parameters[i,1], lambda = parameters[i,2])
  print(paste("Model", i, "done"))
}

times <- sapply(results, function(x) as.double(x$fit_time, units = 'secs'))
accuracy <- sapply(results, function(x) x$accuracy)
ngram_results <- data.frame(n = n_options, time = times, accuracy = accuracy)
write.csv(ngram_results, "./data/ngram_tuning_results.csv")

qplot(n_options, times,xlab = "N-gram", ylab = "Time (seconds)",)
#time seems to double per ngram increase

## Will more data be better?
set.seed(451)
train_en_us_text <- sample_n(en_us_text, 1000000)
results <- eval_model(3, .4)
# indeed... biggest single jump by just increasing the data


sample_text <- c(
  "The guy in front of me just bought a pound of bacon, a bouquet, and a case of"
  ,"You're the reason why I smile everyday. Can you follow me please? It would mean the"
  ,"Hey sunshine, can you follow me and make me the"
  ,"Very early observations on the Bills game: Offense still struggling but the"
  ,"Go on a romantic date at the"
  ,"Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my"
  ,"Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some"
  ,"After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little"
  ,"Be grateful for the good times and keep the faith during the"
  ,"If this isn't the cutest thing you've ever seen, then you must be"
)

predict(results$model, preprocess(sample_text))


sample_text2 <- c(
  "When you breathe, I want to be the air for you. I'll be there for you, I'd live and I'd"
  ,"Guy at my table's wife got up to go to the bathroom and I asked about dessert and he started telling me about his"
  ,"I'd give anything to see arctic monkeys this"
  ,"Talking to your mom has the same effect as a hug and helps reduce your"
  ,"When you were in Holland you were like 1 inch away from me but you hadn't time to take a"
  ,"I'd just like all of these questions answered, a presentation of evidence, and a jury to settle the"
  ,"I can't deal with unsymetrical things. I can't even hold an uneven number of bags of groceries in each"
  ,"Every inch of you is perfect from the bottom to the"
  ,"I’m thankful my childhood was filled with imagination and bruises from playing"
  ,"I like how the same people are in almost all of Adam Sandler's"
)

predict(results$model, preprocess(sample_text2))

