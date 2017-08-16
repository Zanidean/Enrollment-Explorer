library(shiny)
library(sRa)
library(air)
library(ggrepel)

shinyServer(function(input, output) {
  
  dataframe <- reactive({
    
    df <- get_enrolment(input$measure, input$var, input$inst, 
                  remove.offshores = input$offshores,
                  remove.continuingstudies = input$cs)
    
    drop <- df %>% 
      group_by_(.dots = c(lapply(c(input$var), as.symbol))) %>% 
      summarise(N = n()) %>% 
      filter(N >= 5) %>% 
      select(1)
    
    dataframe <- df %>% 
      filter(.[[input$var]] %in% c(drop[[1]])) %>% 
      mutate(Institution = input$inst)
    
    dataframe
    })
  

  output$xmr <- renderPlot({
    whitetheme <- theme_bw() + 
      theme(strip.background = element_rect(fill = NA, linetype = 0), 
            panel.border = element_rect(color = NA), 
            panel.spacing.y = unit(5.5, "lines"), 
            panel.spacing.x = unit(6, "lines"), 
            panel.grid.major = element_blank(), 
            panel.grid.minor = element_line(colour = "#fff2f2"),
            axis.text.y =  element_blank(),
            axis.title.y = element_blank(),
            axis.ticks.y = element_blank(), 
            axis.ticks.x = element_line(),
            text = element_text(family = "sans"),
            axis.text.x = element_text(colour = "#000000", size = 17),
            axis.title.x = element_text(size = 20, face = "bold"),
            strip.text = element_text(size = 20),
            title = element_text(size = 25))
    
    dataframe <- dataframe() %>% 
      group_by_(.dots = c(lapply(c(input$var), as.symbol))) %>% 
      do(xmR(., input$measure, recalc = T)) %>%
      mutate(`Academic Year` = gsub("^.*?-", "", `Academic Year`),
             `Academic Year` = as.numeric(`Academic Year`))
    
    df <- ggplot(dataframe,
               aes(`Academic Year`, group = dataframe[[input$var]])) +
        geom_line(aes(y = `Central Line`),
                  size = 1, 
                  linetype = "dotted", 
                  na.rm = T) +
        geom_line(aes(y = `Lower Natural Process Limit`), 
                  color = "#d02b27",
                  size = 1, 
                  linetype = "dashed", 
                  na.rm = T) +
        geom_line(aes(y = `Upper Natural Process Limit`), color = "#d02b27",
                  size = 1, 
                  linetype = "dashed", 
                  na.rm = T) +
        geom_line(aes(y = dataframe[[input$measure]])) + 
        ggrepel::geom_label_repel(aes(y = dataframe[[input$measure]]),
                                label = format(
                                  round(dataframe[[input$measure]]),
                                  nsmall=0, big.mark=",", trim = T),
                                size = 6,
                                label.padding = unit(0.3, "lines"),
                                label.r = unit(0, "lines"),
                                label.size = 0.15, 
                                point.padding = unit(0.5, "lines")
                                ) +
        geom_point(aes(y = dataframe[[input$measure]]), 
                   size = 5.55, 
                   color = "#000000") +
        geom_point(aes(y = dataframe[[input$measure]]), 
                   size = 4.5, 
                   color = "#7ECBB5") +

        guides(colour=FALSE) +   
        #ggtitle(input$var) + 
        facet_wrap(~dataframe[[input$var]],
                   nrow = length(unique(dataframe[[input$var]])),
                   scales = "free",
                   labeller = label_wrap_gen()) + whitetheme
    df
  }, height = function(){input$size}
  )
  output$downloadData <- downloadHandler(
    filename = "Download.csv",
    content = function(file) {
      write.csv(dataframe(), file)
    })

  
})

