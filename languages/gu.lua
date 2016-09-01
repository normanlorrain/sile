SILE.hyphenator.languages["gu"] = {}
SILE.hyphenator.languages["gu"].patterns =
   {
-- GENERAL RULE
-- Do not break either side of ZERO-WIDTH JOINER  (U+200D)
"2‍2",
-- Break on both sides of ZERO-WIDTH NON JOINER  (U+200C)
"1‌1",
-- Break before or after any independent vowel.
"અ1",
"આ1",
"ઇ1",
"ઈ1",
"ઉ1",
"ઊ1",
"ઋ1",
"ૠ1",
"એ1",
"ઐ1",
"ઓ1",
"ઔ1",
-- Break after any dependent vowel but not before.
"ા1",
"િ1",
"ી1",
"ુ1",
"ૂ1",
"ૃ1",
"ૄ1",
"ૢ1",
"ૣ1",
"ે1",
"ૈ1",
"ો1",
"ૌ1",
-- Break before or after any consonant.
"1ક",
"1ખ",
"1ગ",
"1ઘ",
"1ઙ",
"1ચ",
"1છ",
"1જ",
"1ઝ",
"1ઞ",
"1ટ",
"1ઠ",
"1ડ",
"1ઢ",
"1ણ",
"1ત",
"1થ",
"1દ",
"1ધ",
"1ન",
"1પ",
"1ફ",
"1બ",
"1ભ",
"1મ",
"1ય",
"1ર",
"1લ",
"1ળ",
"1વ",
"1શ",
"1ષ",
"1સ",
"1હ",
-- Do not break before chandrabindu, anusvara, visarga, avagraha
-- and accents.
"2ઁ1",
"2ઃ1",
"2ઽ1",
-- Do not break either side of virama (may be within conjunct).
"2્2",
"2ં2",
   }
