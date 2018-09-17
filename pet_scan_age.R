#!/usr/bin/env Rscript

#
# give list of luna_date, return ages
#
suppressMessages({
library(dplyr)
library(tidyr)
library(lubridate)
})
# read command args into dataframe
idlist <- commandArgs(T)
# eg.
# idlist <- c("11543_20160507", "11577_20180407")

# make input into dataframe of ID and visitdate (d8)
d.in <-
   data.frame(ld8=idlist) %>%
   separate(ld8, c("ID", "d8")) %>%
   mutate(visitdate=ymd(d8)) %>%
   unique

# get online sheet
gsheet_top <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vT32ku-_l9DKLSYi8lHdeWCFolyjZy8V5NaXbYdb7vY6WWA9JFyo-9_XeCB4NvSofN3EaPEWwru51PU/pub?gid=0&single=true&output=tsv"
d.sheet <-
   read.table(gsheet_top, sep="\t", header=T) %>%
   # make dob into a date object (using lubridate)
   mutate(dob=mdy(dob)) %>%
   # we only care about the ID and dob
   select(ID, dob) %>%
   # and we dont want mulitple visits
   unique

# just get parts of the gsheet we care about and calc age 
d <-
   merge(d.in, d.sheet, by="ID", all.x=T) %>%
   mutate(age=round(as.numeric(visitdate-dob)/365.25, 2))

# print tab sep columns(id,visitdate,age), new lines sep rows (ids)
cat(paste(d$ID, d$d8, d$age, sep="\t", collapse="\n"), "\n")
