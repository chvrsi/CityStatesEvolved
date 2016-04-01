-- MinorCivEvolved
-- Author: Charsi
-- DateCreated: 03/13/2016 8:26:39 PM
--------------------------------------------------------------

function MinorCivEvolvedStartTurn(iPlayer)
	local pMinor = Players[iPlayer]
	local pActivePlayer = Players[Game.GetActivePlayer()]
	local iQuestData1, iQuestData2

	if (pMinor == nil) then
		print("MinorCivEvolvedStartTurn: aborting for [" .. iPlayer .. "] because player object is null.")
		return
	end

	if Teams[pMinor:GetTeam()] == nil then
		print("MinorCivEvolvedStartTurn: aborting for [" .. iPlayer .. "] because team object is null.")
		return
	end

	if not Teams[pMinor:GetTeam()]:IsAlive() then
		print("MinorCivEvolvedStartTurn: aborting for [" .. iPlayer .. "] because team is not alive.")
		return
	end

	-- print("MinorCivEvolvedStartTurn: Processing for [" .. iPlayer .. "].");

	-- only iterate for minor civs
	if pMinor:IsMinorCiv() then
		-- Based on type, grant free buildings
		iTrait = pMinor:GetMinorCivTrait()
		iBuilding = -1;

		if (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_CULTURED) then
			-- Free Monument (+2c)
			iBuilding = GameInfo.Buildings.BUILDING_MONUMENT
		end

		if (iTrait == MinorCivTraitTypes.MINOR_TRAIT_MILITARISTIC) then
			-- Free Barracks (+15xp)
			iBuilding = GameInfo.Buildings.BUILDING_BARRACKS
		end

		if (iTrait == MinorCivTraitTypes.MINOR_TRAIT_MARITIME) then
			-- Free Lighthouse (+1f)
			iBuilding = GameInfo.Buildings.BUILDING_LIGHTHOUSE
		end

		if (iTrait == MinorCivTraitTypes.MINOR_TRAIT_MERCANTILE) then
			-- Free Market (+1g +25%g)
			iBuilding = GameInfo.Buildings.BUILDING_MARKET
		end

		if (iTrait == MinorCivTraitTypes.MINOR_TRAIT_RELIGIOUS) then
			-- Free Pyramid (+2f/2s)
			iBuilding = GameInfo.Buildings.BUILDING_PYRAMID
		end

		if (iBuilding ~= -1) then
			for pMinorCity in pMinor:Cities() do
				if not pMinorCity:IsHasBuilding(iBuilding) then
					pMinorCity:SetNumRealBuilding(iBuilding, 1)
				end
			end
		end

		-- print("MinorCivEvolvedStartTurn: Iterating minors, checking potential for peace.");
		-- iterate over all minors.. make peace (small percentage chance)
		for j = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS - 1, 1 do
			if Players[j]:IsAlive() and (iPlayer ~= j) then
				local teamMinorInstigator = Teams[pMinor:GetTeam()]
				local iMinorVictimTeam = Players[j]:GetTeam()

				if teamMinorInstigator:CanChangeWarPeace(iMinorVictimTeam) then
					if teamMinorInstigator:IsAtWar(iMinorVictimTeam) then
						-- print("MinorCivEvolvedStartTurn: State of war detected between Instigator [" .. iPlayer .. "|" .. pMinor:GetTeam() .. "|" .. pMinor:GetName() .. "] and Victim [" .. j .. "|" .. Players[j]:GetTeam() .. "|" .. Players[j]:GetName() .. "].");
						if (teamMinorInstigator:GetNumTurnsLockedIntoWar(iMinorVictimTeam) <= 0) then
							-- print("MinorCivEvolvedStartTurn: At war, and no longer locked in.  Checking if peace can be made between Instigator and Victim.");
							local iChance = math.random(100)

							-- 1% chance (i.e. very small)
							if (iChance < 2) then
								print("MinorCivEvolvedStartTurn: Dice roll succeeded [" .. iChance .. "].  Setting peace state between Instigator and Victim.");
								teamMinorInstigator:MakePeace(iMinorVictimTeam)

								local pActivePlayer = Players[Game.GetActivePlayer()]
								local sTitle = pMinor:GetName() .. " makes peace with " .. Players[j]:GetName() .. "!"
								local sText = "After many years of war, ".. pMinor:GetName() .. " has made peace with " .. Players[j]:GetName() .. "!"

								pActivePlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, sText, sTitle, pMinor:GetCapitalCity():GetX(), pMinor:GetCapitalCity():GetY())
							else
								-- print("MinorCivEvolvedStartTurn: Dice roll failed [" .. iChance .. "].  Skipped.");
							end
						else
							-- print("MinorCivEvolvedStartTurn: At war, and locked in (GetNumTurnsLockedIntoWar > 0).  Skipped.");
						end
					end
				else
					-- print("MinorCivEvolvedStartTurn: Instigator [" .. iPlayer .. "] cannot change war state with Victim [" .. j .."].  Skipped.");
				end
			end
		end

		-- print("MinorCivEvolvedStartTurn: Iterating majors, checking potential for war.");
		-- determine if we should declare war by looking for offered "bullying" quests
		i = Game.GetActivePlayer()
		-- for i = 0, GameDefines.MAX_MAJOR_CIVS - 1, 1 do
			if pMinor:IsMinorCivActiveQuestForPlayer(i, MinorCivQuestTypes.MINOR_CIV_QUEST_BULLY_CITY_STATE) then
				iQuestData1 = pMinor:GetQuestData1(i, MinorCivQuestTypes.MINOR_CIV_QUEST_BULLY_CITY_STATE)
				iQuestData2 = pMinor:GetQuestData2(i, MinorCivQuestTypes.MINOR_CIV_QUEST_BULLY_CITY_STATE)

				-- print("MinorCivEvolvedStartTurn: Instigator [" .. iPlayer .. "|" .. pMinor:GetTeam() .. "|" .. pMinor:GetName() .. "] wants Victim [" .. iQuestData1 ..  "|" .. Players[iQuestData1]:GetTeam() .. "|" .. Players[iQuestData1]:GetName() .. "] to be bullied by Major [" .. i .. " - " .. Players[i]:GetName() .. "] - note param2 [" .. iQuestData2 .."].")

				local teamMinorInstigator = Teams[pMinor:GetTeam()]
				local iMinorVictimTeam = Players[iQuestData1]:GetTeam()

				if teamMinorInstigator:CanChangeWarPeace(iMinorVictimTeam) then
					-- print("MinorCivEvolvedStartTurn: Instigator can change war state with Victim.  Performing checks...");
					if teamMinorInstigator:IsAtWar(iMinorVictimTeam) then
						-- print("MinorCivEvolvedStartTurn: Yup, they're at war.");
					else
						if teamMinorInstigator:CanDeclareWar(iMinorVictimTeam) then
							local iTurnsRemaining = pMinor:GetQuestTurnsRemaining(i, MinorCivQuestTypes.MINOR_CIV_QUEST_BULLY_CITY_STATE, Game.GetGameTurn() - 1);

							-- 100% chance on final turn turn
							if (iTurnsRemaining <= 1) then
								print("MinorCivEvolvedStartTurn: [" .. iTurnsRemaining .. "] turn remaining.  City State has become impatient - setting war state between Instigator and Victim.");
								teamMinorInstigator:DeclareWar(iMinorVictimTeam)

								local pActivePlayer = Players[Game.GetActivePlayer()]
								local sTitle = pMinor:GetName() .. " declares war on " .. Players[iQuestData1]:GetName() .. "!"
								local sText = pMinor:GetName() .. " has grown impatient that the bullying they requested has not taken place and has declared war on " .. Players[iQuestData1]:GetName() .. "!"

								pActivePlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, sText, sTitle, pMinor:GetCapitalCity():GetX(), pMinor:GetCapitalCity():GetY())
							else
								-- print("MinorCivEvolvedStartTurn: [" .. iTurnsRemaining .. "] turns remaining.  City State continues to waits patiently.");
							end
						else
							-- print("MinorCivEvolvedStartTurn: Instigator cannot declare war on Victim.  Skipped.");
						end
					end
				else
					-- print("MinorCivEvolvedStartTurn: Instigator cannot change war state with Victim.  Skipped.");
				end
			end
		-- end
	end
