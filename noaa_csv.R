##########################################################
##### CREATE GRAPH OF ANNUAL TEMP'S FROM NOAA DATA
##########################################################

#---function call "noaa"
noaa.csv<-function(
    #---argument: csv file of NOAA LCD (local climatological data) dataset
      noaa.lcd=NULL
){
  
#---stop if no file is specified
  if(is.null(noaa.lcd)) stop("Argument 'noaa.lcd' not given with no default")
#---stop if file not found
  if(!file.exists(noaa.lcd)) stop("File not found")
  
#---read in file  (read in just first line to check, first???)
  read.csv(noaa.lcd,
           #---later, adjust colClasses for each variable!!
           colClasses="character"
             )->dat
###(stop if not read??)

#---read in names for noaa.lcd data 
  load("noaa_lcd_names.RData")
#---stop if dat names do not match
  if(!all(names(dat)==names(noaa.lcd.names))) stop("File not recognized as an NOAA LCD dataset.  
                                                   Please obtain a NOAA LCD dataset from 
                                                   https://www.ncdc.noaa.gov/cdo-web/datatools/lcd")
  

#---identify hourly observations in the data
  which(!is.na(as.numeric(dat[,11])))->obs.rows
#---extract hourly observations
  dat<-dat[obs.rows,]
  
#############################################################
#----create data frame with observations and temperatures
#############################################################

  datt<-data.frame(
      OBS=dat[,6],
      OBS.N=1:nrow(dat),
      TEMP=as.numeric(dat[,11]),
      stringsAsFactors = F
  )
 
#------BETTER EXPRESS TIME for data
require(lubridate)
    #---create cumulative time metrics
      year(datt$OBS) %% year(datt$OBS[1])->cyear
      month(datt$OBS)+12*cyear-month(datt$OBS[1])->cmonth    
      yday(datt$OBS)+365*cyear-yday(datt$OBS[1])->cday  ##leap days??
      hour(datt$OBS)+24*cday->chour
      minute(datt$OBS)+60*hour(datt$OBS)+1440*cday->cminute
    #---add to data frame
      datt<-cbind(datt,cyear,cmonth,cday,chour,cminute)
      
      
#---output datt
    datt
}
  
  
  