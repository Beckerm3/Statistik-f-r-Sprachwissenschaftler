data1 <- c(0.1, -0.1, 0.1, -0.1, 0.2, -0.3)
#mean(data1)
t.test(data1)

data2 <- c(0.1, -0.1, 0.1, -0.1, 0.2, -4.0)
#mean(data2)
t.test(data2)

#############
#  Sitzung  #
# 26.5.2014 #
#############

ANOVA = Analysis of Variation
      --> (Erweiterung vom) F-Test
      
Befehl na.omit = leere Zellen weglassen
    -> verzerrt aber die Daten

aggregate
  FUN = Funktion
    Mittelwert: mean
    Varianz:    var
  

Befehl attach() erlaubt es, dass man nicht mehr das $ Zeichen benutzen muss...
z.B: attach(test) setzt fest, dass in der Umgebung "Test" gearbeitet wird
wenn nun sum( (a)) eingegeben wird, bedeutet es, dass in der Umgebung test$a gearbeitet wird

Mit dem Befehl detach() wird "Attach" rückgängig gemacht


################
#### Sitzung ###
## 02.06.2014 ##
################

priming <- read.table("Data/priming.tab",header = T)
priming$subj <- as.factor(priming$subj)
priming <- subset(priming, item <= 20) # Filler ausschließen
priming$item <- as.factor(priming$item)

#! Es fehlt das Objekt "prime.target"

head(priming)
aggregate(RT~priming*target, data=priming, mean)
library(ez)
?ezStats
ezStats(priming,dv=.(RT), wid=.(subj),within=.(prime.target))
#Fehlermeldung = 2x2 Datendesign, jeweils ein Teilbereich benutzt - daher keine Teilüberschneidung
#
ezStats(priming,dv=.(RT), wid=.(item),within=.(prime.target))


priming.by.subject <- aggregate(RT~prime*target*subj, data=priming, FUN=mean)
priming.by.subject <- aggregate(RT~cond*subj, data=priming, FUN=mean)
head(priming.by.subject)

ggplot(priming.by.subject)+geom_jitter(aes(x=cond,y=RT))
ggplot(priming.by.subject)+geom_jitter(aes(x=cond,y=RT),position=position_jitter(width=.1))
ggplot(priming.by.subject)+geom_jitter(aes(x=cond,y=RT),position=position_jitter(width=0))
ggplot(priming.by.subject)+geom_point(aes(x=cond,y=RT))
ggplot(priming.by.subject)+geom_point(aes(x=cond,y=RT),alpha=0.2)
ggplot(priming.by.subject)+geom_point(aes(x=cond,y=RT),alpha=0.5)

priming.by.subject <- aggregate(RT~prime*target*subj,data=priming, FUN=mean)
ggplot(priming.by.subject) + geom_point(aes(x=target, y=RT, color=prime),aplha=0.2)
ggplot(priming.by.subject) + geom_point(aes(x=target, y=RT, color=prime))


# ANOVA braucht pro Testperson gleich viele Datenpunkte. Wenn ein Proband weniger Punkte hat, kann ANOVA damit nichts anfangen.

ezStats(priming,dv=.(RT), wid=.(subj), within=.(prime,target))
ezANOVA(priming,dv=.(RT), wid=.(subj), within=.(prime,target))

ezANOVA(priming,dv=.(RT), wid=.(item), within=.(prime,target))

#PRüfung nach Target (erst Englisch(E), dann Deutsch(D))
ezANOVA(subset(priming, target=="E"), dv=.(RT), wid=.(subj), within=.(prime))
ezANOVA(subset(priming, target=="D"), dv=.(RT), wid=.(subj), within=.(prime))

ezANOVA(priming,dv=.(RT), wid=.(item), within=.(prime,target))
  # es gibt wieder die Fehlermeldung.

ezANOVA(priming,dv=.(RT),wid=.(item),within.(prime), within_full=.(prime,target))
ezANOVA(subset(priming,target=="D"),dv=.(RT),wid=.(item),within.(prime))
head(priming)
  #bei der Spalte COrrect ist alles TRUE (True=1, Flase=0)
priming$correct <- as.numeric(priming$correct)
ezANOVA(priming,dv=.(correct), wid=.(item), within=.(prime,target))
ezANOVA(subset(priming,target=="D"),dv=.(correct), wid=.(item), within=.(prime))
ezANOVA(subset(priming,target=="E"),dv=.(correct), wid=.(item), within=.(prime))


################
#### Sitzung ###
## 03.06.2014 ##
################

# Heute:
# lineare Regression

# gute Einfürung
# Fields (Discovering Statistics Using R), Kap 7 

# Ziel: Devianz (Unterschied zwischen den Punkten) minimieren

Ereignisse      Matrix/Maße      Fehler
y[i]        =     (model)x[i] + e[i]               (i = unabhängige Variable)
                                       (e = error, Fehler) 

Datenreihen können auch als Matritzen abgebildet werden

(OT: Möbius Band - ein Zweidimensionales Objekt, das aber 3D aussieht)

Linie/Gerade:
y= mx+b
y = b[o]   +   b[i]       x[i]
  Schnitt-    Anstieg  Unabhängige
  Punkt                Variable

Wie kann man herausfinden, ob eine Linie die "richtige Welt" auch wiedergibt?
--> mit dem Fehler!
    -> F-Test 
    -> r² = Varianztest (Varianz[Modell] = Varianz[Gesamt] - Varianz[Fehler])
        
        SS(ges) = ε([x^_ - x[i])²
        SS(res) = ε(mod - x[i])²
        SS(mod) = SS[ges] - SS[res]
      R² = SS[mod]/SS[ges]
        -> Prozent Varianz erklärt
        -> Maß dafür, wie viel Varianz in Y durch Varianz in X erklärt wird.
            je näher R² in Richtung 1 geht, desto idealer ist die Linie
            je näher R² in Richtung 0 geht, desto schlechter stellt die Linie die Werte dar (0 ist unmöglich!)
