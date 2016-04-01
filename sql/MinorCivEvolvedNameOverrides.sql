-- Insert SQL Rules Here 

-- Run AFTER initial SQL and all XML files are imported

DELETE FROM MinorCivilization_CityNames WHERE MinorCivType IN (SELECT MinorCivType FROM MinorCivilization_Evolved);

INSERT INTO MinorCivilization_CityNames (MinorCivType, CityName) SELECT DISTINCT a.MinorCivType, REPLACE(b.CityName, 'EVOLVED', a.ReplaceEvolvedWith) FROM MinorCivilization_Evolved a, MinorCivilization_CityNames b WHERE b.MinorCivType = 'MINOR_CIV_EVOLVED';