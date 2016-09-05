library(lsa)
library(caret)
library(Metrics); source("AgreementMeasures.R");

# Funciones auxiliares para evaluar el modelo
round_tmp <- function(x, min.grade, max.grade) {
  tmp <- round(x)
  if(tmp < min.grade) {
    return(min.grade)
  }
  
  if(tmp > max.grade) {
    return(max.grade)
  }
  return(tmp)
}

round2 <- function(x, min.grade = 2, max.grade = 12) {
  return(mapply(round_tmp, x, MoreArgs = list(min.grade = min.grade, 
                                              max.grade = max.grade)))
}

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

# LSA
lsaSpace <- lsa(corpus_essays)
dataset <- as.data.frame(lsaSpace$dk)
dataset$grades <- grades

# Crear particion de datos
trainIndex <- createDataPartition(dataset$grades, p = 0.8, list = FALSE)

# Modelo generado para LSA (testeando modelo lineal)
training <- dataset[trainIndex, ]
test <- dataset[-trainIndex, ]

mod <- lm(grades ~ ., data=training)

pred_lsa <- predict(mod, test)
ScoreQuadraticWeightedKappa(round2(pred_lsa), test$grades, 2, 12)
exactAgreement(round2(pred_lsa), test$grades)
adjacentAgreement(round2(pred_lsa), test$grades)

dataset <- read.csv("dataset_features.csv")
dataset$grades <- grades
training <- dataset[trainIndex, ]
test <- dataset[-trainIndex, ]

mod <- lm(grades ~ ., data=training)
pred_base <- predict(mod, test)
ScoreQuadraticWeightedKappa(round2(pred_base), test$grades, 2, 12)
exactAgreement(round2(pred_base), test$grades)
adjacentAgreement(round2(pred_base), test$grades)

new_data <- data.frame(pred_lsa=pred_lsa, pred_base=pred_base)
new_data$grades <- test$grades
ensembled_mod <- lm(grades ~ ., data=new_data)
pred_grades <- predict(ensembled_mod, new_data)
ScoreQuadraticWeightedKappa(round2(pred_grades), test$grades, 2, 12)
exactAgreement(round2(pred_grades), test$grades)
adjacentAgreement(round2(pred_grades), test$grades)