end

function MinorCivEvolvedLimitSettlers(iPlayer, iUnitType)
	local pMinor = Players[iPlayer]
	local retval = true

	if pMinor:IsMinorCiv() then
		if (iUnitType == GameInfoTypes.UNIT_SETTLER) then
			local iNumCities = pMinor:GetNumCities()
			local iNumSettlers = pMinor:GetUnitClassCountPlusMaking(GameInfoTypes.UNITCLASS_SETTLER)
			local iPotentialCities = iNumCities + iNumSettlers
			local iCityCap = pMinor:GetCurrentEra() + 2

			print("MinorCivEvolvedLimitSettlers: [" .. pMinor:GetName() .. "] Potential Cities [" .. iPotentialCities .. "] Era+2 [" .. iCityCap .."]")

			-- limit of 2 (cities + settlers) in ancient era; add 1 per era
			if (iPotentialCities >= iCityCap) then
				-- print(pMinor:GetName() .. " is at the City + Settler cap of [" .. iCityCap .. "]; Settler choice is hidden.")
				retval = false
			end
		end
	end

	return retval
end

function MinorCivEvolvedLimitSettlersByCity(iPlayer, iCity, iUnitType)
	return MinorCivEvolvedLimitSettlers(iPlayer, iUnitType)
end

-- Don't like settler limits?  Comment these two lines out by putting two dashes in front of them.

GameEvents.PlayerCanTrain.Add(MinorCivEvolvedLimitSettlers);
GameEvents.CityCanTrain.Add(MinorCivEvolvedLimitSettlersByCity);

-- Don't like city states declaring war?  Comment this line out by putting two dashes in front of it.

GameEvents.PlayerDoTurn.Add(MinorCivEvolvedStartTurn);