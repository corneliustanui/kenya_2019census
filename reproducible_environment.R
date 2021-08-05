# Load Package
library(renv)

# Initialize environment
renv::init()

# Have a look at the environment
renv::snapshot()

# Revert the environment
renv::restore()