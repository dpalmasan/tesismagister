library(lsa); library(LSAfun)
load("grades")

#############################################################################
# Cuando se quiera usar el corpus y su modelo de espacio vectorial
# Leer y hace representacion del espacio vectorial del corpus
corpus_essays <- textmatrix("essays_cleaned", stemming = FALSE,
                            minWordLength = 3)

save(corpus_essays, file = "corpus.RData")
#############################################################################
load("corpus_LSA.RData")

# Cantidad total de ensayos
NTOTALESSAYS <- length(grades)
N <- NTOTALESSAYS - 1

# Propositos de testeo (Se supone que se saca un ensayo y se computan sus caracteristicas)
id <- 1

# Toma el corpus sin el ensayo al que se le calcularan las caracteristicas
corpus <- corpus_essays[, -id]
feat_grades <- grades[-id]
essay <- corpus_essays[, id]
  
# Se sacan los tipos de nota (recordar que hay un solo dato con nota 3)
grade_types <- unique(feat_grades)

# Indexar en lista conjuntos de ensayos con diferente nota
l <- list()
k <- 1
for (grade in grade_types)
{
  l[[k]] <- which(feat_grades == grade)
  k <- k + 1
}

# Procesar corpus, eliminar palabras que aparezcan una sola vez (ruido)
aparicion <- corpus != 0
rowTotals <- apply(aparicion, 1, sum)
corpus.proc <- corpus[rowTotals > 1, ]

# Vector que tiene la cantidad de veces que ocurre una palabra en todos los ensayos
Ni <- apply(corpus.proc > 0, 1, sum)

# Inicializar matriz de pesos
W <- matrix(0, nrow(corpus.proc), length(grade_types))

# Para cada score point category
for (s in 1:length(grade_types)) {
  score_category <- corpus.proc[, l[[s]]]
  if (length(l[[s]]) > 1)
    Fis <- apply(score_category, 1, sum)
  else
    Fis <- score_category
  W[, s] <- Fis/max(Fis) * log(N/Ni)
}

# Dejar essay con el vocabulario del corpus
essay <- essay[rownames(corpus.proc)]
Wessay <- essay/max(essay) * log(N/Ni)
