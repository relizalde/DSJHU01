#setwd("C:/Users/angel.huerta.juarez/Documents/R training/DSJHU01/session04")

library(RCurl)
#install.packages("sqldf")
library(sqldf)
library(dplyr)


#1
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
csvfile = "./data/hid.csv"
# Download and unzip the files
if(!file.exists(csvfile)) {
    print("File doesn´t exist. It will be downloaded.")
    outDir <- "./data"
    dir.create(outDir)
    download.file(URL, csvfile)
} else print("File already exists. Nothing was downloaded.")

#2
data<- read.csv(csvfile)
str(data)

#3. Use the sqldf package to get the different states where there are houses with 4 or more bedrooms
sqldf("select DISTINCT ST from data where BDS >= 4")

#   ST
# 1 16

#4 .Obtain the households on greater than 10 acres who sold more than $10,000 worth of agriculture products.
subset <-filter(data, ACR==3, AGS==6)
nrow(subset)

# [1] 77

#5. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(URL, "./data/FGDP.csv", mode="wb")

#6. Load the educational data from this data set:
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(URL, "./data/Country.csv", mode="wb")

#7. Match the data based on the country shortcode
countries <- read.csv("./data/Country.csv")

edData <- read.csv("./data/FGDP.csv", skip=3, stringsAsFactors=FALSE)
edData <- edData[,1:5]
edData$Ranking <- as.numeric(edData$Ranking)
edData <- filter(edData, !is.na(Ranking))

edData<- rename(edData, CountryCode=X)
edData<- rename(edData, CountryName=Economy)
edData<- rename(edData, Millions=US.dollars.)
edData$Millions <- as.numeric(gsub(",", "", edData$Millions))

edData <- select(edData, CountryCode, Ranking, CountryName, Millions)

mergedSet <- merge(countries,edData, by="CountryCode")

View(mergedSet)

#8. Describe the data table (dimensions, column names, data types)
str(mergedSet)

#9 What is the average GDP ranking for the "Lower middle income" and "Upper middle income" group?
smallDS<- filter(mergedSet, Income.Group=="Low income" | Income.Group=="Upper middle income")
smallDS<- group_by(smallDS, Income.Group)
summarise(smallDS, mean(Ranking))

# # A tibble: 2 x 2
# Income.Group mean(Ranking)
# <fctr>                    <dbl>
# 1 Low income              133.72973
# 2 Upper middle income     92.13333

#10. Using dyplr package reorder the rows in the dataframe by rank 

sortedSet <- arrange(mergedSet, Ranking)

# Bonus: how would you do it in a descending order?
sortedSet <- arrange(mergedSet, desc(Ranking))

#11. Using dplyr get the average, max, min and median total economy by lending category
grouped <- group_by(mergedSet, Lending.category)

summarise(grouped, max(Millions), min(Millions), median(Millions))
# A tibble: 4 x 4
# Lending.category max(Millions) min(Millions) median(Millions)
# <fctr>         <dbl>         <dbl>            <dbl>
# 1                       16244600            40         196446.0
# 2            Blend       1841710           480          15700.5
# 3             IBRD       8227103           182          50603.0
# 4              IDA        262597           175           7700.0


#12 Add a column with the sum of the total economy by government accounting concept.
mergedSet<- mutate(group_by(mergedSet, Government.Accounting.concept), SumByAccConcept=sum(Millions))
View(mergedSet)

#13. Read the HTML link http://biostat.jhsph.edu/~jleek/contact.html and load it into an R variable

URL <- url("http://biostat.jhsph.edu/~jleek/contact.html")
html = readLines(URL)
close(URL)

#14. Load the dataset from the following link into an R variable and describe it
file <- read.fwf("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
                 ,c(14, 5, 5, 8,5, 8, 5, 8, 5)
                 , skip = 4
)
str(file)