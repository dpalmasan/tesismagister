library(lsa)
load("training_grades.RData")

#############################################################################
# Cuando se quiera usar el corpus y su modelo de espacio vectorial
# Leer y hace representacion del espacio vectorial del corpus
corpus_essays <- textmatrix("essays_cleaned", stemming = FALSE,
                           minWordLength = 3)

save(corpus_essays, file = "corpus.RData")
#############################################################################
load("corpus.RData")

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
#------------------------------------------------------------------------------
# maxima frecuencia de cualquier palabra en todos los ensayos
maxFe <- apply(corpus_essays, 2, max)
testMaxFe <- apply(test_essays, 2, max)
W_test <- test_essays / testMaxFe *log(N / Ni)
#------------------------------------------------------------------------------

score2 <- which(training_grades == 2)
score4 <- which(training_grades == 4)
score5 <- which(training_grades == 5)
score6 <- which(training_grades == 6)
score7 <- which(training_grades == 7)
score8 <- which(training_grades == 8)
score9 <- which(training_grades == 9)
score10 <- which(training_grades == 10)
score11 <- which(training_grades == 11)
score12 <- which(training_grades == 12)

#---------------------------------------------------------------
# SCORE 2
#---------------------------------------------------------------
essays_score <- corpus_essays[, score2]

Fi <- rowSums(essays_score)
MaxF <- max(Fi)
Wi <- Fi / MaxF * log(N / Ni)

# Pesos de los ensayos dado el set
W <- corpus_essays/ maxFe * log(N / Ni)

cosine_sim_2 <- 1:N
for(i in 1:N) {
    cosine_sim_2[i] <- cosine(W[, i], Wi)
}


test_cosine_sim_2 <- 1:356
for(i in 1:356) {
    test_cosine_sim_2[i] <- cosine(W_test[, i], Wi)
}

################################################################

#---------------------------------------------------------------
# SCORE 4
#---------------------------------------------------------------
essays_score <- corpus_essays[, score4]

Fi <- rowSums(essays_score)
MaxF <- max(Fi)
Wi <- Fi / MaxF * log(N / Ni)

# Pesos de los ensayos dado el set
W <- corpus_essays/ maxFe * log(N / Ni)

cosine_sim_4 <- 1:N
for(i in 1:N) {
    cosine_sim_4[i] <- cosine(W[, i], Wi)
}

test_cosine_sim_4 <- 1:356
for(i in 1:356) {
    test_cosine_sim_4[i] <- cosine(W_test[, i], Wi)
}
################################################################

################################################################

#---------------------------------------------------------------
# SCORE 5
#---------------------------------------------------------------
essays_score <- corpus_essays[, score5]

Fi <- rowSums(essays_score)
MaxF <- max(Fi)
Wi <- Fi / MaxF * log(N / Ni)

# Pesos de los ensayos dado el set
W <- corpus_essays/ maxFe * log(N / Ni)

cosine_sim_5 <- 1:N
for(i in 1:N) {
    cosine_sim_5[i] <- cosine(W[, i], Wi)
}

test_cosine_sim_5 <- 1:356
for(i in 1:356) {
    test_cosine_sim_5[i] <- cosine(W_test[, i], Wi)
}
################################################################

#---------------------------------------------------------------
# SCORE 6
#---------------------------------------------------------------
essays_score <- corpus_essays[, score6]

Fi <- rowSums(essays_score)
MaxF <- max(Fi)
Wi <- Fi / MaxF * log(N / Ni)

# Pesos de los ensayos dado el set
W <- corpus_essays/ maxFe * log(N / Ni)


cosine_sim_6 <- 1:N
for(i in 1:N) {
    cosine_sim_6[i] <- cosine(W[, i], Wi)
}

test_cosine_sim_6 <- 1:356
for(i in 1:356) {
    test_cosine_sim_6[i] <- cosine(W_test[, i], Wi)
}
################################################################

#---------------------------------------------------------------
# SCORE 7
#---------------------------------------------------------------
essays_score <- corpus_essays[, score7]

Fi <- rowSums(essays_score)
MaxF <- max(Fi)
Wi <- Fi / MaxF * log(N / Ni)

# Pesos de los ensayos dado el set
W <- corpus_essays/ maxFe * log(N / Ni)

cosine_sim_7 <- 1:N
for(i in 1:N) {
    cosine_sim_7[i] <- cosine(W[, i], Wi)
}

test_cosine_sim_7 <- 1:356
for(i in 1:356) {
    test_cosine_sim_7[i] <- cosine(W_test[, i], Wi)
}
################################################################

