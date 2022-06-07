--------------------------------------------------------------
--TWORZENIE TABEL i OGRANICZENIA
--------------------------------------------------------------

CREATE TABLE druzyny (
    nazwa           VARCHAR2(40 CHAR) NOT NULL,
    miasto          VARCHAR2(20) NOT NULL,
    rok_zalozenia   NUMBER(4) NOT NULL,
    stadion_nazwa   VARCHAR2(50) NOT NULL,
    stadion_miasto  VARCHAR2(20) NOT NULL
);
/

ALTER TABLE druzyny ADD CONSTRAINT druzyny_pk PRIMARY KEY ( nazwa );
/

CREATE TABLE druzyny_w_sezonie (
    id                        NUMBER(4) NOT NULL,
    punkty                    NUMBER(3) NOT NULL,
    liczba_bramek_zdobytych   NUMBER(3) NOT NULL,
    liczba_bramek_straconych  NUMBER(3) NOT NULL,
    nazwa_druzyny             VARCHAR2(40 CHAR) NOT NULL,
    sezon                     VARCHAR2(20) NOT NULL
);
/

ALTER TABLE druzyny_w_sezonie ADD CONSTRAINT druzyny_w_sezonie_pk PRIMARY KEY ( id );
/
ALTER TABLE druzyny_w_sezonie ADD CONSTRAINT druzyny_w_sezonie__un UNIQUE ( nazwa_druzyny,
                                                                            sezon );
/
CREATE TABLE kolejki (
    numer                     NUMBER(2) NOT NULL,
    data_rozpoczecia_kolejki  DATE NOT NULL,
    data_zakonczenia_kolejki  DATE NOT NULL,
    sezon                     VARCHAR2(20) NOT NULL
);

ALTER TABLE kolejki ADD CONSTRAINT kolejki_pk PRIMARY KEY ( numer,
                                                            sezon );

CREATE TABLE mecze (
    data             DATE NOT NULL,
    frekwencja       NUMBER(6) NOT NULL,
    bramki_gosp      NUMBER(2) NOT NULL,
    bramki_gosc      NUMBER(2) NOT NULL,
    id_sedziego      NUMBER(4) NOT NULL,
    nazwa_stadionu   VARCHAR2(50) NOT NULL,
    miasto_stadionu  VARCHAR2(20) NOT NULL,
    nr_kolejki       NUMBER(2) NOT NULL,
    sezon_kolejki    VARCHAR2(20) NOT NULL,
    id_gosp          NUMBER(4) NOT NULL,
    id_gosc          NUMBER(4) NOT NULL
);

ALTER TABLE mecze
    ADD CONSTRAINT mecze_pk PRIMARY KEY ( id_gosc,
                                          id_gosp,
                                          data );

CREATE TABLE okresy_trenowania (
    od_kiedy    DATE NOT NULL,
    do_kiedy    DATE NOT NULL,
    id_trenera  NUMBER(4) NOT NULL,
    id_druzyny  NUMBER(4) NOT NULL
);

ALTER TABLE okresy_trenowania ADD CONSTRAINT okresy_trenowania_pk PRIMARY KEY ( id_trenera,
                                                                                id_druzyny );

CREATE TABLE sedziowie (
    id_sedziego              NUMBER(4) NOT NULL,
    imie                     VARCHAR2(20) NOT NULL,
    nazwisko                 VARCHAR2(30) NOT NULL,
    data_urodzenia           DATE NOT NULL,
    data_uzyskania_licencji  DATE NOT NULL
);

ALTER TABLE sedziowie ADD CONSTRAINT sedziowie_pk PRIMARY KEY ( id_sedziego );

CREATE TABLE sezony (
    nazwa_sezonu             VARCHAR2(20) NOT NULL,
    data_rozpoczecia_sezonu  DATE NOT NULL,
    data_zakonczenia_sezonu  DATE NOT NULL,
    liczba_druzyn            NUMBER(2) NOT NULL
);

ALTER TABLE sezony ADD CONSTRAINT sezony_pk PRIMARY KEY ( nazwa_sezonu );

ALTER TABLE sezony ADD CONSTRAINT sezony__un UNIQUE ( data_rozpoczecia_sezonu,
                                                      data_zakonczenia_sezonu );

CREATE TABLE stadiony (
    nazwa                     VARCHAR2(50) NOT NULL,
    miasto                    VARCHAR2(20) NOT NULL,
    pojemnosc                 NUMBER(6) NOT NULL,
    data_wybudowania          DATE NOT NULL,
    data_ostatniej_renowacji  DATE
);

ALTER TABLE stadiony ADD CONSTRAINT stadiony_pk PRIMARY KEY ( nazwa,
                                                              miasto );

CREATE TABLE trenerzy (
    id_trenera      NUMBER(4) NOT NULL,
    imie            VARCHAR2(20) NOT NULL,
    nazwisko        VARCHAR2(30) NOT NULL,
    data_urodzenia  DATE NOT NULL
);

