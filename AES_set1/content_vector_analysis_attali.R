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

# Features a extraer
score_point_val <- rep(0, NTOTALESSAYS)
corr_best_essays <- rep(0, NTOTALESSAYS)
pat_cos <- rep(0, NTOTALESSAYS)
val_cosine <- rep(0, NTOTALESSAYS)

# Propositos de testeo (Se supone que se saca un ensayo y se computan sus caracteristicas)
# id <- 1

for (id in 1:NTOTALESSAYS) {
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
    
    correlation <- 0
    score_point_value <- 2
    cosine_corr_value <- 0
    
    R <- rep(0, length(grade_types))
    for (i in 1:length(grade_types))
    {
        tmp_cor <- cosine(Wessay, W[, i])
        R[i] <- tmp_cor
        if (tmp_cor > correlation) {
            correlation <- tmp_cor
            score_point_value <- grade_types[i]
        }
    }
    
    correlation <- cosine(Wessay, W[, ncol(W)])
    pattern_cosine <- grade_types %*% R
    grade_n <- length(R)
    val_cos_n <- round(grade_n/2)
    val_cos <- sum(R[(val_cos_n+1):grade_n]) - sum(R[1:val_cos_n])
    
    # Llenar vectores con valores
    score_point_val[id] <- score_point_value
    corr_best_essays[id] <- correlation
    pat_cos[id] <- pattern_cosine
    val_cosine[id] <- val_cos
}

attali_features <- data.frame(score_point_value=score_point_val, 
                              max_cos=corr_best_essays, pattern_cosine=pat_cos,
                              val_cosine=val_cosine)

write.csv(attali_features, "attali_features.csv", row.names=FALSE)
