# Install the required packages as follows:
# install.packages(c("jsonlite", "httr"))

library(jsonlite)
library(httr)

# Script parameters
baseurl <- "https://pbs.puzzle.ch"
token <- "d-Zx8kn-mKWaxXziYs62xVX2HdUdVKnSmLQYpQG-XznkbRD71g"
groupid <- 1
headers <- '{"Accept": "application/json"}'

# Get MiData root group
rootElement <- fromJSON(paste(baseurl,"/groups/", groupid, ".json?token=", token, sep=""))
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