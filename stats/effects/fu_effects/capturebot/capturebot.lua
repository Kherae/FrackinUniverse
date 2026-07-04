--only used on the mega capture bot now. was too broken otherwise.
function init()
	if world.entityType(entity.id()) ~= "monster" then
		effect.expire()
		return
	end

	local pass,result=pcall(world.callScriptedEntity,entity.id(),"config.getParameter","capturable")
	self.isCapturable=pass and result

	if not self.isCapturable or status.statPositive("captureImmunity") or status.statPositive("specialStatusImmunity") then
		effect.expire()
		return
	end

	effect.setParentDirectives(config.getParameter("directives", ""))
	self.healthPercentage = config.getParameter("healthPercentage", 0.1)

	effect.addStatModifierGroup({{stat = "deathbombDud", amount = 1}})

	if (status.isResource("stunned")) and (not status.statPositive("stunImmunity")) and (not status.isResource("food")) then
		mcontroller.controlModifiers({facingSuppressed = true,movementSuppressed = true})
		status.setResource("stunned", math.max(status.resource("stunned"), effect.duration()))
		mcontroller.setVelocity({0, 0})
	end
end

function update(dt)
	if world.entityType(entity.id()) ~= "monster" then
		effect.expire()
		return
	end

	local pass,result=pcall(world.callScriptedEntity,entity.id(),"config.getParameter","capturable")
	self.isCapturable=pass and result

	if not self.isCapturable or status.statPositive("captureImmunity") or status.statPositive("specialStatusImmunity") then
		effect.expire()
		return
	end

	status.setResourcePercentage("health", math.min(status.resourcePercentage("health"), self.healthPercentage))

	if (status.isResource("stunned")) and (not status.statPositive("stunImmunity")) and (not status.isResource("food")) then
		mcontroller.controlModifiers({facingSuppressed = true,movementSuppressed = true})
		status.setResource("stunned", math.max(status.resource("stunned"), effect.duration()))
		mcontroller.setVelocity({0, 0})
	end
end

function uninit()
	if world.entityType(entity.id()) ~= "monster" then
		-- effect.expire()
		return
	end

	local pass,result=pcall(world.callScriptedEntity,entity.id(),"config.getParameter","capturable")
	self.isCapturable=pass and result

	if not self.isCapturable or status.statPositive("captureImmunity") or status.statPositive("specialStatusImmunity") then
		-- effect.expire()
		return
	end

	status.setResource("stunned", 0)
end
