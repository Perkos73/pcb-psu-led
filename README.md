# PCB PSU LED — gałąź `pcb2`

Alternatywna, niezależnie rozwijana wersja modułu zasilania i sterowania diody LED dla customowego zasilacza step-down 230 V → 100 V.

> Ten README opisuje wyłącznie stan gałęzi `pcb2`.  
> Dokumentacja gałęzi `main` pozostaje niezależna.

## Status projektu

- Gałąź robocza: `pcb2`
- Aktualna zatwierdzona rewizja PCB: **PCB2-PCB-04**
- Rewizja w przygotowaniu: **PCB2-PCB-04R1** — oznaczenia produkcyjne
- Schemat: kompletny i zsynchronizowany z PCB
- ERC: **0 errors / 0 warnings**
- DRC bramkujący, tylko błędy: **0 violations**
- Niepołączone pady: **0**
- Błędy zgodności schemat–PCB: **0**
- Pełny DRC: **3 informacyjne ostrzeżenia `lib_footprint_mismatch`**
- Walidacja: wyłącznie przez **GitHub Actions**
- KiCad w CI: seria **10.0.x**

Trzy ostrzeżenia pełnego DRC dotyczą lokalnie osadzonych kopii footprintów:

- `F1` — uchwyt bezpiecznika 5×20 mm
- `J2` — złącze JST XH 2-pin
- `T1` — Talema 70000K

Nie są to błędy elektryczne ani produkcyjne. Pełny raport pozostaje widoczny diagnostycznie, natomiast osobny DRC bramkujący zatrzymuje workflow przy rzeczywistych błędach.

## Parametry PCB

| Parametr | Wartość |
|---|---:|
| Wymiary | 140 × 80 mm |
| Warstwy miedzi | 2 |
| Materiał | FR-4 |
| Grubość laminatu | 1.6 mm |
| Miedź | 70 µm / 2 oz |
| Technologia | THT |
| Liczba komponentów | 12 |
| Liczba przelotek | 0 |
| Minimalna szerokość ścieżki | 0.60 mm |
| Minimalny odstęp ścieżek | 0.57 mm |
| Minimalna średnica wiercenia | 0.75 mm |

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
- napięcie wyjściowe układu: 5 V DC
- `R1` — `3.3 kΩ`
- `RV1` — `5 kΩ`, Bourns 3386P, użyty jako rezystor nastawny
- `J2` — JST XH 2-pin do diody LED montowanej w panelu przednim
- dioda LED nie znajduje się na PCB

## Najważniejsze sieci

```text
L_SW
N_SW
PRI_LINK_5_4
SEC_A
SEC_B
CT_RAW
VRAW_PLUS
PLUS_5V_LED
LED_ANODE_OUT
```

## Pliki projektu

```text
pcb-psu-led.kicad_pro
pcb-psu-led.kicad_sch
pcb-psu-led.kicad_pcb
pcb-psu-led.kicad_sym
sym-lib-table
fp-lib-table
PSU_LED.pretty/
.github/workflows/kicad-validate.yml
README.md
```

Biblioteka `PSU_LED.pretty` zawiera lokalne footprinty używane przez projekt, w tym transformator Talema oraz zamrożone kopie krytycznych footprintów F1 i J2.

## Walidacja CI

Workflow:

```text
.github/workflows/kicad-validate.yml
```

Uruchamia się po pushu do `pcb2` oraz ręcznie przez `workflow_dispatch`.

Walidacja obejmuje:

1. kontrolę obecności wymaganych plików,
2. weryfikację wersji KiCad,
3. eksport lokalnego symbolu i footprintu,
4. eksport netlisty,
5. statystyki PCB,
6. pełny DRC ze wszystkimi poziomami,
7. bramkujący DRC tylko dla błędów,
8. eksport podglądów SVG przodu i tyłu PCB,
9. pełny ERC,
10. bramkujący ERC tylko dla błędów.

Raporty są publikowane bezpośrednio w **GitHub Step Summary** i dodatkowo zapisywane jako artefakt workflow.

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

## Zasady pracy

- jedna logiczna zmiana na commit,
- walidacja wyłącznie przez GitHub Actions,
- raporty muszą być widoczne w logu i w GitHub Step Summary,
- bez paczek ZIP,
- pliki przekazywane pojedynczo pod kanonicznymi nazwami,
- przed kolejną rewizją należy sprawdzić aktualny stan gałęzi `pcb2`,
- przed zatwierdzeniem zmiany należy sprawdzić pełny DRC, DRC bramkujący i ERC.

## Historia bieżącej linii PCB

### PCB2-PCB-03

- pierwsza kompletna, trasowana wersja PCB,
- ujawnione problemy synchronizacji ze schematem i bibliotekami.

### PCB2-PCB-03R1

- synchronizacja nazw sieci i metadanych ze schematem,
- usunięcie błędów parytetu footprintów,
- poprawa połączenia `J2.2 → CT_RAW`,
- wynik: 0 niepołączonych padów i 0 błędów footprintów.

### PCB2-PCB-03R2

- korekta sitodruku,
- redukcja ostrzeżeń DRC z 10 do 4.

### PCB2-PCB-03R3

- zamrożenie krytycznych footprintów w bibliotece projektowej,
- finalna korekta sitodruku,
- pełna zgodność elektryczna schemat–PCB,
- osobny, blokujący DRC dla błędów.

### PCB2-PCB-04

- prawidłowe otwory montażowe M3 jako NPTH 3.2 mm,
- keepout miedzi wokół otworów,
- reguła bezpieczeństwa 6 mm między domenami MAINS i SELV,
- DRC bramkujący: 0 violations,
- aktualny zatwierdzony stan gałęzi `pcb2`.

### PCB2-PCB-04R1

- synchronizacja oznaczenia rewizji na sitodruku,
- jednoznaczne oznaczenia `L` i `N` przy J1,
- jednoznaczne oznaczenia `LED+` i `0V` przy J2,
- rewizja wymaga potwierdzenia przez GitHub Actions.