ALTER TABLE trenerzy ADD CONSTRAINT trenerzy_pk PRIMARY KEY ( id_trenera );

CREATE TABLE wydarzenia (
    id_wydarzenia  NUMBER(3) NOT NULL,
    minuta         NUMBER(2) NOT NULL,
    akcja          VARCHAR2(5) NOT NULL,
    id_zawodnika   NUMBER(4) NOT NULL,
    data_meczu     DATE NOT NULL,
    id_gosp        NUMBER(4) NOT NULL,
    id_gosc        NUMBER(4) NOT NULL,
    id_druz_zaw    NUMBER(4) NOT NULL
);

ALTER TABLE wydarzenia ADD CONSTRAINT wydarzenia_pk PRIMARY KEY ( id_wydarzenia );

CREATE TABLE zawodnicy (
    id_zawodnika    NUMBER(4) NOT NULL,
    imie            VARCHAR2(20) NOT NULL,
    nazwisko        VARCHAR2(30) NOT NULL,
    data_urodzenia  DATE NOT NULL,
    pozycja         VARCHAR2(3) NOT NULL
);

ALTER TABLE zawodnicy ADD CONSTRAINT zawodnicy_pk PRIMARY KEY ( id_zawodnika );

CREATE TABLE zawodnicy_w_sezonie (
    liczba_bramek             NUMBER(2) NOT NULL,
    liczba_zoltych_kartek     NUMBER(2) NOT NULL,
    liczba_czerwonych_kartek  NUMBER(2) NOT NULL,
    id_zawodnika              NUMBER(4) NOT NULL,
    od_kiedy                  DATE NOT NULL,
    do_kiedy                  DATE NOT NULL,
    id_druzyny                NUMBER(4) NOT NULL
);

ALTER TABLE zawodnicy_w_sezonie ADD CONSTRAINT zawodnicy_w_sezonie_pk PRIMARY KEY ( id_zawodnika,
                                                                                    id_druzyny );

ALTER TABLE druzyny
    ADD CONSTRAINT druzyny_stadiony_fk FOREIGN KEY ( stadion_nazwa,
                                                     stadion_miasto )
        REFERENCES stadiony ( nazwa,
                              miasto );

ALTER TABLE druzyny_w_sezonie
    ADD CONSTRAINT druzyny_w_sezonie_druzyny_fk FOREIGN KEY ( nazwa_druzyny )
        REFERENCES druzyny ( nazwa );

ALTER TABLE druzyny_w_sezonie
    ADD CONSTRAINT druzyny_w_sezonie_sezony_fk FOREIGN KEY ( sezon )
        REFERENCES sezony ( nazwa_sezonu );

ALTER TABLE kolejki
    ADD CONSTRAINT kolejki_sezony_fk FOREIGN KEY ( sezon )
        REFERENCES sezony ( nazwa_sezonu );

ALTER TABLE mecze
    ADD CONSTRAINT mecze_druzyny_w_sezonie_fk FOREIGN KEY ( id_gosc )
        REFERENCES druzyny_w_sezonie ( id );

ALTER TABLE mecze
    ADD CONSTRAINT mecze_druzyny_w_sezonie_fkv2 FOREIGN KEY ( id_gosp )
        REFERENCES druzyny_w_sezonie ( id );

ALTER TABLE mecze
    ADD CONSTRAINT mecze_kolejki_fk FOREIGN KEY ( nr_kolejki,
                                                  sezon_kolejki )
        REFERENCES kolejki ( numer,
                             sezon );

ALTER TABLE mecze
    ADD CONSTRAINT mecze_sedziowie_fk FOREIGN KEY ( id_sedziego )
        REFERENCES sedziowie ( id_sedziego );

ALTER TABLE mecze
    ADD CONSTRAINT mecze_stadiony_fk FOREIGN KEY ( nazwa_stadionu,
                                                   miasto_stadionu )
        REFERENCES stadiony ( nazwa,
                              miasto );

ALTER TABLE okresy_trenowania
    ADD CONSTRAINT okr_tren_dru_w_sez_fk FOREIGN KEY ( id_druzyny )
        REFERENCES druzyny_w_sezonie ( id );

ALTER TABLE okresy_trenowania
    ADD CONSTRAINT okresy_trenowania_trenerzy_fk FOREIGN KEY ( id_trenera )
        REFERENCES trenerzy ( id_trenera );

ALTER TABLE wydarzenia
    ADD CONSTRAINT wydarzenia_mecze_fk FOREIGN KEY ( id_gosc,
                                                     id_gosp,
                                                     data_meczu )
        REFERENCES mecze ( id_gosc,
                           id_gosp,
                           data );

ALTER TABLE wydarzenia
    ADD CONSTRAINT wydarzenia_zaw_w_sez_fk FOREIGN KEY ( id_zawodnika,
                                                         id_druz_zaw )
        REFERENCES zawodnicy_w_sezonie ( id_zawodnika,
                                         id_druzyny );

