# Opinion-polling-for-the-next-Italian-general-election

Parser for data collected from Wikipedia. The dataset is stored on [Dataverse](https://doi.org/10.7910/DVN/IFSWXO). To cite:

```bib
@data{DVN/IFSWXO_2018,
author = {Bailo, Francesco},
publisher = {Harvard Dataverse},
title = {Opinion polling for the next Italian general election | wikidata.org/wiki/Q54437087},
year = {2018},
doi = {10.7910/DVN/IFSWXO},
url = {https://doi.org/10.7910/DVN/IFSWXO}
}
```

## Source

Wikipedia opinion polling data are available on these pages:

* [Opinion_polling_for_the_next_Italian_general_election](https://en.wikipedia.org/wiki/Opinion_polling_for_the_next_Italian_general_election)
* [Opinion_polling_for_the_Italian_general_election,_2013](https://en.wikipedia.org/wiki/Opinion_polling_for_the_Italian_general_election,_2013)


## Code

The R script `read_raw_xlsx.R` takes care of parsing the information from the different sheets of the Excel spreadsheet into a long-format data frame. It also adds Wikidata identifiers (when available). 

## Data

Observations in the dataset `open_csv_italian_party_polls.csv`  are defined for this variables
* `polling_firm`: The name of the polling firm.
* `variable`: The name of the variable. It can be a party label to indicate , `Sample size` or `Other`. 
* `value`: Double value of the observation.
* `date`: The last date in which of the survey was administered. 
* `wikidata_id`: The Wikidata identifier for the party in the format `Q\d+(\+Q\d+)?`.  A `+` between two identifiers indicates that entity is a "join" of two Wikidata entities while `-` indicates that that the entity refers to two different Wikidata entities conditionally on the date. 


