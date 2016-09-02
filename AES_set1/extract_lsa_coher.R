library(LSAfun)

strcount <- function(x, pattern, split=" "){
  
  unlist(lapply(
    strsplit(x, split),
    function(z) na.omit(length(grep(pattern, z)))
  ))
  
}

# Cargar espacio semantico
load("EN_100k_lsa.rda")

# Listar archivos en directorio
f <- list.files("train_sent_bow")
N <- length(f)
global_coh <- rep(0, N)

for (i in 1:N) {
  fileName <- paste0("train_sent_bow/", f[i])
  text <- readChar(fileName, file.info(fileName)$size)
  if (strcount(text, "\n") != 0)
    coher <- coherence(text, split=c("\n"), tvectors=EN_100k_lsa)
  else
    coher$global <- 0
  global_coh[i] <- coher$global
}
load("training_grades.RData")
