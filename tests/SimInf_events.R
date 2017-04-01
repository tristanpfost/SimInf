## SimInf, a framework for stochastic disease spread simulations
## Copyright (C) 2015  Pavol Bauer
## Copyright (C) 2015 - 2017  Stefan Engblom
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

library(SimInf)
library(Matrix)

## For debugging
sessionInfo()

E <- Matrix(c(1, 0, 0, 1, 0, 0,
              0, 0, 0, 1, 0, 0,
              0, 1, 0, 0, 1, 0,
              0, 0, 0, 0, 1, 0,
              0, 0, 1, 0, 0, 1,
              0, 0, 0, 0, 0, 1),
            nrow   = 6,
            ncol   = 6,
            byrow  = TRUE,
            sparse = TRUE)

N <- matrix(c(2, 0,
              2, 0,
              0, 2,
              0, 2,
              0, 0,
              0, 0),
            nrow   = 6,
            ncol   = 2,
            byrow  = TRUE)

## Check missing columns in events
## Iterate over each column and rename it
lapply(seq_len(8), function(i) {
    events <- structure(list(
        event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
        time = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
        node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
        dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
        n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
        proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
        select = c(0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2),
        shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
        .Names = c("event", "time", "node", "dest", "n",
                   "proportion", "select", "shift"),
        row.names = c(NA, -15L), class = "data.frame")

    colnames(events)[i] <- "test"
    res <- tools::assertError(SimInf_events(E      = E,
                                            N      = N,
                                            events = events))
    stopifnot(length(grep("Missing columns in events",
                          res[[1]]$message)) > 0)
})

## Check events$event not equal to whole number
events <- structure(list(
    event = c(3.1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
str(events)
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events))
stopifnot(length(grep("Columns in events must be integer",
                      res[[1]]$message)) > 0)

## Check events$time not equal to whole number
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = c(1.1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
str(events)
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events))
stopifnot(length(grep("Columns in events must be integer",
                      res[[1]]$message)) > 0)

## Check missing t0 when events$time is a Date vector
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = structure(c(17168, 17169, 17170, 17171, 17172,
                       17173, 17174, 17175, 17176, 17177,
                       17178, 17179, 17180, 17181, 17182),
                     class = "Date"),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
res <- tools::assertError(SimInf_events(E = E,
                                        N = N,
                                        events = events))
stopifnot(length(grep("Missing 't0'",
                      res[[1]]$message)) > 0)

## Check invalid t0 (length != 1) when events$time is a Date vector
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = structure(c(17168, 17169, 17170, 17171, 17172,
                       17173, 17174, 17175, 17176, 17177,
                       17178, 17179, 17180, 17181, 17182),
                     class = "Date"),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events,
                                        t0     = c(1, 1)))
stopifnot(length(grep("Invalid 't0'",
                      res[[1]]$message)) > 0)

## Check invalid t0 (!numeric) when events$time is a Date vector
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = structure(c(17168, 17169, 17170, 17171, 17172,
                       17173, 17174, 17175, 17176, 17177,
                       17178, 17179, 17180, 17181, 17182),
                     class = "Date"),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events,
                                        t0     = "1"))
stopifnot(length(grep("Invalid 't0'",
                      res[[1]]$message)) > 0)

## Check invalid t0 (!NULL) when events$time is not a Date vector
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events,
                                        t0     = 0))
stopifnot(length(grep("Invalid 't0'",
                      res[[1]]$message)) > 0)

## Check events$time equal to a Date vector
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = structure(c(17168, 17169, 17170, 17171, 17172,
                       17173, 17174, 17175, 17176, 17177,
                       17178, 17179, 17180, 17181, 17182),
                     class = "Date"),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
res <- SimInf_events(E = E, N = N, events = events, t0 = 17166)
stopifnot(identical(res@time, 2:16))

## Check events$time equal to an integer vector
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = c(17168, 17169, 17170, 17171, 17172,
             17173, 17174, 17175, 17176, 17177,
             17178, 17179, 17180, 17181, 17182),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
res <- SimInf_events(E = E, N = N, events = events)
stopifnot(identical(is.null(names(res@time)), TRUE))

