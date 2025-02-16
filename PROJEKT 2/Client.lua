local Players = game:GetService('Players')
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Modules = ReplicatedStorage:WaitForChild('ClientModules')
local RemoteEvents = ReplicatedStorage:WaitForChild('RemoteEvents')
local PlayerGui = player.PlayerGui
local SoundService = game:GetService('SoundService')
local textChatService = game:GetService('TextChatService')
local systemMessageEvent = RemoteEvents.DropSystemMessage

local RollGui = PlayerGui:WaitForChild('RollGui')
local autoRollButton = RollGui.AutoRoll

local db = false
local dbTime = 1.5
local ClickSound = SoundService:WaitForChild('ClickSound')

local function rollButtonClicked()
	if autoRollButton.Text == 'Auto Roll: On' then return end
	if db then return end
	db = true
	ClickSound:Play()
	RemoteEvents.RollEvent:FireServer()
	task.wait(dbTime)
	db = false
end

RollGui.RollButton.MouseButton1Up:Connect(rollButtonClicked)


local messagePrefix = '[System]: '

systemMessageEvent.OnClientEvent:Connect(function(hexColor, message)
	textChatService.TextChannels.RBXGeneral:DisplaySystemMessage(`<font color='#FFFFFF'>{messagePrefix}</font>`..`<font color='{hexColor}'>{message}</font>`)
end)


local db2 = false
local db2Time = .3
local isActivated


local function autoRoll()
	if db2 then return end
	db2 = true
	if autoRollButton.Text == 'Auto Roll: Off' then
		isActivated = false
	elseif autoRollButton.Text == 'Auto Roll: On' then
		isActivated = true
	end
	
	
	if isActivated then
		autoRollButton.Text = 'Auto Roll: Off'
	elseif isActivated == false then
		autoRollButton.Text = 'Auto Roll: On'
	end
	task.wait(db2Time)
	db2 = false
	
	
	if autoRollButton.Text == 'Auto Roll: On' then
		while autoRollButton.Text == 'Auto Roll: On' do
			if autoRollButton.Text == 'Auto Roll: Off' then
			break
			else
				ClickSound:Play()
				RemoteEvents.RollEvent:FireServer()
				task.wait(dbTime)
			end
		end
	elseif autoRollButton.Text == 'Auto Roll: Off' then 
		return
	end
	
end



autoRollButton.MouseButton1Up:Connect(autoRoll)

