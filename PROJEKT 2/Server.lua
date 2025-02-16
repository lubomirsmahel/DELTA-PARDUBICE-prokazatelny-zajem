-- | Services and Vars | --
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local textChatService = game:GetService('TextChatService')
local ServerScriptService = game:GetService('ServerScriptService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerModules =  ServerScriptService:WaitForChild('ServerModules')
local ClientModules = ReplicatedStorage:WaitForChild('ClientModules')
local RemoteEvents = ReplicatedStorage:WaitForChild('RemoteEvents')
local auras = ReplicatedStorage:WaitForChild('Auras')
-- | Module Requiring | --
local _dataStoreManager = require(ServerModules.LeaderStatsStore)
local _inventoryManager = require(ServerModules.InventoryStore)
local _rollMod_S = require(ServerModules.RollModule)
-- | Functions and Modules | --


-- >DataStore | Start --
Players.PlayerAdded:Connect(function(plr)
	_dataStoreManager:loadItems(plr)
	_dataStoreManager:loadData(plr)
	
	_inventoryManager:CreateInvOnAdded(plr)
	_inventoryManager:LoadItems(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
	_dataStoreManager:saveData(plr)
	
	_inventoryManager:SaveItems(plr)
end)

game:BindToClose(function()
	if RunService:IsStudio() then return end 
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			_dataStoreManager:saveData(player)
			
			_inventoryManager:SaveItems(player)
		end)
	end
end)
-- >DataStore | End --

local function onRollEvent(player)
	
	_rollMod_S:AddToStats(player)
	_rollMod_S:GetRandomAura(auras, player)
	
end

RemoteEvents.RollEvent.OnServerEvent:Connect(onRollEvent)
