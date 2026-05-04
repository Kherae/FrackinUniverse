function init()
	animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
	animator.setParticleEmitterActive("flames", true)
	effect.setParentDirectives("fade=BF3300=0.25")

	script.setUpdateDelta(5)

	self.tickDamagePercentage = 0.045
	self.tickTime = 0.5
	self.tickTimer = self.tickTime
end

function update(dt)
	if effect.duration() and world.liquidAt({mcontroller.xPosition(), mcontroller.yPosition() - 1}) then
		effect.expire()
	end

	self.tickTimer = self.tickTimer - dt
	local damageVal
	if status.statPositive("specialStatusImmunity") then
		damageVal=math.floor(world.threatLevel() * self.tickDamagePercentage * 100)
	else
		damageVal=math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1
	end
	if self.tickTimer <= 0 then
		self.tickTimer = self.tickTime
		status.applySelfDamageRequest({
			damageType = "IgnoresDef",
			damage = damageVal,--math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
			damageSourceKind = "fire",
			sourceEntityId = entity.id()
		})
	end
end

function uninit()

end
