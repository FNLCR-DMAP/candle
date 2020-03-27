# Call in code like 'hyperparams[["k"]]'

# load jsonlite library
library(jsonlite)

# append $SUPP_R_LIBS to the R path
.libPaths( c( .libPaths(), Sys.getenv("SUPP_R_LIBS")) )
#.libPaths( c( Sys.getenv("SUPP_R_LIBS"), .libPaths() ) )

# load the parameters from the "params.json" file
hyperparams <- fromJSON("params.json")
