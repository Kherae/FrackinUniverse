require "/stats/effects/fu_armoreffects/setbonuses_common.lua"
setName="fu_hylotltier5setnew"

-- weaponBonus={
	-- {stat = "powerMultiplier", effectiveMultiplier = 1.22}
-- }

armorBonus={
	{stat = "katanaMastery", amount = 0.22},
	{stat = "quarterstaffMastery", amount = 0.22},
	{stat = "insanityImmunity", amount = 1}
}

function init()
	setSEBonusInit(setName)
	-- effectHandlerList.weaponBonusHandle=effect.addStatModifierGroup({})

	-- checkWeapons()

	effectHandlerList.armorBonusHandle=effect.addStatModifierGroup(armorBonus)
end

function update(dt)
	if not checkSetWorn(self.setBonusCheck) then
		effect.expire()
	-- else

		-- checkWeapons()
	end
end

-- function checkWeapons()
	-- local weapons=weaponCheck({"katana","quarterstaff"})

	-- if weapons["either"] then
		-- effect.setStatModifierGroup(effectHandlerList.weaponBonusHandle,weaponBonus)
	-- else
		-- effect.setStatModifierGroup(effectHandlerList.weaponBonusHandle,{})
	-- end
-- end
