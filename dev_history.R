
library(devtools)
library(usethis)
library(pkgdown)



# use project options to choose roxygen2
devtools::document()

usethis::use_build_ignore("dev_history.R") # ensure this file is ignored

#usethis::use_mit_license()

use_readme_rmd()

use_testthat()

use_pkgdown()

use_data_raw()

use_pipe()

use_version('patch')

use_news_md()

use_vignette('AzureHelper') # user guide



# Build and Run

lintr::lint_package()

devtools::document()
pkgdown::build_site()

devtools::test()
devtools::check()
devtools::build()



# create modules
use_r('dynamics.R')
use_test('dynamics.R')
