# PCB PSU LED

Moduł zasilania i sterowania diody LED dla customowego zasilacza step-down 230 V → 100 V.

## Status projektu

- Aktualna rewizja elektryczna: **ECAD-19**
- Ostatnia rewizja dokumentacji: **DOC-07**
- Schemat: **KOMPLETNY — 12 z 12 pozycji**
- Footprinty: **KOMPLETNE — 12 z 12 przypisanych, 10 plików w `PSU_LED.pretty/`**
- Etap 1 (schemat) — **zamknięty**
- Etap 2 (footprinty) — **zamknięty**
- Etap 3 (PCB) — **w toku**: netclasy i reguły DRC gotowe, layout czeka
- ERC bramkujący: **0 errors / 0 warnings**
- Pełny ERC: **0 errors / 0 warnings**
- Walidacja: wyłącznie przez **GitHub Actions**
- Wersja KiCad w CI: **10.0.4** (obraz `ghcr.io/kicad/kicad:10.0-full`, wersja raportowana w runtime)
- Gałąź robocza: `main`
- Gałąź `pcb2`: równoległy projekt drugiego zespołu, wspólny przodek ECAD-11 — **nie mergować**

Obsada: `J1`, `F1`, `T1`, `D1`, `D2`, `C1`, `C2`, `U1`, `C3`, `R1`, `RV1`, `J2`.
Dioda `Kingbright L-7104EC` znajduje się na panelu przednim, poza płytką — wychodzi przez `J2`.

## Zatwierdzona topologia

### Wejście sieciowe

Lokalny symbol:

- `J1`
- `J1.1 = L_SW`
- `J1.2 = N_SW`

Aktualne połączenia:

- `J1.1 → L_SW → F1.1`
- `F1.2 → L_FUSED → T1.6`
- `J1.2 → N_SW → T1.3`
- `T1.5 ↔ T1.4 = PRI_LINK_5_4`

Bezpiecznik `F1` wyłącznie w przewodzie fazowym. Neutralny bez zabezpieczenia —
rozłączanie obu przewodów realizuje wyłącznik NKK M2022SS4W01 (DPDT).

### Transformator

- `T1 = Talema 70000K`
- moc znamionowa: `1.6 VA`
- dwa uzwojenia pierwotne `115 V`
- dwa uzwojenia wtórne `7 V`
- lokalny symbol i footprint przechodzą walidację CI

### Uzwojenie wtórne i prostownik

- `T1.12 ↔ T1.13 = CT_RAW`
- `T1.11 → SEC_A → anoda D2`
- `T1.14 → SEC_B → anoda D1`
- katody `D1` i `D2 → VRAW_PLUS`
- `D1`, `D2 = BYV26C`

### Kondensator zbiorczy

- `C1 = 47 µF / 25 V Panasonic FR`
- `C1 (+) → VRAW_PLUS`
- `C1 (−) → CT_RAW`

### Stabilizator

- `U1 = LM78L05ACZ`
- `U1.3 VIN → VRAW_PLUS`
- `U1.2 GND → CT_RAW`
- `U1.1 VOUT → PLUS_5V_LED`

Pinout projektu:

```text
1 = VOUT
2 = GND
3 = VIN
```

## Pliki projektu

- `pcb-psu-led.kicad_pro` — plik projektu KiCad
- `pcb-psu-led.kicad_sch` — schemat
- `pcb-psu-led.kicad_sym` — lokalna biblioteka symboli
- `PSU_LED.pretty/Talema_70000K.kicad_mod` — lokalny footprint transformatora
- `sym-lib-table` — mapowanie lokalnej biblioteki symboli
- `fp-lib-table` — mapowanie lokalnej biblioteki footprintów
- `.github/workflows/kicad-validate.yml` — workflow walidacyjny
- `README.md` — dokumentacja zatwierdzonego stanu projektu
- `docs/platform.md` — fakty źródłowe: karta 700xxK, ograniczenia `Rev. 6.4.1`,
  macierz wariantów, reguły platformowe

