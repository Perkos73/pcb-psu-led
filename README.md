# PCB PSU LED

Moduł zasilania i sterowania diody LED dla customowego zasilacza step-down 230 V → 100 V.

## Status projektu

- Aktualna rewizja elektryczna: **ECAD-09**
- Status ERC: **0 errors / 0 warnings**
- Walidacja: wyłącznie przez **GitHub Actions**
- Wersja KiCad w CI: **10.0.4**
- Gałąź robocza: `main`

Checkpoint ECAD-09 jest zamrożony. Symbol J1, jego piny, pola, UUID, położenie oraz połączenia nie powinny być zmieniane bez osobnego ECO.

## Zatwierdzona topologia

### Wejście sieciowe

Lokalny symbol:

- `J1`
- `J1.1 = L_SW`
- `J1.2 = N_SW`

Połączenia:

- `L_SW → T1.6`
- `N_SW → T1.3`
- `T1.5 ↔ T1.4 = PRI_LINK_5_4`

### Uzwojenie wtórne i prostownik

- `T1.12 ↔ T1.13 = CT_RAW`
- `T1.11 → SEC_A → anoda D2`
- `T1.14 → SEC_B → anoda D1`
- katody `D1` i `D2 → VRAW_PLUS`
- `D1`, `D2 = BYV26C`

### Transformator

- `T1 = Talema 70000K`
- lokalny symbol i footprint przechodzą walidację CI

## Pliki projektu

- `pcb-psu-led.kicad_pro` — plik projektu KiCad
- `pcb-psu-led.kicad_sch` — schemat
- `pcb-psu-led.kicad_sym` — lokalna biblioteka symboli
- `PSU_LED.pretty/Talema_70000K.kicad_mod` — lokalny footprint transformatora
- `sym-lib-table` — mapowanie lokalnej biblioteki symboli
- `fp-lib-table` — mapowanie lokalnej biblioteki footprintów
- `.github/workflows/kicad-validate.yml` — workflow walidacyjny

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
Full ERC report:      0 errors / 0 warnings
```

## Zasady pracy

- jedna logiczna zmiana na commit,
- bez lokalnej walidacji,
- walidacja wyłącznie przez GitHub Actions,
- bez ZIP-ów,
- pliki przekazywane pojedynczo z kanonicznymi nazwami,
- bez dużych generatorów i masowego nadpisywania plików,
- zmiany w kilku plikach należące do jednego ECO muszą trafić do jednego commitu,
- przed kolejnym etapem elektrycznym wymagane jest zielone CI.

## Historia ostatnich rewizji

### ECAD-08

- kanonizacja zapisu `pin_names` dla J1:
  - z legacy `hide`
  - na `(hide yes)`

Zmiana nie usunęła ostrzeżenia `lib_symbol_mismatch`.

### ECAD-09

- ujednolicenie pola `Datasheet` symbolu `Conn_01x02`
- ustawienie pustego ciągu `""` w bibliotece oraz osadzonej kopii symbolu

Ta zmiana usunęła `lib_symbol_mismatch`.

## Następny etap

Po zatwierdzeniu tego README jako osobnego commitu dokumentacyjnego można rozpocząć **ECAD-10** — kolejny etap rozbudowy schematu.

Commit dokumentacyjny:

```text
DOC-01: add project README
```
