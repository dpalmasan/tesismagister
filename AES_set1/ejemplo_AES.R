# -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
#   
#   essay-scoring.R
#   fridolin.wild@wu-wien.ac.at, June 5th 2006
#   
#   Written for a tutorial at the 
#   ProLearn Summer School 2006, Bled, Slowenia
#   


# -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# PREPARE TRAINING DATA

# files have been generated with 
# textmatrix(stemming=FALSE, minWordLength=3, minDocFreq=1)
library(lsa); library(caret)

# Cargar Datos
load("grades")
load("corpus_LSA.RData")

#############################################################################
# Cuando se quiera usar el corpus y su modelo de espacio vectorial
# Leer y hace representacion del espacio vectorial del corpus
corpus_essays <- textmatrix("bow_lsa", stemming = FALSE,
                            minWordLength = 3)

save(corpus_essays, file = "corpus_LSA.RData")
#############################################################################
trainIndex <- createDataPartition(grades, p = 0.8)
corpus_training = corpus_essays[, unlist(trainIndex)]
corpus_testing = corpus_essays[, -unlist(trainIndex)]

weighted_training = corpus_training * gw_entropy(corpus_training)
space = lsa( weighted_training, dims=dimcalc_share(share=0.5) )


# -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# FOLD IN ESSAYS

# files have been prepared with
# textmatrix( stemming=FALSE, minWordLength=3, 
# vocabulary=rownames(training) )

weighted_essays = corpus_testing * gw_entropy(corpus_training)
lsaEssays = fold_in( weighted_essays, space )
test_grades <- grades[-unlist(trainIndex)]
golden_idx <- which(test_grades == 12)

# -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# TEST THEM, BENCHMARK

essay2essay = cor(lsaEssays, method="spearman")
goldstandard = colnames(corpus_testing[, golden_idx])
machinescores = colSums( essay2essay[goldstandard, ] ) / length(goldstandard)

corpus_scores = test_grades
humanscores = corpus_scores

cor.test(humanscores, machinescores, exact=FALSE, method="spearman", alternative="two.sided")


# -  -  -  -  -  -  -  -  -  -  -  -  -  -  
# COMPARE TO PURE VECTOR SPACE MODEL

essay2essay = cor(corpus_testing, method="spearman")
machinescores = colSums( essay2essay[goldstandard, ] ) / length(goldstandard)
cor.test(humanscores, machinescores, 
         exact=FALSE, method="spearman", alternative="two.sided")

# => impressingly good!
# => in other experiments at the Vienna University
#    of Economics and Business Administration, the 
#    interrater correlation was in the best case .88, 
#    but going down to -0.17 with unfamiliar topics/raters