## Check events$select not equal to whole number
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(0.1, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
str(events)
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events))
stopifnot(length(grep("Columns in events must be integer",
                      res[[1]]$message)) > 0)

## Check events$node not equal to whole number
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    node = c(2.2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
str(events)
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events))
stopifnot(length(grep("Columns in events must be integer",
                      res[[1]]$message)) > 0)

## Check events$node less than one
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    node = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
str(events)
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events))
stopifnot(length(grep("'node' must be greater or equal to 1",
                      res[[1]]$message)) > 0)

## Check events$dest not equal to whole number
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1.1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
str(events)
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events))
stopifnot(length(grep("Columns in events must be integer",
                      res[[1]]$message)) > 0)

## Check events$dest less than 1
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
str(events)
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events))
stopifnot(length(grep("'dest' must be greater or equal to 1",
                      res[[1]]$message)) > 0)

## Check events$n not equal to whole number
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1.1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
str(events)
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events))
stopifnot(length(grep("Columns in events must be integer",
                      res[[1]]$message)) > 0)

## Check events$event equal to character
events <- structure(list(
    event = c("3", "3", "3", "3", "3", "3", "3", "3", "3",
              "3", "3", "3", "3", "3", "3"),
    time = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2),
    shift = c(1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
str(events)
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events))
stopifnot(length(grep("Columns in events must be numeric",
                      res[[1]]$message)) > 0)

## Check events$shift not equal to whole number
events <- structure(list(
    event = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
    time = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    node = c(2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6),
    dest = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    n = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5),
    proportion = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    select = c(0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2),
    shift = c(1.1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0)),
    .Names = c("event", "time", "node", "dest", "n",
               "proportion", "select", "shift"),
    row.names = c(NA, -15L), class = "data.frame")
str(events)
res <- tools::assertError(SimInf_events(E      = E,
                                        N      = N,
                                        events = events))
stopifnot(length(grep("Columns in events must be integer",
                      res[[1]]$message)) > 0)

## Check E and events equal to NULL (default).
events <- new("SimInf_events",
              E = new("dgCMatrix",
                      i = integer(0),
                      p = 0L,
                      Dim = c(0L, 0L),
                      Dimnames = list(NULL, NULL),
                      x = numeric(0),
                      factors = list()),
              N = matrix(integer(0), nrow = 0, ncol = 0),
              event = integer(0),
              time = integer(0),
              node = integer(0),
              dest = integer(0),
              n = integer(0),
              proportion = numeric(0),
              select = integer(0),
              shift = integer(0))
str(events)
stopifnot(identical(SimInf_events(), events))

## Check SimInf_events plot method
E <- Matrix(c(1, 0, 0, 1, 0, 0,
              0, 0, 0, 1, 0, 0,
              0, 1, 0, 0, 1, 0,
              0, 0, 0, 0, 1, 0,
              0, 0, 1, 0, 0, 1,
              0, 0, 0, 0, 0, 1),
            nrow   = 6,
            ncol   = 6,
            byrow  = TRUE,
            sparse = TRUE)
E <- as(E, "dgCMatrix")
N <- matrix(c(2, 0,
              2, 0,
              0, 2,
              0, 2,
              0, 0,
              0, 0),
            nrow   = 6,
            ncol   = 2,
            byrow  = TRUE)
data(events_SISe3)
## Save run-time by only using one year of data
events_SISe3 <- events_SISe3[events_SISe3$time < 366,]
events <- SimInf_events(E = E, N = N, events = events_SISe3)
pdf_file <- tempfile(fileext = ".pdf")
pdf(pdf_file)
plot(events)
dev.off()
stopifnot(file.exists(pdf_file))
unlink(pdf_file)

## Test summary method with scheduled events
summary_expected <-
    c("Number of scheduled events: 195919",
      " - Exit: 45562 (n: min = 1 max = 1 avg = 1.0)",
      " - Enter: 45603 (n: min = 1 max = 1 avg = 1.0)",
      " - Internal transfer: 79225 (n: min = 1 max = 4 avg = 1.1)",
      " - External transfer: 25529 (n: min = 1 max = 1 avg = 1.0)")
summary_observed <- capture.output(summary(events))
stopifnot(identical(summary_observed, summary_expected))