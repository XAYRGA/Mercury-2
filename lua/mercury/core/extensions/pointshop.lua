MAX = FindMetaTable("Player")
timer.Simple(1,function()
	function MAX:PS_GetUsergroup()
		return self:GetUserGroup()
	end
end) 