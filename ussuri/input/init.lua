local input = {}

input.clipboard = ""

input.copy = function(self, text)
	self.clipboard = text
end

input.paste = function(self)
	return self.clipboard
end

return input