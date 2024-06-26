####POBIERANIE I PORZ�DKOWANIE DANYCH

##Ustawianie lokalizacji pliku Excela
getwd()
setwd("C:/Users/Asus/Desktop/projekt statystyka")
##Biblioteki
library(readxl) #do funkcji read_exel
library(dplyr) #do funkcji mutate_at
library(e1071) #do parametr�w typu sko�no�ci itp.
library(scatterplot3d) #do wykresu punktowego
library(ggplot2) #do wykresu s�upkowego
##Pobieranie pliku Excel
tabl22_budzet_panstwa_2 <- read_excel("tabl22_budzet_panstwa_2.xlsx",  na = "0", col_names=FALSE)
View(tabl22_budzet_panstwa_2)
##Uporz�dkowywanie tabeli
tabela <- as.data.frame(tabl22_budzet_panstwa_2[-c(1:4),]) #zamienianie typu tabeli z tibble na ramk� danych i usuwanie niepotrzebnych wierszy
tabela <- tabela[-2,] #usuni�cie niepotrzbnego wiersza
rownames(tabela) <- tabela[,1] #ustawienie pierwszej kolumny na nazw� wierszy
colnames(tabela) <- tabela[1,] #ustawienie pierwszego wiersza na nazw� kolumn
tabela <- tabela[-1,-1] #usuni�cie zduplikowanego wiersza i kolumny
tabela <- tabela[ , colSums(is.na(tabela))==0] #usuni�cie kolumn o pustych warto�ciach
tabela[is.na(tabela) | tabela == "-"] <- 0 #zmienienie znaku - na warto�� 0
tabela[is.na(tabela) | tabela == "NA"] <- 0   #zmienienie wartosci NA - na warto�� 0
##Zmiana nazw kolumn 
names(tabela) #sprawdzenie, jak wygl�daj� przed zmian�
obecne_nazwy_kolumn <- colnames(tabela) # Pobranie obecnych nazw kolumn by usun�� "\r" i "\n" z nazw kolumn
nowe_nazwy_kolumn <- trimws(obecne_nazwy_kolumn, "both", "\r\n") # Usuni�cie znak�w specjalnych "\r" i "\n" z nazw kolumn
colnames(tabela) <- nowe_nazwy_kolumn # Przypisanie nowych nazw kolumn do ramki danych
names(tabela) #sprawdzenie, jak wygl�daj� po zmianie
##Zmiana typu danych na numeryczny
tabela <- mutate_at(tabela, vars(1:22), as.numeric)

####OBLICZANIE PARAMETR�W

#1. �REDNIA
�rednia <- mean(tabela$`Og�em`)
�rednia
#2. MEDIANA
mediana <- median(tabela$`�rodki w�asne `)
mediana
#3. NAJWI�KSZA WARTO��
najwi�ksza_warto�� <- max(tabela$`z dywidend i wp�y�w z zysku`)
najwi�ksza_warto��
#4. NAJMNIEJSZA WARTO��
najmniejsza_warto�� <- min(tabela$`z podatku dochodowego od os�b fizycznych`)
najmniejsza_warto��
#5. WARIANCJA
wariancja <- var(tabela$`z podatku od towar�w i us�ug (VAT)`)
wariancja
#6. ODCHYLENIE STANDARDOWE
odchylenie_standardowe <- sd(tabela$`z podatku akcyzowego`)
odchylenie_standardowe
#7. SUMA
suma <- sum(tabela$`z podatk�w po�rednich`)
suma
#8. LICZBA UNIKALNYCH
liczba_unikalnych <- length(unique(tabela$`Wynik bud�etu pa�stwa`))
liczba_unikalnych
#9. PIERWSZY KWARTYL
pierwszy_kwartyl <- quantile(tabela$Og�em, 0.25)
pierwszy_kwartyl
#10. SKO�NO��
skosnosc <- skewness(tabela$`subwencja og�lna dla jednostek samorz�du terytorialnego`)
skosnosc
#11. KURTOZA
kurtoza <- kurtosis(tabela$`z podatku akcyzowego`)
kurtoza
#12. SUMA KUMULTATYWNA
suma_kumulatywna <- cumsum(tabela$`wydatki bie��ce jednostek bud�etowych`)
suma_kumulatywna
#Ramka z parametrami
ramka_danych <- data.frame(�rednia, mediana, najwi�ksza_warto��, najmniejsza_warto��, wariancja, odchylenie_standardowe, suma, liczba_unikalnych, pierwszy_kwartyl, skosnosc, kurtoza)
####GRAFICZNA PREZENTACJA DANYCH


