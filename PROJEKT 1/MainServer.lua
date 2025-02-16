-- Tohle je skript pro server. To znamen�, �e cokoliv v tomhle skriptu se d�je na obrazovk�ch ka�d�ho hr��e - na serveru

local Players = game:GetService('Players') -- prom�nn� slo�ky v�ech hr��� na serveru
local ReplicatedStorage = game:GetService('ReplicatedStorage') -- prom�nn� pro slu�bu ReplicatedStorage
local ServerScriptService = game:GetService('ServerScriptService') -- prom�nn� pro slu�bu ServerScriptService
local Modules = ServerScriptService:WaitForChild('Modules') -- prom�nn� slo�ky pro moduly


local dataStoreManager = require(Modules.DataStoreManager) -- z�skat modul datab�ze do prom�nn�


local player
Players.PlayerAdded:Connect(function(plr) -- z�skat prom�nnou hr��e na serveru
	player = plr
end)



Players.PlayerAdded:Connect(function(player) -- na��st hr��ovo data kdy� se p�ipoj� do serveru
	dataStoreManager.loadItems(player)
	dataStoreManager.loadData(player)
	
end)

Players.PlayerRemoving:Connect(function(player) -- ulo�it hr��ovo data kdy� se odpoj� od serveru
	dataStoreManager.saveData(player)
end)

game:BindToClose(function() -- ulo�it hr��ovo data kdyby se dan� server nebo v�echny servery restartovaly, vypnuly nebo spadly
	print('Server is shutting down...')
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			dataStoreManager.saveData(player)
		end)
	end
end)


local BlockPlacedEvent = ReplicatedStorage:WaitForChild('BlockPlacedEvent') -- prom�nn� pro event BlockPlacedEvent

BlockPlacedEvent.OnServerEvent:Connect(function(player, ghostBlockPos) -- kdy� server pochyt� sign�l eventu BlockPlacedEvent ze skriptu pro klienty, spust� se funkce s parametry player a ghostBlock (indik�tor)
	local leaderstats = player:WaitForChild('leaderstats') -- prom�nn� pro tabulku hodnot hr���
	local Blocks = leaderstats:WaitForChild('Blocks')
	
	local newBlock = ReplicatedStorage:WaitForChild('buildingBlock'):Clone() -- prom�nn� pro nov� naklonovan� blok z ReplicatedStorage
	newBlock.Parent = workspace -- nov� naklonovan� blok se p�em�st� do workspace aby ho hr��i mohli vid�t a interaktovat s n�m
	newBlock.Position = ghostBlockPos  -- pozice nov� naklonovan�ho bloku se rovn� pozici indik�toru
	Blocks.Value +=1 -- hr��ovy, kter� blok polo��, se p�i�te 1 bod k jeho tabulce hodnot
end)
