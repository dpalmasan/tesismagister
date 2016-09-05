library(LSAfun)

# Cargar espacio semantico
load("EN_100k_lsa.rda")

# Leer ensayo
fileName1 <- "train_sent_bow/essay_0001.txt"
fileName2 <- "train_sent_bow/essay_1000.txt"
di <- readChar(fileName1, file.info(fileName1)$size)
dj <- readChar(fileName2, file.info(fileName2)$size)
# Calcular coherencia utilizando cadenas lexicas
costring(di, dj, tvectors=EN_100k_lsa, breakdown=FALSE)
