library(lsa)
load("grades")

#############################################################################
# Cuando se quiera usar el corpus y su modelo de espacio vectorial
# Leer y hace representacion del espacio vectorial del corpus
corpus_essays <- textmatrix("essays_cleaned", stemming = FALSE,
                            minWordLength = 3)

save(corpus_essays, file = "corpus.RData")
#############################################################################
load("corpus_LSA.RData")

aparicion <- corpus_essays != 0
rowTotals <- apply(aparicion, 1, sum)
corpus_essays <- corpus_essays[rowTotals > 1, ]

# Total number of essays in score 1
N <- dim(corpus_essays)[2]

# Cantidad de ensayos en los que aparece la palabra i
Ni <- rowSums(corpus_essays > 0)

test_essays <- textmatrix("test_essays_cleaned", stemming = FALSE,
                          minWordLength = 3, 
                          vocabulary = rownames(corpus_essays))