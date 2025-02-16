local dataStoreManager = {}

function dataStoreManager.loadItems(player : Player) -- funkce s parametrem player
	
	local leaderstats = Instance.new('Folder') -- vytvo�it novou slo�ku
	leaderstats.Name = 'leaderstats' -- pojmenovat slo�ku na leaderstats
	
	local blocksPlaced = Instance.new('IntValue') -- vytvo�it ��selnou hodnotu leaderstats
	blocksPlaced.Name = 'Blocks' -- p�ejmenovat hodnotu na Blocks
	
	
	leaderstats.Parent = player -- p�ipojit slo�ku leaderstats k hr��ovy
	blocksPlaced.Parent = leaderstats -- p�ipojit ��selnou hodnotu blocksPlaced ke slo�ce leaderstats
end

function dataStoreManager.saveData(player : Player) -- funkce s parametrem player
	local DataStoreService = game:GetService('DataStoreService') -- prom�nn� pro slu�bu DataStoreService
	local database = DataStoreService:GetDataStore('database') -- vytvo�it novou datab�zy ve slu�b� DataStoreService
	
	local leaderstats = player:FindFirstChild('leaderstats') -- z�skat slo�ku leaderstats z hr��e
	local blocksPlaced = leaderstats:FindFirstChild('Blocks') -- z�skat ��selnou hodnotu blocksPlaced ze slo�ky leaderstats
	
	
	local data = {                       -- data table
	 blocksPlaced = blocksPlaced.Value,
}
	
	local success = nil
	local result = nil
	local Key = player.UserId -- prom�nn� pro hr��ovo ID
	local attempt = 1
	
	repeat
		success, result = pcall(function() -- funkce pcall (success jako �sp�ch, result jako odpov�� funkce)
			database:UpdateAsync(Key, function() -- ulo�it hr��ovo data
				return data
			end)
		end)
		attempt +=1 
		
		if not success then -- kdy� se funkce nepovede, po�kat 3 vte�iny
			task.wait(3)
		end
	until success or attempt == 5 -- opakovat funkci dokud se nepovede nebo dokud u� nebude zopakov�na po p�t�
	
	if success then
		print('Successfuly saved data for user '..player.Name)
	elseif not success then
		warn('Unable to save players data for user '..player.Name..'. See here for more: '..tostring(result)) -- varovat do konzole pokud se nepovede ulo�it hr��ovo data
	else
		warn('Something went wrong with saving data for user '..player.Name..'. See here for more'..tostring(result)) -- pokud se nestane ani jedna z mo�nost� (povedlo se nebo nepovedlo se), tak varovat do konzole
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
			data = database:GetAsync(Key) -- z�skat hr��ovo data
		end)
		attempt +=1
		
		if not success then
			task.wait(3)
		end
	until success or attempt == 5 or not Players:FindFirstChild(player.Name) -- opakovat funkci dokud se nepovede, dokud u� nebude zopakov�na po p�t� nebo pokud server nena�l hr��e ve slo�ce v�ech hr��� na serveru
	
	if success and data ~= nil then -- pokud se v�e povedlo, nastavit hr��ovo data tak, jak� bylo naposled co nav�t�vil hru
		blocksPlaced.Value = data.blocksPlaced
		print('Successfuly loaded data for user '..player.Name)
	elseif data == nil then -- pokud hr�� nem� data, co� pravd�podobn� znamen� �e hr�� hraje tuhle hru poprv�, tak mu ud�lit hodnotu 0
		blocksPlaced.Value = 0
		print('Player '..player.Name..' probably joined for the first time')
	elseif not success then -- pokud se n�co nepovedlo, varovat do konzole
		warn('Unable to load players data for user '..player.Name..'. See here for more: '..tostring(result))
	else -- pokud se nestala ani jedna z mo�nost�, varovat do konzole
		warn('Something went wrong with loading data for user '..player.Name..'. See here for more'..tostring(result))
	end
end

return dataStoreManager

