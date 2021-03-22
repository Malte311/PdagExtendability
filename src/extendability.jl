"""

Convert a partially directed acyclic graph (PDAG) into a fully
directed acyclic graph (DAG).
"""
function pdag2dag()
	
end

function mpdag2dag()
	# 1. compute buckets (undirected components)
	# 2. perform modified LBFS from proof of Lemma 5.4 on each bucket
end

function cpdag2dag()
	
end

# R implementation of Dor Tarsi:
# https://github.com/cran/pcalg/blob/afe34d671144292350173b6f534c0eeb7fd0bb90/R/pcalg.R#L869

# ##################################################
# ## pdag2dag
# ##################################################
# find.sink <- function(gm) {
#   ## Purpose: Find sink of an adj matrix; return numeric(0) if there is none;
#   ## a sink may have incident undirected edges, but no directed ones
#   ## ----------------------------------------------------------------------
#   ## Arguments:
#   ## - gm: Adjacency matrix (gm_i_j is edge from j to i)
#   ## ----------------------------------------------------------------------
#   ## Author: Markus Kalisch, Date: 31 Oct 2006;  speedup: Martin Maechler, Dec.2013

#   ## treat undirected edges
#   gm[gm == t(gm) & gm == 1] <- 0
#   ## treat directed edges
#   which(colSums(gm) == 0)
# }

# adj.check <- function(gm,x) {
#   ## Purpose:  Return "TRUE", if:
#   ## For every vertex y, adj to x, with (x,y) undirected, y is adjacent to
#   ## all the other vertices which are adjacent to x
#   ## ----------------------------------------------------------------------
#   ## Arguments:
#   ## - gm: adjacency matrix of graph
#   ## - x: node number (number)
#   ## ----------------------------------------------------------------------
#   ## Author: Markus Kalisch, Date: 31 Oct 2006;
#   ## several smart speedups: Martin Maechler, Dec.2013

#   gm.1 <- (gm == 1)
#   xr <- gm.1[x,]
#   xc <- gm.1[,x]
#   nx <- which(xr | xc)
#   ## undirected neighbors of x
#   un <- which(xr & xc)
#   for(y in un) {
#     adj.x <- setdiff(nx, y)
#     adj.y <- setdiff(which(gm.1[y,] | gm.1[,y]), x)
#     if(!all(adj.x %in% adj.y))
#       return(FALSE)
#   }
#   TRUE
# }