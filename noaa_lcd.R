##########################################################
##### CREATE GRAPH OF ANNUAL TEMP'S FROM NOAA DATA
##########################################################

###########################
#---function call "noaa.lcd"
noaa.lcd<-function(
    #---argument: csv file of NOAA LCD (local climatological data) dataset
      csv=NULL,
    #---argument: year(s) of data to visualize
      year=NULL 
){
  
#---prerequisite packages
  require(lubridate)
  require(ggplot2)
  
###########################
#----check arguments
  
#---stop if no file is specified
  if(is.null(csv)) stop("Argument 'csv' not given with no default")
#---stop if file not found
  if(!file.exists(csv)) stop(cat("File", csv," not found"))
#---stop if year is not numeric
  if(!is.numeric(year)) stop("Argument `year' must be a numeric value")
  
#---read in cols of file
  read.csv(csv,header=F,nrows=1)->cols
#---read in names for noaa.lcd data 
  load("lcd_cols.RData")
#---if there's a row number column is csv, delete it first
  if(all(cols[-1]==lcd.cols)) cols<-cols[-1]
#---stop if column names do not match
  if(!all(cols==lcd.cols)) stop("File not recognized as an NOAA LCD dataset.  
                                                   Please obtain a NOAA LCD dataset from 
                                                   https://www.ncdc.noaa.gov/cdo-web/datatools/lcd")
  
#################################
#----read all data and identify hourly observations
 
#---read all data
  read.csv(csv,colClasses="character")->dat
  #---later, adjust colClasses for each variable!!
  #colClasses="character"
#---if there's a row number column is csv, delete it first
  if(names(dat)[2]=="STATION") dat<-dat[,-1]
  
#---stop if year is not found in the data
  if(!(year %in% year(dat[,6]))) {paste("LCD data does not contain observations in year",year)->error.msg; stop(error.msg)}
#---identify hourly observations in the data
  which(!is.na(as.numeric(dat[,11])))->obs.rows
#---extract hourly observations
  dat<-dat[obs.rows,]
  
#############################################################
#----create data frame with observations and temperatures
#############################################################

#--identify observations in given year
  which(year(dat[,6])==year)->obs.rows
#--extract observation times
      OBS<-dat[obs.rows,6]
  
  
  #--calculate minutes from new year's 
      MINUTES<-1440*(yday(OBS)-1)+60*hour(OBS)+minute(OBS)
  #--find temperatures
      TEMP<-as.numeric(dat[obs.rows,11])
      

#--create data frame
      datt<-data.frame(
          OBS,
          MINUTES,
          TEMP,
          stringsAsFactors = F
      )
      
###########################################
#-----create temperature vs time graph
###########################################
      
#---find breaks on the first of each month
    #--Find the last day of each month in the year
      as_datetime(paste0(year-1,"1231")) %m+% months(1:12)->breakx
    #--Find the number of minutes elapsed through each month
      1440*yday(breakx)->breakx
    #--Add 0 for the start
      breakx<-c(0,breakx)

#---find max & min values of temperature and round from there
      #---HOW TO ADJUST FOR PLACE WITH LESS TEMP RANGE??
    #--Find the max temp, add 5, round up
      ymax<-ceiling((max(TEMP)+5)/10)*10
    #--Find the min temp, subtract 5, round down
      ymin<-floor((min(TEMP)-5)/10)*10
    #--Sequence of breaks on y-axis
      breaky<-seq(ymin,ymax,by=10)
            
#---plot=a graph of temperature vs. time in minutes
      plot<-ggplot(datt,aes(x=MINUTES,y=TEMP))+geom_point()

#---scalex=breaks at each month  
      scalex<-scale_x_continuous(limits=c(0,max(breakx)),breaks=breakx,minor_breaks = NULL,labels=NULL)
#---scaley=breaks every ten degrees
      scaley<-scale_y_continuous(limits = c(ymin-50,ymax),breaks=breaky, minor_breaks=NULL)
      
      
#---output datt
    #datt
      plot+
      scalex+
      scaley
}
  
  
  