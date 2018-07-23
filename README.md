# NOAA.LCD
### NOAA LCD visualizer

This NOAA LCD visualizer requires a csv spreadsheet of local climatological data (LCD) as recorded by the NOAA.  These spreadsheets can be downloaded from the [NOAA website](https://www.ncdc.noaa.gov/cdo-web/datatools/lcd).

Once a csv file of NOAA LCD data is obtained, it can be called as the argument to the R function _noaa.lcd_.  

So, funny thing about this being a 'visualizer'.  Just yet, there's no visualization of the data, at least not automatically.  The function, at current, outputs a 'nice' data frame with the temperature data from the LCD data.  A visualization is easily obtained with ggplot -- but soon enough I'll figure out how to build all that directly into the _noaa.lcd_ function.
