# Define server logic required ----
server <- function(input, output, session) {
  
  
  get_words <- eventReactive(input$Run,{
    
    words <- predict(ngram_model, input$text)
    words <- gsub("<EOS>", ".!?", words)
    paste0("<code>", words, "</code>")
    
  })
  
  get_babble <- eventReactive(input$Run,{

    babble_sentence <- babble(ngram_model, input$text)
    paste0("<pre><code>", babble_sentence, "</pre></code>")
  })

  output$words <- renderText({
    get_words()
  })
  
  output$babble <- renderText({
    get_babble()
  })
}