## Walidacja CI

Workflow korzysta z:

- `ghcr.io/kicad/kicad:10.0-full`
- `actions/checkout@v6`
- `actions/upload-artifact@v7`
- zapisywalnej kopii projektu w `RUNNER_TEMP`

Walidowane są:

1. obecność wymaganych plików,
2. wersja KiCad,
3. parsowanie i eksport lokalnego symbolu,
4. parsowanie i eksport footprintu,
5. eksport netlisty,
6. pełny ERC,
7. bramkujący ERC dla błędów.

Raport bramkujący oraz pełny raport ERC są publikowane bezpośrednio w **GitHub Step Summary**.

Aktualny wynik:

```text
Validation exit code: 0
ERC gating report:    0 errors / 0 warnings
Full ERC report:      0 errors / 1 warning
Warning:              PLUS_5V_LED connected to only one pin
```

## Zasady pracy

- jedna logiczna zmiana na commit,
- bez lokalnej walidacji,
- walidacja wyłącznie przez GitHub Actions,
- bez ZIP-ów,
- pliki przekazywane pojedynczo z kanonicznymi nazwami,
- bez dużych generatorów i masowego nadpisywania plików,
- zmiany w kilku plikach należące do jednego ECO muszą trafić do jednego commitu,
- przed kolejnym etapem należy sprawdzić pełny raport ERC w Step Summary.

## Historia rewizji

### ECAD-08

- zapis `pin_names` J1 znormalizowany do formy `(hide yes)`
- zmiana nie usunęła ostrzeżenia `lib_symbol_mismatch`

### ECAD-09

- pole `Datasheet` symbolu `Conn_01x02` ujednolicone do pustego ciągu `""`
- usunięto `lib_symbol_mismatch`
- ERC osiągnął `0 errors / 0 warnings`

### ECAD-10

- dodano kondensator zbiorczy `C1`
- `C1 = 47 µF / 25 V Panasonic FR`
- połączenie między `VRAW_PLUS` i `CT_RAW`
- ERC: `0 errors / 0 warnings`

### ECAD-11

- dodano stabilizator `U1 = LM78L05ACZ`
- `VIN → VRAW_PLUS`
- `GND → CT_RAW`
- `VOUT → PLUS_5V_LED`
- ERC bramkujący: `0 errors`
- pełny ERC: jedno oczekiwane ostrzeżenie dla tymczasowo jednoelementowej sieci `PLUS_5V_LED`

### CI-04

- rozszerzono `kicad-validate.yml` o dwie bramki, bez zmiany istniejacej logiki ERC:
  - **kontrola BOM**: `kicad-cli sch export bom` + wykrycie pustego pola `Footprint`
    → nowy kod wyjscia `70`. To jest bramka, ktora zlapalaby ECAD-19 (commit
    "assign footprints" przeszedl wtedy na zielono, nie przypisawszy niczego,
    bo ERC nie widzi footprintow)
  - **DRC warunkowy**: jesli `pcb-psu-led.kicad_pcb` istnieje →
    `kicad-cli pcb drc --severity-error` z regulami z `mains.kicad_dru`
    → kody `71` (naruszenia) / `72` (brak raportu). Dopoki plytki nie ma,
    krok grzecznie sie pomija
- bariera 6 mm z ECAD-20 staje sie egzekwowalna automatycznie w momencie,
  gdy powstanie layout

### ECAD-20

- zdefiniowano klasy sieci w `pcb-psu-led.kicad_pro`:
  - **MAINS** (`L_SW`, `N_SW`, `L_FUSED`, `PRI_LINK_5_4`): ścieżka min. 1 mm,
    clearance 0.5 mm, kolor czerwony
  - **SELV** (`SEC_A`, `SEC_B`, `CT_RAW`, `VRAW_PLUS`, `LED_R`, `LED_A`,
    `PLUS_5V_LED`): ścieżka 0.5 mm, kolor zielony
