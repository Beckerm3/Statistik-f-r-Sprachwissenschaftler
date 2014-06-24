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

################
#### Sitzung ###
## 10.06.2014 ##
################
colnames(women)
?women
women[,2]

# Gewicht als Funktion von Größe
lm(weight ~ height, women)
summary(lm(weight ~ height, women))

# Größe als Funktion von Gewicht
lm(height ~ weight, women)
summary(lm(height ~ weight, women))

library(ggplot2)
ggplot(women, aes(x=height, y=weight)) + geom_point() + geom_smooth(method="lm")

# t-Wert ist "Estimate / Standardfehler"
# Bsp. für height ~ weight:
    0.287249/0.007588

ggplot(body, aes(x=sex, y=weight)) + geom_point()

summary(lm(weight ~ sex, body))

# ANOVA Zusammenfassung
summary(aov(weight ~ sex, body))
  # -> ANOVA ist ein Sonderfall der Regression

factor(body$sex, levels=c("m", "f"))
body$sex <- factor(body$sex, levels=c("m", "f"))
summary (lm(weight~sex, body))

summary (lm(weight~height + age, body))

ggplot(body, aes(x=height, y=weight, color=age)) + geom_point() + geom_smooth()
ggplot(body, aes(x=height, y=weight, color=sex)) + geom_point() + geom_smooth()

summary(lm(weight ~ height * sex, data = body))


Man kann durch R-Eigene "Zeichenfunktionen" Annahmen testen:
lm(weight ~ height, women)
plot(lm(weight ~ height, women))
 
################
#### Sitzung ###
## 16.06.2014 ##
################

2 Subsets kann man gleichzeitig erstellen, wenn man sie in der Subset-Umgebung mit einem | trennt:
  subset(A | B)


--> Wie berichtet man einen T- oder f-Wert? 
Was ist die korrekte Schreibweise?!
  http://www.statistik-tutorial.de/forum/ftopic4185.html
  
  
Es wird keine Formel abgefragt (man soll grob wissen, wie die Formel aussieht, das reicht)
t-test = Abweichung(0)/ Standardfehler



################
#### Sitzung ###
## 17.06.2014 ##
################

Formel von Varianz:
  (Eta (x(i)-x^_)²) / (n-1)
    eigentlich ein Durchschnitt der Abweichungen

andere Schreibweise:
  Eta ((x[i]-x^_)*(x[i]-x^_)) / (n-1)

Vergleich zweier Variablen (Kovariation)
  Eta ((x[i]-x^_)*(y[i]-y^_)) / (n-1)
  Die Summe kann auch negativ werden!
  -> wenn die Varianzen immer in die gleiche Richtung gehen, kommt was positives dabei raus.
  -> sind die Varianzen von y immer umgekehrt von x sind, kommt was nevatives raus.
  
vergleich zweier unterschiedlichen Datensätze (mit untersch. Einheiten):
  Vergleich der Stabw.
  -> der Wert kann nie größer als 1 werden

Pearson Product-Moment Correlation
  -> 
  
  
  Wann ist ein Wert (welcher Wert?) groß oder klein?
  (Cohen)
  > 0,1 -> klein
  > 0,3 -> mittel
  > 0,5 -> groß
  wird in ezANOVA angegeben als ges (Generalized Eta Squared)
          --> Maß für die Effektgröße
          in EEG Experimenten gibts oft Werte ca. 0,001
            --> sehr kleine Effektgröße
      Effektwerte sind ein zuverlässiges Maß für p-Werte.
        -> sie sind besser vergleichbar als p-Werte
      wir wollen eigentlich möglichst größere Effektwerte

Fisher-Transformation
  = wird benutzt, um Standartwerte (Z-Werte) zu standartisieren
  Z[r] = 1/z * ln ((1+r)/(1.r))

Spearman
  -> berechnet Korrelation im Bezug auf den Rang (z.B. "wächst das 4.x so an wie das 4. Y?")
  r[s]
  Zeichen/Koefizient:  p (Rho!)


kurs <- read.table("Beckerm3/body_dim_long.tab", header = T)


  # cor=correlation
cor(kurs$height, kurs$weight, method="pearson")

cor(kurs$height, kurs$weight, method="pearson")**2

cor(kurs$height, kurs$weight, method="spearman")
# es ist Zufall, dass Pearson*2 zu einem -ähnlichen Ergebnis führt wie Spearman.

library(ggplot2)
qplot(height, weight, data=kurs) + geom_smooth(method="lm")

  # COR-TEST:
    # gibt auch Koeffizienzinterval wieder
cor.test(kurs$height, kurs$weight, method="pearson")
cor.test(kurs$height, kurs$weight, method="spearman")
  # spearman klappt nicht, weil es mind 2 Personen gibt, die die gleiche Größe oder Masse haben.
    # daher ist der P-Wert nicht vertrauenswürdig.
    # Phillip würde eher das Konfidenzinterval angeben statt des P-Werts

cor.test(kurs$height, kurs$weight, method="kendall")
  Zeichen/Koeffizient: Tau