local clickDetector = game.Workspace.Box.cheeseButtonService.ClickDetector

local function addPoint(player)
	
	player.leaderstats.Cheese.Value +=1
	
end

clickDetector.MouseClick:Connect(addPoint)

