## SimInf, a framework for stochastic disease spread simulations
## Copyright (C) 2017 - 2018  Robin Eriksson
## Copyright (C) 2015 - 2018  Stefan Engblom
## Copyright (C) 2015 - 2018  Stefan Widgren
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

library("SimInf")

## For debugging
sessionInfo()

## Check invalid u0
res <- tools::assertError(SISe(u0 = "u0"))
stopifnot(length(grep("Missing columns in u0",
                      res[[1]]$message)) > 0)

u0 <- structure(list(S  = c(9, 9, 9, 9, 9, 10),
                     I  = c(1, 1, 1, 1, 1, 0)),
                .Names = c("S", "I"),
                row.names = c(NA, -6L), class = "data.frame")

## Check missing columns in u0
res <- tools::assertError(SISe(u0 = u0[, "I", drop = FALSE]))
stopifnot(length(grep("Missing columns in u0",
                      res[[1]]$message)) > 0)
res <- tools::assertError(SISe(u0 = u0[, "S", drop = FALSE]))
stopifnot(length(grep("Missing columns in u0",
                      res[[1]]$message)) > 0)

## Check 'susceptible' and 'infected' compartments
## no events
model <- SISe(u0      = u0,
              tspan   = seq_len(10) - 1,
              events  = NULL,
              phi     = rep(0, nrow(u0)),
              upsilon = 0.0357,
              gamma   = 0.1,
              alpha   = 1.0,
              beta_t1 = 0.19,
              beta_t2 = 0.085,
              beta_t3 = 0.075,
              beta_t4 = 0.185,
              end_t1  = 91,
              end_t2  = 182,
              end_t3  = 273,
              end_t4  = 365,
              epsilon = 0.000011)

set.seed(22)
result <- run(model, threads = 1, solver = "aem")

S_expected <- structure(c(9L, 9L, 9L, 9L, 9L, 10L, 9L, 9L, 10L, 9L, 9L, 10L, 9L,
                          9L, 10L, 9L, 9L, 10L, 9L, 9L, 10L, 9L, 8L, 10L, 9L, 9L,
                          10L, 9L, 8L, 10L, 9L, 8L, 10L, 9L, 8L, 10L, 9L, 8L, 10L,
                          10L, 8L, 10L, 9L, 8L, 10L, 10L, 7L, 10L, 10L, 7L, 10L,
                          10L, 7L, 10L, 10L, 7L, 10L, 10L, 7L, 10L),
                        .Dim = c(6L, 10L),
                        .Dimnames = list(c("S", "S", "S", "S", "S", "S"),
                                         c("0", "1", "2", "3", "4",
                                           "5", "6", "7", "8", "9")))

S_observed <- trajectory(result, compartments = "S", as.is = TRUE)
stopifnot(identical(S_observed, S_expected))

I_expected <- structure(c(1L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 0L, 1L, 1L, 0L, 1L,
                          1L, 0L, 1L, 1L, 0L, 1L, 1L, 0L, 1L, 2L, 0L, 1L, 1L,
                          0L, 1L, 2L, 0L, 1L, 2L, 0L, 1L, 2L, 0L, 1L, 2L, 0L,
                          0L, 2L, 0L, 1L, 2L, 0L, 0L, 3L, 0L, 0L, 3L, 0L, 0L,
                          3L, 0L, 0L, 3L, 0L, 0L, 3L, 0L),
                        .Dim = c(6L, 10L),
                        .Dimnames = list(c("I", "I", "I", "I", "I", "I"),
                                         c("0", "1", "2", "3", "4",
                                           "5", "6", "7", "8", "9")))

I_observed <- trajectory(result, compartments = "I", as.is = TRUE)
stopifnot(identical(I_observed, I_expected))

## test with events.
u0 <- structure(list(S = c(10, 9),
                     I = c(0, 1)),
                .Names = c("S", "I"),
                row.names = c(NA, -2L),
                class = "data.frame")

events <- structure(list(
    event      = c(3, 3),
    time       = c(1, 5),
    node       = c(1, 2),
    dest       = c(2, 1),
    n          = c(2, 2),
    proportion = c(0, 0),
    select     = c(2, 2),
    shift      = c(0, 0)),
    .Names = c("event", "time", "node", "dest",
               "n", "proportion", "select", "shift"),
    row.names = c(NA, -2L), class = "data.frame")

model <- SISe(u0  = u0,
              tspan   = seq_len(10) - 1,
              events  = events,
              phi     = rep(1, nrow(u0)),
              upsilon = 0.0357,
              gamma   = 0.1,
              alpha   = 1.0,
              beta_t1 = 0.19,
              beta_t2 = 0.085,
              beta_t3 = 0.075,
              beta_t4 = 0.185,
              end_t1  = 91,
              end_t2  = 182,
              end_t3  = 273,
              end_t4  = 365,
              epsilon = 0.000011)

set.seed(123)
result <- run(model, threads = 1, solver = "aem")

S_expected <- structure(c(10L, 9L, 8L, 9L, 7L, 10L, 6L, 10L, 6L, 10L, 8L, 6L,
                          7L, 7L, 7L, 7L, 7L, 7L, 7L, 9L),
                        .Dim = c(2L, 10L),
                        .Dimnames = list(
                            c("S", "S"),
                            c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")))

S_observed <- trajectory(result, compartments = "S", as.is = TRUE)
stopifnot(identical(S_observed, S_expected))

I_expected <- structure(c(0L, 1L, 0L, 3L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 4L, 3L,
                          3L, 3L, 3L, 3L, 3L, 3L, 1L),
                        .Dim = c(2L, 10L),
                        .Dimnames = list(
                            c("I", "I"),
                            c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")))

I_observed <- trajectory(result, compartments = "I", as.is = TRUE)
stopifnot(identical(I_observed, I_expected))

## run with AEM using multiple threads
if (SimInf:::have_openmp()) {
    result <- run(model, threads = 123L, solver = "aem")
    result

    stopifnot(identical(length(trajectory(result, compartments = "S", as.is = TRUE)), 20L))
    stopifnot(identical(length(trajectory(result, compartments = "I", as.is = TRUE)), 20L))

    p <- prevalence(result, I~S+I, as.is = TRUE)
    stopifnot(identical(length(p), 10L))
    stopifnot(is.null(dim(p)))

    p <- prevalence(result, I~S+I, type = "wnp", as.is = TRUE)
    stopifnot(identical(dim(p), c(2L, 10L)))
}

## Check solver argument
tools::assertError(run(model, threads = 1, solver = 1))
tools::assertError(run(model, threads = 1, solver = c("ssa", "aem")))
tools::assertError(run(model, threads = 1, solver = NA_character_))
tools::assertError(run(model, threads = 1, solver = "non-existing-solver"))
