
1.Download the American Community Survey data about United States communities and load it into an R object. https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv You can find the codebook here
download.file(URL, destfile = "./data/data.csv", method="curl")
session4 <- read.csv("./data/getdata_data_ss06hid.csv")

2.Describe the data table (dimensions, column names, data types) 
dim(session4)
[1] 6496  188
sapply(session4, class)

3.Use the  sqldf  package to get the different states where there are houses with 4 or more bedrooms.
> sqldf("select DISTINCT ST from session4 where BDS >= 4") 
ST
1 16

4.With the same data obtain the households on greater than 10 acres who sold more than $10,000 worth of agriculture products.
sqldf("select count(*) from session4 where BDS >= 4 and AGS >= 3 and ACR = 3")
count(*)
1       65

5.Load the Gross Domestic Product data for the 190 ranked countries in this data set: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(urlFile2, "./data/gdp.csv")
library(dplyr)
df2 <- read.csv("./data/gdp.csv", skip = 4 , header = TRUE
                , blank.lines.skip = TRUE, colClasses = "character"
                , na.strings = "NA")
ds2 <- tbl_df(df2)


url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url2, "./data/led.csv")
df3 <- read.csv("./data/led.csv", header = TRUE, blank.lines.skip = TRUE)
ds3 <- tbl_df(df3)

7.Match the data based on the country shortcode.

mrg <- merge(ds2,ds3, by.ds2 = "X", by.ds3 ="CountryCode")
> ds4 <- tbl_df(mrg)

8.Describe the data table (dimensions, column names, data types) 

> dim(ds4)
[1] 76284    41


9.What is the average GDP ranking for the "Lower middle income" and "Upper middle income" group?
> nms <- gsub("\\.","",names(ds4),)
> colnames(ds4) <- nms
