library(LSAfun)

# Cargar espacio semantico
load("EN_100k_lsa.RData")

# Leer ensayo
fileName <- "train_sent_bow/essay_0001.txt"
text <- readChar(fileName, file.info(fileName)$size)

# Calcular coherencia utilizando cadenas lexicas
coherence(text, split=c("\n"), tvectors=EN_100k_lsa)
