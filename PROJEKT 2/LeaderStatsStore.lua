local dataStoreManager = {}

local Players = game:GetService('Players')

function dataStoreManager:loadItems(player : Player)
	
	local leaderstats = Instance.new('Folder')
	leaderstats.Name = 'leaderstats'
	
	local Rolls = Instance.new('IntValue')
	Rolls.Name = 'Rolls'
	
	leaderstats.Parent = player
	Rolls.Parent = leaderstats
	
end

function dataStoreManager:saveData(player : Player)
	
	local DataStoreService = game:GetService('DataStoreService')
	local dataStore1 = DataStoreService:GetDataStore('dataStore1')
	
	local leaderstats = player:FindFirstChild('leaderstats')
	local Rolls = leaderstats:FindFirstChild('Rolls')
	
	local data = {
    Rolls = Rolls.Value
	}
	
	local success
	local errormsg
	local attempt = 1
	
	repeat
		success, errormsg = pcall(function()
			dataStore1:UpdateAsync(player.UserId, function()
				return data
			end)
		end)
		if not success then
			attempt +=1
			task.wait(3)
			else continue end

	until success or attempt == 5
	
	if success then
		print('Successfuly saved data for player '..player.Name)
	elseif not success then
		warn('Failed to SAVE players data. Player: '..player.Name..'. See here for more: '..errormsg)
	else
		warn('Something went wrong with SAVING players data. Player: '..player.Name..'. See here for more: '..errormsg)
	end
end

function dataStoreManager:loadData(player : Player)
	
	local DataStoreService = game:GetService('DataStoreService')
	local dataStore1 = DataStoreService:GetDataStore('dataStore1')
	
	local leaderstats = player:FindFirstChild('leaderstats')
	local Rolls = leaderstats:FindFirstChild('Rolls')
	
	local success
	local errormsg
	local attempt = 1
	local data
	
	repeat
		success, errormsg = pcall(function()
			data = dataStore1:GetAsync(player.UserId)
		end)
		if not success then
			attempt +=1
			task.wait(3)
		else continue end
		
	until success or attempt == 5 or not Players:FindFirstChild(player.Name)
	
	if success and data then
		Rolls.Value = data.Rolls
		print('Successfuly loaded data for player '..player.Name)
	elseif not data then
		Rolls.Value = 0
	elseif not success then
		warn('Failed to LOAD players data. Player: '..player.Name..'. See here for more: '..errormsg)
		player:Kick('Not able to load your data. Try again later')
	else
		warn('Something went wrong with LOADING players data. Player: '..player.Name..'. See here for more: '..errormsg)
		player:Kick('Something went wrong whilst loading your data. Try again later')
	end
end

return dataStoreManager

