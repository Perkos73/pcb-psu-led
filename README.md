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

- `L_SW → T1.6`
- `N_SW → T1.3`
- `T1.5 ↔ T1.4 = PRI_LINK_5_4`

Planowana zmiana ECAD-12:

- `J1.1 / L_SW → F1 → T1.6`
- `F1 = T32 mA / 250 V, 5×20 mm`
- bezpiecznik wyłącznie w przewodzie fazowym
- neutralny i pozostałe połączenia transformatora pozostają bez zmian

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

## Następny etap

**ECAD-12 — zabezpieczenie pierwotne transformatora T1**

Zakres:

- dodać `F1 = T32 mA / 250 V, 5×20 mm`,
- włączyć F1 pomiędzy `J1.1 / L_SW` a `T1.6`,
- nie zmieniać przewodu neutralnego,
- nie zmieniać mostka `T1.5 ↔ T1.4`,
- nie zmieniać strony wtórnej ani układu regulatora.

Planowany commit elektryczny:

```text
ECAD-12: add primary fuse F1
```