ALTER TABLE zawodnicy_w_sezonie
    ADD CONSTRAINT zaw_w_sez_dru_w_sez_fk FOREIGN KEY ( id_druzyny )
        REFERENCES druzyny_w_sezonie ( id );

ALTER TABLE zawodnicy_w_sezonie
    ADD CONSTRAINT zaw_w_sez_zaw_fk FOREIGN KEY ( id_zawodnika )
        REFERENCES zawodnicy ( id_zawodnika );

ALTER TABLE zawodnicy
    ADD CONSTRAINT valid_position CHECK (pozycja IN ('BRA', 'OBR', 'POM', 'NAP'));
    
ALTER TABLE stadiony
    ADD CONSTRAINT valid_capacity CHECK (pojemnosc > 0);
    
ALTER TABLE stadiony
    ADD CONSTRAINT valid_date_of_renovation CHECK (data_ostatniej_renowacji > data_wybudowania);

ALTER TABLE wydarzenia
    ADD CONSTRAINT valid_time_wydarzenia CHECK ( minuta > 0 AND minuta <= 90 );
    
ALTER TABLE wydarzenia
    ADD CONSTRAINT valid_action CHECK (akcja IN ('GOL', 'ZK', 'CK'));
    
ALTER TABLE sedziowie
    ADD CONSTRAINT valid_date_of_license CHECK ( EXTRACT(YEAR FROM data_uzyskania_licencji) - 18 > EXTRACT(YEAR FROM data_urodzenia) );
    
ALTER TABLE mecze
    ADD CONSTRAINT valid_frequence CHECK ( frekwencja >= 0 );

ALTER TABLE kolejki
    ADD CONSTRAINT valid_dates CHECK ( data_rozpoczecia_kolejki <= data_zakonczenia_kolejki );
    
ALTER TABLE kolejki
    ADD CONSTRAINT valid_number CHECK ( numer >= 1 AND numer <= 18 );

ALTER TABLE sezony
    ADD CONSTRAINT valid_dates_season CHECK ( data_rozpoczecia_sezonu < data_zakonczenia_sezonu );
 
ALTER TABLE sezony
    ADD CONSTRAINT valid_teams_number CHECK ( MOD(liczba_druzyn, 2) = 0 );

COMMIT;

-- =============================================================================
-- Sekwencje
-- =============================================================================

CREATE SEQUENCE id_sedziow START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_trenerow START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_zawodnikow START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_wydarzen START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_druzyn_w_sezonie START WITH 1 INCREMENT BY 1;

-- ============================================================================
-- Funkcje, procedury
-- ============================================================================

CREATE OR REPLACE PROCEDURE RozbudujStadion(vNazwa IN VARCHAR2)  
IS 
BEGIN 
    UPDATE stadiony SET pojemnosc = pojemnosc + 4000 WHERE nazwa = vNazwa; 
END RozbudujStadion;

CREATE OR REPLACE PROCEDURE DodajZawodnika (vImie IN VARCHAR2, vNazwisko IN VARCHAR2, vDataUrodzenia IN DATE, vPozycja IN VARCHAR2) 
IS
BEGIN
    INSERT INTO zawodnicy VALUES (id_zawodnikow.NEXTVAL, vImie, vNazwisko, vDataUrodzenia, vPozycja);
END DodajZawodnika;


CREATE OR REPLACE FUNCTION PozycjaKlubu (vNazwaKlubu IN VARCHAR2, vSezon IN VARCHAR2)
    RETURN NUMBER IS vPozycja NUMBER;
    CURSOR cDruzyny(vSezon VARCHAR2) IS 
        SELECT nazwa_druzyny FROM druzyny_w_sezonie WHERE sezon = vSezon ORDER BY punkty DESC, liczba_bramek_zdobytych - liczba_bramek_straconych DESC, liczba_bramek_zdobytych DESC;
    vLicznik NUMBER := 1;
BEGIN
    FOR vDruzyna IN cDruzyny(vSezon) LOOP
        IF vDruzyna.nazwa_druzyny = vNazwaKlubu THEN
            RETURN vLicznik;
        END IF;
        vLicznik := vLicznik + 1;
    END LOOP;
    RETURN -1;
END PozycjaKlubu;

-- ============================================================================
-- Modyfikacja Statystyk Druzyn
-- ============================================================================

create or replace TRIGGER modyfikujStatstykiDruzyn 
    AFTER INSERT OR UPDATE OR DELETE ON mecze 
    FOR EACH ROW 