#HISTOGRAM
par(mar=c(5, 6, 4, 2) + 0.1) #ustawienie wi�kszego marginesu dla osi y
hist(tabela$`z podatk�w po�rednich`, main="Histogram - z podatk�w po�rednich", xlab = "Zakres warto�ci podatk�w po�rednich", ylab= "Ilo�� obserwacji w ka�dym z przedzia��w", col="darkblue", border="white") 
legend("topright", legend="Przedzia�y warto�ci", col="darkblue", lwd=10, cex=0.5)
#WYKRES PUDE�KOWY
boxplot(tabela$`z podatku od towar�w i us�ug (VAT)`, 
        main="Wykres pude�kowy - z podatku od towar�w i us�ug (VAT)", 
        col="darkgreen", 
        border="white",
        xlab="Okresy miesi�czne (2010-2022)",
        ylab="Warto�ci podatku od towar�w i us�ug")
legend("topright", legend="Wp�ywy z podatku od towar�w i us�ug(VAT)", col="darkgreen", lwd=10, cex=0.5)
#DYSTRYBUANTA
par(mar=c(5, 6, 4, 2) + 0.1) #ustawienie wi�kszego marginesu dla osi y
plot(ecdf(tabela$`z podatku od niekt�rych instytucji finansowych`), main="Dystrybuanta - z podatku od niekt�rych instytucji finansowych", xlab = "Warto�ci dla dystrybuanty", ylab= "Funkcja dystrybunaty", col="purple")
legend("bottomright", legend="warto�ci z kolumny:z podatku od niekt�rych instytucji finansowych", col="purple", lwd=10, cex=0.5)
#WYKRES KOLUMNOWY
barplot(tabela$`z podatku akcyzowego`, main="Wykres kolumnowy - z podatku akcyzowego", ylab="Warto�ci wp�yw�w z podatku akcyzowego", xlab="Miesi�ce na przedziale 2010-2022r.", col="orange")
legend("topright", legend="Wp�ywy z podatku akcyzowego", col="orange", lwd=10, cex=0.5)
#WYKRES KO�OWY
par(mar=c(6, 7, 7, 7) - 6)  #ustawienie marginesu
pie(tabela$`z wp�y�w z c�a`, main="Wykres ko�owy - z wp�yw�w z c�a", col=c("red", "blue", "green", "yellow"), cex=0.5)
legend("topright", legend=c("z wp�yw�w z c�a A", "z wp�yw�w z c�a B", "z wp�yw�w z c�a C", "z wp�yw�w z c�a D"), col=c("red", "blue", "green", "yellow"), lwd=10, cex=0.5)
#WYKRES PUNKTOWY
scatterplot3d(tabela$`obs�uga d�ugu Skarbu Pa�stwa`,tabela$`z podatku od towar�w i us�ug (VAT)`, tabela$`z podatku dochodowego od os�b prawnych`, xlab= "Obs�uga d�ugu Skarbu Pa�stwa", ylab = "Z podatku od towar�w i us�ug (VAT)", zlab = "Z podatku dochodowego od os�b prawnych", color="darkred")
legend("topright", legend="Wykres punktowy", col="darkred", lwd=10, cex=0.5)
#WYKRES S�UPKOWY
ggplot(data = tabela, aes(x = `�rodki z Unii Europejskiej i innych �r�de� niepodlegaj�ce zwrotowi`, y = `�rodki z Unii Europejskiej i innych �r�de� niepodlegaj�ce zwrotowi`, fill = `�rodki z Unii Europejskiej i innych �r�de� niepodlegaj�ce zwrotowi`)) +
  geom_bar(stat = "identity", width = 100) +
  labs(title = "Wykres s�upkowy", x = "Warto�ci", y = "Liczba wyst�pie�") +
  scale_fill_gradient(low = "red", high = "blue") +
  theme(axis.text.x = element_text(size = 10))


####WERYFIKACJA HIPOTEZ STATYSTYCZNYCH

#Hipoteza pierwsza
#Za��my, �e chcemy przetestowa� hipotez� zerow�, �e �rednia warto�� w pierwszej kolumnie jest r�wna 200000. Jest to przybli�ona liczba, z tej kt�r� wyliczyli�my w parametrach.
wynik_hip1 <- t.test(tabela[, 1], mu = 200000, alternative = "greater") # Wykonanie testu t
print(wynik_hip1) # Wy�wietlenie wynik�w testu

#Hipoteza druga
# Za��my, �e chcemy przetestowa� hipotez� zerow�, kt�ra m�wi, �e wariancja kolumny trzeciej: z podatku z towar�w i us�ug (VAT) jest taka sama co wariancja kolumny czwartej: z podatku akcyzowego, przy hipotezie alternatywnej m�wi�cej, �e s� one r�ne. Poziom istotno�ci wynosi 0,05. Skorzysta�am z funkcji var.test, kt�ra por�wna�a wariancj� tych dw�ch pr�bek.
wynik_hip2 <- var.test(tabela$`z podatku od towar�w i us�ug (VAT)`, tabela$`z podatku akcyzowego`, ratio=1)
print(wynik_hip2)


