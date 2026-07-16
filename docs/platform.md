# PSU LED — specyfikacja platformy

Dokument źródłowy projektu PCB. Zawiera fakty zewnętrzne (karta katalogowa, norma,
dokument nadrzędny), których nie wolno wyprowadzać z pamięci ani z plików KiCada.

**Nadrzędność:**

1. Karta katalogowa producenta — dla faktów o elemencie.
2. `PSU_230_100V_PL50LII Rev. 6.4.1` — dla architektury układu i ograniczeń systemowych.
3. Ten plik — dla decyzji dotyczących samej płytki.

W razie sprzeczności między tym plikiem a kartą katalogową: **wygrywa karta**, a plik
idzie do poprawy przez ECO.

---

## 1. Czym jest ta płytka

Izolowany galwanicznie zasilacz pomocniczy dla **diody sygnalizacyjnej**. Nic więcej.

- Nie jest częścią toru 230 V → 100 V. Zasila wyłącznie wskaźnik `ON` na panelu przednim.
- Zastępuje dotychczasową płytkę uniwersalną `PC4` montowaną warsztatowo.
- Architektura układu jest **zamknięta i zwalidowana na stole**. Ten projekt jest
  **transkrypcją na laminat**, a nie projektowaniem elektroniki od nowa.
- Traktowana jako **platforma wielokrotnego użytku** — ta sama goła płytka ma obsłużyć
  przyszłe projekty ze wskaźnikiem LED, w duchu `ANEKS 8.1 P2-R4` (PCB INLET).

Ryzyko tego projektu leży w **warstwie fizycznej** (bariera izolacyjna, geometria
wyprowadzeń, lustrzanie footprintów), nie w schemacie.

---

## 2. Fakty z karty katalogowej Talema 700xxK

Źródło: `Toroidal PC Transformers 1.6VA - 50VA`, talema.com, plik `700xxK.pdf`.

### 2.1 Dane elektryczne — 70000K

| Parametr | Wartość |
|---|---|
| Moc | **1.6 VA** |
| Pierwotne | **2 × 115 V**, 50-60 Hz |
| Wtórne | **2 × 7 V** |
| Prąd wtórny przy pełnym obciążeniu | 114 mA |
| Napięcie jałowe wtórnej | **2 × 8.9 V** |
| Regulacja (no load) | **29 %** |
| Sprawność | 77 % |
| Prąd jałowy (typ.) | 1.0 mA |
| Napięcie próby pierwotne-wtórne | **4.0 kV** |
| Klasa izolacji | A (105 °C), spełnia wymagania klasy E (120 °C) |
| Maks. temp. otoczenia | +60 °C (dla 1.6-25 VA) |

W serii **nie istnieje wariant 0.5 VA** — najniższa moc to 1.6 VA. Zapis `0,5 VA`
w `Rev. 6.4.1 §3.4` oraz `§5.3 T-02` jest **błędny** i podlega ECO w dokumencie
nadrzędnym. Pliki KiCada są zgodne z kartą.

### 2.2 Bezpiecznik pierwotny — wymóg producenta

| Parametr | Wartość dla 1.6 VA |
|---|---|
| **230V Fuse mA (Max.)** | **32 mA** |
| Rec. Fuse mA | 32 mA |

Talema **jawnie specyfikuje bezpiecznik pierwotny** — transformator nie jest
*inherently short-circuit proof* i zakłada zabezpieczenie zewnętrzne.

Prąd pierwotny znamionowy ≈ 1.6 VA / 230 V ≈ **7 mA**.

Kolumna jest indeksowana **mocą**, nie wariantem napięciowym → **32 mA obowiązuje całą
rodzinę 1.6 VA** i jest stałą platformową.

Bezpiecznik główny systemu (`Rev. 6.4.1 §4.3`: T500 mA / 250 V w module SCI PC-5,
FROZEN) jest **15.6× powyżej maksimum producenta** i nie zareaguje na żadną awarię
tego transformatora.

### 2.3 Dane mechaniczne — 1.6 VA

