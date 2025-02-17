local RNG = require(script.RNG)
local RNG_number = RNG.new(1, 5000) -- pùvodní: 5000

local rollModule = {}

function rollModule:AddToStats(player : Player)
	local leaderstats = player:FindFirstChild('leaderstats')
	local Rolls = leaderstats:FindFirstChild('Rolls')
	
	Rolls.Value += 1
end



local systemMessageEvent = game:GetService('ReplicatedStorage'):WaitForChild('RemoteEvents').DropSystemMessage
local soundService = game:GetService('SoundService')
local LegendaryDrop = soundService:WaitForChild('LegendaryDrop')
local MythicDrop = soundService:WaitForChild('MythicDrop')

function rollModule:GetRandomAura(auraFolder, player : Player)
	
	
	local inventory = player:FindFirstChild('Inventory')
	local torso = player.Character:FindFirstChild('Torso')
	local head = player.Character:FindFirstChild('Head')
	
	for _, aura in ipairs(torso:GetChildren()) do
		if aura.Name == 'Effect' then
			aura:Destroy()
		else
			continue
		end
	end
	
	for _, gui in ipairs(head:GetChildren()) do
		if gui.Name == 'OneIn' then
			gui:Destroy()
		else
			continue
		end
	end
	
	
	local _NUMBER = RNG_number:GetRandomNum()
	print(_NUMBER)
	
	if _NUMBER == 1 then
		local newMythic = auraFolder.Mythic.Mythic:Clone() -- new[aura name] stands for Int value in inventory
		local mythicClone = auraFolder.Mythic.Effect:Clone() -- [aura name]Clone stands for aura effect it self
		local mythicGui = auraFolder.Mythic.OneIn:Clone() -- [aura name]Gui stands for label above players head
		
		newMythic.Parent = inventory
		mythicClone.Parent = torso
		mythicGui.Parent = head
		
		systemMessageEvent:FireAllClients('#800080', player.Name..' has just got 1 in 5000 Mythic Aura!')
		
		MythicDrop:Play()
		mythicClone.MythicMusic.Playing = true
		
	elseif _NUMBER <= 10 then
		local newLegendary = auraFolder.Legendary.Legendary:Clone()
		local legendaryClone = auraFolder.Legendary.Effect:Clone()
		local legendaryGui = auraFolder.Legendary.OneIn:Clone()
		
		newLegendary.Parent = inventory
		legendaryClone.Parent = torso
		legendaryGui.Parent = head
		
		systemMessageEvent:FireAllClients('#FFFF00', player.Name..' has just got 1 in 500 Legendary Aura!')
		
		LegendaryDrop:Play()
		legendaryClone.LegendaryMusic.Playing = true
		
	elseif _NUMBER <= 150 then
		local newEpic = auraFolder.Epic.Epic:Clone()
		local epicClone = auraFolder.Epic.Effect:Clone()
		local epicGui = auraFolder.Epic.OneIn:Clone()
		
		newEpic.Parent = inventory
		epicClone.Parent = torso
		epicGui.Parent = head
		
	elseif _NUMBER <= 800 then
		local newRare = auraFolder.Rare.Rare:Clone()
		local rareClone = auraFolder.Rare.Effect:Clone()
		local rareGui = auraFolder.Rare.OneIn:Clone()
		
		newRare.Parent = inventory
		rareClone.Parent = torso
		rareGui.Parent = head
		
	elseif _NUMBER <= 1750 then
		local newUncommon = auraFolder.Uncommon.Uncommon:Clone()
		local uncommonClone = auraFolder.Uncommon.Effect:Clone()
		local uncommonGui = auraFolder.Uncommon.OneIn:Clone()
		
		newUncommon.Parent = inventory
		uncommonClone.Parent = torso
		uncommonGui.Parent = head
		
	elseif _NUMBER <= 5000 then
		local newCommon = auraFolder.Common.Common:Clone()
		local commonClone = auraFolder.Common.Effect:Clone()
		local commonGui = auraFolder.Common.OneIn:Clone()
		
		newCommon.Parent = inventory
		commonClone.Parent = torso
		commonGui.Parent = head
		
	else
		warn('ERROR')
	end
end

return rollModule
