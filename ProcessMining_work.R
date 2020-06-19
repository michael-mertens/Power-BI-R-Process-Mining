

# install.packages('bupaR')
# install.packages('DiagrammeR')
# install.packages('DiagrammeRsvg')
# install.packages('processmapR')
# install.packages('rsvg')
# install.packages("dplyr")

setwd('D:/OneDrive/_ClientSyncDev/_Git/Power-BI-R-Process-Mining')

library(bupaR)
library(DiagrammeR)
library(DiagrammeRsvg)
library(processmapR)
library(rsvg)
library(dplyr)

purchase_log = read.csv("PurchaseLog.csv", header = T, sep = ';')

purchase_cases =
  purchase_log %>%
  group_by(case_id) %>%
  summarise( activity_count = n())

max(purchase_cases$activity_count)
sum(purchase_cases$activity_count)

hist(
  purchase_cases$activity_count,
  main="Frequency of Activity Count", 
  xlab="Cases", 
  ylab="Frequency",
  border="blue", 
  col="green",
  breaks = 600
)

hist(
  purchase_cases$activity_count,
  main="Frequency of Activity Count", 
  xlab="Cases", 
  ylab="Frequency",
  border="blue", 
  col="green",
  xlim=c(0,10),
  breaks = 600
)

purchase_cases_excerpt = subset(purchase_cases,
            activity_count >= 30 & activity_count <= 30)

purchase_log_excerpt = 
  purchase_log %>%
    filter(case_id %in% purchase_cases_excerpt$case_id)

purchase_log_excerpt$timestamp = as.POSIXct(purchase_log_excerpt$timestamp, tz = "GMT", format = c("%Y-%m-%d %H:%M:%OS"))

x =
        eventlog(purchase_log_excerpt,
            activity_id = "activity_id",
            case_id = "case_id",
            resource_id = "resource_id",
            activity_instance_id = "activity_instance_id",
            lifecycle_id = "lifecycle_id",
            timestamp = "timestamp"
        )

process_map(x, type = frequency("relative", color_scale = "Purples"), render = TRUE)

trace_explorer(x, type = "frequent", coverage = 0.985)









