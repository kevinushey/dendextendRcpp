\name{cut_lower_fun}
\alias{Rcpp_cut_lower}
\alias{cut_lower_fun}
\alias{old_cut_lower_fun}
\title{Cut a dendrogram using Rcpp - and run a function on the output}
\usage{
cut_lower_fun(tree, h, FUN = labels, warn = FALSE, ...)
}
\arguments{
  \item{tree}{a dendrogram object.}

  \item{h}{a scalar of height to cut the tree by.}

  \item{warn}{logical (FALSE) - should the user be warned
  if reverting to default? (I set it to FALSE since it can
  be very noisy sometimes...)}

  \item{FUN}{the function to run (default is "labels")}

  \item{...}{passed to FUN.}
}
\value{
A list with the output of running FUN on each of the sub
trees derived from cutting "tree"
}
\description{
Cuts the a tree at height h and returns a list with the FUN
function implemented on all the sub trees created by cut at
height h. This is used for creating a
\link[dendextend]{cutree.dendrogram} function, by using the
\code{labels} function as FUN.

This is the Rcpp version of the function, offering a 10-60
times improvement in speed (depending on the tree size it
is used on).
}
\examples{
dend = as.dendrogram(hclust(dist(iris[1:4,-5])))
dendextendRcpp::Rcpp_cut_lower(dend, .4)
dendextendRcpp::Rcpp_cut_lower(dend, .4, FALSE)
# this is really cool!
cut_lower_fun(dend, .4, labels)
lapply(cut(dend, h = .4)$lower, labels)
cut_lower_fun(dend, .4, order.dendrogram)

\dontrun{
   # require(dendextend)
   require(dendextendRcpp)
   dend_big = as.dendrogram(hclust(dist(iris[1:150,-5])))
   require(microbenchmark)
   microbenchmark(old_cut_lower_fun(dend_big,.1),
                  dendextendRcpp::cut_lower_fun(dend_big,.1),
                     times = 100)
   # about 7-15 times faster. It is faster the larger the tree is, and the lower h is.
}
}
\author{
Tal Galili
}
\seealso{
\code{\link{labels}}, \code{\link{dendrogram}},
\link[dendextend]{cutree} (in dendextend),
\link[stats]{cutree} (in stats)
}

