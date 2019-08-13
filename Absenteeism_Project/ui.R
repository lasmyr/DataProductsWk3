library(shiny)

# EC703AFF orange
#55804eff green
#283d4eff blue
# SteelBlue
# Chocolate
# SeaGreen
shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      # ================ SIDEBAR
      tags$style(".well {background-color:transparent; border:none;}"),
      div(id = "logo", class = "simpleDiv", 
          img(src = "https://i.ibb.co/PWmrXJj/Untitled-presentation-1.png"),
          style = {"height:200px; width:auto; margin-left:-10%"}
      ),
      div(id = "description", class = "simpleDiv",
          p("Hooky! Is an app that helps predict absenteeism of employees. With just a few bits of information, it can predict whether an employee will be absent in the following month."),
          style = {"background-color:SteelBlue; color:white; padding:10px; margin-top:-25px"})
    ),
    mainPanel(
      # ================ MAIN PANEL
      tabsetPanel(type = "pills",
                  tabPanel("Let's Predict", fluidRow(
                    column(width = 10,
                           style = "margin-top:10px; margin-left:12px; padding:10px; 
                           height:75vh; width:100vh;
                           background-color:Tomato; color: white;
                           overflow-y:scroll;",
                           p("Tell us more about the employee:"),
                           # "son", "social_smoker", "pet", "education", "ratio_transexp_distance", "avg_work_load", "height", "ratio_transexpense_workload", "avg_monthly_absenthours"
                           textInput(inputId = "name", label = "Employee Name:", value = "  ", width = "100%", 
                                     placeholder = "John Wick"),
                           numericInput(inputId = "height", label = "Height (in cm):", value = 0, width = "100%"),
                           radioButtons(inputId = "son", label = "Children?", choices = c("yes", "no"), 
                                        width = "100%", inline = TRUE),
                           radioButtons(inputId = "social_smoker", label = "Social Smoker?", choices = c("yes", "no"), 
                                        width = "100%", inline = TRUE),
                           radioButtons(inputId = "pet", label = "Pets?", choices = c("yes", "no"), 
                                        width = "100%", inline = TRUE),
                           selectInput(inputId = "education", label = "Highest Education Attained:", 
                                       choices = c("High School", "Bachelor's Degree", "Master's Degree", "Postgraduate"), 
                                       width = "100%"),
                           numericInput(inputId = "distance", label = "Average Distance from Work to Home (in km):", value =0 , 
                                        width = "100%"),
                           numericInput(inputId = "transpexp", label = "Average Daily Transportation Expense:", value = 0,
                                        min = 0, max = NA, width = "100%"),
                           sliderInput(inputId = "avg_work_load", label = "Average workload (0-4, 4 being heavy):",
                                       min = 0, max = 4, value = 2, width = "100%"),
                           sliderInput(inputId = "avg_monthly_absenthours", label = "Average Hours Absent:",
                                       min = 0, max = 20, value = 2, width = "100%"),
                           actionButton(inputId = "predstart", label = "Predict!", width = "100px"),
                           htmlOutput(outputId = "result", container = span, inline = FALSE)
                           )
                    )
                    ),
                  tabPanel("How it Works", fluidRow(
                    column(width = 10,
                           style = "margin-top:10px; margin-left:12px; padding:20px; 
                           height:75vh; width:100vh;
                           background-color:Tomato; color: white;
                           overflow-y:scroll;",
                           h3("Data Used"),
                           p("Data from employees with regards to their demographic, lifestyle, and commute behaviour was collected in order to get the data set to train this model"),
                           HTML("The data used to train the model is from <a href='https://archive.ics.uci.edu/ml/datasets/Absenteeism+at+work'> UC Irvine's Machine Learning Repository</a>."),
                           h3("Data Processed"),
                           p("All variables were made into binary or factors, whichever was applicable. Continuous variables were binned via a kmeans one-dimensional clustering technique, producing 4 clusters.
                             Other data was computed before binning, such as the ratio of transportation expense to distance of work from home and ratio of transportation expense to work load."),
                           h3("The Model"),
                           p("The model used is a normal adaboost model, with 490 iterations. The resulting accuracy from a 70/30 train/valid split is a 70% accuracy and a 75% AUC score. For further improvements to the model,
                             other adaboost models or bagged tree models can be employed.")
                           )
                  )
                  )
                  )
      )
    )
  )
  )
