-- Insert SQL Rules Here 


-- Override flavor expansion (often zero)
DELETE FROM MinorCivilization_Flavors WHERE FlavorType IN ('FLAVOR_EXPANSION');

INSERT INTO MinorCivilization_Flavors (MinorCivType, FlavorType, Flavor) SELECT DISTINCT MinorCivType, 'FLAVOR_EXPANSION', '3' FROM MinorCivilization_Flavors;

-- New (added) flavors for minor civs
-- Give every civ every flavor they don't already have, at a value of 3
INSERT INTO MinorCivilization_Flavors (MinorCivType, FlavorType, Flavor) SELECT DISTINCT C.MinorCivType, F.Type, '3' FROM MinorCivilization_Flavors C, Flavors F WHERE F.Type NOT IN (SELECT FlavorType FROM MinorCivilization_Flavors WHERE MinorCivType = C.MinorCivType);

-- New minor civ city names
INSERT OR REPLACE INTO MinorCivilization_CityNames (MinorCivType, CityName) SELECT a.MinorCivType, b.CityName FROM MinorCivilization_CityNames a, MinorCivilization_Citynames b WHERE a.MinorCivType <> b.MinorCivType ORDER BY a.MinorCivType, random();