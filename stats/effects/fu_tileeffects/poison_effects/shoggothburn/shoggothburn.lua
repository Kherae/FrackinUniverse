function init()
  script.setUpdateDelta(5)
  self.tickDamagePercentage = 0.04
  self.tickTime = 1
  self.tickTimer = self.tickTime
  activateVisualEffects()
end


function activateVisualEffects()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
  if entity.entityType()=="player" then
  local statusTextRegion = { 0, 1, 0, 1 }
  animator.setParticleEmitterOffsetRegion("statustext", statusTextRegion)
  animator.burstParticleEmitter("statustext")
  end
end

function update(dt)
  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
	local damageVal
	if status.statPositive("specialStatusImmunity") then
		damageVal=math.floor(world.threatLevel() * self.tickDamagePercentage * 100)
	else
		damageVal=math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1
	end

    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = damageVal,--math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "shadow",
        sourceEntityId = entity.id()
      })
  end

  effect.setParentDirectives("fade=000000="..self.tickTimer * 0.65)
end


function uninit()

end
