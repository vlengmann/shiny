

# Linear Regression and Multicollinearity

## Link to Shiny App
Check out the interactive app: [Linear Regression and Multicollinearity](https://vlengmann.shinyapps.io/multicollin2shiny/)

---

## Purpose
This app helps diagnose multicollinearity and address linear regression assumptions using diagnostic plots while fitting regression models interactively.

---

## Workflow
The app workflow is as follows:

1. Start by selecting a dependent variable from the `mtcars` dataset.
2. Select independent variables for the model using checkboxes.
3. Click the **Run Regression** button to fit the initial model.
4. Drop variables to reduce VIF scores using the checkboxes under **Drop Variables**.
5. Click the **Update Model** button to compute the VIF and display updated values in the VIF analysis table.

Users can then explore the results through three tabs:
- **Model Summary**: View regression performance metrics like coefficients, R², and p-values.
- **VIF Analysis**: Diagnose multicollinearity by checking VIF values.
- **Diagnostic Plots**: Assess linear regression assumptions using plots created with `ggplot2`.

---

## Variables in the mtcars Dataset
- **mpg**: Miles per gallon
- **cyl**: Number of cylinders
- **disp**: Displacement in cubic inches
- **hp**: Gross horsepower
- **drat**: Rear axle ratio
- **wt**: Weight in 1,000 lbs
- **qsec**: 1/4 mile time
- **vs**: Engine (0 = V-shaped, 1 = straight)
- **am**: Transmission (0 = automatic, 1 = manual)
- **gear**: Number of forward gears
- **carb**: Number of carburetors

---

## Features
The app provides:
- Dynamic selection of dependent and independent variables.
- Real-time VIF analysis to identify and reduce multicollinearity.
- Diagnostic plots to evaluate regression assumptions visually.

---

## How to Run Locally
To run the app locally:
```r
library(shiny)
runApp("path/to/your/app")


---

