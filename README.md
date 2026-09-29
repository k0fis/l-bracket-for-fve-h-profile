# FVE L-Bracket — Rohová spojka pro hliníkový H-profil

## Co to je

**Rohová spojka** (L-bracket insert) pro hliníkový H-profil z fotovoltaické konstrukce (FVE).

Díl ve tvaru **L** se zasune do T-drážky jednoho profilu jedním ramenem a druhým ramenem do kolmého profilu. Drží pravý úhel a rovinu mezi dvěma lištami.

Obě ramena jsou vzájemně **otočená** — každé odpovídá orientaci drážky svého profilu:

- **Rameno A** (osa X): otočeno 270° kolem X
- **Rameno B** (osa Y): otočeno 90° kolem Y, s rozšířenou přechodovou zónou (±45 mm)

## Profil

H-profil 40×45 mm (solární montážní lišta). Průřez drážky (tvar kříže):

```
     ┌───┐         ← 2 mm hrdlo, šířka 9 mm
     │   │
┌────┘   └────┐
│   14 mm     │    ← 7 mm dutina
└────┐   ┌────┘
     │   │         
     │   │         
     │   │
     └───┘         ← 13 mm hrdlo, šířka 9 mm
```

Celková výška profilu: **22 mm**

## Parametry modelu

### Průřez

| Parametr | Hodnota | Popis |
|----------|---------|-------|
| `stem_w` | 9 mm | Šířka úzkého středu (hrdlo + střed) |
| `flange_w` | 14 mm | Šířka příruby (v dutině) |
| `flange_h` | 7 mm | Výška příruby |
| `narrow_h` | 2 mm | Výška úzkého hrdla |
| `center_h` | 13 mm | Výška středové stěny |
| `profile_h` | 22 mm | Celková výška průřezu |

### Rozměry dílu

| Parametr | Hodnota | Popis |
|----------|---------|-------|
| `arm_length` | 70 mm | Délka každého ramena |
| `transition` | 15 mm | Přechodová zóna u rohu (bez přírub) |
| `arm_y_ext` | 45 mm | Rozšíření přechodové zóny ramena Y |

### Zkosení a náběhy

| Parametr | Hodnota | Popis |
|----------|---------|-------|
| `taper_len` | 3 mm | Délka zkosení na konci ramena |
| `taper_angle` | 30° | Úhel zkosení špičky |
| `flange_taper_len` | 5 mm | Délka náběhu příruby (začátek i konec) |

Rozměry jsou **hotového insertu** — vůli si uživatel zahrnuje sám.

## Struktura ramena

Každé rameno se skládá z 5 zón (od rohu ke konci):

```
  Roh                                                  Konec
   │                                                     │
   ├── Přechodová zóna ──┤                               │
   │   (jen dřík)        │                               │
                         ├─ Náběh ─┤         ├─ Náběh ─┤ │
                         │ příruby │         │ příruby │ │
                                   ├─ Plná ──┤         │ │
                                   │ příruba │         │ │
                                                       ├─┤
                                                       │Z│
   ╠═════════════════════╬═════════╬═════════╬═════════╬═╣
   0                    15        20        62        67 70
                    transition  +ft_len  -ft_len  -taper
```

1. **Přechodová zóna** (0–15 mm) — jen dřík bez přírub, snazší zasunutí
2. **Náběh příruby** (15–20 mm) — hull rampa ze stem_w (9) na flange_w (14)
3. **Plná příruba** (20–62 mm) — plný křížový průřez, zámek v drážce
4. **Výběh příruby** (62–67 mm) — hull rampa z flange_w (14) zpět na stem_w (9)
5. **Zkosení špičky** (67–70 mm) — symetrické zúžení dříku (30°)

## Soubory

- `fve-l-bracket.scad` — parametrický OpenSCAD model
- `H profile_insert.png` — ruční náčrtek profilu

## Export STL

V OpenSCAD:

1. **F6** (Render) — přepne z preview na plný CGAL render
2. **File → Export as STL** — uloží mesh pro slicer
3. Importovat do sliceru (PrusaSlicer, Cura, …)

## Tisk

- **Materiál**: PETG nebo ABS (odolnost UV a teplu na střeše)
- **Orientace**: na bok — jedno rameno leží na tiskové ploše, druhé směřuje nahoru. Roh bude potřebovat **support**.
- **Výplň**: 60–80 % (mechanická odolnost)
- **Vrstva**: 0.2 mm
- **Stěny**: min. 3 perimetry (pro pevnost v drážce)

### Poznámky k tisku

- Zkosení konců (taper) a náběhy přírub (flange taper) pomáhají zasouvání do drážky
- Náběhy přírub jsou hull-based rampy — tisknou se bez problémů, úhel je dostatečně pozvolný
- Po tisku ověřit fit v reálném profilu; případně upravit rozměry (přidat/ubrat vůli)
- Pro venkovní použití: PETG odolává UV lépe, ABS má vyšší teplotní odolnost

## Stav

- [x] Náčrtek a rozměry profilu
- [x] Parametrický OpenSCAD model
- [x] Rotace ramen (odpovídá reálné orientaci profilů)
- [x] Zkosení konců ramen (taper)
- [x] Náběhy přírub (začátek + konec)
- [ ] Ověřit rozměry na reálném profilu (posuvné měřítko)
- [ ] Test tisk a fit-check
- [ ] Případná úprava vůle
