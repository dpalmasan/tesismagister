# Este codigo lo utilizo para aplicar regresion lineal al modelo baseline
# Y ver el comportamiento del mismo en 10 experimentos

library(caret); library(Metrics); source("AgreementMeasures.R"); source("auxiliares.R"); library(ggplot2)

load("grades")
dataset <- read.csv("discourse_features.csv")
dataset$grades <- grades

trainIndex <- createDataPartition(dataset$grades, p = 0.8, list = FALSE)
training <- dataset[trainIndex, ]
test <- dataset[-trainIndex, ]

mod <- lm(grades ~ ., data=training)
pred_base <- predict(mod, test)
ScoreQuadraticWeightedKappa(round2(pred_base), test$grades, 2, 12)
exactAgreement(round2(pred_base), test$grades)
adjacentAgreement(round2(pred_base), test$grades)

