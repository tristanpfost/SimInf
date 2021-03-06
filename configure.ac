# SimInf, a framework for stochastic disease spread simulations
# Copyright (C) 2015  Pavol Bauer
# Copyright (C) 2017 - 2018  Robin Eriksson
# Copyright (C) 2015 - 2018  Stefan Engblom
# Copyright (C) 2015 - 2018  Stefan Widgren
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# The configuration for OpenMP is from an example by Simon Urbanek on
# the r-devel mail-list:
# https://stat.ethz.ch/pipermail/r-devel/2010-September/058488.html

AC_PREREQ([2.69])
AC_INIT([SimInf], [see.DESCRIPTION.file], [https://github.com/stewid/SimInf/issues])
AC_CONFIG_SRCDIR([src/SimInf.c])

# Checks for programs.
AC_PROG_CC

# Check for OpenMP
AC_OPENMP

# Optional GSL include and library path
AC_ARG_WITH([gsl-include],
            AC_HELP_STRING([--with-gsl-include=INCLUDE_PATH],
                           [the location of gsl header files]),
            [gsl_include_path=$withval])

AC_ARG_WITH([gsl-lib],
            AC_HELP_STRING([--with-gsl-lib=LIB_PATH],
                           [the location of gsl library]),
            [gsl_lib_path=$withval])

# Find the compiler and compiler flags to use
: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
    echo "could not determine R_HOME"
    exit 1
fi
RBIN="${R_HOME}/bin/R"
RSCRIPT="${R_HOME}/bin/Rscript"
CPPFLAGS=`"${RBIN}" CMD config CPPFLAGS`

# since some systems have broken OMP libraries
# we also check that the actual package will work
ac_pkg_openmp=no
if test -n "${OPENMP_CFLAGS}"; then
    AC_MSG_CHECKING([whether OpenMP will work in a package])
    AC_LANG_CONFTEST(
    [AC_LANG_PROGRAM([[#include <omp.h>]], [[ return omp_get_num_threads (); ]])])
    PKG_CFLAGS="${OPENMP_CFLAGS}" PKG_LIBS="${OPENMP_CFLAGS}" "$RBIN" CMD SHLIB conftest.c \
    1>&AS_MESSAGE_LOG_FD 2>&AS_MESSAGE_LOG_FD && \
    "$RBIN" --vanilla -q -e "dyn.load(paste('conftest',.Platform\$dynlib.ext,sep=''))" \
    1>&AS_MESSAGE_LOG_FD 2>&AS_MESSAGE_LOG_FD && ac_pkg_openmp=yes
    AC_MSG_RESULT([${ac_pkg_openmp}])
fi

if test "x${ac_pkg_openmp}" = xno; then
    OPENMP_CFLAGS=''
    AC_MSG_WARN([
  -----------------------------------------------
   Unable to find OpenMP on this system.
   Building a version without support for OpenMP.
  -----------------------------------------------])
fi

# Check for GSL.
have_gsl=yes

# Check for optional GSL include path
if test [ -n "$gsl_include_path" ] ; then
    CPPFLAGS="-I${gsl_include_path} ${CPPFLAGS}"
fi

# Check for optional GSL lib path
if test [ -n "$gsl_lib_path" ] ; then
    LIBS="-L${gsl_lib_path} ${LIBS}"
fi

# Check for gsl
have_gsl=no
AC_PATH_PROG([GSL_CONFIG], [gsl-config])
if test "x${GSL_CONFIG}" != x; then
    # Check for gsl using gsl-config
    GSL_CFLAGS=`${GSL_CONFIG} --cflags`
    GSL_LIBS=`${GSL_CONFIG} --libs`
    have_gsl=yes
else
    # Check for gsl using autoconf macros
    # https://www.gnu.org/software/gsl/manual/html_node/Autoconf-Macros.html
    AC_CHECK_LIB([m],[cos])
    AC_CHECK_LIB([gslcblas], [cblas_dgemm], [], [have_gsl=no])
    AC_CHECK_LIB([gsl], [gsl_blas_dgemm], [], [have_gsl=no])
fi

if test "x${have_gsl}" = xno; then AC_MSG_FAILURE([
  ---------------------------------------------
   The GNU Scientific Library (GSL) that is
   required to build SimInf was not found.

   Please install:
        libgsl0-dev (package on e.g. Debian and Ubuntu)
     gsl-devel   (package on e.g. Fedora, CentOS and RHEL)
     gsl         (Homebrew package on OS X)
   and try again.

   If the GNU Scientific Library (GSL) is
   installed on your system but the SimInf
   configuration is unable to find it, you
   can specify the include and lib path to
   GSL with:
   R CMD INSTALL --configure-args='--with-gsl-include=INCLUDE_PATH --with-gsl-lib=LIB_PATH' SimInf
  ---------------------------------------------])
fi

# List all model files to compile
MODELS_OBJ=`"${RSCRIPT}" -e "cat(paste0('models/', sub('c$', 'o', list.files('src/models', '[.]c$')), collapse=' '))"`

AC_SUBST([PKG_CPPFLAGS], ["-I. -Icore -Imisc -Imodels ${CPPFLAGS} ${GSL_CFLAGS}"])
AC_SUBST([PKG_CFLAGS], ["${OPENMP_CFLAGS} -DR_NO_REMAP -DSTRICT_R_HEADERS"])
AC_SUBST([PKG_LIBS], ["${OPENMP_CFLAGS} ${GSL_LIBS} ${LIBS}"])
AC_SUBST(MODELS_OBJ)

AC_CONFIG_FILES([src/Makevars])

echo "
  ---- Results for the SimInf package configure ----

    PKG_CPPFLAGS..............: -I. -Icore -Imisc -Imodels ${CPPFLAGS} ${GSL_CFLAGS}
    PKG_LIBS..................: ${OPENMP_CFLAGS} ${GSL_LIBS} ${LIBS}
    PKG_CFLAGS................: ${OPENMP_CFLAGS} -DR_NO_REMAP -DSTRICT_R_HEADERS
    Have support for OpenMP...: ${ac_pkg_openmp}

  --------------------------------------------------
"

AC_OUTPUT
