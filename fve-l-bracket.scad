//// ============================================================
// FVE L-Bracket — Rohová spojka pro hliníkový H-profil
// ============================================================
// Pravoúhlý insert: jedno rameno do drážky profilu A (osa X),
// druhé rameno (90°) do drážky profilu B (osa Y).
// Pro 3D tisk (FDM), materiál PETG nebo ABS.
//
// Průřez insertu = kříž (vyplňuje celý H-profil):
//
//       ┌───┐          ← 2mm hrdlo, šířka 9mm
//       │   │
//   ┌───┘   └───┐
//   │   14mm    │     ← 7mm příruba (dolní dutina)
//   └───┐   ┌───┘
//       │   │          ← 13mm střed, šířka 9mm
//       │   │
//       │   │
//       └───┘          
//
// Rozměry jsou INSERTU (vůle už zahrnuta uživatelem).
// ============================================================

// === ROZMĚRY PRŮŘEZU (KŘÍŽ) ===
stem_w    = 9;     // šířka úzkého středu (hrdla + střed)
flange_w  = 14;    // šířka příruby (v dutině)
flange_h  = 7;     // výška příruby
narrow_h  = 2;     // výška úzkého hrdla (nahoře + dole)
center_h  = 13;     // výška středové stěny
profile_h = 22;    // celková výška: 2+7+4+7+2 = 22
arm_y_ext = 45;

// === PARAMETRY DÍLU ===
arm_length = 70;   // délka každého ramena [mm]
transition = 15;   // přechodová zóna u rohu bez přírub [mm]

// === ZKOSENÍ KONCŮ ===
taper_len   = 3;                        // délka zkosení [mm]
taper_angle = 30;                       // úhel zkosení [°]
taper_inset = taper_len * tan(taper_angle);  // zúžení na stranu [~2.89 mm]

// === NÁBĚH PŘÍRUBY ===
flange_taper_len = 5;   // délka náběhu příruby [mm]

// === ODVOZENÉ POZICE (Z-osa = svisle) ===
// Průřez vycentrovaný na Z=0:
//   Z = -11 .. -9   → dolní hrdlo (stem_w)
//   Z =  -9 .. -2   → dolní příruba (flange_w)
//   Z =  -2 .. +2   → střed (stem_w)
//   Z =  +2 .. +9   → horní příruba (flange_w)
//   Z =  +9 .. +11  → horní hrdlo (stem_w)

flange_lo_z = -profile_h/2 + narrow_h;           // -9
flange_hi_z = profile_h/2 - narrow_h - flange_h; // +2

// ============================================================
// RAMENO PODÉL OSY X
// ============================================================
// Průřez v rovině YZ:
//   Y = šířka (stem_w nebo flange_w), Z = výška (profile_h)
//   Příruby rozšiřují v Y

module arm_x(x_start, x_end, with_flanges = true, flange_offset = 0, flange_end_offset = 0) {
    len = x_end - x_start;

    // Dřík (stem) — plná výška, úzký
    translate([x_start, -stem_w/2, -profile_h/2])
        cube([len, stem_w, profile_h]);

    if (with_flanges) {
        translate([x_start + flange_offset, -flange_w/2, flange_hi_z])
            cube([len - flange_offset - flange_end_offset, flange_w, flange_h]);
    }
}

// ============================================================
// RAMENO PODÉL OSY Y
// ============================================================
// Průřez v rovině XZ:
//   X = šířka (stem_w nebo flange_w), Z = výška (profile_h)
//   Příruby rozšiřují v X
//   STEJNÁ Z-orientace jako rameno X → příruby ve stejné výšce

module arm_y(y_start, y_end, with_flanges = true, flange_offset = 0, flange_end_offset = 0) {
    len = y_end - y_start;

    // Dřík (stem) — plná výška, úzký
    translate([-stem_w/2, y_start, -profile_h/2])
        cube([stem_w, len, profile_h]);

    if (with_flanges) {
        translate([-flange_w/2, y_start + flange_offset, flange_hi_z])
            cube([flange_w, len - flange_offset - flange_end_offset, flange_h]);
    }
}

// ============================================================
// ZKOSENÍ KONCE RAMENA (hull mezi plným a zúženým průřezem)
// ============================================================

module taper_x() {
    hull() {
        // Plný průřez na začátku zkosení
        translate([arm_length - taper_len, -stem_w/2, -profile_h/2])
            cube([0.01, stem_w, profile_h]);
        // Zúžený průřez na špičce
        translate([arm_length,
                   -stem_w/2 + taper_inset,
                   -profile_h/2 + taper_inset])
            cube([0.01,
                  stem_w - 2*taper_inset,
                  profile_h - 2*taper_inset]);
    }
}

