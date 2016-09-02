library(caret); library(kernlab); library(Metrics); source("AgreementMeasures.R");

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

# Leer calificacion de los ensayos
load("test_grades.RData")
training <- read.csv("essay_features.csv")
load("training_grades.RData")
training$grades <- training_grades

testing <- read.csv("test_essay_features.csv")

lmFit <- lm(grades ~ ., data = training)
pred <- predict(lmFit, testing)
ScoreQuadraticWeightedKappa(round2(pred), test_grades, 2, 12)
exactAgreement(round2(pred), test_grades)
adjacentAgreement(round2(pred), test_grades)
##############################################################################

rfFit <- train(grades ~ ., data = training, method = "rf", 
               ntree = 100,
               trControl = trainControl(method="cv"), number = 5)
pred <- predict(rfFit, testing)
ScoreQuadraticWeightedKappa(round2(pred), test_grades, 2, 12)
exactAgreement(round2(pred), test_grades)
adjacentAgreement(round2(pred), test_grades)

