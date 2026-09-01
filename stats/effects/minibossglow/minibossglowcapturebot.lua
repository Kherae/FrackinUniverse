function update(dt)
	if world.entityType(entity.id()) ~= "monster" or status.statPositive("captureImmunity") or status.statPositive("specialStatusImmunity") then
		effect.expire()
		return
	else

		local pass,result=pcall(world.callScriptedEntity,entity.id(),"config.getParameter","capturable")
		self.isCapturable=pass and result

		if not self.isCapturable then
			effect.expire()
			return
		else
			effect.setParentDirectives("border=2;FF000075;00000000")
		end
	end
end