BEGIN 
    CASE
        WHEN INSERTING THEN
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_zdobytych = liczba_bramek_zdobytych + :NEW.bramki_gosc 
            WHERE  
            id = :NEW.id_gosc; 
            
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_zdobytych = liczba_bramek_zdobytych + :NEW.bramki_gosp 
            WHERE 
            id = :NEW.id_gosp; 
            
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_straconych = liczba_bramek_straconych + :NEW.bramki_gosp 
            WHERE  
            id = :NEW.id_gosc; 
            
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_straconych = liczba_bramek_straconych + :NEW.bramki_gosc 
            WHERE  
            id = :NEW.id_gosp; 
            
            IF (:NEW.bramki_gosc > :NEW.bramki_gosp) THEN 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty + 3 
                WHERE  
                id = :NEW.id_gosc; 
            ELSIF (:NEW.bramki_gosc < :NEW.bramki_gosp) THEN 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty + 3 
                WHERE  
                id = :NEW.id_gosp; 
            ELSE 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty + 1 
                WHERE  
                id = :NEW.id_gosp; 
                
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty + 1 
                WHERE  
                id = :NEW.id_gosc; 
            END IF; 
    
        WHEN UPDATING THEN
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_zdobytych = liczba_bramek_zdobytych + :NEW.bramki_gosc - :OLD.bramki_gosc
            WHERE  
            id = :NEW.id_gosc; 
            
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_zdobytych = liczba_bramek_zdobytych + :NEW.bramki_gosp - :OLD.bramki_gosp
            WHERE 
            id = :NEW.id_gosp; 
            
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_straconych = liczba_bramek_straconych + :NEW.bramki_gosp - :OLD.bramki_gosp
            WHERE  
            id = :NEW.id_gosc; 
            
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_straconych = liczba_bramek_straconych + :NEW.bramki_gosc - :OLD.bramki_gosc
            WHERE  
            id = :NEW.id_gosp; 
            
            IF (:NEW.bramki_gosc > :NEW.bramki_gosp) THEN 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty + 3 
                WHERE  
                id = :NEW.id_gosc; 
            ELSIF (:NEW.bramki_gosc < :NEW.bramki_gosp) THEN 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty + 3 
                WHERE  
                id = :NEW.id_gosp; 
            ELSE 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty + 1 
                WHERE  
                id = :NEW.id_gosp; 
                
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty + 1 
                WHERE  
                id = :NEW.id_gosc; 
            END IF;
            
            IF (:OLD.bramki_gosc > :OLD.bramki_gosp) THEN 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty - 3 
                WHERE  
                id = :NEW.id_gosc; 
            ELSIF (:OLD.bramki_gosc < :OLD.bramki_gosp) THEN 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty - 3 
                WHERE  
                id = :NEW.id_gosp; 
            ELSE 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty - 1 
                WHERE  
                id = :NEW.id_gosp; 
                
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty - 1 
                WHERE  
                id = :NEW.id_gosc;
            END IF;  
        
        WHEN DELETING THEN
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_zdobytych = liczba_bramek_zdobytych - :OLD.bramki_gosc 
            WHERE  
            id = :OLD.id_gosc; 
            
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_zdobytych = liczba_bramek_zdobytych - :OLD.bramki_gosp 
            WHERE 
            id = :OLD.id_gosp; 
            
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_straconych = liczba_bramek_straconych - :OLD.bramki_gosp 
            WHERE  
            id = :OLD.id_gosc; 
            
            UPDATE druzyny_w_sezonie 
            SET liczba_bramek_straconych = liczba_bramek_straconych - :OLD.bramki_gosc 
            WHERE  
            id = :OLD.id_gosp; 
            
            IF (:OLD.bramki_gosc > :OLD.bramki_gosp) THEN 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty - 3
                WHERE  
                id = :OLD.id_gosc; 
            ELSIF (:OLD.bramki_gosc < :OLD.bramki_gosp) THEN 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty - 3 
                WHERE  
                id = :OLD.id_gosp; 
            ELSE 
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty - 1
                WHERE  
                id = :OLD.id_gosp; 
                
                UPDATE druzyny_w_sezonie 
                SET punkty = punkty - 1
                WHERE  
                id = :OLD.id_gosc; 
            END IF; 
    END CASE;   
END;


create or replace TRIGGER UpdateZawodnicyWSezonie 
    AFTER INSERT OR DELETE OR UPDATE ON Wydarzenia  
    FOR EACH ROW 
