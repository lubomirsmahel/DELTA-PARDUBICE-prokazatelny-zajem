-- Tohle je skript pro klienta. To znamen�, �e cokoliv v tomhle skriptu se d�je jen na obrazovce dan�ho hr��e

-- z�skat prom�nn� pro ka�dou ze slu�eb
local Players = game:GetService('Players')
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local PlayerGui = player.PlayerGui
local SoundService = game:GetService('SoundService')
local MainScreenGui = PlayerGui:WaitForChild('MainScreenGui')

-- ud�lat animaci textu varovan� �e RayCast nen� v dosahu
local ReachwarningTextLabel = MainScreenGui:WaitForChild('ReachwarningText')
local tooFarTextWarningTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, true, 0)
local tooFarTextWarningTweenProperties = {TextTransparency = 0}
local tooFarTextWarningTween = TweenService:Create(ReachwarningTextLabel, tooFarTextWarningTweenInfo, tooFarTextWarningTweenProperties)

-- dal�� prom�nn�
local blockGhost = ReplicatedStorage:WaitForChild('buildingBlockGhost')
local BlockPlacedEvent = ReplicatedStorage:WaitForChild('BlockPlacedEvent')
local ErrorSoundEffect = SoundService:WaitForChild('ErrorSoundEffect')
local PlaceBlockSound = SoundService:WaitForChild('PlaceBlockSound')
local camera : Camera = workspace.Camera


local db = false -- debounce
local dbTime = .2
local maxDistance = 85 -- maxim�ln� dosah RayCast

local function mouseRayCast() -- funkce

local mouse = UserInputService:GetMouseLocation() -- z�skat lokaci kurzoru hr��e
local mouseRay = camera:ViewportPointToRay(mouse.X, mouse.Y) -- ud�lat RayCast (polop��mku) z kamery hr��e p�es pozici kurzoru

local params = RaycastParams.new()  -- vytvo�it parametry RayCastu
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = {player.Character, camera, blockGhost} -- nekon�it �se�ku na hr��ovo charakteru, kame�e nebo ten blockghost

local result = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * maxDistance, params) -- z�skat odpov�� od t� polop��mky, kde ta polop��mka skon�ila
if result then -- kdy� se to povede tak k funkci p�i�adit pozici, kde RayCast skon�il
		return result.Position	
end
end

local leaderstats = player:WaitForChild('leaderstats') -- z�skat slo�ku leaderstats z hr��e
local Blocks = leaderstats:WaitForChild('Blocks') -- z�skat ��selnou hodnotu ze slo�ky leaderstats

local function moveBlockToMouseLocation() -- funkce
	local newPosition = mouseRayCast() -- prom�nn� pro funkci mouseRayCast
	if newPosition then -- kdy� jste v dosahu RayCast, tak zobrazit indik�tor
		blockGhost.Transparency = .5
		blockGhost.Parent = workspace
	blockGhost.Position = newPosition + Vector3.new(0,2,0)
	else -- pokud ale v dosahu nejste, indik�tor nezobrazovat
		blockGhost.Transparency = 1
	end
	
	return blockGhost.Position -- k funkci p�i�adit pozici indik�toru
end
	
	
local function placeBlock(input, proc) -- funkce s parametry input a proc
	if proc then return end -- kdy� plat� gameProccessedEvent tak nepokra�ovat d�le
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then -- pokud hr�� klikne lev�m tla��tkem na my�i
		if db then return end -- kdy� je�t� plat� debounce tak nepokr�ovat d�le
		db = true -- zapnout debounce
		local ghostBlockPos = moveBlockToMouseLocation() -- prom�nn� pro pozici indik�toru
		local mouseRay = mouseRayCast() -- prom�nn� pro funkci mouseRayCast
		
		if ghostBlockPos and mouseRay then -- pokud oboj� plat�, poslat serveru event s pozic� indik�toru a spustit zvuk polo�en� bloku
			BlockPlacedEvent:FireServer(ghostBlockPos)
			PlaceBlockSound:Play()
		else -- pokud se n�co nepovede, uk�zat na obrazovce text �e takhle daleko se dos�hnout ned� a zahraje zvuk
			tooFarTextWarningTween:Play()
			ErrorSoundEffect:Play()
		end
		task.wait(dbTime) -- po�kat dokud debounce nevypr�� a pak ho vypnout
		db = false
	end
end

UserInputService.InputBegan:Connect(placeBlock) -- spustit funkci placeBlock pokud klient zaznamen� jakoukoliv interakci hr��e s jeho po��ta�em

UserInputService.InputChanged:Connect(function(input, proc) -- spustit funkci pokud klient zaznamen� jakoukoliv zm�nu interakce hr��e s jeho po��ta�em
	if proc then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement then -- pokud hr�� pohne my��
		moveBlockToMouseLocation() -- spustit funkci moveBlockToMouseLocation
	end
end)