| Parametr | Wartość |
|---|---|
| Korpus L × W × H | **39.6 × 39.6 × 18.5 mm** |
| Masa | **82 g** |
| Pin Layout XY | **35.56 mm** |
| Pin Size | **1.0 × 0.5 mm**, prostokątny (przekątna **1.118 mm**) |
| Pin Availability | **1 - 16** |
| Mocowanie | **blind insert M4 × 6 deep** (dla 1.6-25 VA) |
| Długość wyprowadzeń pod korpusem | 5 mm |

Dla 35-50 VA mocowanie zmienia się na `M5 Through hole` — **nie dotyczy tej platformy**.

### 2.4 Wyprowadzenie geometrii pinów

Karta podaje `XY = 35.56 mm` (rozpiętość pola pinów) oraz raster **5.08 mm** z offsetem
**2.54 mm** od osi. `35.56 / 5.08 = 7` podziałek → **8 pozycji w kolumnie**.

Kolumna, `Pin Side View`, góra → dół:

```text
poz.   1     2     3     4        5     6     7     8
pin    6     5    20    28   [M4] 27    19     4     3
Y  -17.78 -12.70 -7.62 -2.54   +2.54 +7.62 +12.70 +17.78
```

`Pin Availability 1-16` → pozycje **19, 20, 27, 28 nie są obsadzone** na 1.6 VA.

**Zostają: 6, 5, 4, 3 przy Y = −17.78, −12.70, +12.70, +17.78.**

Kolumna wtórna (11, 12, 13, 14) leży symetrycznie przy tych samych Y, w odległości
`X = 35.56 mm`.

### 2.5 Reguły połączeń — cytat z karty

```text
For 230 volt operation, connect primaries in series by connecting
pins 5 & 4 together and apply 230 volts across pins 6 & 3

To place the secondaries in series, connect pins 13 to 12 and take
the output across pins 14 & 11
```

Schemat projektu realizuje **dokładnie te dwie reguły** — zweryfikowane pin po pinie.

### 2.6 Normy

Recognized to **UL5085** (70000K do 70065K), **UL62368-1** oraz **IEC62368-1**.

Normą odniesienia dla odstępów izolacyjnych tej płytki jest **IEC 62368-1**.

---

## 3. Ograniczenia z Rev. 6.4.1

### 3.1 BOM gałęzi pomocniczej (§3.4, §5.5)

| Ref | Element | Uwagi |
|---|---|---|
| J1 | wejście 230 V (`L_SW`, `N_SW`) | MPN otwarty |
| F1 | T32 mA / 250 V zwłoczny | wg karty, poza modułem SCI PC-5 |
| T1 | Talema 70000K | 1.6 VA, 2×115 V → 2×7 V |
| D1, D2 | Vishay BYV26C | `CT = GND`, konfiguracja pełnofazowa |
| C1 | Panasonic FR 47 µF / 25 V / 105 °C | E-06 |
| U1 | LM78L05ACZ, TO-92 | E-07, `V_out = 5 V` |
| C2, C3 | 100 nF X7R | E-08, bypass U1 |
| R1 | Vishay PR02 **680 Ω / 0.6 W** | E-09, **FROZEN**, zakaz 560 Ω |
| RV1 | Bourns 3296W 10 kΩ cermet | E-04, regulacja jasności |
| J2 | JST XH 2-pin | E-10, wyjście na LED |
| — | Kingbright L-7104EC, 617-620 nm, `I_f < 1 mA` | E-03, **na panelu, nie na płytce** |

`E-05` podaje ilość mostka BYV26C jako `1 szt.` — topologia `CT = GND` pełnofazowa
wymaga **dwóch diod**. Pliki KiCada (D1 + D2) są poprawne; BOM podlega ECO.

`E-16` (snubber RC wtórny, WIMA MKP10) należy do toru 100 V — **nie do tej płytki**.

### 3.2 Ograniczenia konstrukcyjne

| Wymóg | Źródło | Status |
|---|---|---|
| Creepage 230 V ↔ 5 V: **min. 6 mm** | checklist Rev. 6.4.1 | wymóg DRC |
| Routing **liniowy**: 230 V z lewej → 5 V z prawej → LED; brak pętli | checklist Rev. 6.4.1 | wymóg placementu |
| Bezpiecznik główny T500 mA w SCI PC-5 | §4.3 | **FROZEN**, nie modyfikować |
| NKK M2022SS4W01 **DPDT** — rozłącza L i N | §3.2 krok 4 | polaryzacja L/N rozstrzygnięta |
| `J1.1 = L_SW`, `J1.2 = N_SW` | §20 handoff | zrealizowane |

