library(shiny)    
library(readxl)
library(dplyr)
library(leaflet)
library(tidyverse)
library(sf)

diccionario<- read_excel("Diccionario_Base_PERSONA.xlsx", sheet = "depto", col_types = c("numeric","text"))
names(diccionario)[1] <- "departamen"
datapob <- read_excel("Estimaciones-y-Proyecciones-Municipales-2015-2035.xlsx",sheet = "Regulada")
data_long <- datapob %>% gather(Anio, Poblacion, 3:23)
Prueba=data_long%>% group_by(Depto, Anio)%>% summarise(Población=sum(Poblacion))
Prueba=Prueba %>% group_by(Anio) %>% mutate(porcentaje = (Población/sum(Población) * 100))
Prueba=right_join(diccionario,Prueba)
Prueba=select(Prueba,-2)
data <- read_csv("muestralimpia.csv", col_types = cols(X1 = col_skip(),Id = col_skip()))
names(data)[1] <- "departamen"

muestra<- data %>% group_by(departamen) %>% summarise(Población = n())
muestra$porcentaje=100*muestra$Población/sum(muestra$Población)
muestra$Anio="muestra"

todo=bind_rows(Prueba, muestra)

gt_map <- st_read("departamentos_gtm.shp")
gtmap_proyec=left_join(todo, gt_map)

ui = fluidPage(
    selectInput(inputId = "Ano", "Elija el anio del que desea ver proyecciones", c("muestra",2015:2035)),
    plotOutput(outputId = "map")
)
server = function(input, output) {
    output$map = renderPlot({
        ggplot(data=gtmap_proyec[gtmap_proyec$Anio==input$Ano,], aes(fill = porcentaje, geometry = geometry)) +geom_sf()
    })
}
shinyApp(ui, server)

