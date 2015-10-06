-- Szkielet programu do zadania z języków programowania
-- Studenci powinni przemianować zadania producentów, konsumentów i bufora
-- Powinni następnie zmienić je tak, by odpowiadały ich własnym zadaniom
-- Powinni także uzupełnić kod o brakujące konstrucje
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; 
with Ada.Numerics.Discrete_Random;


procedure Symulacja is
   Liczba_Wyrobow: constant Integer := 5;
   Liczba_Zestawow: constant Integer := 3;
   Liczba_Konsumentow: constant Integer := 2;
   subtype Zakres_Czasu_Produkcji is Integer range 3 .. 6;
   subtype Zakres_Czasu_Konsumpcji is Integer range 4 .. 8;
   subtype Typ_Wyrobow is Integer range 1 .. Liczba_Wyrobow;
   subtype Typ_Zestawow is Integer range 1 .. Liczba_Zestawow;
   subtype Typ_Konsumenta is Integer range 1 .. Liczba_Konsumentow;
   Nazwa_Wyrobu: constant array (Typ_Wyrobow) of String(1 .. 6)
     := ("Wyrob1", "Wyrob2", "Wyrob3", "Wyrob4", "Wyrob5");
   Nazwa_Zestawu: constant array (Typ_Zestawow) of String(1 .. 7)
     := ("Zestaw1", "Zestaw2", "Zestaw3");
   package Losowa_Konsumpcja is new
     Ada.Numerics.Discrete_Random(Zakres_Czasu_Konsumpcji);
   package Losowy_Zestaw is new
     Ada.Numerics.Discrete_Random(Typ_Zestawow);
   type My_Str is new String(1 ..256);

   -- Producent produkuje określony wyrób
   task type Producent is
      -- Nadaj Producentowi tożsamość, czyli rodzaj wyrobu
      entry Zacznij(Wyrob: in Typ_Wyrobow; Czas_Produkcji: in Integer);
   end Producent;

   -- Konsument pobiera z Bufora dowolny zestaw składający się z wyrobów
   task type Konsument is
      -- Nadaj Konsumentowi tożsamość
      entry Zacznij(Numer_Konsumenta: in Typ_Konsumenta;
		    Czas_Konsumpcji: in Integer);
   end Konsument;

   -- W Buforze następuje składanie wyrobów w zestawy
   task type Bufor is
      -- Przyjmij wyrób do magazynu, o ile jest miejsce
      entry Przyjmij(Wyrob: in Typ_Wyrobow; Numer: in Integer);
      -- Wydaj zestaw z magazynu, o ile są części (wyroby)
      entry Wydaj(Zestaw: in Typ_Zestawow; Numer: out Integer);
   end Bufor;

   P: array ( 1 .. Liczba_Wyrobow ) of Producent;
   K: array ( 1 .. Liczba_Konsumentow ) of Konsument;
   B: Bufor;

   task body Producent is
      package Losowa_Produkcja is new
	Ada.Numerics.Discrete_Random(Zakres_Czasu_Produkcji);
      G: Losowa_Produkcja.Generator;	--  generator liczb losowych
      Nr_Typu_Wyrobu: Integer;
      Numer_Wyrobu: Integer;
      Produkcja: Integer;
   begin
      accept Zacznij(Wyrob: in Typ_Wyrobow; Czas_Produkcji: in Integer) do
	 Losowa_Produkcja.Reset(G);	--  zacznij generator liczb losowych
	 Numer_Wyrobu := 1;
	 Nr_Typu_Wyrobu := Wyrob;
	 Produkcja := Czas_Produkcji;
      end Zacznij;
      Put_Line("Zaczęto producenta wyrobu " & Nazwa_Wyrobu(Nr_Typu_Wyrobu));
      loop
	 delay Duration(Losowa_Produkcja.Random(G)); --  symuluj produkcję
	 Put_Line("Wyprodukowano wyrób " & Nazwa_Wyrobu(Nr_Typu_Wyrobu)
		    & " numer "  & Integer'Image(Numer_Wyrobu));
	 -- Wstaw do magazynu
	 B.Przyjmij(Nr_Typu_Wyrobu, Numer_Wyrobu);
	 Numer_Wyrobu := Numer_Wyrobu + 1;
      end loop;
   end Producent;

   task body Konsument is
      G: Losowa_Konsumpcja.Generator;	--  generator liczb losowych (czas)
      G2: Losowy_Zestaw.Generator;	--  też (zestawy)
      Nr_Konsumenta: Typ_Konsumenta;
      Numer_Zestawu: Integer;
      Konsumpcja: Integer;
      Rodzaj_Zestawu: Integer;
      Nazwa_Konsumenta: constant array (1 .. Liczba_Konsumentow)
	of String(1 .. 10)
	:= ("Konsument1", "Konsument2");
   begin
      accept Zacznij(Numer_Konsumenta: in Typ_Konsumenta;
		     Czas_Konsumpcji: in Integer) do
	 Losowa_Konsumpcja.Reset(G);	--  ustaw generator
	 Losowy_Zestaw.Reset(G2);	--  też
	 Nr_Konsumenta := Numer_Konsumenta;
	 Konsumpcja := Czas_Konsumpcji;
      end Zacznij;
      Put_Line("Zaczęto konsumenta " & Nazwa_Konsumenta(Nr_Konsumenta));
      loop
	 delay Duration(Losowa_Konsumpcja.Random(G)); --  symuluj konsumpcję
	 Rodzaj_Zestawu := Losowy_Zestaw.Random(G2);
	 -- pobierz zestaw do konsumpcji
	 B.Wydaj(Rodzaj_Zestawu, Numer_Zestawu);
	 Put_Line(Nazwa_Konsumenta(Nr_Konsumenta) & ": pobrano zestaw " &
		    Nazwa_Zestawu(Rodzaj_Zestawu) & " numer " &
		    Integer'Image(Numer_Zestawu));
      end loop;
   end Konsument;

   task body Bufor is
      Pojemnosc_Magazynu: constant Integer := 30;
      Magazyn: array (Typ_Wyrobow) of Integer
	:= (0, 0, 0, 0, 0);
      Sklad_Zestawu: array(Typ_Zestawow, Typ_Wyrobow) of Integer
	:= ((2, 1, 2, 1, 2),
	    (2, 2, 0, 1, 0),
	    (1, 1, 2, 0, 1));
      Numer_Zestawu: array(Typ_Zestawow) of Integer
	:= (1, 1, 1);
      W_Magazynie: Integer := 0;

      function Mozna_Przyjac(Wyrob: Typ_Wyrobow) return Boolean is
	 Wolne: Integer;
      begin
	 if W_Magazynie >= Pojemnosc_Magazynu then
	    return False;
	 else
	    Wolne := Pojemnosc_Magazynu - W_Magazynie;
	    for Z in Typ_Zestawow loop
	      for W in Typ_Wyrobow loop
		if W /= Wyrob then
		 if Magazyn(W) + Wolne - 1 < Sklad_Zestawu(Z, W) then
		    return False;
		 end if;
		end if;
	      end loop;
	    end loop;
	    return True;
	 end if;
      end Mozna_Przyjac;

      function Mozna_Wydac(Zestaw: Typ_Zestawow) return Boolean is
      begin
	 for W in Typ_Wyrobow loop
	    if Magazyn(W) < Sklad_Zestawu(Zestaw, W) then
	       return False;
	    end if;
	 end loop;
	 return True;
      end Mozna_Wydac;

      procedure Sklad_Magazynu is
      begin
	 for W in Typ_Wyrobow loop
	    Put_Line("Skład magazynu: " & Integer'Image(Magazyn(W)) & " "
		       & Nazwa_Wyrobu(W));
	 end loop;
      end Sklad_Magazynu;

   begin
      Put_Line("Zaczęto Bufor");
      loop
	 accept Przyjmij(Wyrob: in Typ_Wyrobow; Numer: in Integer) do
	   if Mozna_Przyjac(Wyrob) then
	      Put_Line("Przyjęto wyrób " & Nazwa_Wyrobu(Wyrob) & " nr " &
		Integer'Image(Numer));
	      Magazyn(Wyrob) := Magazyn(Wyrob) + 1;
	      W_Magazynie := W_Magazynie + 1;
  	   else
	      Put_Line("Odrzucono wyrób " & Nazwa_Wyrobu(Wyrob) & " nr " &
		    Integer'Image(Numer));
	   end if;
	 end Przyjmij;
	 Sklad_Magazynu;
	 accept Wydaj(Zestaw: in Typ_Zestawow; Numer: out Integer) do
	    if Mozna_Wydac(Zestaw) then
	       Put_Line("Wydano zestaw " & Nazwa_Zestawu(Zestaw) & " nr " &
			  Integer'Image(Numer_Zestawu(Zestaw)));
	       for W in Typ_Wyrobow loop
		  Magazyn(W) := Magazyn(W) - Sklad_Zestawu(Zestaw, W);
		  W_Magazynie := W_Magazynie - Sklad_Zestawu(Zestaw, W);
	       end loop;
	       Numer := Numer_Zestawu(Zestaw);
	       Numer_Zestawu(Zestaw) := Numer_Zestawu(Zestaw) + 1;
	    else
	       Put_Line("Brak części dla zestawu " & Nazwa_Zestawu(Zestaw));
	       Numer := 0;
	    end if;
	 end Wydaj;
	 Sklad_Magazynu;
      end loop;
   end Bufor;
   
begin
   for I in 1 .. Liczba_Wyrobow loop
      P(I).Zacznij(I, 10);
   end loop;
   Put_Line("1");
   for J in 1 .. Liczba_Konsumentow loop
      K(J).Zacznij(J,12);
   end loop;
   Put_Line("2");
end Symulacja;
--- http://www.adahome.com/rm95/rm9x-A-05-02.html


