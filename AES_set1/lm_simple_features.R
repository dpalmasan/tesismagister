library(caret); library(kernlab); library(Metrics); source("AgreementMeasures.R");
source("auxiliares.R")

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
