local RNG = {}
RNG.__index = RNG

function RNG.new(minNum : number, maxNum: number)
	local self = setmetatable({}, RNG)
	
	self.minNum = minNum
	self.maxNum = maxNum
	
	return self
end

function RNG:GetRandomNum()
	return math.random(self.minNum, self.maxNum)
end

return RNG