BEGIN 
    CASE 
        WHEN INSERTING THEN 
            IF (:NEW.akcja = 'GOL') THEN 
                UPDATE zawodnicy_w_sezonie SET liczba_bramek = liczba_bramek + 1 WHERE id_zawodnika = :NEW.id_zawodnika AND id_druzyny = :NEW.id_druz_zaw; 
            END IF; 
            IF (:NEW.akcja = 'ZK') THEN 
                UPDATE zawodnicy_w_sezonie SET liczba_zoltych_kartek = liczba_zoltych_kartek + 1 WHERE id_zawodnika = :NEW.id_zawodnika AND id_druzyny = :NEW.id_druz_zaw; 
            END IF; 
            IF (:NEW.akcja = 'CK') THEN 
                UPDATE zawodnicy_w_sezonie SET liczba_czerwonych_kartek = liczba_czerwonych_kartek + 1 WHERE id_zawodnika = :NEW.id_zawodnika AND id_druzyny = :NEW.id_druz_zaw; 
            END IF; 
        WHEN DELETING THEN 
            IF (:OLD.akcja = 'GOL') THEN 
                UPDATE zawodnicy_w_sezonie SET liczba_bramek = liczba_bramek - 1 WHERE id_zawodnika = :OLD.id_zawodnika AND id_druzyny = :OLD.id_druz_zaw; 
            END IF; 
            IF (:OLD.akcja = 'ZK') THEN 
                UPDATE zawodnicy_w_sezonie SET liczba_zoltych_kartek = liczba_zoltych_kartek - 1 WHERE id_zawodnika = :OLD.id_zawodnika AND id_druzyny = :OLD.id_druz_zaw;
            END IF; 
            IF (:OLD.akcja = 'CK') THEN 
                UPDATE zawodnicy_w_sezonie SET liczba_czerwonych_kartek = liczba_czerwonych_kartek - 1 WHERE id_zawodnika = :OLD.id_zawodnika AND id_druzyny = :OLD.id_druz_zaw;
            END IF; 
        WHEN UPDATING THEN
            IF (:NEW.akcja = 'GOL') THEN 
                UPDATE zawodnicy_w_sezonie SET liczba_bramek = liczba_bramek + 1 WHERE id_zawodnika = :NEW.id_zawodnika AND id_druzyny = :NEW.id_druz_zaw; 
                UPDATE zawodnicy_w_sezonie SET liczba_bramek = liczba_bramek - 1 WHERE id_zawodnika = :OLD.id_zawodnika AND id_druzyny = :OLD.id_druz_zaw; 
            END IF; 
            IF (:NEW.akcja = 'ZK') THEN 
                UPDATE zawodnicy_w_sezonie SET liczba_zoltych_kartek = liczba_zoltych_kartek + 1 WHERE id_zawodnika = :NEW.id_zawodnika AND id_druzyny = :NEW.id_druz_zaw; 
                UPDATE zawodnicy_w_sezonie SET liczba_zoltych_kartek = liczba_zoltych_kartek - 1 WHERE id_zawodnika = :OLD.id_zawodnika AND id_druzyny = :OLD.id_druz_zaw;
            END IF; 
            IF (:NEW.akcja = 'CK') THEN 
                UPDATE zawodnicy_w_sezonie SET liczba_czerwonych_kartek = liczba_czerwonych_kartek + 1 WHERE id_zawodnika = :NEW.id_zawodnika AND id_druzyny = :NEW.id_druz_zaw; 
                UPDATE zawodnicy_w_sezonie SET liczba_czerwonych_kartek = liczba_czerwonych_kartek - 1 WHERE id_zawodnika = :OLD.id_zawodnika AND id_druzyny = :OLD.id_druz_zaw;
            END IF; 
    END CASE; 
END;

-- =============================================================================
-- Wyzwalacze kontrolujace wprowadzane dane
-- =============================================================================

CREATE OR REPLACE TRIGGER sprawdzPojemnoscStadionu
    BEFORE INSERT OR UPDATE ON mecze
    FOR EACH ROW
DECLARE
    vPojemnosc NATURAL;
    ZlaFrekwencja EXCEPTION;
    PRAGMA EXCEPTION_INIT(ZlaFrekwencja, -20020);
BEGIN

    SELECT pojemnosc
    INTO vPojemnosc
    FROM stadiony
    WHERE 
      nazwa = :NEW.nazwa_stadionu
    AND
      miasto = :NEW.miasto_stadionu;
      
    IF(vPojemnosc < :NEW.frekwencja) THEN
        RAISE_APPLICATION_ERROR(-20020, 'Podana frekwencja przekracza dopuszczalna pojemnosc stadionu!');
    END IF;
END;

CREATE OR REPLACE TRIGGER sprawdzDateMeczu
    BEFORE INSERT OR UPDATE ON mecze
    FOR EACH ROW
DECLARE
    vDataStart DATE;
    vDataKoniec DATE;
    MeczNieWKolejce EXCEPTION;
    PRAGMA EXCEPTION_INIT(MeczNieWKolejce, -20021);
BEGIN

    SELECT data_rozpoczecia_kolejki, data_zakonczenia_kolejki
    INTO vDataStart, vDataKoniec
    FROM kolejki
    WHERE 
        numer = :NEW.nr_kolejki;
    AND
        sezon = :NEW.sezon_kolejki;
      
    IF(NOT (:NEW.data BETWEEN vDataStart AND vDataKoniec)) THEN
        RAISE_APPLICATION_ERROR(-20021, 'Podana data meczu nie mieści się w terminach dostępnych dla kolejki!');
    END IF;
END;


CREATE OR REPLACE TRIGGER sprawdzCzySedziaMaLicencje
    BEFORE INSERT OR UPDATE OF id_sedziego ON mecze
    FOR EACH ROW
DECLARE
    vDataLicencji DATE;
    SedziaBezLicencji EXCEPTION;
    PRAGMA EXCEPTION_INIT(SedziaBezLicencji, -20022);
