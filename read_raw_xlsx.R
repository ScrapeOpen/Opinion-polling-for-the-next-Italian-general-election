formatDate <- function(x, year) {

  x <- gsub("31 Nov", "30 Nov", x)

  if (grepl("\\d{5}", x)) {
    return(as.character(as.Date("1900-01-01") + as.numeric(x) - 2)) # This is how Excel stores numbers
  } else if (grepl("[A-Za-z]{3}(-|–)\\d{1,2}", x)) {
    return(as.character(as.Date(paste0(gsub("^(.*)(-|–)", "", x), " ", year), "%d %b %Y")))
  } else {
    return(as.character(as.Date(paste0(gsub("^\\d+(-|–)", "", x), " ", year), "%d %b %Y")))
  }
}

excel_file <- "~/public_git/ScrapeOpen/Opinion-polling-for-the-next-Italian-general-election/raw_xlsx_italian_party_polls.xlsx"

library(readxl)
sheets <- excel_sheets(excel_file)

wikipedia_data <- data.frame()

library(reshape2)
library(stringr)
for (s in sheets) {
  print(s)
  this_dat <- read_excel(excel_file, sheet = s)
  this_dat <- this_dat[,-c(1:2)]
  this_dat <- reshape2::melt(this_dat, id.vars = c("Date.3", "Polling firm"))
  this_dat$sheet <- s
  this_dat$date.class <- as.Date(sapply(this_dat$Date.3, formatDate, year = str_extract(s, "\\d{4}")))
  wikipedia_data <- rbind(wikipedia_data, this_dat)
}

wikipedia_data <- subset(wikipedia_data, !variable %in% c("Lead", "Date text", "Others", "Oth."))
wikipedia_data$value <- as.numeric(wikipedia_data$value)
wikipedia_data <- subset(wikipedia_data, !is.na(value))
wikipedia_data$variable <- droplevels(wikipedia_data$variable)

wikipedia_data_elections <-
  subset(wikipedia_data, `Polling firm` %in% c('General Election','EP Election'))
wikipedia_data <-
  subset(wikipedia_data, !`Polling firm` %in% c('General Election','EP Election'))

wikipedia_data$Date.3 <- NULL
wikipedia_data$sheet <- NULL

## `+` indicates that entity is a `join` of two Wikidata entities,
## `-` conditionally on date, entity refers to two different
##  Wikidata entities

wikidata_id <-
  c('Q47720' = 'PdL', 'Q47729' = 'PD', 'Q47750' = 'LN', 'Q47781' = 'UdC', 'Q47768' = 'IdV',
    'Q286140' = 'SEL', 'Q47817' = 'M5S', 'Q47795' = 'FLI', 'None1' = 'VTR',
    'Q1757843' = 'FdI', 'Q1952211' = 'CD', 'Q2152252' = 'RC', 'Q2792033' = 'SC',  'Q47720+Q14924303' = 'PdL/FI',
    'Q15196039' = 'NCD', 'Q215350-Q14924303' = 'FI', 'SEL/SI', 'Q286140+Q21405813' = 'SI',
    'Q28962342' = 'AP', 'Q28841838' = 'MDP',  'Q28946245' = 'CP',  'Q44929224' = 'LeU',
    'Q46624077' = 'I',  'Q47389793' = 'LCP',  'Q47090559' = '+E', 'Q46997473' = 'NcI', 'Q46217506' = 'PaP',
    'Q25648673' = 'CPI')

wikipedia_data$wikidata_id <- names(wikidata_id)[match(wikipedia_data$variable, wikidata_id)]
wikipedia_data$wikidata_id[wikipedia_data$wikidata_id == ""] <- NA
wikipedia_data$wikidata_id[grepl("None", wikipedia_data$wikidata_id)] <- NA

wikipedia_data$wikidata_id[wikipedia_data$variable == "Lega"] <- 'Q47750'
wikipedia_data$wikidata_id[wikipedia_data$variable == "LeU[a]"] <- 'Q44929224'

names(wikipedia_data) <- c("polling_firm", "variable", "value", "date", 'wikidata_id')

write.csv(wikipedia_data, file = '~/public_git/ScrapeOpen/Opinion-polling-for-the-next-Italian-general-election/open_csv_italian_party_polls.csv', row.names = F)

