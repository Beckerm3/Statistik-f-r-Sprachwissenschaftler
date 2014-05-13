##################################
übliche Alpha () ist 0,05
--> bei zweisetigem Test aber 0,025

Mit dem "Shapiro-Wilk-Test" wird die Normalverteilung überprüft (normaerweise kann davon ausgegangen werden, dass Werte normalverteilt sind)
  mit R kann es mittels shapiro.test() berechnet werden
  W-Wert = Prüfgröße
  
der T-Test wird mit t.test(Argument1, Argument2) berechnet
T-Wert wird unabhängig von der Null-Hypothese berechnet
F-Test testet, ob Daten homogen sind 
  wird in R über var.test() berechnet
  F = Var1/Var2
  zeigt an, ob sich etwas signifikant von 1 unterscheidet
  paired=TRUE (d.h. Untersuchung beruht auf 2 Erhebungen - die sollen untersucht werden.)
  
P-Test kleiner als 0,05 --> Valide (passt)
Datensatz[Zeile, Spalte]
~ bedeutet "Funktion"
| bedeutet "oder"
df = Freiheitsgrade (=)


readme --> hat viele Links, die gerne angeschaut werden möchten...
##################################

# aus Folien 09:


aphasiker <- read.csv2("Data/aphasiker.csv", header=T)
head(aphasiker)
qplot(x=Lex_Dec, 
      data=na.omit(aphasiker), 
      geom="density", 
      fill=Aphasie, alpha=(0.3))
# gibt noch nen Error :(

broca.lex.dec <- aphasiker[aphasiker%Aphasie == "B", "Lex_Dec"]

t.test(broca.lex.dec,wernicke.lex.dec, var.equal=TRUE,alternative="less")


kurs <- read.table("Data/body_dim_long.tab",header = T)
klinisch <- subset(kurs, major=="M.A..Klinische.Linguistik")
speech <- subset(kurs, major=="M.A..Speech.Science")
var.test(klinisch$age,speech$age)
speech
var.test(klinisch$height,speech$height)

