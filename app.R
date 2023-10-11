library(shiny)
library(DT)
#setwd("D:/R_Quarto_various/ShinyApps/ROSAapp") ## COMMENT BEFORE DEPLOYING
alimentos = read.csv("alimentos.csv")
colnames(alimentos) = c("COD","NUM","ALIMENTO","ENERCKCAL","ENERCKJ","WATER","PROCNT",
                   "FAT","CHOCDF","ZN","K","P","FE","VITA",
                   "ACFOLIC","VITC","NA")
alimentos = alimentos[,c("COD","NUM", "ALIMENTO", "ENERCKCAL", "ENERCKJ", "WATER", "PROCNT", "FAT", "CHOCDF",
                         "ZN","K","P","FE","VITA","ACFOLIC","VITC","NA")]

codigo = c("A","B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "Q", "T", "U", "S")
categoria = c("Cereales y derivados", "Verduras, hortalizas y derivados", "Frutas y derivados", "Grasas, aceites y oleaginosas",
              "Pescados y mariscos", "Carnes y derivados", "Leche y derivados", "Bebidas (alcohólicas y analcohólicas)", "Huevos y derivados",
              "Productos azucarados", "Misceláneos", "Alimentos infantiles", "Leguminosas y derivados", "Tubérculos, raíces y derivados",
              "Alimentos preparados")
codigoGrupo = data.frame(codigo,categoria)
colnames(codigoGrupo) = c("Código", "Categoría")

ui <- fluidPage(
  titlePanel("TABLAS PERUANAS DE COMPOSICIÓN DE ALIMENTOS - 2017"),
  h2(tags$a("Centro Nacional de Alimentación y Nutrición, 2017, Tablas Peruanas de composición de Alimentos, Ministerio de Salud del Perú, Lima.",href="https://web.ins.gob.pe/es/alimentacion-y-nutricion/ciencia-y-tecnologia-de-alimentos/tabla-de-composicion-de-alimentos")),
  h3("Modified and intended for daily use of diet planning by Nutrionist Rosa Zavaleta Gavidia"),
  tabsetPanel(
    tabPanel("Tabla",
      h3("Composición en 100 g de alimento !"),
      numericInput("proportion","Nueva composición (gramos)?", value = 100, min = 1, max = 500),
      DT::dataTableOutput('foodTable'),#DTOutput("foodTable")
      verbatimTextOutput("dataConversion")
    ),
    tabPanel("Códigos y grupos", tableOutput('codigoGrupos')),
    tabPanel("Extras")
  ),
  hr(),
  tags$div(class = "header", checked = NA,
           tags$h5("App built with R Shiny. Did you like it? If so"),
           tags$a(href = "shiny.rstudio.com/tutorial", "Click Here to learn more!")
  )
)

server <- function(input, output, session) {
  getComposition <- reactive({
    proportionConversion = input$proportion
    idx = input$foodTable_rows_selected
    alimentos[idx,c("PROCNT", "FAT", "CHOCDF","ZN","K","P","FE","VITA","ACFOLIC","VITC","NA")]*proportionConversion/100
  })
  
  output$foodTable = DT::renderDataTable(alimentos, options = list(pageLength = 15), 
                                          server = FALSE, selection = "single")#renderDT
  output$dataConversion = renderPrint({getComposition()})
  
  output$codigoGrupos = renderTable(codigoGrupo)
}

shinyApp(ui, server)


## Uncomment for compilation and uploading in ShinnyApss
#library(rsconnect)
#rsconnect::deployApp('D:/R_Quarto_various/ShinyApps/ROSAapp')