#---------------------------------------------------------------
# SCORE 7
#---------------------------------------------------------------
essays_score <- corpus_essays[, score8]

Fi <- rowSums(essays_score)
MaxF <- max(Fi)
Wi <- Fi / MaxF * log(N / Ni)


# Pesos de los ensayos dado el set
W <- corpus_essays/ maxFe * log(N / Ni)

cosine_sim_8 <- 1:N
for(i in 1:N) {
    cosine_sim_8[i] <- cosine(W[, i], Wi)
}

test_cosine_sim_8 <- 1:356
for(i in 1:356) {
    test_cosine_sim_8[i] <- cosine(W_test[, i], Wi)
}
################################################################

#---------------------------------------------------------------
# SCORE 9
#---------------------------------------------------------------
essays_score <- corpus_essays[, score9]

Fi <- rowSums(essays_score)
MaxF <- max(Fi)
Wi <- Fi / MaxF * log(N / Ni)

# Pesos de los ensayos dado el set
W <- corpus_essays/ maxFe * log(N / Ni)

cosine_sim_9 <- 1:N
for(i in 1:N) {
    cosine_sim_9[i] <- cosine(W[, i], Wi)
}

test_cosine_sim_9 <- 1:356
for(i in 1:356) {
    test_cosine_sim_9[i] <- cosine(W_test[, i], Wi)
}
################################################################

#---------------------------------------------------------------
# SCORE 10
#---------------------------------------------------------------
essays_score <- corpus_essays[, score10]

Fi <- rowSums(essays_score)
MaxF <- max(Fi)
Wi <- Fi / MaxF * log(N / Ni)

# Pesos de los ensayos dado el set
W <- corpus_essays/ maxFe * log(N / Ni)

cosine_sim_10 <- 1:N
for(i in 1:N) {
    cosine_sim_10[i] <- cosine(W[, i], Wi)
}

test_cosine_sim_10 <- 1:356
for(i in 1:356) {
    test_cosine_sim_10[i] <- cosine(W_test[, i], Wi)
}
################################################################

#---------------------------------------------------------------
# SCORE 10
#---------------------------------------------------------------
essays_score <- corpus_essays[, score11]

Fi <- rowSums(essays_score)
MaxF <- max(Fi)
Wi <- Fi / MaxF * log(N / Ni)

# Pesos de los ensayos dado el set
W <- corpus_essays/ maxFe * log(N / Ni)

cosine_sim_11 <- 1:N
for(i in 1:N) {
    cosine_sim_11[i] <- cosine(W[, i], Wi)
}

test_cosine_sim_11 <- 1:356
for(i in 1:356) {
    test_cosine_sim_11[i] <- cosine(W_test[, i], Wi)
}

################################################################

#---------------------------------------------------------------
# SCORE 12
#---------------------------------------------------------------
essays_score <- corpus_essays[, score12]

Fi <- rowSums(essays_score)
MaxF <- max(Fi)
Wi <- Fi / MaxF * log(N / Ni)

# Pesos de los ensayos dado el set
W <- corpus_essays/ maxFe * log(N / Ni)

cosine_sim_12 <- 1:N
for(i in 1:N) {
    cosine_sim_12[i] <- cosine(W[, i], Wi)
}

test_cosine_sim_12 <- 1:356
for(i in 1:356) {
    test_cosine_sim_12[i] <- cosine(W_test[, i], Wi)
}
################################################################

sim <- data.frame(sim2 = cosine_sim_2,
                  sim4 = cosine_sim_4,
                  sim5 = cosine_sim_5,
                  sim6 = cosine_sim_6,
                  sim7 = cosine_sim_7,
                  sim8 = cosine_sim_8,
                  sim9 = cosine_sim_9,
                  sim10 = cosine_sim_10,
                  sim11 = cosine_sim_11,
                  sim12 = cosine_sim_12)
save(sim, file = "similarities.RData")

test_sim <- data.frame(sim2 = test_cosine_sim_2,
                  sim4 = test_cosine_sim_4,
                  sim5 = test_cosine_sim_5,
                  sim6 = test_cosine_sim_6,
                  sim7 = test_cosine_sim_7,
                  sim8 = test_cosine_sim_8,
                  sim9 = test_cosine_sim_9,
                  sim10 = test_cosine_sim_10,
                  sim11 = test_cosine_sim_11,
                  sim12 = test_cosine_sim_12)
save(test_sim, file = "test_similarities.RData")
