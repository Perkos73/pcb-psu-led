# PCB PSU LED

Moduł zasilania i sterowania diody LED dla customowego zasilacza step-down 230 V → 100 V.

## Status projektu

- Aktualna rewizja elektryczna: **ECAD-11**
- ERC bramkujący: **0 errors / 0 warnings**
- Pełny ERC: **0 errors / 1 warning**
- Otwarte ostrzeżenie: `isolated_pin_label` dla sieci `PLUS_5V_LED`
- Walidacja: wyłącznie przez **GitHub Actions**
- Wersja KiCad w CI: **10.0.4**
- Gałąź robocza: `main`

Ostrzeżenie `PLUS_5V_LED` jest oczekiwane na obecnym etapie: wyjście U1 jest już utworzone, ale kolejny element tej sieci nie został jeszcze dodany.

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

**ECAD-15 — kondensatory odsprzęgające U1**

- `C2`, `C3 = 100 nF X7R` — bypass wejścia i wyjścia stabilizatora
- `C2`: `VRAW_PLUS ↔ CT_RAW`, blisko `U1.3`
- `C3`: `PLUS_5V_LED ↔ CT_RAW`, blisko `U1.1`
- podstawa: `Rev. 6.4.1` poz. `E-08` (2 szt. 100 nF X7R)
- `C3` domyka sieć `PLUS_5V_LED` → znika ostrzeżenie `isolated_pin_label`

Kolejka:

```text
ECAD-15   C2, C3 = 100 nF X7R — bypass wejścia i wyjścia U1
ECAD-16   R1 = 680 Ω / 0.6 W, RV1 = Bourns 3296W 10 kΩ, J2 = JST XH 2-pin
────────  schemat kompletny: 11 pozycji, ERC 0/0
etap 2    footprinty — kopie stockowe z obrazu 10.0-full + lokalna Talema
etap 3    PCB — netclasy MAINS/SELV, mains.kicad_dru, obrys, placement, DRC w CI
etap 4    dokumentacja produkcyjna
```

## Dokumenty źródłowe

- `docs/platform.md` — fakty z karty 700xxK, ograniczenia `Rev. 6.4.1`,
  macierz wariantów, reguły platformowe, pozycje otwarte.
  **Czytać przed każdą zmianą projektową.**
