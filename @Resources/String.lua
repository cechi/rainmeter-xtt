function AutoScale(num, idp)
	assert(tonumber(num), 'AutoScale expects a number.')
	local scales = {'B', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'}
	local places = idp or 0
	local scale = ""
	local scaled = 0

	for i, v in ipairs(scales) do
		if (num < (1024 ^ i)) or (i == #scales) then
			scale = v
			scaled = Round(num / 1024 ^ (i - 1), places)
			break
		end
	end

	return scaled, scale
end

function Round(num, idp)
	assert(tonumber(num), 'Round expects a number.')
	local mult = 10 ^ (idp or 0)
	if num >= 0 then
		return math.floor(num * mult + 0.5) / mult
	else
		return math.ceil(num * mult - 0.5) / mult
	end
end

function Format2(label, value, charCount, decNum, suffix)
	if decNum ~= nil then
		value = AutoScale(value, decNum)
	end

	if suffix == nil then
		suffix = ""
	end

	return label .. string.rep(".", charCount - string.len(label) - string.len(value) - string.len(suffix) - 1) .. " " .. value .. suffix
end

function Format(...)
	text = ""
	charCount = arg[1]
	skip = false

	for i = 2, arg["n"], 1 do 
		if skip == false then
			value = arg[i]
			if type(value) == 'number' then
				places = 0;
				if type(arg[i + 1]) == 'number' then
					places = arg[i + 1]
					skip = true
				end

				if arg[i + 1] == '%' then
					value = string.format("%.1f", value * 100) .. "%"
					skip = true
				else
					value, scale = AutoScale(value, places)
					if scale ~= "" then
						value = value .. " " .. scale
					end
				end
			end

			text = text .. value
		else
			skip = false
		end
	end

	text = string.gsub(text, "%.", string.rep(".", charCount - string.len(text) + 1), 1)
	return text
end