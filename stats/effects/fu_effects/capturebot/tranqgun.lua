require "/scripts/util.lua"

function init()
	message.setHandler("fuTranqPower",podPower)
	message.setHandler("fuTranqSource",podSource)
end

function update(dt)
	if self and self.podPower and not self.didDamage then
		local damage=math.min(self.podPower,status.resource("health")-1.0)
		if damage > 0.0 then
			status.applySelfDamageRequest({damageType = "IgnoresDef",damage = damage,damageSourceKind = self.podType,sourceEntityId = self.podSource})
		end
		self.didDamage=true
	end
end

function podPower(_,_,powerStats)
	self.podPower=math.max(0,powerStats.power * powerStats.powerMultiplier)
	self.podType=powerStats.elementalType
	self.didDamage=false
	return self.podPower
end

function podSource(_,_,source)
	self.podSource=source
	return self.podSource
end
