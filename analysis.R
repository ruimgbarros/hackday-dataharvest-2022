#import the needed packages
library(tidyverse)
library(janitor)
library(dineq)
library(glue)

#Define a list of countries that we are fetching the data from
countries <- c("at","be","bg","cy","cz","de","dk","ee","es","fr","gb","gr","hr","ie","it","lt","lu","lv","mt","pl","pt","ro","se","si","sk")

#set a dataframe
df <- data.frame(
  country = NA,
  gini = NA
)


#loop over all the countries
for (i in 1:length(countries)) {
  
  
  short_name <- countries[i]
  
  cat(glue("Getting {short_name} 🚜🚜🚜"))
  cat('\n')
  cat('\n')
  cat('\n')
  
  data <- read_csv(glue("https://s3.aleph.ninja/farmsubsidy/cleaned/{short_name}_2020.csv.cleaned.csv.gz")) %>% 
    clean_names() %>% 
    select(recipient_id, recipient_name,amount) %>% 
    group_by(recipient_id) %>% 
    summarise(amount = sum(amount)) %>% 
    filter(amount >= 0)
  
  gini <- gini.wtd(data$amount)
  
  df_to_bind <- data.frame(
    country = short_name,
    gini = gini
  )
  
  
  df <- df %>% 
    bind_rows(df_to_bind)
  
  
}


df <- df %>% 
  filter(!is.na(gini))








