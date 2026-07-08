require "/scripts/util.lua"
require "/scripts/vec2.lua"

function checkTranqValid() return projectile.power() == 0.0 end

function init()
	if not checkTranqValid() then
		world.spawnProjectile(projectile.getParameter("projectileName"),entity.position(),projectile.sourceEntity(),vec2.norm(mcontroller.velocity()),false,{
			power=0,
			fuTranqPower=projectile.power()
		})
		projectile.die()
		return
	end
	local baseHomingForce=config.getParameter("baseHomingControlForce")
	if(baseHomingForce) then
		self.targetSpeed = vec2.mag(mcontroller.velocity())
		self.controlForce = baseHomingForce * self.targetSpeed
		mcontroller.setVelocity({0,0})
	end
end

function update(dt)
	if not checkTranqValid() then return end
	if self.controlForce then
		local targets = world.entityQuery(mcontroller.position(), 20, {
			withoutEntityId = projectile.sourceEntity(),
			includedTypes = {"monster"},
			order = "nearest"
		})
		for _, target in pairs(targets) do
			if entity.isValidTarget(target) and entity.entityInSight(target) then
				local targetPos = world.entityPosition(target)
				local myPos = mcontroller.position()
				local dist = world.distance(targetPos, myPos)
				local mDist=vec2.mag(dist)

				local targetSpeed=self.targetSpeed*math.max((math.min(mDist,10)/10.0),0.125)
				local targetForce=self.controlForce^((2.0-(math.min(mDist,10)/10.0)))^2
				mcontroller.approachVelocity(vec2.mul(vec2.norm(dist), targetSpeed), targetForce)
				break
			end
		end
	end

	if self.entityId then
		if not self.sentPowerData then
			if self.sendingPowerData and self.sendingPowerData:finished() and self.sendingPowerData:succeeded() and self.sendingPowerData:result() then
				self.sentPowerData=true
			elseif (not self.sendingPowerData) or (self.sendingPowerData and self.sendingPowerData:finished()) then
				local powerStats= getPowerStats()
				sb.logInfo("sending %s",powerStats)
				self.sendingPowerData=world.sendEntityMessage(self.entityId, "fuTranqPower",powerStats)
			end
		end
		if not self.sentSourceData then
			if self.sendingSourceData and self.sendingSourceData:finished() and self.sendingSourceData:succeeded() and self.sendingSourceData:result() then
				self.sentSourceData=true
			elseif (not self.sendingSourceData) or (self.sendingSourceData and self.sendingSourceData:finished()) then
				self.sendingSourceData=world.sendEntityMessage(self.entityId, "fuTranqSource",projectile.sourceEntity())
			end
		end
	end
	if shouldDestroy() then destroy() end
end

function hit(entityId)
	if self.hit or not checkTranqValid() then return end
	if world.isMonster(entityId) then
		self.hit = true
		self.entityId=entityId
		local powerStats=getPowerStats()
		self.sendingPowerData=world.sendEntityMessage(self.entityId, "fuTranqPower",powerStats)
		self.sendingSourceData=world.sendEntityMessage(self.entityId, "fuTranqSource",projectile.sourceEntity())
	end
end

function shouldDestroy()
	return (projectile.timeToLive() <= 0) or (self.hit and self.sentPowerData and self.sentSourceData)-- or not checkTranqValid()
end

function destroy()
	if self.hit then
		projectile.die()
	end
end

function getPowerStats()
	local stats={}
	stats.powerMultiplier=projectile.powerMultiplier()
	stats.power=config.getParameter("fuTranqPower") or 0
	stats.elementalType=projectile.getParameter("damageKind")
	return stats
end
