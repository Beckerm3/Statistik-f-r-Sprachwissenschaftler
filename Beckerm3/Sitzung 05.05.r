setwd("C:/Users/Martin_2/Documents/Statistik-f-r-Sprachwissenschaftler")
rtdata <- read.table(("Data/priming_rt.tab"),header = T)

rtdata$subj <- as.factor(rtdata$subj)
summary(rtdata)

#Zentrierung der Daten:
rt.zentriert <- rtdata$RT - mean(rtdata$RT)
head(rt.zentriert,n=4)
# Berechnung des Z-Werts
rt.z <- (rtdata$RT - mean(rtdata$RT)) / sd(rtdata$RT)
head(rt.z,n=4)
    # !!! Weder die Zentrierung, noch der Z-Wert hat eine Einheit!!
# andere Art, den Z-Wert zu berechnen!
rt.z2 <- scale(rtdata$RT)
rt.z2[1:4] #Berechnung der ersten vier Werte

# bei Umfragen etc. muss zwischen Population (alle relevanten Testpersonen) und Stichprobe (alle befragte Personen) unterschieden werden.
# Zur Markierung der Populationen werden griechische Buchstaben benutzt.
# Zur Markierung der Stichprobe werden lateinische Buchstaben benutzt.
