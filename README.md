# PCB PSU LED — gałąź `pcb2`

Alternatywna, niezależnie rozwijana wersja modułu zasilania i sterowania diody LED dla customowego zasilacza step-down 230 V → 100 V.

> Ten README opisuje wyłącznie stan gałęzi `pcb2`.  
> Dokumentacja gałęzi `main` pozostaje niezależna.

## Status projektu

- Gałąź robocza: `pcb2`
- Aktualna zatwierdzona rewizja PCB: **PCB2-PCB-04R2**
- Schemat: kompletny i zsynchronizowany z PCB
- ERC: **0 errors / 0 warnings**
- DRC bramkujący: **0 violations**
- Niepołączone pady: **0**
- Błędy zgodności schemat–PCB: **0**
- Pełny DRC: **3 informacyjne ostrzeżenia `lib_footprint_mismatch`**
- KiCad w CI: **10.0.4**
- Pliki produkcyjne: **wygenerowane i zapisane w repo**
- Gotowość produkcyjna: **zatwierdzona**

Trzy ostrzeżenia pełnego DRC dotyczą lokalnie osadzonych kopii footprintów `F1`, `J2` i `T1`. Nie są błędami elektrycznymi ani produkcyjnymi.

## Orientacja urządzenia

Określenia stron odnoszą się zawsze do widoku użytkownika patrzącego od strony panelu przedniego:

```text
LEWA STRONA  = MAINS / NKK / 230 V
PRAWA STRONA = LED / tor wyjściowy
```

Na panelu przednim włącznik NKK znajduje się po lewej, a dioda LED po prawej.

## Parametry PCB

| Parametr | Wartość |
|---|---:|
| Wymiary | 140 × 80 mm |
| Warstwy miedzi | 2 |
| Materiał | FR-4 |
| Grubość laminatu | 1.6 mm |
| Miedź | 35 µm / 1 oz |
| Technologia | THT |
| Liczba komponentów | 12 |
| Liczba przelotek | 0 |
| Minimalna szerokość ścieżki | 0.60 mm |
| Minimalny odstęp występujący na PCB | 0.57 mm |
| Minimalna średnica wiercenia | 0.75 mm |
| Otwory montażowe | 4 × NPTH 3.2 mm / M3 |

## Zatwierdzona topologia

### Wejście i transformator

- `J1` — wejście 230 V AC po zewnętrznym włączniku
- `F1` — bezpiecznik `T32 mA / 250 V`, 5×20 mm, wyłącznie w przewodzie fazowym
- `T1` — `Talema 70000K`, 1.6 VA
- uzwojenia pierwotne 2×115 V połączone szeregowo
- uzwojenia wtórne 2×7 V z odczepem środkowym

### Prostownik i filtracja

- `D1`, `D2` — `BYV26C`
- prostownik dwudiodowy z odczepem środkowym
- `C1` — `47 µF / 25 V`, Panasonic FR
- `C2`, `C3` — `100 nF`

### Stabilizacja i wyjście LED

- `U1` — `LM78L05ACZ`
- `R1` — `3.3 kΩ`
- `RV1` — `5 kΩ`, Bourns 3386P
- `J2` — JST XH 2-pin do diody LED montowanej w panelu przednim
- dioda LED nie znajduje się na PCB

## Bezpieczeństwo i DFM

Rewizja `PCB2-PCB-04R2` zawiera:

- regułę odstępu 6 mm między domenami MAINS i SELV,
- otwory montażowe M3 jako NPTH,
- keepout miedzi wokół otworów,
- brak przelotek,
- osobne pliki wierceń PTH i NPTH,
- oznaczenia `L`, `N`, `LED+`, `0V`,
- aktualne oznaczenie rewizji na sitodruku.

## Pliki projektu

```text
pcb-psu-led.kicad_pro
pcb-psu-led.kicad_sch
pcb-psu-led.kicad_pcb
pcb-psu-led.kicad_sym
pcb-psu-led.kicad_dru
sym-lib-table
fp-lib-table
PSU_LED.pretty/
.github/workflows/kicad-validate.yml
.github/workflows/kicad-manufacturing.yml
README.md
```

## Walidacja CI

### KiCad Validate

