> Jakub Trzebiatowski
> Informatyka r.14/15 gr.6
> Indeks: 155215
> 4.10.2015

# Bazy danych – projekt

## Część 1 – założenia

### Temat projektu

Stypendialna baza danych zawiera dane o studentach, dochodach w ich rodzinach i wysokości kolejnych 
wypłat miesięcznych.

### Treść projektu

Projekt stypendialnej bazy danych ma za zadanie usprawnić działanie Wydziałowej
Komisji Stypendialnej. Baza będzie zawierała dane osobowe studentów, którzy
złożyli wnioski o stypendium socjalne, informacje o przychodach członków ich
rodzin oraz wysyokości kolejnych wypłat miesięcznych.

### Opis wymagań

#### Zlecający

Zleceniodawcą projektu jest dziekan Wydziału ETI Politechniki Gdańskiej.

#### Przedmiot zlecenia

Przedmiotem zlecenia jest usprawnienie działania Wydziałowej Komisji Stypendialnej. Studenci na początku roku akademickiego składają wnioski o stypendium socjalne. Próg dochódu uprawniającego do otrzymania stypendium socjalnego jest ustalony z góry (np. w roku akademickim 2014/15 próg wynosi 670 zł netto na miesiąc na osobę). Wnioski studentów, których rodzinny dochód jest większy od progu są natychmiast odrzucane. Z góry ustalona jest również minimalna i maksymalna wartość stypendium socjalnego (odpowiednio 100 zł i 700 zł w roku 2014/15). Następnie co miesiąc wyznaczana jest wartość stypendium dla każdego studenta z osobna. Studenci mają prawo składać oświadczenie o zmianie okoliczności mających wpływ na przyznane prawo do stypendium socjalnego, więc kwota która jest przyznawana konkretnemu studentowi może zmieniać. Kwoty te są archiwizowane w bazie danych.

#### Główne scenariusze

1. Studenci składają wnioski o stypendium socjalne
    1. Wnioski są przyjmowane, gdy dochód rodzinny jest mniejszy lub równy od ustalonego progu i odrzucane w przeciwnym wypadku.

2. Comiesięczna wypłata stypendiów
    1. Wyznaczenie kwoty stypendium dla danego studenta w danym miesiącu
        1. Na podstawie przychodu netto na miesiąc na osobę (p), progu (P), minimalnej wartości stypendium (m) oraz maksymalnej wartości stypendium (M) określa się kwotę stypendium (K) dla danego studenta w danym miesiącu następującym wzorem: K = m + (p/P)(M - m)
    2. Przekazanie pieniędzy
        1. Jeśli student posiada rachunek bankowy i podał jego numer we wniosku, stypendium przesyłane jest przelewem elektronicznym.
        2. W przeciwnym przypadku, student musi odebrać stypendium osobiście.

3. Zmiana okoliczności mających wpływ na przyznane prawo do stypendium socjalnego
    1. Studenci mają prawo składać oświadczenie o zmianie okoliczności mających wpływ na przyznane prawo do stypendium socjalnego.
        1. Oznacza to, że wartość przychodu netto na miesiąc na osobę może się zmieniać w czasie i należy to uwzględnić w algorytmie obliczania kwoty wypłaty. (patrz 2.1.1).

#### Problemy rozwiązywane przez system

Największym problemem Wydziałowej Komisji Stypendialnej jest liczność studentów wnoszących o stypendium. System ma usprawnić zarządzanie wnioskami oraz co miesiąc automatycznie wyliczać kwoty stypendium dla każdego studenta z osobna. Oczekuje się również, że korekta danych o rodzinnych przychodach studenta, w przypadku złożenia przez niego oświadczenia o zmianie okoliczności mających wpływ na przyznane prawo do stypendium socjalnego, będzie prosta oraz bezproblemowa.
