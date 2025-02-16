-- Tohle je skript pro klienta. To znamená, že cokoliv v tomhle skriptu se dìje jen na obrazovce daného hráèe

-- získat promìnné pro každou ze služeb
local Players = game:GetService('Players')
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local PlayerGui = player.PlayerGui
local SoundService = game:GetService('SoundService')
local MainScreenGui = PlayerGui:WaitForChild('MainScreenGui')

-- udìlat animaci textu varovaní že RayCast není v dosahu
local ReachwarningTextLabel = MainScreenGui:WaitForChild('ReachwarningText')
local tooFarTextWarningTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, true, 0)
local tooFarTextWarningTweenProperties = {TextTransparency = 0}
local tooFarTextWarningTween = TweenService:Create(ReachwarningTextLabel, tooFarTextWarningTweenInfo, tooFarTextWarningTweenProperties)

-- další promìnné
local blockGhost = ReplicatedStorage:WaitForChild('buildingBlockGhost')
local BlockPlacedEvent = ReplicatedStorage:WaitForChild('BlockPlacedEvent')
local ErrorSoundEffect = SoundService:WaitForChild('ErrorSoundEffect')
local PlaceBlockSound = SoundService:WaitForChild('PlaceBlockSound')
local camera : Camera = workspace.Camera


local db = false -- debounce
local dbTime = .2
local maxDistance = 85 -- maximální dosah RayCast

local function mouseRayCast() -- funkce

local mouse = UserInputService:GetMouseLocation() -- získat lokaci kurzoru hráèe
local mouseRay = camera:ViewportPointToRay(mouse.X, mouse.Y) -- udìlat RayCast (polopøímku) z kamery hráèe pøes pozici kurzoru

local params = RaycastParams.new()  -- vytvoøit parametry RayCastu
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = {player.Character, camera, blockGhost} -- nekonèit úseèku na hráèovo charakteru, kameøe nebo ten blockghost

local result = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * maxDistance, params) -- získat odpovìï od té polopøímky, kde ta polopøímka skonèila
if result then -- když se to povede tak k funkci pøiøadit pozici, kde RayCast skonèil
		return result.Position	
end
end

local leaderstats = player:WaitForChild('leaderstats') -- získat složku leaderstats z hráèe
local Blocks = leaderstats:WaitForChild('Blocks') -- získat èíselnou hodnotu ze složky leaderstats

local function moveBlockToMouseLocation() -- funkce
	local newPosition = mouseRayCast() -- promìnná pro funkci mouseRayCast
	if newPosition then -- když jste v dosahu RayCast, tak zobrazit indikátor
		blockGhost.Transparency = .5
		blockGhost.Parent = workspace
	blockGhost.Position = newPosition + Vector3.new(0,2,0)
	else -- pokud ale v dosahu nejste, indikátor nezobrazovat
		blockGhost.Transparency = 1
	end
	
	return blockGhost.Position -- k funkci pøiøadit pozici indikátoru
end
	
	
local function placeBlock(input, proc) -- funkce s parametry input a proc
	if proc then return end -- když platí gameProccessedEvent tak nepokraèovat dále
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then -- pokud hráè klikne levým tlaèítkem na myši
		if db then return end -- když ještì platí debounce tak nepokrèovat dále
		db = true -- zapnout debounce
		local ghostBlockPos = moveBlockToMouseLocation() -- promìnná pro pozici indikátoru
		local mouseRay = mouseRayCast() -- promìnná pro funkci mouseRayCast
		
		if ghostBlockPos and mouseRay then -- pokud obojí platí, poslat serveru event s pozicí indikátoru a spustit zvuk položení bloku
			BlockPlacedEvent:FireServer(ghostBlockPos)
			PlaceBlockSound:Play()
		else -- pokud se nìco nepovede, ukázat na obrazovce text že takhle daleko se dosáhnout nedá a zahraje zvuk
			tooFarTextWarningTween:Play()
			ErrorSoundEffect:Play()
		end
		task.wait(dbTime) -- poèkat dokud debounce nevyprší a pak ho vypnout
		db = false
	end
end

UserInputService.InputBegan:Connect(placeBlock) -- spustit funkci placeBlock pokud klient zaznamená jakoukoliv interakci hráèe s jeho poèítaèem

UserInputService.InputChanged:Connect(function(input, proc) -- spustit funkci pokud klient zaznamená jakoukoliv zmìnu interakce hráèe s jeho poèítaèem
	if proc then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement then -- pokud hráè pohne myší
		moveBlockToMouseLocation() -- spustit funkci moveBlockToMouseLocation
	end
end)

