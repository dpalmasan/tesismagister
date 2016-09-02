library(lsa)

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

###############################################################################
# Test essays using the vocabulary of training essays
test_essays <- textmatrix("test_essays_cleaned", stemming = FALSE,
                          minWordLength = 3, 
                          vocabulary = rownames(corpus_essays))
################################################################################

# Weighting scheme 

# LSA Space
lsaSpace <- lsa(corpus_essays)
training <- lsaSpace$dk %*% diag(lsaSpace$sk)
training <- as.data.frame(training)
training$grades <- training_grades

lmFit <- lm(grades ~ ., data=training)

test <- fold_in(test_essays, lsaSpace)
test.matrix <- t(test)[, 1:length(lsaSpace$sk)]

testing <- as.data.frame(test.matrix)

pred <- predict(lmFit, testing)
ScoreQuadraticWeightedKappa(round2(pred), test_grades, 2, 12)
exactAgreement(round2(pred), test_grades)
adjacentAgreement(round2(pred), test_grades)
predict(lmFit, training)
