-- Insert SQL Rules Here 

-- Rename 'city state' to something more appropriate since they can have more than one city...
UPDATE Language_en_US SET Text = replace(Text, 'City State', 'Nation State') WHERE Text like '%City State%';

UPDATE Language_en_US SET Text = replace(Text, 'city state', 'nation state') WHERE Text like '%city state%';

UPDATE Language_en_US SET Text = replace(Text, 'City-State', 'Nation-State') WHERE Text like '%City-State%';

UPDATE Language_en_US SET Text = replace(Text, 'city-state', 'nation-state') WHERE Text like '%city-state%';

-- Override flavor expansion (often zero)
DELETE FROM MinorCivilization_Flavors WHERE FlavorType IN ('FLAVOR_EXPANSION');

INSERT INTO MinorCivilization_Flavors (MinorCivType, FlavorType, Flavor) SELECT DISTINCT MinorCivType, 'FLAVOR_EXPANSION', '3' FROM MinorCivilization_Flavors;

-- New (added) flavors for minor civs
-- Give every minor civ every flavor they don't already have, at a value of 3
INSERT INTO MinorCivilization_Flavors (MinorCivType, FlavorType, Flavor) SELECT DISTINCT C.MinorCivType, F.Type, '3' FROM MinorCivilization_Flavors C, Flavors F WHERE F.Type NOT IN (SELECT FlavorType FROM MinorCivilization_Flavors WHERE MinorCivType = C.MinorCivType);

-- New minor civ city names
-- INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) SELECT a.MinorCivType, b.CityName FROM MinorCivilization_CityNames a, MinorCivilization_Citynames b WHERE a.MinorCivType <> b.MinorCivType ORDER BY a.MinorCivType, random();

-- (new) Create a table for minor civ city names
CREATE TABLE MinorCivilization_Evolved( id INTEGER PRIMARY KEY AUTOINCREMENT, MinorCivType TEXT UNIQUE, ReplaceEvolvedWith TEXT );

-- Create a framework for replace commands
INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) VALUES ('MINOR_CIV_EVOLVED', 'TXT_KEY_CITYSTATE_EVOLVED_01');
INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) VALUES ('MINOR_CIV_EVOLVED', 'TXT_KEY_CITYSTATE_EVOLVED_02');
INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) VALUES ('MINOR_CIV_EVOLVED', 'TXT_KEY_CITYSTATE_EVOLVED_03');
INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) VALUES ('MINOR_CIV_EVOLVED', 'TXT_KEY_CITYSTATE_EVOLVED_04');
INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) VALUES ('MINOR_CIV_EVOLVED', 'TXT_KEY_CITYSTATE_EVOLVED_05');
INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) VALUES ('MINOR_CIV_EVOLVED', 'TXT_KEY_CITYSTATE_EVOLVED_06');
INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) VALUES ('MINOR_CIV_EVOLVED', 'TXT_KEY_CITYSTATE_EVOLVED_07');
INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) VALUES ('MINOR_CIV_EVOLVED', 'TXT_KEY_CITYSTATE_EVOLVED_08');
INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) VALUES ('MINOR_CIV_EVOLVED', 'TXT_KEY_CITYSTATE_EVOLVED_09');
INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) VALUES ('MINOR_CIV_EVOLVED', 'TXT_KEY_CITYSTATE_EVOLVED_10');