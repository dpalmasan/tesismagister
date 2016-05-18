load("similarities.RData")
load("training_grades.RData")
load("test_similarities.RData")
load("test_grades.RData")

translate <- function (id) {
    if (id == 1) {
        return(2)
    }
    if (id == 2) {
        return(4)
    }
    
    return(id + 2)
}
trainingN <- length(training_grades)
testN <- length(test_grades)

score_point_value <- 1:trainingN
for(i in 1:trainingN){
    score_point_value[i] <- translate(which(sim[i, ] == max(sim[i, ])))
}


pattern_cosine <- 2*sim$sim2 + 4*sim$sim4 + 5*sim$sim5 +
    6*sim$sim6 + 7*sim$sim7 + 8*sim$sim8 + 9*sim$sim9 + 10*sim$sim10 +
    11*sim$sim11 + 12*sim$sim12

val_cos <- sim$sim12 + sim$sim11 + sim$sim10 + sim$sim9 + sim$sim8 - sim$sim7 -
    sim$sim6 - sim$sim5 - sim$sim4 - sim$sim2

cor(training_grades, score_point_value)
cor(training_grades, sim$sim12)
cor(training_grades, pattern_cosine)
cor(training_grades, val_cos)

content_features <- data.frame(score_point_val = score_point_value,
                               sim_highest = sim$sim12,
                               pattern_cos = pattern_cosine,
                               weighted_cos = val_cos)
write.table(content_features, file = "content.csv", sep = ",", row.names = FALSE) 
##################################################################################
score_point_value <- 1:testN
for(i in 1:testN){
    score_point_value[i] <- translate(which(test_sim[i, ] == max(test_sim[i, ])))
}


pattern_cosine <- 2*test_sim$sim2 + 4*test_sim$sim4 + 5*test_sim$sim5 +
    6*test_sim$sim6 + 7*test_sim$sim7 + 8*test_sim$sim8 + 9*test_sim$sim9 + 
    10*test_sim$sim10 + 11*test_sim$sim11 + 12*test_sim$sim12

val_cos <- test_sim$sim12 + test_sim$sim11 + test_sim$sim10 + test_sim$sim9 + 
    test_sim$sim8 - test_sim$sim7 - test_sim$sim6 - test_sim$sim5 - 
    test_sim$sim4 - test_sim$sim2

cor(test_grades, score_point_value)
cor(test_grades, test_sim$sim12)
cor(test_grades, pattern_cosine)
cor(test_grades, val_cos)

content_features <- data.frame(score_point_val = score_point_value,
                               sim_highest = test_sim$sim12,
                               pattern_cos = pattern_cosine,
                               weighted_cos = val_cos)
write.table(content_features, file = "test_content.csv", sep = ",", 
            row.names = FALSE) 