### 3.3 Weryfikacja bariery wobec IEC 62368-1

Warunki: 230 V robocze, kategoria przepięciowa **II**, stopień zanieczyszczenia **2**,
FR-4 grupy materiałowej **IIIa**.

Izolacja wzmocniona wymaga rzędu **5 mm** creepage i **3 mm** clearance.
**Zamrożone 6 mm mieści się nad wymaganiem wzmocnionej.**

Przyjęte: **6 mm jako wymóg DRC**, 8 mm jako cel projektowy tam, gdzie geometria pozwoli.

---

## 4. Macierz wariantów platformy

Oś wariantowości **istnieje w karcie katalogowej** — nie jest wymyślona.

### 4.1 Transformator — jeden footprint, sześć wariantów

Cała rodzina 1.6 VA dzieli **identyczną mechanikę**: `39.6 × 39.6 × 18.5`, `XY 35.56`,
`availability 1-16`, `blind insert M4 × 6`, `230V Fuse 32 mA`.

| MPN | Wtórne | Jałowe | Pełne obciążenie |
|---|---|---|---|
| **70000K** | 2 × 7 V | 2 × 8.9 V | 114 mA |
| 70001K | 2 × 9 V | 2 × 11.6 V | 89 mA |
| 70002K | 2 × 12 V | 2 × 15.4 V | 67 mA |
| 70003K | 2 × 15 V | 2 × 19.3 V | 53 mA |
| 70004K | 2 × 18 V | 2 × 23.4 V | 44 mA |
| 70005K | 2 × 22 V | 2 × 28.2 V | 36 mA |

Ta sama goła płytka pokrywa napięcie surowe od ~11 V do ~35 V.

### 4.2 Macierz

| Oś | Rezerwa platformowa | Wariant obecny |
|---|---|---|
| T1 | dowolny 7000xK 1.6 VA — jeden footprint | 70000K (2 × 7 V) |
| U1 | dowolny 78Lxx TO-92 (3.3/5/6/8/9/10/12/15 V) | LM78L05ACZ (5 V) |
| F1 | **T32 mA / 250 V** — stała dla rodziny 1.6 VA | tak samo |
| C1 | Ø5-8 mm, raster 2.5/5.0, napięcie dobrane do wariantu T1 | 47 µF / 25 V FR |
| Gałąź LED | R1 + RV1 | 680 Ω + 3296W 10 kΩ |
| Emiter | J2 → LED poza płytką | Kingbright L-7104EC |

**Nie jest wariantem:** geometria bariery izolacyjnej. Wynika z 230 V i normy,
nie z BOM-u — pozostaje zamrożona niezależnie od obsady.

### 4.3 Weryfikacja obecnego wariantu

Przy ~20 mA (18 % z 114 mA) i regulacji 29 %:

```text
V_sec  ≈ 8.6 V
V_peak ≈ 8.6 × 1.414 − 0.9 ≈ 11.3 V DC
sieć +10 % (253 V)         ≈ 12.4 V DC   ← przypadek projektowy
```

`C1 = 47 µF / 25 V` dobrane prawidłowo. 16 V byłoby na styk.
`LM78L05` — wejście 12.4 V przy `V_in max` 30 V, z zapasem.

Prąd LED: `(5 − 1.9) / 680 ≈ 4.6 mA` maks.; z RV1 10 kΩ w szeregu schodzi do ~0.3 mA.
Wymóg `I_f < 1 mA` osiągalny pokrętłem.

---

## 5. Reguły platformowe

### 5.1 Format plików

- Pole `Datasheet` **nigdy `~`** — zawsze `""` lub pełny URL.
  Legacy placeholder `~` jest normalizowany asymetrycznie między parserem biblioteki
  a parserem cache w schemacie i wywołuje `lib_symbol_mismatch` (przyczyna ECAD-09).
