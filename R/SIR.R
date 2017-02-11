## SimInf, a framework for stochastic disease spread simulations
## Copyright (C) 2015 - 2017  Stefan Widgren
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

##' Class \code{"SIR"}
##'
##' Class to handle the SIR \code{\link{siminf_model}}.
##' @include siminf_model.R
##' @include AllGenerics.R
##' @export
setClass("SIR", contains = c("siminf_model"))

##' Create a SIR model
##'
##' Create a SIR model to be used by the simulation framework.
##'
##'
##' The argument \code{u0} must be a \code{data.frame} with one row for
##' each node with the following columns:
##' \describe{
##' \item{S}{The number of sucsceptible in each node}
##' \item{I}{The number of infected in each node}
##' \item{R}{The number of recovered in each node}
##' }
##'
##' @param u0 A \code{data.frame} with the initial state in each node,
##'     see details.
##' @template tspan-param
##' @param events a \code{data.frame} with the scheduled events, see
##'     \code{\link{siminf_model}}.
##' @param beta The transmission rate from susceptible to infected.
##' @param gamma The recovery rate from infected to recovered.
##' @return \code{SIR}
##' @include check_arguments.R
##' @export
##' @examples
##' ## Create a SIR model object.
##' model <- SIR(u0 = data.frame(S = 99, I = 1, R = 0),
##'              tspan = 1:100,
##'              beta = 0.16,
##'              gamma = 0.077)
##'
##' ## Run the SIR model and plot the result.
##' result <- run(model, seed = 123)
##' plot(result)
SIR <- function(u0,
                tspan,
                events = NULL,
                beta   = NULL,
                gamma  = NULL)
{
    compartments <- c("S", "I", "R")

    ## Check arguments.

    ## Check u0
    if (!is.data.frame(u0))
        stop("'u0' must be a data.frame")
    if (!all(compartments %in% names(u0)))
        stop("Missing columns in u0")
    u0 <- u0[, compartments]

    ## Check for non-numeric parameters
    check_gdata_arg(beta, gamma)

    ## Arguments seems ok...go on

    E <- Matrix(c(1, 1,
                  0, 1,
                  0, 1),
                nrow   = 3,
                ncol   = 2,
                byrow  = TRUE,
                sparse = TRUE)
    E <- as(E, "dgCMatrix")
    colnames(E) <- as.character(1:2)
    rownames(E) <- compartments

    N <- matrix(integer(0), nrow = 0, ncol = 0)

    G <- Matrix(c(1, 1,
                  1, 1),
                nrow = 2,
                ncol = 2,
                byrow  = TRUE,
                sparse = TRUE)
    G <- as(G, "dgCMatrix")
    colnames(G) <- as.character(1:2)
    rownames(G) <- c("S -> I", "I -> R")

    S <- Matrix(c(-1,  0,
                   1, -1,
                   0,  1),
                nrow   = 3,
                ncol   = 2,
                byrow  = TRUE,
                sparse = TRUE)
    S <- as(S, "dgCMatrix")
    colnames(S) <- as.character(1:2)
    rownames(S) <- compartments

    v0 <- matrix(numeric(0), nrow  = 0, ncol = nrow(u0))
    storage.mode(v0) <- "double"

    ldata <- matrix(numeric(0), nrow = 0, ncol = nrow(u0))
    storage.mode(ldata) <- "double"

    gdata <- c(beta, gamma)
    storage.mode(gdata) <- "double"
    names(gdata) <- c("beta", "gamma")

    model <- siminf_model(G      = G,
                          S      = S,
                          E      = E,
                          N      = N,
                          tspan  = tspan,
                          events = events,
                          ldata  = ldata,
                          gdata  = gdata,
                          u0     = u0,
                          v0     = v0)

    return(as(model, "SIR"))
}

##' @rdname susceptible-methods
##' @export
setMethod("susceptible",
          signature("SIR"),
          function(model, i = NULL, by = 1, ...) {
              if (identical(dim(model@U), c(0L, 0L)))
                  stop("Please run the model first, the 'U' matrix is empty")

              ii <- seq(from = 1, to = dim(model@U)[1], by = 3)
              if (!is.null(i))
                  ii <- ii[i]
              j <- seq(from = 1, to = dim(model@U)[2], by = by)
              as.matrix(model@U[ii, j, drop = FALSE])
          }
)

##' @rdname infected-methods
##' @export
setMethod("infected",
          signature("SIR"),
          function(model, i = NULL, by = 1, ...) {
              if (identical(dim(model@U), c(0L, 0L)))
                  stop("Please run the model first, the 'U' matrix is empty")

              ii <- seq(from = 2, to = dim(model@U)[1], by = 3)
              if (!is.null(i))
                  ii <- ii[i]
              j <- seq(from = 1, to = dim(model@U)[2], by = by)
              as.matrix(model@U[ii, j, drop = FALSE])
          }
)

##' @rdname recovered-methods
##' @export
setMethod("recovered",
          signature("SIR"),
          function(model, i = NULL, by = 1, ...) {
              if (identical(dim(model@U), c(0L, 0L)))
                  stop("Please run the model first, the 'U' matrix is empty")

              ii <- seq(from = 3, to = dim(model@U)[1], by = 3)
              if (!is.null(i))
                  ii <- ii[i]
              j <- seq(from = 1, to = dim(model@U)[2], by = by)
              as.matrix(model@U[ii, j, drop = FALSE])
          }
)

##' @name plot-methods
##' @aliases plot plot-methods plot,SIR-method
##' @importFrom graphics plot
##' @export
setMethod("plot",
          signature(x = "SIR"),
          function(x, ...)
      {
          callNextMethod(x, legend = c("S", "I", "R"), ...)
      }
)

##' Scheduled events example data for the \code{SIR} model
##'
##' Synthetic scheduled events data to demonstrate the \code{SIR}
##' model. The data contains 466692 events for 1600 nodes over 365 * 4
##' days.
##' @return A \code{data.frame}
##' @keywords methods
##' @importFrom utils data
##' @export
events_SIR <- function() {
    utils::data(events_SISe3, envir = environment())
    events_SISe3$select[events_SISe3$event == 0] <- 2
    events_SISe3$select[events_SISe3$event == 1] <- 1
    events_SISe3 <- events_SISe3[events_SISe3$event != 2,]
    events_SISe3$select[events_SISe3$event == 3] <- 2
    events_SISe3
}

##' Example data to initialize the \code{SIR} model
##'
##' Synthetic init data for 1600 nodes to demonstrate the \code{SIR}
##' model.
##' @return A \code{data.frame}
##' @keywords methods
##' @importFrom utils data
##' @export
u0_SIR <- function() {
    utils::data(u0_SISe3, envir = environment())
    u0_SISe3$S <- u0_SISe3$S_1 + u0_SISe3$S_2 + u0_SISe3$S_3
    u0_SISe3$I <- u0_SISe3$I_1 + u0_SISe3$I_2 + u0_SISe3$I_3
    u0_SISe3$R <- 0
    u0_SISe3[, c("S", "I", "R")]
}