- dodano `mains.kicad_dru` — reguły bezpieczeństwa sieciowego jako maszynowa bramka:
  - `mains_to_selv_reinforced`: bariera **MAINS ↔ SELV ≥ 6 mm** (IEC 62368-1,
    izolacja wzmocniona)
  - `mains_internal_clearance`: L ↔ N ≥ 2.5 mm
  - `mains_min_track`: ścieżki MAINS ≥ 1 mm, zero neck-down
  - `mains_to_edge`: miedź MAINS ≥ 2 mm od krawędzi
  - `mains_to_hole`: miedź MAINS ≥ 3 mm od otworów
- 6 mm przestaje być zapisem w dokumencie — staje się regułą, przez którą
  płytka nie przejdzie DRC

### ECAD-19

- przypisano footprinty do wszystkich 12 pozycji schematu
- przypisanie **wyłącznie na instancjach** — symbole `R`, `C`, `Fuse`, `Conn_01x02`
  i pozostałe generyczne zostają bez footprintu, żeby biblioteka nadawała się
  do kolejnych projektów; `lib_symbols` nietknięte → zero ryzyka `lib_symbol_mismatch`
- kontrola: każdy przypisany footprint istnieje w `PSU_LED.pretty/`; żaden plik
  biblioteki nie jest nieużywany
