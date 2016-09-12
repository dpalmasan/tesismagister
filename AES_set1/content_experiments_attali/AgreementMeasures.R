exactAgreement <- function(rater.a, rater.b) {
    return(sum(rater.a == rater.b)/length(rater.a))
}

adjacentAgreement <- function(rater.a, rater.b) {
    return(sum(abs(rater.a - rater.b) <= 1)/length(rater.a))
}