% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xgrove.R
\name{xgrove}
\alias{xgrove}
\title{Explanation groves}
\usage{
xgrove(
  model,
  data,
  ntrees = c(4, 8, 16, 32, 64, 128),
  pfun = NULL,
  remove.target = T,
  shrink = 1,
  b.frac = 1,
  seed = 42,
  ...
)
}
\arguments{
\item{model}{A model with corresponding predict function that returns numeric values.}

\item{data}{Training data.}

\item{ntrees}{Sequence of integers: number of boosting trees for rule extraction.}

\item{pfun}{Optional predict function \code{function(model, data)} returning a real number. Default is the \code{predict()} method of the \code{model}.}

\item{remove.target}{Logical. If \code{TRUE} the name of the target variable is identified from \code{terms(model)} and automatically removed if this variable is still in \code{data}.}

\item{shrink}{Sets the \code{shrinkage} argument for the internal call of \code{\link[gbm]{gbm}}. As the \code{model} usually has a deterministic response 
the default is 1 different to the default of \code{\link[gbm]{gbm}} applied train a model based on data.}

\item{b.frac}{Sets the \code{bag.fraction} argument for the internal call of \code{\link[gbm]{gbm}}. As the \code{model} usually has a deterministic response 
the default is 1 different to the default of \code{\link[gbm]{gbm}} applied train a model based on data.}

\item{seed}{Seed for the random number generator to ensure reproducible results (e.g. for the default \code{bag.fraction} < 1 in boosting).}

\item{...}{Further arguments to be passed to \code{gbm} or the \code{predict()} method of the \code{model}.}
}
\value{
List of the results:

\item{explanation}{Matrix containing tree sizes, rules, explainability \eqn{{\Upsilon}} and the correlation between the predictions of the explanation and the true model.}

\item{rules}{Summary of the explanation grove: Rules with identical splits are aggegated. For numeric variables any splits are merged if they lead to identical parititions of the training data.}

\item{groves}{Rules of the explanation grove.}

\item{model}{\code{gbm} model.}
}
\description{
Compute surrogate groves to explain predictive machine learning model and analyze complexity vs. explanatory power.
}
\details{
A surrogate grove is trained via gradient boosting using \code{\link[gbm]{gbm}} on \code{data} with the predictions of using of the \code{model} as target variable.
Note that \code{data} must not contain the original target variable! The boosting model is trained using stumps of depth 1.
The resulting interpretation is extracted from \code{\link[gbm]{pretty.gbm.tree}}. 
The column \code{upper_bound_left} of the \code{rules} and the \code{groves} value of the output object contains 
the split point for numeric variables denoting the uppoer bound of the left branch. Correspondingly, the 
\code{levels_left} column contains the levels of factor variables assigned to the left branch. 
The rule weights of the branches are given in the rightmost columns. The prediction of the grove is 
obtained as the sum of the assigned weights over all rows.       
Note that the training data must not contain the target variable. It can be either removed manually or will be removed automatically from \code{data} 
if the argument \code{remove.target == TRUE}.
}
\examples{
library(randomForest)
library(pdp)
data(boston)
set.seed(42)
rf <- randomForest(cmedv ~ ., data = boston)
data <- boston[,-3] # remove target variable
ntrees <- c(4,8,16,32,64,128)
xg <- xgrove(rf, data, ntrees)
xg
plot(xg)

# Example of a classification problem using the iris data.
# A predict function has to be defined, here for the posterior probabilities of the class Virginica.  
data(iris)
set.seed(42)
rf    <- randomForest(Species ~ ., data = iris)
data  <- iris[,-5] # remove target variable

pf <- function(model, data){
  predict(model, data, type = "prob")[,3]
  }
  
xgrove(rf, data, pfun = pf)

}
\references{
\itemize{
    \item {Szepannek, G. and von Holt, B.H. (2023): Can’t see the forest for the trees -- analyzing groves to explain random forests,
           Behaviormetrika, DOI: 10.1007/s41237-023-00205-2}.
    \item {Szepannek, G. and Luebke, K.(2023): How much do we see? On the explainability of partial dependence plots for credit risk scoring,
           Argumenta Oeconomica 50, DOI: 10.15611/aoe.2023.1.07}.
  }
}
\author{
\email{gero.szepannek@web.de}
}