Workflow `.github/workflows/kicad-validate.yml` wykonuje pełny DRC, bramkujący DRC tylko dla błędów, pełny ERC, bramkujący ERC oraz eksport podglądów SVG.

### KiCad Manufacturing

Workflow `.github/workflows/kicad-manufacturing.yml`:

1. sprawdza rewizję PCB,
2. ponownie wykonuje bramkujący DRC i ERC,
3. generuje Gerbery,
4. generuje osobne pliki PTH i NPTH,
5. generuje mapy wierceń,
6. generuje IPC-D-356,
7. tworzy raporty i manifest SHA-256,
8. zapisuje komplet produkcyjny bezpośrednio w repo.

## Aktualny wynik walidacji

```text
Validation exit code: 0

PCB DRC gating:
- 0 violations
- 0 unconnected pads
- 0 footprint errors

ERC:
- 0 errors
- 0 warnings

Full DRC:
- 3 informational lib_footprint_mismatch warnings
```

## Pliki produkcyjne

Komplet produkcyjny znajduje się w:

```text
production/PCB2-PCB-04R2/
```

Manifest potwierdza wygenerowanie kompletu w KiCad 10.0.4 z rewizji `PCB2-PCB-04R2`.

### Gerbery

```text
gerbers/pcb-psu-led-top_cu.gbr
gerbers/pcb-psu-led-bottom_cu.gbr
gerbers/pcb-psu-led-F_Mask.gbr
gerbers/pcb-psu-led-B_Mask.gbr
gerbers/pcb-psu-led-F_Silkscreen.gbr
gerbers/pcb-psu-led-B_Silkscreen.gbr
gerbers/pcb-psu-led-Edge_Cuts.gbr
```

### Wiercenia

```text
drill/pcb-psu-led-PTH.drl
drill/pcb-psu-led-NPTH.drl
```

### Pliki dodatkowe

```text
gerbers/pcb-psu-led-job.gbrjob
netlist/pcb-psu-led.d356
```

## Parametry zamówienia

```text
2 layers
140 × 80 mm
FR-4
1.6 mm
1 oz copper
solder mask both sides
silkscreen both sides
no panelization
no controlled impedance
no V-score
no edge plating
no castellated holes
```

### Uwaga o Gerber Job

Plik `pcb-psu-led-job.gbrjob` może zawierać metadane niezgodne z faktycznym zamówieniem, w szczególności informację o kontrolowanej impedancji.

Przy zamówieniu ustaw:

```text
Controlled Impedance: No
```

Jeżeli portal producenta błędnie interpretuje `.gbrjob`, prześlij tylko siedem Gerberów i dwa pliki wierceń.

## Historia bieżącej linii PCB

### PCB2-PCB-03

- pierwsza kompletna, trasowana wersja PCB,
- ujawnione problemy synchronizacji ze schematem i bibliotekami.

### PCB2-PCB-03R1

- synchronizacja nazw sieci i metadanych ze schematem,
- poprawa połączenia `J2.2 → CT_RAW`,
- 0 niepołączonych padów i 0 błędów footprintów.

### PCB2-PCB-03R2

- korekta sitodruku,
- redukcja ostrzeżeń DRC.

### PCB2-PCB-03R3

- zamrożenie krytycznych footprintów,
- pełna zgodność elektryczna schemat–PCB,
- osobny, blokujący DRC dla błędów.

### PCB2-PCB-04

- otwory montażowe M3 jako NPTH 3.2 mm,
- keepout miedzi wokół otworów,
- reguła bezpieczeństwa 6 mm między MAINS i SELV.

### PCB2-PCB-04R1

- oznaczenia `L`, `N`, `LED+`, `0V`,
- aktualne oznaczenie rewizji,
- walidacja GitHub Actions: PASS,
- wygenerowany komplet produkcyjny dla wariantu 2 oz.

### PCB2-PCB-04R2

- zmiana miedzi z 70 µm / 2 oz na 35 µm / 1 oz,
- zachowanie nominalnej grubości PCB 1.6 mm,
- aktualizacja stackupu i sitodruku,
- aktualny wariant produkcyjny gałęzi `pcb2`,
- rewizja wymaga ponownej walidacji i wygenerowania plików produkcyjnych.
