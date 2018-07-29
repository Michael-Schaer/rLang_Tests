# Install the required packages as follows:
# install.packages(c("jsonlite", "httr"))

library(jsonlite)
library(httr)

# Script parameters
baseurl <- "https://pbs.puzzle.ch"
usermail <- "hussein_kohlmann@hitobito.example.com"
userpassword <- "hito42bito"
groupid <- 1
headers <- '{"Accept": "application/json"}'
query <- list(	'person[email]'=usermail, 
			'person[password]'=userpassword,
			'headers'=headers
)

# Get user token
response = POST(url = paste(baseurl, "/users/sign_in.json", sep=""), body = query)
responseTxt <- content(response, "text")
responseData <- fromJSON(responseTxt)
tokenTxt <- responseData$people$authentication_token

# Get MiData root group
rootElement <- fromJSON(paste(baseurl,"/groups.json?user_email=", usermail, "&user_token=", tokenTxt, sep=""))
# Filter cantons
cantons = subset(rootElement$linked$groups, group_type == "Kantonalverband")
rownames(cantons) <- seq(length=nrow(cantons))

# Set a flag if the canton has an even id (just for fun)
cantons$even <- F
counter <- 1
for (id in cantons$id) {
	cantons$even[counter] <- ((as.numeric(cantons$id[counter]) %% 2) == 0)
	counter = counter + 1
}

# Print table of cantons
cantons