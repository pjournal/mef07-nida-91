pti <- c("shiny","tidyverse","ggplot2")
pti <- pti[!(pti %in% installed.packages())]
if(length(pti)>0){
  install.packages(pti)}

library(shiny)
library(tidyverse)
library(ggplot2)

yt <- read.csv("trending_yt_videos_113_countries-2.csv")

yt

yt$PublishMonthDay <- sapply(strsplit(as.character(yt$publish_date), " "), "[", 1)
yt$PublishTime <- sapply(strsplit(as.character(yt$publish_date), " "), "[", 2)


yt$PublishDate <- as.Date(yt$publish_date)

yt$snapshot_date <- as.Date(yt$snapshot_date)

yt1 <- yt %>% group_by(country) %>%
  summarise(total_view=sum(view_count)) %>% arrange(desc(total_view))

yt2 <- yt %>% group_by(channel_name, country) %>%
  summarise(total_view=sum(view_count)) %>% arrange(desc(total_view)) 

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Youtube Data"),
  tabsetPanel
    (tabPanel('Total Views', sidebarPanel(position="left", 
                                                             selectInput("country",
                                                                         "Enter Country:",
                                                                         choices = unique(yt$country),
                                                                         multiple = TRUE),
                                                             selectInput("channel_name",
                                                                         "Enter Channel Name:",
                                                                         choices = unique(yt$channel_name),
                                                                         multiple = TRUE)),   mainPanel(plotOutput("Plot1"), plotOutput("Plot2"))), 
              tabPanel('Date Range', sidebarPanel(position="left",
                                                  dateRangeInput("date_range", "Select The Date Range:", start = min(yt$snapshot_date), end = max(yt$snapshot_date), min = min(yt$snapshot_date), max=max(yt$snapshot_date))
              ), mainPanel(plotOutput("Plot3"))))
  )
                                                                                                                                                                          

server <- function(input, output) {
  rval <- reactive({
    yt1 %>% 
      filter(if (!is.null(input$country)) country %in% input$country else TRUE)
  })
  
  rval2 <- reactive({
    yt2 %>% 
      filter(if (!is.null(input$country)) country %in% input$country else TRUE, if (!is.null(input$channel_name)) channel_name %in% input$channel_name else TRUE)
  })
  
  rval3 <- reactive({filter(yt, snapshot_date>=input$date_range[1] & snapshot_date<=input$date_range[2], if (!is.null(input$country)) country %in% input$country else TRUE, if (!is.null(input$channel_name)) channel_name %in% input$channel_name else TRUE)
  })
  
  output$Plot1 <- renderPlot({
    rval () %>%
      ggplot(aes(x=country,y=total_view, fill=country)) + geom_bar(stat="identity") + expand_limits(y=0) + labs(title= "Total Views Of The Selected Countries") 
  })
  
  output$Plot2 <- renderPlot({
    rval2 () %>%
      ggplot(aes(x=channel_name,y=total_view, fill=country)) + geom_bar(stat="identity") + expand_limits(y=0) + labs(title= "Total Views Of The Selected Channels in Selected Countries") 
  })
  
  output$Plot3 <- renderPlot({
    rval3() %>%
      ggplot(aes(x=snapshot_date,y=view_count, color=country))+geom_point() + labs(title= "View of Selected Channels On Selected Countries Between The Selected Dates")
  })
}
# Run the application 
shinyApp(ui = ui, server = server)

