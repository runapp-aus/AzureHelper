

#' @title Get Dynamics365 Table
#'
#' @param table_id character table name
#'
#' @import glue
#' @import httr
#' @import jsonlite
#'
#' @return
#' @export
#'
#' @examples
get_dynamics_table <- function(table_id) {

  #set these values to query your crm data
  query <-  glue("{Sys.getenv()[['DYNAMICS_URL']]}/api/data/v9.2/{table_id}")

  #build the authorization token request
  tokenpost = list(
    client_id = Sys.getenv()[['APP_CLIENT_ID']],
    resource = Sys.getenv()[['DYNAMICS_URL']],
    username = Sys.getenv()[['APP_CLIENT_USER']],
    password = Sys.getenv()[['APP_CLIENT_PASS']],
    grant_type = "password"
  )

  #make the token request
  tokenres <- POST(glue("https://login.microsoftonline.com/{Sys.getenv()[['AZURE_TENANT']]}/oauth2/token"),
                   body = tokenpost)
  accesstoken <- paste("Bearer", content(tokenres)$access_token)

  crmres <- httr::GET(query,
                      httr::add_headers("Authorization" = accesstoken,
                                        "Accept" = "application/json",
                                        "OData-Version" = '4.0',
                                        "OData-MaxVersion" = '4.0',
                                        "Content-Type" =  "application/json; charset=utf-8",
                                        "Prefer" =  "odata.include-annotations=OData.Community.Display.V1.FormattedValue"))

  tbl_data <- content(crmres, 'text') %>% fromJSON()
  df <- tbl_data$value
  colnames(df) <- gsub(pattern = '@OData.Community.Display.V1.FormattedValue',
                       replacement = '',
                       x = colnames(df))

  return(df)

}