module taper_y() {
    hull() {
        // Plný průřez na začátku zkosení
        translate([-stem_w/2, arm_length - taper_len, -profile_h/2])
            cube([stem_w, 0.01, profile_h]);
        // Zúžený průřez na špičce
        translate([-stem_w/2 + taper_inset,
                   arm_length,
                   -profile_h/2 + taper_inset])
            cube([stem_w - 2*taper_inset,
                  0.01,
                  profile_h - 2*taper_inset]);
    }
}

// ============================================================
// NÁBĚH PŘÍRUBY (hull ze stem_w na flange_w)
// ============================================================

module flange_taper_x(x_pos) {
    hull() {
        // Začátek: šířka stem_w (na úrovni dříku)
        translate([x_pos, -stem_w/2, flange_hi_z])
            cube([0.01, stem_w, flange_h]);
        // Konec: plná šířka flange_w
        translate([x_pos + flange_taper_len, -flange_w/2, flange_hi_z])
            cube([0.01, flange_w, flange_h]);
    }
}

module flange_taper_y(y_pos) {
    hull() {
        // Začátek: šířka stem_w (na úrovni dříku)
        translate([-stem_w/2, y_pos, flange_hi_z])
            cube([stem_w, 0.01, flange_h]);
        // Konec: plná šířka flange_w
        translate([-flange_w/2, y_pos + flange_taper_len, flange_hi_z])
            cube([flange_w, 0.01, flange_h]);
    }
}

// Koncový náběh příruby (z flange_w zpět na stem_w)

module flange_taper_x_end(x_pos) {
    hull() {
        // Začátek: plná šířka flange_w
        translate([x_pos, -flange_w/2, flange_hi_z])
            cube([0.01, flange_w, flange_h]);
        // Konec: zúženo na stem_w
        translate([x_pos + flange_taper_len, -stem_w/2, flange_hi_z])
            cube([0.01, stem_w, flange_h]);
    }
}

module flange_taper_y_end(y_pos) {
    hull() {
        // Začátek: plná šířka flange_w
        translate([-flange_w/2, y_pos, flange_hi_z])
            cube([flange_w, 0.01, flange_h]);
        // Konec: zúženo na stem_w
        translate([-stem_w/2, y_pos + flange_taper_len, flange_hi_z])
            cube([stem_w, 0.01, flange_h]);
    }
}

// ============================================================
// L-BRACKET SESTAVA
// ============================================================
module l_bracket() {

    // --- Rameno A podél osy X (otočeno 90° kolem X) ---
    // Průřez pootočen: příruby rozšiřují v Z místo Y
    rotate([270, 0, 0]) {
        // Přechodová zóna (jen dřík, bez přírub)
        color("SteelBlue")
            arm_x(0, transition, with_flanges = false);

        // Hlavní část (plný kříž, zkrácená o taper)
        color("SteelBlue")
            arm_x(transition, arm_length - taper_len,
                  with_flanges = true,
                  flange_offset = flange_taper_len,
                  flange_end_offset = flange_taper_len);

        // Náběh příruby — začátek (rampa stem_w → flange_w)
        color("SteelBlue")
            flange_taper_x(transition);

        // Náběh příruby — konec (rampa flange_w → stem_w)
        color("SteelBlue")
            flange_taper_x_end(arm_length - taper_len - flange_taper_len);

        // Zkosení konce
        color("Lime")
            taper_x();
    }


    // --- Rameno B podél osy Y ---
    // Přechodová zóna (jen dřík, bez přírub)
    rotate([0, 90, 0]) {
        color("Coral")
        arm_y(-arm_y_ext, arm_y_ext+transition, with_flanges = false);

    // Hlavní část (plný kříž, zkrácená o taper)
        color("Coral")
        arm_y(transition, arm_length - taper_len,
              with_flanges = true,
              flange_offset = flange_taper_len,
              flange_end_offset = flange_taper_len);

        // Náběh příruby — začátek (rampa stem_w → flange_w)
        color("Coral")
        flange_taper_y(transition);

        // Náběh příruby — konec (rampa flange_w → stem_w)
        color("Coral")
        flange_taper_y_end(arm_length - taper_len - flange_taper_len);

        // Zkosení konce
        color("Lime")
        taper_y();
    }
    
}

// === RENDER ===
l_bracket();

// === INFO ===
echo(str("=== FVE L-Bracket ==="));
echo(str("Délka ramena: ", arm_length, " mm"));
echo(str("Průřez kříž: stem ", stem_w, "×", profile_h,
         ", příruby ", flange_w, "×", flange_h, " mm"));
echo(str("Přechodová zóna: ", transition, " mm"));
