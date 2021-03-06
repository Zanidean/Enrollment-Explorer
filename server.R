library(shiny)
library(sRa)
library(air)
library(ggrepel)
library(tidyverse)

shinyServer(function(input, output) {
  
  
  dataframe <- reactive({
    
    df <- get_enrolment(measures = input$measure, 
                        rows = input$var, 
                        institutions = input$inst, 
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
  
  plotHeight = reactive({
    dat <- dataframe()
    dat <- dat[[input$var]]
    dat <- unique(dat)
    return(length(dat)*450)
  })
  

  output$xmr <- renderPlot({
    whitetheme <- theme_bw() + 
      theme(strip.background = element_rect(fill = NA, linetype = 0), 
            panel.border = element_rect(color = NA), 
            panel.spacing.y  = unit(5.5, "lines"), 
            panel.spacing.x  = unit(6, "lines"), 
            panel.grid.minor = element_blank(), 
            panel.grid.major = element_line(colour = "#fff2f2"),
            axis.text.y  = element_blank(),
            axis.title.y = element_blank(),
            axis.ticks.y = element_blank(), 
            axis.ticks.x = element_blank(),
            text = element_text(family = "sans"),
            axis.text.x = element_text(colour = "#000000", size = 17),
            axis.title.x = element_text(size = 20, face = "bold"),
            strip.text = element_text(size = 20),
            title = element_text(size = 20))
    
    measure <- gsub("\\-", " ", input$measure)
     
    dataframe <- dataframe() %>% 
      group_by_(.dots = c(lapply(c(input$var), as.symbol))) %>% 
      do(xmR(., measure, recalc = T)) %>%
      # mutate(`Academic Year` = gsub("^.*?-", "", `Academic Year`),
      #        `Academic Year` = as.numeric(`Academic Year`))
      mutate(`Academic Year` = gsub("-20", "-", `Academic Year`))
    
    # dataframe$Colour <- 0
    # if(any(dataframe[[input$measure]] > dataframe$`Upper Natural Process Limit`,
    #        dataframe[[input$measure]] < dataframe$`Lower Natural Process Limit`)){
    #   dataframe$Colour <- 1
    # }
      
    df <- ggplot(dataframe,
               aes(`Academic Year`, 
                   group = dataframe[[input$var]])) +
        geom_line(aes(y = `Central Line`),
                  size = 1, 
                  linetype = "dotted", 
                  na.rm = T) +
        geom_line(aes(y = `Lower Natural Process Limit`), 
                  color = "#d02b27",
                  size  = 1, 
                  linetype = "dashed", 
                  na.rm  = T) +
        geom_line(aes(y  = `Upper Natural Process Limit`), 
                  color  = "#d02b27",
                  size   = 1, 
                  linetype = "dashed", 
                  na.rm  = T) +
        geom_line(aes(y  = dataframe[[measure]])) + 
        geom_point(aes(y = dataframe[[measure]]), 
                   size  = 5.55, 
                   color = "#000000") +
        geom_point(aes(y = dataframe[[measure]]), 
                   size  = 4.5, 
                   color = "#7ECBB5") + 
        geom_label_repel(aes(y = dataframe[[measure]]),
                label = format(
                  round(dataframe[[measure]], 2),
                  nsmall = 0, big.mark = ",", trim = T),
                size = 6,
                label.r = unit(0.2, "lines"),
                label.size = 0.15, nudge_x = 0.32) +
        guides(colour = FALSE) +   
        ggtitle(paste(input$measure,
                       "Enrolment by",
                       input$var,
                       "at",
                       input$inst, sep = " ")) + 
        facet_wrap(~dataframe[[input$var]],
                   nrow   = length(unique(dataframe[[input$var]])),
                   scales = "free",
                   labeller = label_wrap_gen()) + whitetheme
    df
  }, 
  height = function() {
    plotHeight()
    }
  )
  
  output$downloadData <- downloadHandler(
    filename = "Download.csv",
    content = function(file) {
      write.csv(dataframe(), file, na = "", row.names = F)
    })

})