BEGIN
    SELECT data_uzyskania_licencji
    INTO vdatalicencji
    FROM sedziowie
    WHERE id_sedziego = :NEW.id_sedziego;
    
    IF (vdatalicencji > :NEW.data) THEN
        RAISE_APPLICATION_ERROR(-20022, 'Podany sędzia nie mógl/może sedziować tego meczu bez licencji!');
    END IF;
END;

CREATE OR REPLACE TRIGGER sprawdzCzyDruzynaMaStadionWSezonie
    BEFORE INSERT ON druzyny_w_sezonie
    FOR EACH ROW
DECLARE
    vDataStadion DATE;
    vDataRozpoczeciaSezonu DATE;
    DruzynaBezStadionu EXCEPTION;
    PRAGMA EXCEPTION_INIT(DruzynaBezStadionu, -20023);
BEGIN
    SELECT s.data_wybudowania
    INTO vDataStadion
    FROM stadiony s
    RIGHT OUTER JOIN druzyny d
    ON(d.stadion_nazwa = s.nazwa AND d.stadion_miasto = s.miasto)
    WHERE d.nazwa = :NEW.nazwa_druzyny;
    
    SELECT data_rozpoczecia_sezonu INTO vDataRozpoczeciaSezonu FROM sezony WHERE nazwa_sezonu = :NEW.sezon;
    
    IF(vDataStadion > vDataRozpoczeciaSezonu) THEN
        RAISE_APPLICATION_ERROR(-20023, 'Stadion podanej drużyny nie byl/jest jeszcze oddany do użytku!');
    END IF;
END;

CREATE OR REPLACE TRIGGER sprawdzCzyZawodnikMa16Lat
    BEFORE INSERT OR UPDATE ON zawodnicy_w_sezonie
    FOR EACH ROW
DECLARE
    vDataUrodzenia DATE;
    vDataRozpoczeciaSezonu DATE;
    ZaMlodyZawodnik EXCEPTION;
    PRAGMA EXCEPTION_INIT(ZaMlodyZawodnik, -20024);
BEGIN
    SELECT data_urodzenia
    INTO vDataUrodzenia
    FROM zawodnicy
    WHERE id_zawodnika = :NEW.id_zawodnika;
    
    SELECT data_rozpoczecia_sezonu INTO vDataRozpoczeciaSezonu FROM druzyny_w_sezonie dws JOIN sezony s ON dws.sezon = s.nazwa_sezonu WHERE dws.id = :NEW.id_druzyny;
    
    IF (FLOOR(MONTHS_BETWEEN(vDataRozpoczeciaSezonu, vDataUrodzenia) /12)) < 16 THEN
        RAISE_APPLICATION_ERROR(-20024, 'Zawodnik byl/jest zbyt mlody aby brac udzial w podanym sezonie!');
    END IF;
END;

CREATE OR REPLACE TRIGGER sprawdzDateUrodzeniaTrenera
    BEFORE INSERT OR UPDATE ON okresy_trenowania
    FOR EACH ROW
DECLARE
    vDataUrodzenia DATE;
    vDataRozpoczeciaSezonu DATE;
    ZaMlodyTrener EXCEPTION;
    PRAGMA EXCEPTION_INIT(ZaMlodyTrener, -20025);
BEGIN
    SELECT data_urodzenia
    INTO vDataUrodzenia
    FROM trenerzy
    WHERE id_trenera = :NEW.id_trenera;
    
    SELECT data_rozpoczecia_sezonu INTO vDataRozpoczeciaSezonu FROM druzyny_w_sezonie dws JOIN sezony s ON dws.sezon = s.nazwa_sezonu WHERE dws.id = :NEW.id_druzyny;
    
    IF (FLOOR(MONTHS_BETWEEN(vDataRozpoczeciaSezonu, vDataUrodzenia) /12)) < 30 THEN
        RAISE_APPLICATION_ERROR(-20025, 'Trener byl/jest zbyt mlody aby trenowac w podanym sezonie!');
    END IF;
END;

CREATE OR REPLACE TRIGGER sprawdzCzyDruzynaIstniejeWSezonie
    BEFORE INSERT OR UPDATE ON druzyny_w_Sezonie
    FOR EACH ROW
DECLARE
    vRokZalozeniaDruzyny NUMBER(4);
    vRokRozpoczeciaSezonu NUMBER(4);
    BrakDruzynyWSezonie EXCEPTION;
    PRAGMA EXCEPTION_INIT(BrakDruzynyWSezonie, -20026);
BEGIN
    SELECT rok_zalozenia INTO vRokZalozeniaDruzyny FROM druzyny WHERE nazwa = :NEW.nazwa_druzyny;
    SELECT EXTRACT(YEAR FROM data_rozpoczecia_sezonu) INTO vRokRozpoczeciaSezonu FROM sezony WHERE nazwa_sezonu = :NEW.sezon;
    
    IF (vRokZalozeniaDruzyny > vRokRozpoczeciaSezonu) THEN
        RAISE_APPLICATION_ERROR(-20026, 'Druzyna nie istniala/istnieje w danym sezonie!');
    END IF;
