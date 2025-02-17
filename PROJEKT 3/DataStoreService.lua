local DataStoreService = game:GetService('DataStoreService')
local myDataStore = DataStoreService:GetDataStore('myDataStore')

game.Players.PlayerAdded:Connect(function(player)
	
	local leaderstats = Instance.new('Folder')
	leaderstats.Name = 'leaderstats'
	leaderstats.Parent = player
	
	local Cheese = Instance.new('IntValue')
	Cheese.Name = 'Cheese'
	Cheese.Parent = leaderstats
	
	local data1		
	local success, errormessage = pcall(function()
		data1 = myDataStore:GetAsync(player.UserId..'-Cheese')
	end)
	if	success then
		Cheese.Value = data1
		print('successfully loaded player data')
	else
		print('there was an error whilst loading player data')
		warn(errormessage)
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	
	local success, errormessage = pcall(function()
		myDataStore:SetAsync(player.UserId..'-Cheese', player.leaderstats.Cheese.Value)
	end)
	if success then
		print('successfully saved player data')
	else
		print('there was an error whilst saving player data')
		warn(errormessage)
	end
end)

