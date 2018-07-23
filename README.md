# NOAA.LCD
### NOAA LCD visualizer

This NOAA LCD visualizer requires a csv spreadsheet of local climatological data (LCD) as recorded by the NOAA.  These spreadsheets can be downloaded from the [NOAA website](https://www.ncdc.noaa.gov/cdo-web/datatools/lcd).  

As a sample, the file _ohare2014.csv_ is provided, containing the LCD data from Chicago's O'Hare airport from 2014.  Assuming all files from the repository are in your working directory, the following commands in R will run the visualizer for the data:

```{
source("noaa_csv.R")
noaa.csv("ohare2014.csv")->dat
ggplot(dat,aes(x=OBS.N,y=TEMP))+geom_line()
```

So, funny thing about this being a 'visualizer'.  You might notice how the visualization of the data comes from ggplot -- not the _noaa.csv_ function itself.  The function, at current, only outputs a 'nice' data frame with the temperature data from the LCD data.  I'm wokring on building the graphs directly into the _noaa.csv_ function.  Coming soon!!
