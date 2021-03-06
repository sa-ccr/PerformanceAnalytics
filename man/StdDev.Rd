% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/StdDev.R
\name{StdDev}
\alias{StdDev}
\title{calculates Standard Deviation for univariate and multivariate series, also
calculates component contribution to standard deviation of a portfolio}
\usage{
StdDev(
  R,
  ...,
  clean = c("none", "boudt", "geltner", "locScaleRob"),
  portfolio_method = c("single", "component"),
  weights = NULL,
  mu = NULL,
  sigma = NULL,
  use = "everything",
  method = c("pearson", "kendall", "spearman"),
  SE = FALSE,
  SE.control = NULL
)
}
\arguments{
\item{R}{a vector, matrix, data frame, timeSeries or zoo object of asset
returns}

\item{\dots}{any other passthru parameters}

\item{clean}{method for data cleaning through \code{\link{Return.clean}}.
Current options are "none", "boudt", "geltner", or "locScaleRob".}

\item{portfolio_method}{one of "single","component" defining whether to do
univariate/multivariate or component calc, see Details.}

\item{weights}{portfolio weighting vector, default NULL, see Details}

\item{mu}{If univariate, mu is the mean of the series. Otherwise mu is the
vector of means of the return series , default NULL, , see Details}

\item{sigma}{If univariate, sigma is the variance of the series. Otherwise
sigma is the covariance matrix of the return series , default NULL, see
Details}

\item{use}{an optional character string giving a method for computing
covariances in the presence of missing values.  This must be (an
abbreviation of) one of the strings \code{"everything"}, \code{"all.obs"},
\code{"complete.obs"}, \code{"na.or.complete"}, or
\code{"pairwise.complete.obs"}.}

\item{method}{a character string indicating which correlation coefficient
(or covariance) is to be computed.  One of \code{"pearson"} (default),
\code{"kendall"}, or \code{"spearman"}, can be abbreviated.}

\item{SE}{TRUE/FALSE whether to ouput the standard errors of the estimates of the risk measures, default FALSE.}

\item{SE.control}{Control parameters for the computation of standard errors. Should be done using the \code{\link{RPESE.control}} function.}
}
\description{
calculates Standard Deviation for univariate and multivariate series, also
calculates component contribution to standard deviation of a portfolio
}
\details{
TODO add more details

This wrapper function provides fast matrix calculations for univariate,
multivariate, and component contributions to Standard Deviation.

It is likely that the only one that requires much description is the
component decomposition.  This provides a weighted decomposition of the
contribution each portfolio element makes to the univariate standard
deviation of the whole portfolio.

Formally, this is the partial derivative of each univariate standard
deviation with respect to the weights.

As with \code{\link{VaR}}, this contribution is presented in two forms, both
a scalar form that adds up to the univariate standard deviation of the
portfolio, and a percentage contribution, which adds up to 100%.  Note that
as with any contribution calculation, contribution can be negative.  This
indicates that the asset in question is a diversified to the overall
standard deviation of the portfolio, and increasing its weight in relation
to the rest of the portfolio would decrease the overall portfolio standard
deviation.
}
\examples{

    data(edhec)

    # first do normal StdDev calc
    StdDev(edhec)
    # or the equivalent
    StdDev(edhec, portfolio_method="single")

    # now with outliers squished
    StdDev(edhec, clean="boudt")

    # add Component StdDev for the equal weighted portfolio
    StdDev(edhec, clean="boudt", portfolio_method="component")


}
\seealso{
\code{\link{Return.clean}} \code{sd}
}
\author{
Brian G. Peterson and Kris Boudt
}