- kontrola pin↔pad: `F1` 1/2 (dwa pady „2" równolegle + NPTH oprawki),
  `U1` 1/2/3, `RV1` 1/2/3, reszta 1/2 — wszystkie zgodne z symbolami

### ECAD-18

- `TerminalBlock_Phoenix_MKDS-1,5-2-5.08_1x02_P5.08mm_Horizontal` dla `J1`
- dwubiegunowy bloczek śrubowy, raster 5.08 mm, przewód do 1.5 mm², pad Ø2.6, wiertło Ø1.3
- Phoenix COMBICON PC 6 (raster 10.16) **nie istnieje** w bibliotece stockowej —
  wspólność z `J_IN`/`J_OUT` z ANEKS 8.1 P2-R4.1 niemożliwa

### ECAD-17

- import 8 footprintów ze stockowych bibliotek zamrożonego obrazu `10.0.4`
- pliki kopiowane bez zmian, weryfikacja bajt w bajt; repo pozostaje samowystarczalne
- `U1` → `TO-92_Wide`: rozgięcie nóżek do 2.54 daje 1.04 mm przerwy między padami
  zamiast 0.17 mm; pad 1 prostokątny = pin 1, sito = płaska ścianka (kontrola lustra OK)
- `F1` → oprawka Schurter FUP **zamknięta** („Shock-Safe"): wymiana bezpiecznika
  bez dostępu do metalu pod napięciem; koszt — ~45 mm długości sektora sieciowego

### ECAD-16

- dodano gałąź diody LED: `R1`, `RV1`, `J2` — **schemat kompletny**
- nowe lokalne symbole `R` i `R_Potentiometer` w `pcb-psu-led.kicad_sym`
  i w `lib_symbols` schematu
- `J2` wykorzystuje istniejący symbol `Conn_01x02` z nadpisaniem `Value` na poziomie
  instancji — bez tworzenia zbędnego symbolu
- tor: `PLUS_5V_LED → R1 → LED_R → RV1.1`; `RV1.2 ↔ RV1.3 → LED_A → J2.1`; `J2.2 → CT_RAW`
- suwak `RV1.2` zwarty z końcem `RV1.3` — reostat z zabezpieczeniem przed utratą
  styku suwaka (rozwarcie suwaka nie gasi diody, tylko ustawia maksymalną rezystancję)
- `R1 = 680 Ω / 0.6 W` — **FROZEN** wg `Rev. 6.4.1` poz. `E-09`, zakaz 560 Ω
- prąd: `(5 − 1.9) / 680 ≈ 4.6 mA` maks., z `RV1` w szeregu do `~0.3 mA`
  → wymóg `I_f < 1 mA` osiągalny pokrętłem
- podstawa: `Rev. 6.4.1` §3.4 oraz poz. `E-04`, `E-09`, `E-10`

### ECAD-15

- dodano kondensatory odsprzęgające stabilizatora: `C2`, `C3 = 100 nF X7R`
- nowy lokalny symbol `C` (niespolaryzowany) w `pcb-psu-led.kicad_sym`
  i w `lib_symbols` schematu
- `C2`: `VRAW_PLUS ↔ CT_RAW`, wejście `U1.3`
- `C3`: `PLUS_5V_LED ↔ CT_RAW`, wyjście `U1.1`
- podstawa: `Rev. 6.4.1` poz. `E-08` (2 szt. 100 nF X7R)
- `C3` domknął sieć `PLUS_5V_LED` drugim pinem → ostrzeżenie `isolated_pin_label` znika
- schemat: 9 z 11 pozycji

### ECAD-14

- dodano bezpiecznik pierwotny `F1 = T32 mA / 250 V` zwłoczny
- nowy lokalny symbol `Fuse` w `pcb-psu-led.kicad_sym` i w `lib_symbols` schematu
- tor fazowy rozdzielony na dwie sieci: `L_SW` (J1.1 → F1.1) i `L_FUSED` (F1.2 → T1.6)
- podstawa: karta 700xxK, `230V Fuse mA (Max.)` = `32 mA` dla rodziny `1.6 VA`
- zamrożony `T500 mA` w module SCI PC-5 jest `15.6×` powyżej maksimum producenta
  i nie zareaguje na awarię tego transformatora
- `J1`, `T1`, przewód neutralny, mostek `T1.5 ↔ T1.4` i strona wtórna — bez zmian
- obudowa (`5×20` vs `TR5`) rozstrzygana na etapie placementu; symbol wspólny

### ECAD-13

- `pcb-psu-led.kicad_sch:890` — instancja `J1`, pole `Datasheet` `"~"` → `""`
- usunięto ostatni legacy placeholder w projekcie
- ERC bez zmian: `0 errors / 1 warning`

### ECAD-12

- footprint `Talema_70000K`: wiertło padów sygnalowych `Ø1.3` → `Ø1.5`
- podstawa: karta 700xxK — pin `1.0 x 0.5 mm` prostokątny, przekątna `1.118 mm`
- `Ø1.3` dawało `0.09 mm` luzu promieniowego (minimum bezwzględne IPC); `Ø1.5` daje `0.19 mm`
- pierścień przy padzie `Ø3.0` pozostaje `0.75 mm`
- współrzędne padów, maska, NPTH i strefy — bez zmian
- `descr` uzupełniony o dane z karty i regułę placementu (`rot=180`)
- zmiana wpływa na fabrykację, nie na ERC

## Następny etap

**Etapy 1 i 2 zamknięte.** Schemat kompletny, footprinty przypisane, ERC `0/0`.

**Etap 3 — PCB**

```text
netclasy MAINS / SELV
mains.kicad_dru — bariera MAINS <-> SELV >= 6 mm (IEC 62368-1, izolacja wzmocniona)
obrys i mocowanie
placement: 230 V z lewej -> 5 V z prawej -> LED; T1 w osi X = 162.50 (Rev. 6.4.1 §2.2)
routing
DRC w CI jako bramka
```

## Walidacja lokalna

Repozytorium jest otwierane w GitHub Codespaces. Obraz KiCada jest dostępny przez
Dockera, więc ERC można uruchomić **przed** commitem:

```bash
./check.sh
```

Skrypt używa dokładnie tego samego obrazu i tej samej komendy co CI.
CI pozostaje bramką — `check.sh` służy do złapania błędu, zanim trafi do historii.

## Dokumenty źródłowe

- `docs/platform.md` — fakty z karty 700xxK, ograniczenia `Rev. 6.4.1`,
  macierz wariantów, reguły platformowe, pozycje otwarte.
  **Czytać przed każdą zmianą projektową.**