- Zmiana symbolu w `pcb-psu-led.kicad_sym` **musi** trafić w tym samym commicie do
  `lib_symbols` w `pcb-psu-led.kicad_sch`. Rozjazd = `lib_symbol_mismatch`.

### 5.2 Pułapki lustrzane

- **Talema 70000K** — karta pokazuje `Pin Side View` (widok od spodu). Footprint jest
  widokiem od góry płytki, czyli **odbiciem**. Wykonane i zweryfikowane.
  Placement: `rot=180`, żeby sito `PRIMARY / MAINS` patrzyło na J1.
- **LM78L05 TO-92** — ST rysuje pinout jako **bottom view**. Pinout jest **odwrotny
  niż w 7805**:

```text
78L05 TO-92:   1 = VOUT    2 = GND    3 = VIN
7805  TO-220:  1 = VIN     2 = GND    3 = VOUT
```

  Płaska ścianka do obserwatora, nóżki w dół: **lewa = wyjście, środek = masa,
  prawa = wejście**. Odwrócenie tego elementu podaje napięcie wejściowe na wyjście.

### 5.3 Taksonomia ECO

| Prefiks | Zakres |
|---|---|
| `ECAD-xx` | schemat, symbole, footprinty, fabrykacja |
| `DOC-xx` | dokumentacja |
| `CI-xx` | workflow walidacyjny |

Jedna logiczna zmiana = jeden commit. Zmiany w kilku plikach należące do jednego ECO
trafiają do **jednego** commitu razem z aktualizacją `README.md`.

### 5.4 Walidacja

Wyłącznie przez GitHub Actions. Obraz `ghcr.io/kicad/kicad:10.0-full` — zamrożona
**seria 10.0**, konkretny patch raportowany w runtime (`kicad-version.txt`).
Rejestr kicad-docker publikuje obrazy z opóźnieniem względem wydań binarnych,
dlatego zamrażana jest seria, a nie patch.

### 5.5 Gałąź pcb2

Równoległy projekt drugiego zespołu. Wspólny przodek: **ECAD-11**.
**Nie mergować, nie cherry-pickować, nie porównywać.** Własna pula `PCB2-xx`.

`CI-PCB2-01` przestawił tam wyzwalacz workflow z `main` na `pcb2` — merge tej gałęzi
do `main` **wyłączyłby CI na main po cichu**.

---

## 6. Weryfikacje wykonane

| Co | Wynik | Kiedy |
|---|---|---|
| Footprint Talema — geometria wobec karty | wszystkie współrzędne zgodne, lustrzanie poprawne | ECAD-12 |
| Footprint Talema — wiertło | Ø1.3 → **Ø1.5**; przekątna pinu 1.118 mm, IPC nominalnie 1.37 | ECAD-12 |
| Schemat — pierwotna | `5↔4` zwarte, 230 V na `6 & 3` — zgodne z kartą | — |
| Schemat — wtórna | `12↔13 = CT`, wyjście na `11 & 14` — zgodne z kartą | — |
| Pinout U1 | `1=VOUT, 2=GND, 3=VIN` — zgodny z ST/TI | — |
| Bariera 6 mm | powyżej wymagania izolacji wzmocnionej IEC 62368-1 | — |

---

## 7. Pozycje otwarte

| # | Pozycja | Blokuje |
|---|---|---|
| 1 | **Alokacja X/Y/Z płytki i Talemy w bazie Valchromat** — brak w Rev. 6.4.1 | layout |
| 2 | Obrys i mocowanie — do zaproponowania przez projekt, do wpasowania przez Rev. 6.4.1 | layout |
| 3 | MPN złącza J1 | BOM |
| 4 | F1: 5×20 z klipsami (~32 mm) czy TR5 (8.5 mm) — decyzja przestrzenna | placement |
| 5 | ECO w dokumencie nadrzędnym: `0,5 VA` → `1.6 VA`; `E-05` ilość `1` → `2` | Rev. 6.4.1 |

**Uwaga mechaniczna:** 82 g wisi na jednej śrubie M4 wkręconej od spodu w blind insert
oraz ośmiu pinach 1.0 × 0.5 mm. Płytka wymaga podparcia bezpośrednio przy T1.
