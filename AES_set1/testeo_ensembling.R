# Este codigo testea uso de LSI y las caracteristicas extraidas para el test y el training set
# Usado con fines de pruebas aun

library(lsa)
library(caret)
library(Metrics); source("AgreementMeasures.R"); source("auxiliares.R")

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

# Preprocesado
corpus_essays.lsa<- lw_bintf(corpus_essays) * gw_idf(corpus_essays) # weighting

# LSA
lsaSpace <- lsa(corpus_essays.lsa)
dataset.lsa <- as.data.frame(lsaSpace$dk)
dataset.lsa$grades <- grades

# Crear particion de datos
trainIndex <- createDataPartition(dataset.lsa$grades, p = 0.8, list = FALSE)

# Modelo generado para LSA (testeando modelo lineal)
training <- dataset.lsa[trainIndex, ]
test <- dataset.lsa[-trainIndex, ]

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