END;


CREATE OR REPLACE TRIGGER sprawdzSezony
    BEFORE INSERT ON sezony
    FOR EACH ROW
DECLARE
    CURSOR cSezony IS
        SELECT data_rozpoczecia_sezonu, data_zakonczenia_sezonu FROM sezony;
    SezonyNachodzace EXCEPTION;
    PRAGMA EXCEPTION_INIT(SezonyNachodzace, -20028);
BEGIN
    FOR vSezon IN cSezony LOOP
        IF ((:NEW.data_rozpoczecia_sezonu >= vSezon.data_rozpoczecia_sezonu AND :NEW.data_zakonczenia_sezonu <= vSezon.data_zakonczenia_sezonu) 
            OR (:NEW.data_rozpoczecia_sezonu <= vSezon.data_rozpoczecia_sezonu AND :NEW.data_zakonczenia_sezonu >= vSezon.data_rozpoczecia_sezonu) 
            OR (:NEW.data_rozpoczecia_sezonu <= vSezon.data_zakonczenia_sezonu AND :NEW.data_zakonczenia_sezonu >= vSezon.data_zakonczenia_sezonu)) THEN
            RAISE_APPLICATION_ERROR(-20028, 'Dwa sezony nie moga się nakladać!');
        END IF;
    END LOOP;
END;
    
CREATE OR REPLACE TRIGGER ValidDate
    BEFORE INSERT OR UPDATE ON kolejki
    FOR EACH ROW
DECLARE
    vDataRozpoczeciaSezonu DATE;
    vDataZakonczeniaSezonu DATE;
    NieprawidlowaData EXCEPTION;
    PRAGMA EXCEPTION_INIT(NieprawidlowaData, -20031);
BEGIN
    SELECT data_rozpoczecia_sezonu, data_zakonczenia_sezonu INTO vDataRozpoczeciaSezonu, vDataZakonczeniaSezonu FROM sezony WHERE nazwa_sezonu = :NEW.sezon;
    
    IF ( (:NEW.numer = 1 AND :NEW.data_rozpoczecia_kolejki = vDataRozpoczeciaSezonu) OR (:NEW.numer > 1 AND :NEW.data_rozpoczecia_kolejki > vDataRozpoczeciaSezonu ) ) AND :NEW.data_rozpoczecia_kolejki < vDataZakonczeniaSezonu THEN
        RETURN;
    ELSE
        RAISE_APPLICATION_ERROR(-20031, 'Podano nieprawidlowe daty rozgrywania kolejki');
    END IF;
END;

CREATE OR REPLACE TRIGGER ValidDate2
    BEFORE INSERT OR UPDATE ON kolejki
    FOR EACH ROW
DECLARE
    vDataRozpoczeciaSezonu DATE;
    vDataZakonczeniaSezonu DATE;
    vLiczbaDruzyn NUMBER;
    NieprawidlowaData2 EXCEPTION;
    PRAGMA EXCEPTION_INIT(NieprawidlowaData2, -20032);
BEGIN
    SELECT data_rozpoczecia_sezonu, data_zakonczenia_sezonu, liczba_druzyn INTO vDataRozpoczeciaSezonu, vDataZakonczeniaSezonu, vLiczbaDruzyn FROM sezony WHERE nazwa_sezonu = :NEW.sezon;
    
    IF ( (:NEW.numer = (vLiczbaDruzyn - 1) * 2 AND :NEW.data_zakonczenia_kolejki = vDataZakonczeniaSezonu) OR (:NEW.numer < (vLiczbaDruzyn - 1) * 2 AND :NEW.data_zakonczenia_kolejki < vDataZakonczeniaSezonu ) ) AND :NEW.data_zakonczenia_kolejki > vDataRozpoczeciaSezonu THEN
        RETURN;
    ELSE
        RAISE_APPLICATION_ERROR(-20032, 'Podano nieprawidlowe daty rozgrywania kolejki');
    END IF;
END;

CREATE OR REPLACE TRIGGER ValidPlayTime
    BEFORE INSERT OR UPDATE ON zawodnicy_w_sezonie
    FOR EACH ROW
DECLARE
    vDataRozpoczeciaSezonu DATE;
    vDataZakonczeniaSezonu DATE;
    NieprawidlowyOkresGrania EXCEPTION;
    PRAGMA EXCEPTION_INIT(NieprawidlowyOkresGrania, -20029);
BEGIN
    SELECT data_rozpoczecia_sezonu, data_zakonczenia_sezonu INTO vDataRozpoczeciaSezonu, vDataZakonczeniaSezonu FROM druzyny_w_sezonie dws JOIN sezony s ON dws.sezon = s.nazwa_sezonu WHERE dws.id = :NEW.id_druzyny;
    
    IF :NEW.od_kiedy >= vDataRozpoczeciaSezonu AND :NEW.do_kiedy <= vDataZakonczeniaSezonu AND :NEW.do_kiedy > :NEW.od_kiedy THEN
        RETURN;
    ELSE
        RAISE_APPLICATION_ERROR(-20029, 'Podano nieprawidlowy okres grania zawodnika w klubie');
    END IF;
