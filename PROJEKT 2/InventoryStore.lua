local inventory = {}

local Players = game:GetService('Players')

function inventory:CreateInvOnAdded(player : Player)
	local inventory = Instance.new('Folder')
	inventory.Name = 'Inventory'
	inventory.Parent = player
end

function inventory:SaveItems(player : Player)
	local DSS = game:GetService('DataStoreService')
	local InventoryStore = DSS:GetDataStore('InvStore')
	local inventory = player:FindFirstChild('Inventory')
	
	local data = {}
	
	for i, aura : IntValue in ipairs(inventory:GetChildren()) do
			table.insert(data, {
			aura.Name,
			})
	end
	
	local success, errormessage
	local attempt = 1
	
	repeat
		success, errormessage = pcall(function()
			InventoryStore:UpdateAsync(player.UserId, function()
				return data
			end)
		end)
		
		if not success then
			attempt += 1
			task.wait(3)
		end
		
	until success or attempt == 5
	
	if success then
		print('Successfuly saved items for player '..player.Name)
	elseif not success then
		warn('Failed to save players items '..tostring(errormessage)..' - '..player.Name)
	else
		warn('Something went wrong whilst saving players items'..tostring(errormessage)..' - '..player.Name)
	end
end

function inventory:LoadItems(player : Player)
	local DSS = game:GetService('DataStoreService')
	local InventoryStore = DSS:GetDataStore('InvStore')
	local inventory = player:FindFirstChild('Inventory')
	
	
	local success, errormessage
	local attempt = 1
	
	local data
	repeat
		success, errormessage = pcall(function()
			data = InventoryStore:GetAsync(player.UserId)
		end)
	until success or attempt == 5 or not Players:FindFirstChild(player.Name)
	
	
	if not data then return end
	if data == 0 then return end
	
	if success and data then
		for i, aura in ipairs(data) do
			local newAura = Instance.new('IntValue')
			newAura.Name = aura[1]
			newAura.Parent = inventory
		end
		print('Successfuly loaded items for player '..player.Name)
	elseif not success then
		warn('Failed to load players items '..tostring(errormessage)..' - '..player.Name)
	else
		warn('Something went wrong whilst loading players items'..tostring(errormessage)..' - '..player.Name)
	end
end

return inventory