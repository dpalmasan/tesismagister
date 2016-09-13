library(caret); library(Metrics); source("AgreementMeasures.R"); source("auxiliares.R"); library(ggplot2)
library(MASS)
load("grades")

# Conjunto de features simples
F1 <- read.csv("dataset_features.csv")
nzv <- nearZeroVar(F1)
F1 <- F1[, -nzv]

# Attali features
F2 <- read.csv("attali_features.csv")
F3 <- read.csv("discourse_features.csv")

dataset <- cbind(F1, F2, F3)
dataset$grades <- grades

# Runs para experimento y promediar
runs <- 100
qwk1 <- rep(0, runs)
eag1 <- rep(0, runs)
aag1 <- rep(0, runs)

for (i in 1:runs) {
  # Crea particion de datos
  trainIndex <- createDataPartition(dataset$grades, p = 0.8, list = FALSE)
  training <- dataset[trainIndex, ]
  test <- dataset[-trainIndex, ]
  
  mod <- rlm(grades ~ ., data=training)
  pred_base <- predict(mod, test)
  qwk1[i] <- ScoreQuadraticWeightedKappa(round2(pred_base), test$grades, 2, 12)
  eag1[i] <- exactAgreement(round2(pred_base), test$grades)
  aag1[i] <- adjacentAgreement(round2(pred_base), test$grades)
}

stats <- data.frame(qwk=qwk1, exact.agreement=eag1, adjacent.agreement=aag1)
p <- ggplot(data = stats, aes(x="qwk", y=qwk))
p <- p + geom_boxplot()
p

mean(qwk1)