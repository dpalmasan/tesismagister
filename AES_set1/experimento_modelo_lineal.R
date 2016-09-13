# Este codigo lo utilizo para aplicar regresion lineal al modelo baseline
# Y ver el comportamiento del mismo en 10 experimentos

library(caret); library(Metrics); source("AgreementMeasures.R"); source("auxiliares.R"); library(ggplot2)
library(MASS)

load("grades")
dataset <- read.csv("dataset_features.csv")
nzv <- nearZeroVar(dataset)
dataset <- dataset[, -nzv]

dataset$grades <- grades

# Runs para experimento y promediar
runs <- 100
qwk <- rep(0, runs)
eag <- rep(0, runs)
aag <- rep(0, runs)

for (i in 1:runs) {
  # Crea particion de datos
  trainIndex <- createDataPartition(dataset$grades, p = 0.8, list = FALSE)
  training <- dataset[trainIndex, ]
  test <- dataset[-trainIndex, ]
  
  mod <- rlm(grades ~ ., data=training)
  pred_base <- predict(mod, test)
  qwk[i] <- ScoreQuadraticWeightedKappa(round2(pred_base), test$grades, 2, 12)
  eag[i] <- exactAgreement(round2(pred_base), test$grades)
  aag[i] <- adjacentAgreement(round2(pred_base), test$grades)
}

stats <- data.frame(qwk=qwk, exact.agreement=eag, adjacent.agreement=aag)
p <- ggplot(data = stats, aes(x="qwk", y=qwk))
p <- p + geom_boxplot()
p

mean(qwk)
