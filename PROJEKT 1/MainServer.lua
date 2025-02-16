-- Tohle je skript pro server. To znamená, že cokoliv v tomhle skriptu se dìje na obrazovkách každého hráèe - na serveru

local Players = game:GetService('Players') -- promìnná složky všech hráèù na serveru
local ReplicatedStorage = game:GetService('ReplicatedStorage') -- promìnná pro službu ReplicatedStorage
local ServerScriptService = game:GetService('ServerScriptService') -- promìnná pro službu ServerScriptService
local Modules = ServerScriptService:WaitForChild('Modules') -- promìnná složky pro moduly


local dataStoreManager = require(Modules.DataStoreManager) -- získat modul databáze do promìnné


local player
Players.PlayerAdded:Connect(function(plr) -- získat promìnnou hráèe na serveru
	player = plr
end)



Players.PlayerAdded:Connect(function(player) -- naèíst hráèovo data když se pøipojí do serveru
	dataStoreManager.loadItems(player)
	dataStoreManager.loadData(player)
	
end)

Players.PlayerRemoving:Connect(function(player) -- uložit hráèovo data když se odpojí od serveru
	dataStoreManager.saveData(player)
end)

game:BindToClose(function() -- uložit hráèovo data kdyby se daný server nebo všechny servery restartovaly, vypnuly nebo spadly
	print('Server is shutting down...')
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			dataStoreManager.saveData(player)
		end)
	end
end)


local BlockPlacedEvent = ReplicatedStorage:WaitForChild('BlockPlacedEvent') -- promìnná pro event BlockPlacedEvent

BlockPlacedEvent.OnServerEvent:Connect(function(player, ghostBlockPos) -- když server pochytí signál eventu BlockPlacedEvent ze skriptu pro klienty, spustí se funkce s parametry player a ghostBlock (indikátor)
	local leaderstats = player:WaitForChild('leaderstats') -- promìnná pro tabulku hodnot hráèù
	local Blocks = leaderstats:WaitForChild('Blocks')
	
	local newBlock = ReplicatedStorage:WaitForChild('buildingBlock'):Clone() -- promìnná pro novì naklonovaný blok z ReplicatedStorage
	newBlock.Parent = workspace -- novì naklonovaný blok se pøemístí do workspace aby ho hráèi mohli vidìt a interaktovat s ním
	newBlock.Position = ghostBlockPos  -- pozice novì naklonovaného bloku se rovná pozici indikátoru
	Blocks.Value +=1 -- hráèovy, který blok položí, se pøiète 1 bod k jeho tabulce hodnot
end)
