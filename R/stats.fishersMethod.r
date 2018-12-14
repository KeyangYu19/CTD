#' Fisher's Combined P-value
#'
#' Fisher's combined p-value, used to combine the results of individual statistical tests into an overall hypothesis.
#' @param x - A vector of p-values (floating point numbers).
#' @export stats.fishersMethod
#' @examples
#' stats.fishersMethod(c(0.2,0.1,0.3))
#' > 0.1152162
stats.fishersMethod = function(x) {
  return (pchisq(-2 * sum(log(x)),df=2*length(x),lower=FALSE))
}
