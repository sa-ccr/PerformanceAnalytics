% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ES.R
\name{ETL}
\alias{ETL}
\alias{ES}
\alias{CVaR}
\title{calculates Expected Shortfall(ES) (or Conditional Value-at-Risk(CVaR) for
univariate and component, using a variety of analytical methods.}
\usage{
ETL(
  R = NULL,
  p = 0.95,
  ...,
  method = c("modified", "gaussian", "historical"),
  clean = c("none", "boudt", "geltner", "locScaleRob"),
  portfolio_method = c("single", "component"),
  weights = NULL,
  mu = NULL,
  sigma = NULL,
  m3 = NULL,
  m4 = NULL,
  invert = TRUE,
  operational = TRUE,
  SE = FALSE,
  SE.control = NULL
)
}
\arguments{
\item{R}{a vector, matrix, data frame, timeSeries or zoo object of asset
returns}

\item{p}{confidence level for calculation, default p=.95}

\item{\dots}{any other passthru parameters}

\item{method}{one of "modified","gaussian","historical", see
Details.}

\item{clean}{method for data cleaning through \code{\link{Return.clean}}.
Current options are "none", "boudt", "geltner", or "locScaleRob".}

\item{portfolio_method}{one of "single","component","marginal" defining
whether to do univariate, component, or marginal calc, see Details.}

\item{weights}{portfolio weighting vector, default NULL, see Details}

\item{mu}{If univariate, mu is the mean of the series. Otherwise mu is the
vector of means of the return series, default NULL, see Details}

\item{sigma}{If univariate, sigma is the variance of the series. Otherwise
sigma is the covariance matrix of the return series, default NULL, see
Details}

\item{m3}{If univariate, m3 is the skewness of the series. Otherwise m3 is
the coskewness matrix (or vector with unique coskewness values) of the 
returns series, default NULL, see Details}

\item{m4}{If univariate, m4 is the excess kurtosis of the series. Otherwise
m4 is the cokurtosis matrix (or vector with unique cokurtosis values) of the 
return series, default NULL, see Details}

\item{invert}{TRUE/FALSE whether to invert the VaR measure, see Details.}

\item{operational}{TRUE/FALSE, default TRUE, see Details.}

\item{SE}{TRUE/FALSE whether to ouput the standard errors of the estimates of the risk measures, default FALSE.}

\item{SE.control}{Control parameters for the computation of standard errors. Should be done using the \code{\link{RPESE.control}} function.}
}
\description{
Calculates Expected Shortfall(ES) (also known as) Conditional Value at
Risk(CVaR) or Expected Tail Loss (ETL) for univariate, component, 
and marginal cases using a variety of analytical methods.
}
\note{
The option to \code{invert} the ES measure should appease both
academics and practitioners.  The mathematical definition of ES as the
negative value of extreme losses will (usually) produce a positive number.
Practitioners will argue that ES denotes a loss, and should be internally
consistent with the quantile (a negative number).  For tables and charts,
different preferences may apply for clarity and compactness.  As such, we
provide the option, and set the default to TRUE to keep the return
consistent with prior versions of PerformanceAnalytics, but make no value
judgement on which approach is preferable.
}
\section{Background}{
 

This function provides several estimation methods for
the Expected Shortfall (ES) (also called Expected Tail Loss (ETL)
or Conditional Value at Risk (CVaR)) of a return series and the Component ES
(ETL/CVaR) of a portfolio.

At a preset probability level denoted \eqn{c}, which typically is between 1
and 5 per cent, the ES of a return series is the negative value of the
expected value of the return when the return is less than its
\eqn{c}-quantile.  Unlike value-at-risk, conditional value-at-risk has all
the properties a risk measure should have to be coherent and is a convex
function of the portfolio weights (Pflug, 2000).  With a sufficiently large
data set, you may choose to estimate ES with the sample average of all
returns that are below the \eqn{c} empirical quantile. More efficient
estimates of VaR are obtained if a (correct) assumption is made on the
return distribution, such as the normal distribution. If your return series
is skewed and/or has excess kurtosis, Cornish-Fisher estimates of ES can be
more appropriate. For the ES of a portfolio, it is also of interest to
decompose total portfolio ES into the risk contributions of each of the
portfolio components. For the above mentioned ES estimators, such a
decomposition is possible in a financially meaningful way.
}

\section{Univariate estimation of ES}{


The ES at a probability level \eqn{p} (e.g. 95\%) is  the negative value of
the expected value of the return when the return is less than its
\eqn{c=1-p} quantile. In a set of returns for which sufficently long history
exists, the per-period ES can be estimated by the negative value of the
sample average of all returns below the quantile. This method is also
sometimes called \dQuote{historical ES}, as it is by definition \emph{ex
post} analysis of the return distribution, and may be accessed with
\code{method="historical"}.

When you don't have a sufficiently long set of returns to use non-parametric
or historical ES, or wish to more closely model an ideal distribution, it is
common to us a parmetric estimate based on the distribution. Parametric ES
does a better job of accounting for the tails of the distribution by more
precisely estimating shape of the distribution tails of the risk quantile.
The most common estimate is a normal (or Gaussian) distribution  \eqn{R\sim
N(\mu,\sigma)} for the return series. In this case, estimation of ES requires
the mean return  \eqn{\bar{R}}, the return distribution and the variance of
the returns  \eqn{\sigma}. In the most common case, parametric VaR is thus
calculated by

\deqn{\sigma=variance(R)}{sigma=var(R)}

\deqn{ES=-\bar{R} + \sqrt{\sigma} \cdot \frac{1}{c}\phi(z_{c}) }{VaR= -mean(R) + sqrt(sigma)*dnorm(z_c)/c}

where  \eqn{z_{c}} is the  \eqn{c}-quantile of the standard normal
distribution. Represented in \R by \code{qnorm(c)}, and may be accessed with
\code{method="gaussian"}. The function \eqn{\phi}{dnorm} is the Gaussian
density function.


The limitations of Gaussian ES are well covered in the literature, since most
financial return series are non-normal. Boudt, Peterson and Croux (2008)
provide a modified ES calculation that takes the higher moments of non-normal
distributions (skewness, kurtosis) into account through the use of a
Cornish-Fisher expansion, and collapses to standard (traditional) Gaussian ES
if the return stream follows a standard distribution. More precisely, for a
loss probability \eqn{c}, modified ES is defined as the negative of the
expected value of all returns below the \eqn{c} Cornish-Fisher quantile and
where the expectation is computed under the second order Edgeworth expansion
of the true distribution function.

Modified expected shortfall should always be larger than modified Value at
Risk. Due to estimation problems, this might not always be the case. Set
Operational = TRUE to replace modified ES with modified VaR in the
(exceptional) case where the modified ES is smaller than modified VaR.
}

\section{Component ES}{


By setting \code{portfolio_method="component"} you may calculate the ES
contribution of each element of the portfolio. The return from the function in
this case will be a list with three components: the univariate portfolio ES,
the scalar contribution of each component to the portfolio ES (these will sum
to the portfolio ES), and a percentage risk contribution (which will sum to
100\%).

Both the numerical and percentage component contributions to ES may contain
both positive and negative contributions. A negative contribution to Component
ES indicates a portfolio risk diversifier. Increasing the position weight will
reduce overall portoflio ES.

If a weighting vector is not passed in via \code{weights}, the function will
assume an equal weighted (neutral) portfolio.

Multiple risk decomposition approaches have been suggested in the literature.
A naive approach is to set the risk contribution equal to the stand-alone
risk. This approach is overly simplistic and neglects important
diversification effects of the units being exposed differently to the
underlying risk factors. An alternative approach is to measure the ES
contribution as the weight of the position in the portfolio times the partial
derivative of the portfolio ES with respect to the component weight. \deqn{C_i
\mbox{ES} = w_i \frac{ \partial \mbox{ES} }{\partial w_i}.}{C[i]ES =
w[i]*(dES/dw[i]).} Because the portfolio ES is linear in position size, we
have that by Euler's theorem the portfolio VaR is the sum of these risk
contributions. Scaillet (2002) shows that for ES, this mathematical
decomposition of portfolio risk has a financial meaning. It equals the
negative value of the asset's expected contribution to the portfolio return
when the portfolio return is less or equal to the negative portfolio VaR:

    \deqn{C_i \mbox{ES} = = -E\left[ w_i r_{i} | r_{p} \leq - \mbox{VaR}\right]}{C[i]ES = -E( w[i]r[i]|rp<=-VaR ) }

For the decomposition of Gaussian ES, the estimated mean and covariance
matrix are needed. For the decomposition of modified ES, also estimates of
the coskewness and cokurtosis matrices are needed. If \eqn{r} denotes the
\eqn{Nx1} return vector and \eqn{mu} is the mean vector, then the \eqn{N
\times N^2} co-skewness matrix is
\deqn{ m3 = E\left[ (r - \mu)(r - \mu)' \otimes (r - \mu)'\right]}{m3 = E[ (r - mu)(r - mu)' \%x\%  (r - \mu)']}

The \eqn{N \times N^3} co-kurtosis matrix is

\deqn{ m_{4} =
    E\left[ (r - \mu)(r - \mu)' \otimes (r - \mu)'\otimes (r - \mu)'
\right] }{E[ (r - \mu)(r - \mu)' \%x\% (r - \mu)'\%x\% (r - \mu)']} 

where \eqn{\otimes}{\%x\%} stands for the Kronecker product. The matrices can
be estimated through the functions \code{skewness.MM} and \code{kurtosis.MM}.
More efficient estimators were proposed by Martellini and Ziemann (2007) and
will be implemented in the future.

As discussed among others in Cont, Deguest and Scandolo (2007), it is
important that the estimation of the ES measure is robust to single outliers.
This is especially the case for  modified VaR and its decomposition, since
they use higher order moments. By default, the portfolio moments are
estimated by their sample counterparts. If \code{clean="boudt"} then the
\eqn{1-p} most extreme observations are winsorized if they are detected as
being outliers. For more information, see Boudt, Peterson and Croux (2008)
and \code{\link{Return.clean}}.  If your data consist of returns for highly
illiquid assets, then \code{clean="geltner"} may be more appropriate to
reduce distortion caused by autocorrelation, see \code{\link{Return.Geltner}}
for details.
}

\examples{

    data(edhec)

    # first do normal ES calc
    ES(edhec, p=.95, method="historical")

    # now use Gaussian
    ES(edhec, p=.95, method="gaussian")

    # now use modified Cornish Fisher calc to take non-normal distribution into account
    ES(edhec, p=.95, method="modified")

    # now use p=.99
    ES(edhec, p=.99)
    # or the equivalent alpha=.01
    ES(edhec, p=.01)

    # now with outliers squished
    ES(edhec, clean="boudt")

    # add Component ES for the equal weighted portfolio
    ES(edhec, clean="boudt", portfolio_method="component")
    
}
\references{
Boudt, Kris, Peterson, Brian, and Christophe Croux. 2008.
Estimation and decomposition of downside risk for portfolios with non-normal
returns. 2008. The Journal of Risk, vol. 11, 79-103.

Cont, Rama, Deguest, Romain and Giacomo Scandolo. Robustness and sensitivity
analysis of risk measurement procedures. Financial Engineering Report No.
2007-06, Columbia University Center for Financial Engineering.

Laurent Favre and Jose-Antonio Galeano. Mean-Modified Value-at-Risk
Optimization with Hedge Funds. Journal of Alternative Investment, Fall 2002,
v 5.

Martellini, L. and Ziemann, V., 2010. Improved estimates of higher-order 
comoments and implications for portfolio selection. Review of Financial 
Studies, 23(4):1467-1502.

Pflug, G. Ch.  Some remarks on the value-at-risk and the conditional
value-at-risk. In S. Uryasev, ed., Probabilistic Constrained Optimization:
Methodology and Applications, Dordrecht: Kluwer, 2000, 272-281.

Scaillet, Olivier. Nonparametric estimation and sensitivity analysis of
expected shortfall. Mathematical Finance, 2002, vol. 14, 74-86.
}
\seealso{
\code{\link{VaR}} \cr \code{\link{SharpeRatio.modified}} \cr
\code{\link{chart.VaRSensitivity}} \cr \code{\link{Return.clean}}
}
\author{
Brian G. Peterson and Kris Boudt
}
