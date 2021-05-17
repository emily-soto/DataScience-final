library(readr)
library(tidyverse)

# cargo data limpia
df <- read_csv("data-limpia.csv")

#pongo nombbre al ID
names(df)[1] <- "Id"

#Asigno variables con NA ocultos a vectores
a <- df$PCP31_D
b <- df$PCP37
c <- df$PCP30_1D
d <- df$PCP31_D

#Traduzo los NA a spaces blanks
a <- str_replace_all(string = a,pattern = "9",replacement = "")
b <- str_replace_all(string = b,pattern = "99",replacement = "")
c <- str_replace_all(string = c,pattern = "99",replacement = "")
d <- str_replace_all(string = d,pattern = "9",replacement = "")

#Inbtroduzco los vectores traducidos al df
df$PCP31_D <- a
df$PCP37 <- b
df$PCP30_1D <- c
df$PCP31_D <- d


# Cambios los blank space a Na y elimino todas observaciones con algun NA
df[df==""] <- NA
df2 <- na.omit(df)
