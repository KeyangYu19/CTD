#' Metabolite set enrichment analysis (MSEA) using pathway knowledge curated by Metabolon
#'
#' A function that returns the pathway enrichment score for all perturbed metabolites in a patient's full metabolomic profile.
#' @param allSimMatrices - A list of all similarity matrices, across all k for a given graph, or across many graphs.
#' @export mle.getMinPtDistance
#' @examples
#' # Get patient distances for the first 4 patients in the Miller et al 2015 dataset.
#' data("Miller2015")
#' data_mx = Miller2015[-grep("x - ", rownames(data_mx)),grep("IEM", colnames(Miller2015))]
#' data_mx = data_mx[,c(1:4)]
#' # Look at the top 15 metabolites for each patient. 
#' kmx=15
#' topMets_allpts = c()
#' for (pt in 1:ncol(data_mx)) { topMets_allpts = c(topMets_allpts, rownames(data_mx)[order(abs(data_mx[,pt]), decreasing=TRUE)[1:kmx]]) }
#' topMets_allpts = unique(topMets_allpts)
#' # Pre-compute node ranks for all metabolites in topMets_allpts for faster distance calculations.
#' ranks = list()
#' for (n in 1:length(topMets_allpts)) { ranks[n] = singleNode.getNodeRanksN(n, G, p1=0.9, thresholdDiff=0.01, adj_mat) }
#' names(ranks) = topMets_allpts
#' # Also pre-compute patient bitstrings for faster distance calculations.
#' ptBSbyK = list()
#' for (pt in 1:ncol(data_mx)) {
#'   S = rownames(data_mx)[order(abs(data_mx[,pt]), decreasing=TRUE)[1:kmx]]
#'   ptBSbyK[[ptID]] = singleNode.getPtBSByK(S, ranks)
#' }
#' # Build your results ("res") list object to store patient distances at different size k's.
#' res = list()
#' t = list(ncd=matrix(NA, nrow=ncol(data_mx), ncol=ncol(data_mx)))
#' rownames(t$ncd) = colnames(data_mx)
#' colnames(t$ncd) = colnames(data_mx)
#' for (i in 1:kmx) { res[[i]] = t }
#' for (pt in 1:ncol(data_mx)) {
#'   print(pt)
#'   ptID = colnames(data_mx)[pt]
#'   for (pt2 in pt:ncol(data_mx)) {
#'     ptID2 = colnames(data_mx)[pt2]
#'     tmp = mle.getPtDist(ptBSbyK[[ptID]], ptID, ptBSbyK[[ptID2]], ptID2, data_mx, ranks)
#'     for (k in 1:kmx) {
#'       res[[k]]$ncd[ptID, ptID2] = tmp$NCD[k]
#'       res[[k]]$ncd[ptID2, ptID] = tmp$NCD[k]
#'     }
#'   }
#' }
#' minPtDist = mle.getMinPtDistance(res)
mle.getMinPtDistance = function(allSimMatrices) {
  ptSim = matrix(1000, nrow=nrow(allSimMatrices[[1]]), ncol=ncol(allSimMatrices[[1]]))
  for (ind in 1:length(allSimMatrices)) {
    for (n1 in 1:nrow(allSimMatrices[[ind]])) {
      for (n2 in 1:ncol(allSimMatrices[[ind]])) {
        ptSim[n1, n2] = min(ptSim[n1, n2], allSimMatrices[[ind]][n1, n2])
      }
    }
  }

  return(ptSim)
}
