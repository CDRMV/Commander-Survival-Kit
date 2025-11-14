function LOUD_TitleCase(string)
	local function tchelper(first, rest)
		return first:upper()..rest:lower()
	end
	return string:gsub("(%a)([%w_']*)", tchelper)
end