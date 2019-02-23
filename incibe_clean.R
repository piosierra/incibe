library(data.table)
library(tidyr)

#reads the data got from "Tabula")

datos <- read.csv("tabula-catalogo_ciberseguridad-pages-1236-1500.csv",
                          header= FALSE, 
                          encoding="UTF-8", 
                          blank.lines.skip = TRUE, 
                          colClasses = "character")

#elimina filas en blanco OBSOLETO?

datos <- datos[datos!=""]

#elimina filas de categorías OBSOLETO?

datos_der <- sub("^.*[:]", "", datos)

#elimina fila posterior a aquella que termina en guión

lista_sobrante <- append(FALSE, grepl("-$", datos_der[-7970]))
datos_der <- datos_der[!lista_sobrante] 

#Corrige un nombre de empresa duplicado

datos_der[4648]="CCQ2"

#Elimina filas dobles que no tenían guión

datos_limp <- datos_der[-c(332, 1454, 1809, 1810, 2352, 2755, 3170, 
                           3716, 3717, 3718, 3750, 3979, 4154, 4275,
                           4384, 4685, 4758, 4771, 4928, 5277, 5416,
                           5933, 6252, 6631, 6746, 6753, 6934, 7337,
                           7356, 7573)]

#crea el resto de columnas

tipos <- c("Nombre", "Tipo", "Provincia", "URL", "email", "Tfn")
empresas <- datos_limp[(0:7901)%/%6*6+1]

#las une y da formato ancho

DT <- data.table(Empresa = empresas, Campos=tipos, Datos=datos_limp)
ancha <- spread(DT, Campos, Datos)
write.csv(ancha, file = "lista empresas.csv")

