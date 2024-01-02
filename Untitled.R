library(tidyverse)
library(ggplot2)
library(dplyr)


yt11 <- yt %>% group_by(channel_name, country) %>%
  summarise(total_view=sum(view_count)) %>% arrange(desc(total_view))

yt10 <- yt%>% filter(channel_name == "DrakeVEVO", country == "US") %>% group_by(channel_name, country) %>% 
summarise(view_count, snapshot_date, .groups = "drop")

yt12 <- yt %>% group_by(country, channel_name) %>%
  summarise(snapshot_date, title) %>% arrange(desc(total_view))

yt15 <- yt %>% group_by(channel_name, country) %>%
  summarise(total_view=sum(view_count)) %>% arrange(desc(total_view))

yt13 <- yt %>% group_by(country) %>%
  summarise(total_view=sum(view_count)) %>% arrange(desc(total_view))

