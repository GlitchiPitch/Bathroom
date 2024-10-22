local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local players = Instance.new("Folder")
players.Name = "Players"
players.Parent = workspace

local lineInstance: Folder & {
	Part & {
		Surface: SurfaceGui & {
			Background: ImageLabel,
			Index: TextLabel,
		},
	}
} = workspace.Line

local bathroomInstance: Folder & {
	Body: Model,
	SpawnPoint: Part,
} = workspace.Room

local line: {
	[number]: {
		point: number,
		-- @prop userId
		player: number | nil,
      cutPrice: number,
	},
} = {}

local bathroom: { number } = {}

local sessionData: {
	[number]: {
		session: {
			cash: number,
			cashMultiplier: number,
			index: number,
			bathroomTimer: number,
		},
	},
} = {}

local basicIncome = 5

function changeIndex(player: number | "userId", lineIndex: number, cutAmount: number)
	local prevPlayer = line[lineIndex + cutAmount].player
	line[lineIndex + cutAmount].player = player
	line[lineIndex].player = prevPlayer
end

function getFreePoint() : number
   for i = 1, #line do
      if line[i].player == nil then
         return i
      end
   end
end

function updateBathroom()
	while task.wait(1) do
		for i = 1, #bathroom do
         local userId = bathroom[i]
         local playerData = sessionData[userId]
			playerData.session.bathroomTimer -= 1
			if playerData.session.bathroomTimer <= 0 then
            local freeIndex = getFreePoint()
				changeIndex(userId, freeIndex, 0)
            bathroom[i] = nil
			end
		end
	end
end

function checkBathroomTimer()
	local userId = line[1].player
	if userId ~= nil then
		local playerData = sessionData[userId]
		playerData.session.bathroomTimer -= 1
		if playerData.session.bathroomTimer <= 0 then
         -- TEST --
			-- local player = Players:GetPlayerByUserId(userId)
			-- player.Character:MoveTo(bathroomInstance.SpawnPoint.Position)
			local player = players:FindFirstChild(userId)
			player:MoveTo(bathroomInstance.SpawnPoint.Position)

			table.insert(bathroom, userId)
			playerData.session.bathroomTimer = 50
			line[1].player = nil
		end
	end
end

function checkPlayerState(i: number)
	local userId = line[i].player
	local playerData = sessionData[userId]
	if playerData.session.index ~= i then
      playerData.session.index = i
      -- TEST --
		-- local player = Players:GetPlayerByUserId(userId)
		local player = players:FindFirstChild(userId)
		player.Humanoid:MoveTo(line[i].point.Position)
	end
end

function checkShift(i: number)
	-- if line[i].player == nil and i < #Players:GetPlayers() then
	if line[i].player == nil and i < #players:GetChildren() then
		for j = i, #line - 1 do
			line[j].player = line[j + 1].player
		end
	end
end

function checkEmptyPoint(i: number)
	line[i].point.Surface.Enabled = line[i].player == nil
end

function updateLine()
	while task.wait(0.5) do
		for i = 1, #line do
			checkShift(i)
			checkPlayerState(i)
			checkEmptyPoint(i)
         checkBathroomTimer()
		end
	end
end

local mainRemote: RemoteEvent
function updateUI(userId: number, playerData)
	local player = Players:GetPlayerByUserId(userId)
	mainRemote:FireClient(player, playerData)
end

function updateCash()
	while task.wait(3) do
		for i = 1, #line do
			local userId = line[i].player
			if userId then
				local playerData = sessionData[userId]
				playerData.session.cash += basicIncome * playerData.session.cashMultiplier
				-- updateUI(userId, playerData)
			end
		end
	end
end

function update()
	coroutine.wrap(updateLine)()
	-- coroutine.wrap(updateCash)()
	-- coroutine.wrap(updateBathroom)()
end

function setupPlayer(character: Model, userId: number, lineIndex: number)
   local humanoidRootPart = character:WaitForChild("HumanoidRootPart") :: BasePart
   print(line, lineIndex)
   local linePoint = line[lineIndex]
   print(linePoint)
   local playerData = sessionData[userId]

   humanoidRootPart:PivotTo(linePoint.point.CFrame + Vector3.yAxis * 5)
   playerData.session.index = lineIndex
end

function onCharacterAdded(character: Model, userId: number)
   local freePoint = getFreePoint()
   local humanoidRootPart = character:WaitForChild("HumanoidRootPart") :: BasePart
   local cont = Instance.new("Model")
   cont.Parent = players
   cont.Name = userId
   character.Parent = cont
	humanoidRootPart:GetPropertyChangedSignal("CFrame"):Connect(function()
		setupPlayer(character, userId, freePoint)
		-- activateCollisionGroupToPlayer(character)
	end)
end

function onPlayerAdded(player: Player)
   sessionData[player.UserId] = {
      session = {
			cash = 0,
			cashMultiplier = 1,
			index = 0,
			bathroomTimer = 50,
		},
   }
   player.CharacterAdded:Connect(function(character)
      onCharacterAdded(character, player.UserId)
   end)
   print(sessionData)
end

function createFakePlayer(userId: number, lineIndex: number)
   sessionData[userId] = {
      session = {
			cash = 0,
			cashMultiplier = 1,
			index = 0,
			bathroomTimer = 50,
		},
   }

   local dummy = ServerStorage.Rig:Clone()
   dummy.Parent = players
   dummy.Name = userId
   setupPlayer(dummy, userId, lineIndex)
   return userId
end

function initLine()

   local lineInstanceTable = lineInstance:GetChildren()
   table.sort(lineInstanceTable, function(a, b)
      return tonumber(a.Name) < tonumber(b.Name)
   end)
   
   for i, v in lineInstanceTable do
      line[i] = {
         point = v,
         player = i < 5 and createFakePlayer(i, i) or nil,
      }
   end

   print(line)
end

function init()
   initLine()
   Players.PlayerAdded:Connect(onPlayerAdded)
	update()
end

init()

-- for stepBack changeIndex(player, player.index, -1)
-- for doCut changeIndex(player, player.index, %s (1, 3, 7, 12))
-- for moveToEnd changeIndex(player, #line, 0)
-- for moveToStart changeIndex(player, 1, 0)
