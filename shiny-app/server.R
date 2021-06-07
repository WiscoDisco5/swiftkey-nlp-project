# Define server logic required ----
server <- function(input, output, session) {
  
  
  get_words <- eventReactive(input$Run,{
    
    predict(ngram_model, input$text)
    
  })
  
  get_babble <- eventReactive(input$Run,{

    babble(ngram_model, input$text)
    
  })

  output$words <- renderText({
    get_words()
  })
  
  output$babble <- renderText({
    get_babble()
  })
}