END;

CREATE OR REPLACE TRIGGER ValidTrainTime
    BEFORE INSERT OR UPDATE ON okresy_trenowania
    FOR EACH ROW
DECLARE
    vDataRozpoczeciaSezonu DATE;
    vDataZakonczeniaSezonu DATE;
    NieprawidlowyOkresTrenowania EXCEPTION;
    PRAGMA EXCEPTION_INIT(NieprawidlowyOkresTrenowania, -20030);
BEGIN
    SELECT data_rozpoczecia_sezonu, data_zakonczenia_sezonu INTO vDataRozpoczeciaSezonu, vDataZakonczeniaSezonu FROM druzyny_w_sezonie dws JOIN sezony s ON dws.sezon = s.nazwa_sezonu WHERE dws.id = :NEW.id_druzyny;
    
    IF :NEW.od_kiedy >= vDataRozpoczeciaSezonu AND :NEW.do_kiedy <= vDataZakonczeniaSezonu AND :NEW.do_kiedy > :NEW.od_kiedy THEN
        RETURN;
    ELSE
        RAISE_APPLICATION_ERROR(-20030, 'Podano nieprawidlowy okres trenowania trenera w klubie');
    END IF;
END;

create or replace TRIGGER trg_meczow 
BEFORE INSERT ON mecze 
FOR EACH ROW 
DECLARE
    vNazwa varchar2(50);
    vMiasto varchar2(20);
BEGIN  
    SELECT s.nazwa INTO vNazwa from druzyny_w_sezonie dws JOIN druzyny d ON dws.nazwa_druzyny = d.nazwa JOIN stadiony s ON d.stadion_nazwa = s.nazwa WHERE dws.id = :NEW.id_gosp;
    SELECT s.miasto INTO vMiasto from druzyny_w_sezonie dws JOIN druzyny d ON dws.nazwa_druzyny = d.nazwa JOIN stadiony s ON d.stadion_miasto = s.miasto WHERE dws.id = :NEW.id_gosp;
    :NEW.nazwa_stadionu := vNazwa;
    :NEW.miasto_stadionu := vMiasto;
END; 

create or replace TRIGGER trg_wydarzenia_druzyna
BEFORE INSERT ON wydarzenia 
FOR EACH ROW 
DECLARE
    vIdDruzyny number;
    vGosc number;
    vGospodarz number;
BEGIN  
    vGosc := 0;
    vGospodarz := 0;
    SELECT COUNT(*) INTO vGospodarz from zawodnicy_w_sezonie zws JOIN druzyny_w_sezonie dws ON zws.id_druzyny = dws.id WHERE id_zawodnika = :NEW.id_zawodnika and id_druzyny = :NEW.id_gosp;
    SELECT COUNT(*) INTO vGosc from zawodnicy_w_sezonie zws JOIN druzyny_w_sezonie dws ON zws.id_druzyny = dws.id WHERE id_zawodnika = :NEW.id_zawodnika and id_druzyny = :NEW.id_gosc;
    if vGosc = 1 THEN
        SELECT id_druzyny INTO vIdDruzyny from zawodnicy_w_sezonie WHERE id_zawodnika = :NEW.id_zawodnika and id_druzyny = :NEW.id_gosc;
        :NEW.id_druz_zaw := vIdDruzyny;
    ELSE
        SELECT id_druzyny INTO vIdDruzyny from zawodnicy_w_sezonie WHERE id_zawodnika = :NEW.id_zawodnika and id_druzyny = :NEW.id_gosp;
        :NEW.id_druz_zaw := vIdDruzyny;
    END IF;
END;

create or replace TRIGGER trg_sedziow 
BEFORE INSERT ON sedziowie 
FOR EACH ROW 
BEGIN  
    :NEW.id_sedziego := id_sedziow.nextval; 
END; 

create or replace TRIGGER trg_druzyn_w_sezonie 
BEFORE INSERT ON druzyny_w_sezonie 
FOR EACH ROW 
BEGIN  
    :NEW.id := id_druzyn_w_sezonie.nextval; 
END; 

create or replace TRIGGER trg_trenerow 
BEFORE INSERT ON trenerzy 
FOR EACH ROW 
BEGIN  
    :NEW.id_trenera := id_trenerow.nextval; 
END; 

create or replace TRIGGER trg_wydarzen 
BEFORE INSERT ON wydarzenia 
FOR EACH ROW 
BEGIN  
    :NEW.id_wydarzenia := id_wydarzen.nextval; 
END; 

create or replace TRIGGER trg_zawodnikow 
BEFORE INSERT ON zawodnicy 
FOR EACH ROW 
BEGIN  
    :NEW.id_zawodnika := id_zawodnikow.nextval; 
END; 