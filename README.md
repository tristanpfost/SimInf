

![](./logo/logo.png)

> A flexible and efficient framework for data-driven stochastic disease spread simulations

[![Build Status](https://travis-ci.org/stewid/SimInf.svg?branch=master)](https://travis-ci.org/stewid/SimInf)
[![Build status](https://ci.appveyor.com/api/projects/status/pe68xiu1anxvet2n?svg=true)](https://ci.appveyor.com/project/stewid/SimInf)
[![CRAN status](http://www.r-pkg.org/badges/version/SimInf)](http://cran.r-project.org/web/packages/SimInf/index.html)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/last-month/SimInf)](http://cran.r-project.org/web/packages/SimInf/index.html)
[![Coverage Status](https://coveralls.io/repos/stewid/SimInf/badge.svg?branch=master&service=github)](https://coveralls.io/github/stewid/SimInf?branch=master)

# SimInf

The package provides an efficient and very flexible framework to
conduct data-driven epidemiological modeling in realistic large scale
disease spread simulations. The framework integrates infection
dynamics in subpopulations as continuous-time Markov chains using the
Gillespie stochastic simulation algorithm and incorporates available
data such as births, deaths and movements as scheduled events at
predefined time-points. Using C code for the numerical solvers and
'OpenMP' (if available) to divide work over multiple processors
ensures high performance when simulating a sample outcomes. One of our
design goal was to make the package extendable and enable usage of the
numerical solvers from other R extension packages in order to
facilitate complex epidemiological research. The package contains
template models and can be extended with user-defined models.

## Installation

To install the latest release on CRAN


```r
install.packages("SimInf")
```

To install the development version of `SimInf`, it's easiest to use
the devtools package:


```r
# install.packages("devtools")
library(devtools)
install_github("stewid/SimInf"")
```

Another alternative is to use `git` and `make`


```r
$ git clone https://github.com/stewid/SimInf.git
$ cd SimInf
$ make install
```

### Dependencies

#### On a Debian based system

Before installing `SimInf` you need to install
[The GNU Scientific Library](http://www.gnu.org/software/gsl/) (GSL).


```r
apt-get install libgsl0-dev
```

You may need to do:

```r
sudo apt-get install libgsl0-dev
```

#### On a Windows machine

To install the development version of `SimInf` you first need to
download and install
[Rtools](http://cran.r-project.org/bin/windows/Rtools/)

# Authors

* Pavol Bauer (Uppsala University, Sweden)
* Robin Eriksson (Uppsala University, Sweden)
* Stefan Engblom (Uppsala University, Sweden)
* Stefan Widgren (National Veterinary Institute, Sweden) **(Maintainer)**

# Acknowledgments

This work was financially supported by the Swedish Research Council
within the UPMARC Linnaeus centre of Excellence (Pavol Bauer, Robin
Eriksson and Stefan Engblom), the Swedish Research Council Formas
(Stefan Engblom and Stefan Widgren), the Swedish Board of Agriculture
(Stefan Widgren), and by the Swedish strategic research program
eSSENCE (Stefan Widgren).

# License

The `SimInf` package is licensed under the GPLv3.

- [LICENSE](LICENSE) - `SimInf` package license

Any suggestions, bug reports, forks and pull requests are
appreciated. Get in touch.
