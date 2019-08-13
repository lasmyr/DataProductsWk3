library(shiny)
model<-readRDS("model_final.rds")

model_pred <- function(x) {
  pred <- predict(model, newdata = x)
  return(pred)
}

model_pred_proba <- function(x) {
  pred_proba <- predict(model, newdata = x, type = "prob")
  return(pred_proba)
 }
# c("height", "son", "social_smoker", "pet", "education", "distance", "transpexp", "avg_work_load", "avg_monhtly_absenthours")

shinyServer(function(input, output) {
  observeEvent(input$predstart, {
    # make into dataframe
    df <- data.frame(input$height, input$son, input$social_smoker, input$pet, input$education, input$distance,
                     input$transpexp, input$avg_work_load, input$avg_monthly_absenthours)
    
    colnames(df) <- c("height", "son", "social_smoker", "pet", "education", "distance", "transpexp", "avg_work_load", "avg_monthly_absenthours")
    
    # convert to 1,0 factors
    df[, "son"] <- ifelse(df[, "son"] == "yes", 1, 0)
    df[, "pet"] <- ifelse(df[, "pet"] == "yes", 1, 0)
    df[, "social_smoker"] <- ifelse(df[, "social_smoker"] == "yes", 1, 0)
    df[, "education"] <- if (df[,"education"] == "High School") {1} else if (df[,"education"] == "Bachelor's Degree") {2} else if (df[,"education"] == "Master's Degree") {3} else {4}
    df <- df %>%
      mutate(height = case_when(height >= 190 ~ 4,
                                height >= 175 & height <190 ~ 3,
                                height >= 170 & height < 175 ~ 2,
                                TRUE ~ 1)) %>%
      mutate(ratio_transexp_distance = transpexp/distance) %>%
      mutate(avg_monthly_absenthours = 
               case_when(
                 avg_monthly_absenthours >= 16 ~ 4,
                 avg_monthly_absenthours >= 6.8 & avg_monthly_absenthours < 16 ~ 3,
                 avg_monthly_absenthours >= 3.2 & avg_monthly_absenthours < 6.8 ~ 2,
                 TRUE ~ 1)) %>%
      mutate(ratio_transexp_distance = 
               case_when(ratio_transexp_distance >= 50 ~ 4,
                         ratio_transexp_distance >=20 & ratio_transexp_distance < 50 ~ 3,
                         ratio_transexp_distance >= 10 & ratio_transexp_distance < 20 ~ 2,
                         TRUE ~ 1)) %>%
      mutate(ratio_transexpense_workload = 
               case_when(avg_work_load == 1 ~ transpexp/((258+272)/2),
                         avg_work_load == 2 ~ transpexp/((240+256)/2),
                         avg_work_load == 3 ~ transpexp/((273+281)/2),
                         TRUE ~ transpexp/((299+328)/2))) %>%
      mutate(ratio_transexpense_workload = 
               case_when(ratio_transexpense_workload >= 1 ~ 4,
                         ratio_transexpense_workload >= .8 & ratio_transexpense_workload < 1 ~ 3,
                         ratio_transexpense_workload >=.59 & ratio_transexpense_workload <.8 ~ 2,
                         TRUE ~ 1)) %>%
      select("son", "social_smoker", "pet", "education", 
             "ratio_transexp_distance", "avg_work_load", "height", 
             "ratio_transexpense_workload", "avg_monthly_absenthours")
    
    for (i in 1:ncol(df)) {
      df[,i] <- as.factor(df[,i])
    }
    
    # Print to Output
    if (model_pred(df) == 1) {
      output$result <- renderUI(div(style = "padding:10px",
                                    HTML(paste0("There is a 70% chance that ", input$name, "<b> will have absenteeism issues in the next 2 months.</b>"))
      ))
    } else {
      output$result <- renderUI(div(style = "padding:10px",
                                    HTML(paste0("<b>Congrats! </b>", ifelse(input$name == "  ", "Employee", input$name), "<b> will most likely not show any absenteeism behavior in the next 2 months </b>"))
      ))
    }
    }
  )
  }
  )