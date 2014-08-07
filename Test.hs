module DivanTest where

import Divan.Syllable
import Divan.Vezin
import Divan.Tefile
import Test.HUnit

tests ::  Test
tests = TestList $ map TestCase
  [
  -- Syllable tests
    assertEqual "Syllablize \"birbirlerine\""       ["bir", "bir", "le", "ri", "ne"]         (syllablize "birbirlerine")
  , assertEqual "Syllablize \"kafiyelendirmiştir\"" ["ka","fi","ye","len","dir","miş","tir"] (syllablize "kafiyelendirmiştir")
  , assertEqual "Syllablize \"hayatında\""          ["ha","ya","tın","da"]                   (syllablize "hayatında")
  , assertEqual "Syllablize \"ece\""                ["e", "ce"]                              (syllablize "ece")
  , assertEqual "Syllablize \"mef'ûlü\""            ["mef","û","lü"]                         (syllablize "mef'ûlü")
  , assertEqual "Syllablize \"müfte'ilün\""         ["müf","te","i","lün"]                   (syllablize "müfte'ilün")
  -- Vezin tests
  , assertEqual "Read Vezin \".-.-\""       (Just [Open,Closed,Open,Closed])   (readVezin ".-.-")
  , assertEqual "Read Vezin \"--.-\""       (Just [Closed,Closed,Open,Closed]) (readVezin "--.-")
  , assertEqual "Detect Syl. Vezin \"gön\"" [Closed]                           (detectSyllableVezin "gön")
  , assertEqual "Detect Syl. Vezin \"ne\""  [Open]                             (detectSyllableVezin "ne")
  , assertEqual "Detect Syl. Vezin \"a\""   [Open]                             (detectSyllableVezin "a")
  , assertEqual "Detect Syl. Vezin \"her\"" [Closed]                           (detectSyllableVezin "her")
  , assertEqual "Detect Syl. Vezin \"fâ\""  [Closed]                           (detectSyllableVezin "fâ")
  , assertEqual "Detect Syl. Vezin \"dâh\"" [Closed,Open]                      (detectSyllableVezin "dâh")

  -- Poem line vezin tests
  , assertEqual "Detect Sent.Vezin \"Nedir bu gizli gizli âhlar çâk-i girîbanlar\""
                ".-.-.-.---..---"   ((showVezin . detectSentenceVezin) "Nedir bu gizli gizli âhlar çâk-i girîbanlar")
  , assertEqual "Detect Sent.Vezin \"Aceb bir şûha sen de âşık-ı nâlân mısın kâfir\""
                ".---.-.-..--..---" ((showVezin . detectSentenceVezin) "Acebbir şûha sen de âşık-ı nâlân mısın kâfir")
  , assertEqual "Detect Sent.Vezin \"Yaraşır kim seni ser-defter-i hûban yazalar\""
                "..--..--..--..-"   ((showVezin . detectSentenceVezin) "Yaraşır kim seni ser-defter-i hûban yazalar")
  , assertEqual "Detect Sent.Vezin \"Nâme-i hüsnün için bir yeni unvan yazalar\""
                "-..-..--..--..-"   ((showVezin . detectSentenceVezin) "Nâme-i hüsnün için bir yeni unvan yazalar")
  , assertEqual "Detect Sent.Vezin \"Açılmaz ne bir yüz ne bir pencere\""
                ".--.--.--.."   ((showVezin . detectSentenceVezin) "Açılmaz ne bir yüz ne bir pencere")
  , assertEqual "Detect Sent.Vezin \"Bakıldıkça vahşet çöker yerlere\""
                ".--.--.--.."   ((showVezin . detectSentenceVezin) "Bakıldıkça vahşet çöker yerlere")

  -- Tefile tests
  , assertEqual "Tefile Lookup \".--\""               (Just "feûlün")                    (tefileLookup [Open,Closed,Closed])
  , assertEqual "Tefile Lookup \"-.--\""              (Just "fâilâtün")                  (tefileLookup [Closed,Open,Closed,Closed])
  -- Simple tefile detection tests
  , assertEqual "Detect Tefile \"[Open]\""            (Just ["fa"])                      (detectTefile [Open])
  , assertEqual "Detect Tefile \"[Closed, Closed]\""  (Just ["fa'lün"])                  (detectTefile [Closed,Closed])
  , assertEqual "Detect Tefile \"nereden\""           (Just ["feilün"])                  ((detectTefile . detectSentenceVezin) "nereden")
  , assertEqual "Detect Tefile \"nereden geliyor\""   (Just ["feilün","feilün"])         ((detectTefile . detectSentenceVezin) "nereden geliyor")
  -- Complex tefile detection tests
  , assertEqual "Detect Tefile \"..--..--..--..-\""
                (Just ["feilâtün","feilâtün","feilâtün","feilün"])        (detectSymbolsTefile "..--..--..--..-")
  , assertEqual "Detect Tefile \"-..-..--..--..-\""
                (Just ["müfteilün","feilâtün","feilâtün","feilün"])       (detectSymbolsTefile "-..-..--..--..-")
  , assertEqual "Detect Tefile \"Küçük, muttarid, muhteriz darbeler\""
                (Just ["mefâîlü","müstef'ilâtün","feûl"])                 ((detectTefile . detectSentenceVezin) "Küçük, muttarid, muhteriz darbeler")
  , assertEqual "Detect Tefile \"Kafeslerde, ramlarda pür' ihtizaz\"" -- we have to put an apostrophe to prevent `ulama` (liaison in French)
                (Just ["mefâîlü","müstef'ilâtün","feûl"])                 ((detectTefile . detectSentenceVezin) "Kafeslerde, ramlarda pür' ihtizaz")

  -- This test fails because the rule that the last syllable of a verse if ALWAYS closed isn't implemented yet. TODO!
  , assertEqual "Detect Tefile \"Dinle neyden kim hikâyet etmede\""
                (Just ["fâilâtün","fâilâtün","fâilün"])                 ((detectTefile . detectSentenceVezin) "Dinle neyden kim hikâyet etmede")
  -- Tefile equivalence tests
  , assertEqual "Tefile Equivalence \"[feûlün,feûlün,feûlün,feûl] and [mefâîlü,müstef'ilâtün,feûl]\"" True
                (["feûlün","feûlün","feûlün","feûl"] `equivalent` ["mefâîlü","müstef'ilâtün","feûl"])
  ]

runTests ::  IO ()
runTests = do
  _ <- runTestTT tests
  return ()

-- | For now, main will run our tests.
main :: IO ()
main = runTests
