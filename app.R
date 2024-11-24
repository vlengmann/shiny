#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)
library(car)

ui = fluidPage(
  #begin
  #Application title, this is what shows up in the beg of page
  titlePanel("Linear Regression and Multicollinearity"),
  
  #Layout: Sidebar for inputs and Main Panel for the outputs
  sidebarLayout(
    sidebarPanel(
      #Input to select the  dependent variable
      selectInput("dependent", "Select Dependent Variable:", choices = colnames(mtcars), selected = "mpg"),
      # Checkbox group to select the independent variables of the dataset
      checkboxGroupInput("independent", "Select Independent Variables:", 
                         choices = setdiff(colnames(mtcars), "mpg"), 
                         selected = setdiff(colnames(mtcars), "mpg")),
      #Button to start running the regression
      actionButton("run_model", "Run Regression"),
      hr(), #add a horizntal line for visual seperation
      # Input to drop variables dynamically based on VIF
      checkboxGroupInput("drop_vars", "Drop Variables (Reduce VIF):", choices = NULL), #start
      #Button to update and strt the regression model
      actionButton("update_model", "Update Model")
    ),
    #comma needed to seperate the panels
    mainPanel(
      #Tabs to organize outputs: Model Summary, VIF Analysis, and the different Diagnostics Plots
      tabsetPanel(
        tabPanel("Model Summary", verbatimTextOutput("model_summary")),
        tabPanel("VIF Analysis", tableOutput("vif_table")),
        tabPanel("Diagnostics Plots",
                 #show the plots, they end up showing up one  below the other
                 plotOutput("residual_plot", height= "500px"),
                 plotOutput("qq_plot", height= "500px"),
                 plotOutput("histogram_plot", height= "500px")
                 
        )
      )
    )
  )
)
#end


# Define server  logic
server = function(input, output, session) {
  #begin
  #Reactive value to store the regression model
  model = reactiveVal()
  
  #Observe event to fit the initial regression model
  observeEvent(input$run_model, {
    req(input$dependent, input$independent)  # Ensure that the inputs are provided for independent and dep
    
    #Create  th formula dynamically based on user selections
    formula = as.formula(paste(input$dependent, "~", paste(input$independent, collapse = "+")))
    
    #Fit the regression model using lm  from cars
    model(lm(formula, data = mtcars))
    
    #Update drop variables choices based on initial independent variables
    updateCheckboxGroupInput(session, "drop_vars", choices = input$independent)
  }
  )#end function
  
  # Observe event to update the model by dropping selected variables
  observeEvent(input$update_model, {
    req(input$dependent, input$independent, input$drop_vars)  # Ensure inputs are provided
    
    #Create a new formula excluding dropped variables
    formula = as.formula(paste(input$dependent, "~", paste(setdiff(input$independent, input$drop_vars), collapse = "+")))
    
    #Update the regression model
    model(lm(formula, data = mtcars))
  }
  )
  
  #Output model summary
  output$model_summary = renderPrint({
    req(model())  # Ensure the model is available
    summary(model())
  }
  ) #end render as print, model summary
  
  #Output VIF table
  output$vif_table = renderTable({
    req(model())  # Ensure the model is available
    data.frame(Variable = names(vif(model())), VIF = vif(model()))
  }
  ) #end render as table VIF values
  
  #Residual diagnostics: Residual Plot
  output$residual_plot = renderPlot({
    req(model())  # Ensure the model is available
    residuals = residuals(model())  # Extract residuals values
    fitted = fitted(model())  # Extract fitted values
    
    #Create the residual plot, ggplot only takes in as data.frame
    ggplot(data.frame(Fitted = fitted, Residuals = residuals), aes(x = Fitted, y = Residuals)) +
      geom_point(alpha = 0.5) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "pink") +
      labs(title = "Residual Plot", x = "Fitted Values", y = "Residuals") +
      theme_minimal()
  }
  )#eend render for residual. ggplot only takes in as data.frame
  
  #Residual diagnostics: QQ Plot
  output$qq_plot = renderPlot({
    req(model())  # Ensure the model is available
    residuals = residuals(model())  # Extract residuals
    
    #Create the QQ plot
    ggplot(data.frame(Sample = residuals), aes(sample = Sample)) +
      stat_qq() +
      stat_qq_line(color = "pink") +
      labs(title = "QQ Plot of Residuals", x = "Theoretical Quantiles", y = "Sample Quantiles") +
      theme_minimal()
  }
  )#end render for qq
  
  #Residual diagnostics: Histogram of Residuals
  output$histogram_plot = renderPlot({
    req(model())  # Ensure the model is available
    residuals = residuals(model())  # Extract residuals
    
    #Create the histogram of residuals
    ggplot(data.frame(Residuals = residuals), aes(x = Residuals)) +
      geom_histogram(bins = 40, fill = "purple", alpha = 0.7, color = "black") +
      labs(title = "Histogram of Residuals", x = "Residuals", y = "Frequency") +
      theme_minimal()
  }
  )#end render for histogram
}
#end
#check parentheses
# Run the application 
shinyApp(ui = ui, server = server)




