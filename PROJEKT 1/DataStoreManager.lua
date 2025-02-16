local dataStoreManager = {}

function dataStoreManager.loadItems(player : Player) -- funkce s parametrem player
	
	local leaderstats = Instance.new('Folder') -- vytvoøit novou složku
	leaderstats.Name = 'leaderstats' -- pojmenovat složku na leaderstats
	
	local blocksPlaced = Instance.new('IntValue') -- vytvoøit èíselnou hodnotu leaderstats
	blocksPlaced.Name = 'Blocks' -- pøejmenovat hodnotu na Blocks
	
	
	leaderstats.Parent = player -- pøipojit složku leaderstats k hráèovy
	blocksPlaced.Parent = leaderstats -- pøipojit èíselnou hodnotu blocksPlaced ke složce leaderstats
end

function dataStoreManager.saveData(player : Player) -- funkce s parametrem player
	local DataStoreService = game:GetService('DataStoreService') -- promìnná pro službu DataStoreService
	local database = DataStoreService:GetDataStore('database') -- vytvoøit novou databázy ve službì DataStoreService
	
	local leaderstats = player:FindFirstChild('leaderstats') -- získat složku leaderstats z hráèe
	local blocksPlaced = leaderstats:FindFirstChild('Blocks') -- získat èíselnou hodnotu blocksPlaced ze složky leaderstats
	
	
	local data = {                       -- data table
	 blocksPlaced = blocksPlaced.Value,
}
	
	local success = nil
	local result = nil
	local Key = player.UserId -- promìnná pro hráèovo ID
	local attempt = 1
	
	repeat
		success, result = pcall(function() -- funkce pcall (success jako úspìch, result jako odpovìï funkce)
			database:UpdateAsync(Key, function() -- uložit hráèovo data
				return data
			end)
		end)
		attempt +=1 
		
		if not success then -- když se funkce nepovede, poèkat 3 vteøiny
			task.wait(3)
		end
	until success or attempt == 5 -- opakovat funkci dokud se nepovede nebo dokud už nebude zopakována po páté
	
	if success then
		print('Successfuly saved data for user '..player.Name)
	elseif not success then
		warn('Unable to save players data for user '..player.Name..'. See here for more: '..tostring(result)) -- varovat do konzole pokud se nepovede uložit hráèovo data
	else
		warn('Something went wrong with saving data for user '..player.Name..'. See here for more'..tostring(result)) -- pokud se nestane ani jedna z možností (povedlo se nebo nepovedlo se), tak varovat do konzole
	end
end

function dataStoreManager.loadData(player : Player) -- funkce s parametrem player
	local Players = game:GetService('Players')
	local DataStoreService = game:GetService('DataStoreService')
	local database = DataStoreService:GetDataStore('database')
	
	local leaderstats = player:FindFirstChild('leaderstats')
	local blocksPlaced = leaderstats:FindFirstChild('Blocks')
	
	local success = nil
	local result = nil
	local Key = player.UserId
	local attempt = 1
	
	local data
	repeat
		success, result = pcall(function() -- funkce pcall
			data = database:GetAsync(Key) -- získat hráèovo data
		end)
		attempt +=1
		
		if not success then
			task.wait(3)
		end
	until success or attempt == 5 or not Players:FindFirstChild(player.Name) -- opakovat funkci dokud se nepovede, dokud už nebude zopakována po páté nebo pokud server nenašl hráèe ve složce všech hráèù na serveru
	
	if success and data ~= nil then -- pokud se vše povedlo, nastavit hráèovo data tak, jaké bylo naposled co navštívil hru
		blocksPlaced.Value = data.blocksPlaced
		print('Successfuly loaded data for user '..player.Name)
	elseif data == nil then -- pokud hráè nemá data, což pravdìpodobnì znamená že hráè hraje tuhle hru poprvé, tak mu udìlit hodnotu 0
		blocksPlaced.Value = 0
		print('Player '..player.Name..' probably joined for the first time')
	elseif not success then -- pokud se nìco nepovedlo, varovat do konzole
		warn('Unable to load players data for user '..player.Name..'. See here for more: '..tostring(result))
	else -- pokud se nestala ani jedna z možností, varovat do konzole
		warn('Something went wrong with loading data for user '..player.Name..'. See here for more'..tostring(result))
	end
end

return dataStoreManager

