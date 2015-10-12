with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; 

procedure SymulacjaFabrykiRowerow is
    MaksymalnaLiczbaOczekujacychZamowien: constant Integer := 2;
    MaksymalnaLiczbaRowerowWMagazynie: constant Integer := 2;
    CzasProdukcjiRoweru: constant Integer := 10;

    task type Fabryka is
        entry PrzyjmijZamowienieNaRower(NumerZamowienia: out Integer);
        entry WydajRower(NumerZamowienia: in Integer; RowerWydano: out Boolean);
    end Fabryka;

    task type KolejkaZamowien is
        entry DodajOczekujaceZamowienie(NumerZamowienia: in Integer);
        entry ZrealizujZamowienie(NumerZamowienia: out Integer);
    end KolejkaZamowien;

    task type LiniaProdukcyjna is
        entry UruchomLinieProdukcyjna;
    end LiniaProdukcyjna;

    task type Magazyn is
        entry PrzyjmijRower(NumerZamowienia: in Integer);
        entry WydajRower(NumerZamowienia: in Integer; RowerBylWMagazynie: out Boolean);
    end Magazyn;

    task type Klient is
        entry KupRower(NumerKlienta: in Integer; Cierpliwosc: Integer);
    end Klient;

    Fabryka1: Fabryka;
    KolejkaZamowien1: KolejkaZamowien;
    LiniaProdukcyjna1: LiniaProdukcyjna;
    Magazyn1: Magazyn;

    Klient1: Klient;
    Klient2: Klient;
    Klient3: Klient;
    Klient4: Klient;

    task body Fabryka is
        LiczbaPrzyjetychZamowien: Integer := 0;
        RowerWydano : Boolean := FALSE;
    begin
        Put_Line("Fabryka rowerow ruszyla!");
        loop
            select
                accept PrzyjmijZamowienieNaRower(NumerZamowienia: out Integer) do
                    select
                        KolejkaZamowien1.DodajOczekujaceZamowienie(LiczbaPrzyjetychZamowien + 1);
                        LiczbaPrzyjetychZamowien := LiczbaPrzyjetychZamowien + 1;
                        NumerZamowienia := LiczbaPrzyjetychZamowien;
                    else
                        NumerZamowienia := -1;
                        Put_Line("Nie mozna przyjac zamowienia nr" & Integer'Image(LiczbaPrzyjetychZamowien + 1) & ". (kolejka zamowien pelna)");
                    end select;
                end PrzyjmijZamowienieNaRower;
            or
                accept WydajRower(NumerZamowienia: in Integer; RowerWydano: out Boolean) do
                    Put_Line("Sprawdzanie magazynu... (nr zamowienia:" & Integer'Image(NumerZamowienia) & ")");
                    Magazyn1.WydajRower(NumerZamowienia, RowerWydano);
                    if RowerWydano then
                        Put_Line("Rower wydano klientowi! (nr zamowienia:" & Integer'Image(NumerZamowienia) & ")");
                    else
                        Put_Line("Rower nie jest jeszcze gotowy do odbioru. (nr zamowienia:" & Integer'Image(NumerZamowienia) & ")");
                    end if;
                end WydajRower;
            end select;
        end loop;
    end Fabryka;

    task body KolejkaZamowien is
        OczekujaceNumeryZamowien: array ( 1 .. MaksymalnaLiczbaOczekujacychZamowien ) of Integer;
        LiczbaOczekujacychZamowien: Integer := 0;
    begin
        loop
            select
                when LiczbaOczekujacychZamowien < MaksymalnaLiczbaOczekujacychZamowien =>
                    accept DodajOczekujaceZamowienie(NumerZamowienia: in Integer) do
                        OczekujaceNumeryZamowien(LiczbaOczekujacychZamowien + 1) := NumerZamowienia;
                        LiczbaOczekujacychZamowien := LiczbaOczekujacychZamowien + 1;
                        Put_Line("Zamowienie przyjeto i dodano do kolejki. (nr zamowienia:" & Integer'Image(NumerZamowienia) & ")");
                    end DodajOczekujaceZamowienie;
            or
                when LiczbaOczekujacychZamowien > 0 =>
                    accept ZrealizujZamowienie(NumerZamowienia: out Integer) do
                        NumerZamowienia := OczekujaceNumeryZamowien(LiczbaOczekujacychZamowien);
                        LiczbaOczekujacychZamowien := LiczbaOczekujacychZamowien - 1;
                        Put_Line("Zamowienie oddane do realizacji. (nr zamowienia:" & Integer'Image(NumerZamowienia) & ")");
                    end ZrealizujZamowienie;
            end select;
        end loop;
    end KolejkaZamowien;

    task body LiniaProdukcyjna is
        NumerRealizowanegoZamowienia: Integer;
    begin
        accept UruchomLinieProdukcyjna;
        Put_Line("Uruchomiono linie produkcyjna!");
        loop
            Put_Line("Linia produkcyjna jest w stanie oczekiwania...");
            KolejkaZamowien1.ZrealizujZamowienie(NumerRealizowanegoZamowienia);
            Put_Line("~~~~~~~~ Rower jest w trakcie produkcji! (nr zamowienia:" & Integer'Image(NumerRealizowanegoZamowienia) & ") ~~~~~~~~");
            delay Duration(CzasProdukcjiRoweru);
            Put_Line("Rower wyprodukowano! Przekazywanie do magazynu... (nr zamowienia:" & Integer'Image(NumerRealizowanegoZamowienia) & ")");
            Magazyn1.PrzyjmijRower(NumerRealizowanegoZamowienia);
        end loop;
    end LiniaProdukcyjna;

    task body Magazyn is
        NumeryZamowienZmagazynowanychRowerow: array ( 1 .. MaksymalnaLiczbaRowerowWMagazynie ) of Integer;
        LiczbaZmagazynowanychRowerow: Integer := 0;
    begin
        loop
            select
                when LiczbaZmagazynowanychRowerow < MaksymalnaLiczbaRowerowWMagazynie =>
                    accept PrzyjmijRower(NumerZamowienia: in Integer) do
                        Put_Line("Rower przyjeto do magazynu. (nr zamowienia:" & Integer'Image(NumerZamowienia) & ")");
                        NumeryZamowienZmagazynowanychRowerow(LiczbaZmagazynowanychRowerow + 1) := NumerZamowienia;
                        LiczbaZmagazynowanychRowerow := LiczbaZmagazynowanychRowerow + 1;
                    end PrzyjmijRower;
            or
                accept WydajRower(NumerZamowienia: in Integer; RowerBylWMagazynie: out Boolean) do
                    Put_Line("Przeszukiwanie magazynu... (nr zamowienia:" & Integer'Image(NumerZamowienia) & ")");
                    RowerBylWMagazynie := FALSE;
                    for I in 1 .. MaksymalnaLiczbaRowerowWMagazynie loop
                        if NumeryZamowienZmagazynowanychRowerow(I) = NumerZamowienia then
                            NumeryZamowienZmagazynowanychRowerow(I) := 0;
                            RowerBylWMagazynie := TRUE;
                            LiczbaZmagazynowanychRowerow := LiczbaZmagazynowanychRowerow - 1;
                            Put_Line("Rower wydano z magazynu. (nr zamowienia:" & Integer'Image(NumerZamowienia) & ")");
                            return;
                        end if;
                    end loop;
                    Put_Line("Roweru nie bylo w magazynie. (nr zamowienia:" & Integer'Image(NumerZamowienia) & ")");
                end WydajRower;
            end select;
        end loop;
    end Magazyn;

    task body Klient is
        MojNumerKlienta: Integer := 0;
        MojaCierpliwosc: Integer := 0;
        MojNumerZamowienia: Integer := 0;
        RowerWydano: Boolean := FALSE;
    begin
        accept KupRower(NumerKlienta : Integer; Cierpliwosc: Integer) do
            MojNumerKlienta := NumerKlienta;
            MojaCierpliwosc := Cierpliwosc;
        end;
        Put_Line("******** Klient" & Integer'Image(MojNumerKlienta) & " sklada zamowienie na rower! ********");
        Fabryka1.PrzyjmijZamowienieNaRower(MojNumerZamowienia);
        if MojNumerZamowienia = -1 then
            Put_Line("######## Klient" & Integer'Image(MojNumerKlienta) & " - zamowienie odrzucone. ########");
        else
            Put_Line("Klient" & Integer'Image(MojNumerKlienta) & " zlozyl zamowienie. (nr zamowienia:" & Integer'Image(MojNumerZamowienia) & ")");
            while not RowerWydano loop
                delay Duration(MojaCierpliwosc);
                Put_Line("Klient" & Integer'Image(MojNumerKlienta) & " chce odebrac rower... (nr zamowienia:" & Integer'Image(MojNumerZamowienia) & ")");
                Fabryka1.WydajRower(MojNumerZamowienia, RowerWydano);
                if RowerWydano then
                    Put_Line("```````` Klient" & Integer'Image(MojNumerKlienta) & " odebral swoj rower! (nr zamowienia:" & Integer'Image(MojNumerZamowienia) & ") ````````");
                end if;
            end loop;
        end if;
    end Klient;

begin
    LiniaProdukcyjna1.UruchomLinieProdukcyjna;
    Klient1.KupRower(1, 11);
    Klient2.KupRower(2, 15);
    Klient3.KupRower(3, 22);
    Klient4.KupRower(4, 25);
end SymulacjaFabrykiRowerow;
