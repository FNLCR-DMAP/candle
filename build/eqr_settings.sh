#!/bin/bash

myrroot=/usr/local/apps/R/3.5/3.5.0_build2/lib64/R
mytclroot=/usr/local/Tcl_Tk/8.6.8/gcc_7.2.0
#CANDLE=/data/BIDS-HPC/public/candle
#R_LOCAL_LIB=/data/BIDS-HPC/public/software/builds/versions/R/R-2019-04-04/libs
R_LOCAL_LIB=$R_LIBS

# R system-wide install where libraries and includes have
# a different parent and optional packages are installed within
# a user's home directory (e.g. Ubuntu 16.04)
#R_INCLUDE=/usr/share/R/include
R_INCLUDE=$myrroot/include
#R_LIB=/usr/lib/R/lib
R_LIB=$myrroot/lib
#R_LOCAL_LIB=$HOME/R/x86_64-pc-linux-gnu-library/3.3
#R_LOCAL_LIB=$CANDLE/R/libs
#R_INSIDE=$R_LOCAL_LIB/RInside
R_INSIDE=$myrroot/../../../site-library_build2/RInside
#RCPP=$R_LOCAL_LIB/Rcpp
RCPP=$myrroot/../../../site-library_build2/Rcpp


# R system-wide install where libraries and includes
# are under a common system wide home directory, and 3rd party
# packages are installed in a user's home directory.
# R_HOME=/software/R-3.2-el6-x86_64/lib64/R
# R_INCLUDE=$R_HOME/include
# R_LIB=$R_HOME/lib
# R_LOCAL_LIB=$HOME/R/x86_64-unknown-linux-gnu-library/3.2
# R_INSIDE=$R_LOCAL_LIB/RInside
# RCPP=$R_LOCAL_LIB/Rcpp

# R install where libraries and includes are under
# a common directory e.g. a local install of R in a
# user's home directory.
# R_HOME=$HOME/sfw/R-3.0.1
# R_INCLUDE=$R_HOME/lib/R/include
# R_LIB=$R_HOME/lib/R/lib
# R_INSIDE=$R_HOME/lib/R/library/RInside
# RCPP=$R_HOME/lib/R/library/Rcpp

# OSX - R installed in /Library/Framework/R with
# Rcpp and RInside installed beneath that
# R_HOME=/Library/Frameworks/R.framework
# R_INCLUDE=$R_HOME/Resources/include
# R_LIB=$R_HOME/Resources/lib
# R_INSIDE=$R_HOME/Resources/RInside
# RCPP=$R_HOME/Resources/Rcpp

#system-wide tcl
#TCL_INCLUDE=/usr/local/include/tcl
TCL_INCLUDE=$mytclroot/include
#TCL_LIB=/usr/local/lib
TCL_LIB=$mytclroot/lib
TCL_LIBRARY=tcl8.6

# APT tcl-dev
# TCL_INCLUDE=/usr/include/tcl8.6
# TCL_LIB=/usr/lib/x86_64-linux-gnu
# TCL_LIBRARY=tcl8.6

# a local tcl
# TCL_INCLUDE=$HOME/sfw/tcl-8.6.0/include
# TCL_LIB=$HOME/sfw/tcl-8.6.0/lib
# TCL_LIBRARY=tcl8.6

CPPFLAGS=""
CPPFLAGS+="-I$TCL_INCLUDE "
CPPFLAGS+="-I$R_INCLUDE "
CPPFLAGS+="-I$RCPP/include "
CPPFLAGS+="-I$R_INSIDE/include "
CXXFLAGS=$CPPFLAGS

LDFLAGS=""
LDFLAGS+="-L$R_INSIDE/lib -lRInside "
LDFLAGS+="-L$R_LIB -lR "
LDFLAGS+="-L$TCL_LIB -l$TCL_LIBRARY "
LDFLAGS+="-Wl,-rpath -Wl,$TCL_LIB "
LDFLAGS+="-Wl,-rpath -Wl,$R_LIB "
LDFLAGS+="-Wl,-rpath -Wl,$R_INSIDE/lib"

export CPPFLAGS CXXFLAGS LDFLAGS
