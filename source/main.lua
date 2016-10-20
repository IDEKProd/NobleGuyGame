local json = require("json")

local ccx = display.contentCenterX
local ccy = display.contentCenterY
local charPos = 0

-- internal function declaration
local function optionsMenu()
	hideMainMenu()
	print("It works")
end

local function getcharPos(num)
	pos = ccx + num
	return pos
end

local function gameInit()
	hideMainMenu()
	backGround1 = display.newGroup()
	backGround1.x = ccx
	backGround2 = display.newGroup()
	backGround2.x = ccx - display.contentWidth
	middGround1 = display.newGroup()
	middGround1.x = ccx
	middGround2 = display.newGroup()
	middGround2.x = ccx - display.contentWidth
	foreGround1 = display.newGroup()
	foreGround1.x = ccx
	foreGround2 = display.newGroup()
	foreGround2.x = ccx - display.contentWidth
	-- object declaration
	-- -character
	local sheetData1 = { width=240, height=656, numFrames=3, sheetContentWidth=720, sheetContentHeight=656 }
	local knightBase = graphics.newImageSheet( "knightSheet.png", sheetData1 )
	local characterSequenceData = {
		{ name = "standing", start = 1, count = 1 },
		{ name = "walking", frames = {2, 3}, time = 300}
	}
	character = display.newSprite(knightBase, characterSequenceData)
	character.x = ccx ; character.y = ccy + (ccy/2.065)
	character:scale(0.25, 0.25)
	-- -end character
	-- -mountains
	mountains = display.newImageRect("mountains.png", 960, 540)
	mountains.x = ccx ; mountains.y = ccy
	mountains2 = display.newImageRect("mountains.png", 960, 540)
	mountains2.x = ccx ; mountains2.y = ccy
	backGround1:insert(mountains)
	backGround2:insert(mountains2)
	-- -end mountains
	-- -ground
	groundFloor1 = display.newImageRect("groundFloor.png", 960, 64)
	groundFloor1.x = ccx ; groundFloor1.y = ccy + (ccy/1.1)
	groundFloor2 = display.newImageRect("groundFloor.png", 960, 64)
	groundFloor2.x = ccx ; groundFloor2.y = ccy + (ccy/1.1)
	foreGround1:insert(groundFloor1)
	foreGround2:insert(groundFloor2)
	-- -end ground
	-- -castle
	castle = display.newImageRect("castle.png", 400, 400)
	castle.x = ccx*2 ; castle.y = ccy + 41
	middGround1:insert(castle)
	middGround2:insert(castle)
	-- -end castle
	-- -tree
	local function treeSpawn(count)
		for iters = 0, count, 1 do
			iters = iters + 1
			local tree = display.newImageRect("tree.png", 128, 256)
			tree.yScale = 2
			if (math.random(0, 1) > 0.5) then
				tree.xScale = -2
			else
				tree.xScale = 2
			end
			tree.x = math.random(-10000, 10000) ; tree.y = ccy-40
			middGround1:insert(tree)
		end
	end
	treeSpawn(20)
	-- -end tree
	-- -enemies
	local enemyTable = {}
	local sheetData2 = { width=160, height=240, numFrames=3, sheetContentWidth=480, sheetContentHeight=240 }
	local enemyT1 = graphics.newImageSheet("goonSheet.png", sheetData2)
	local enemySequenceData = {
		{ name = "standing", start = 1, count = 1 },
		{ name = "walking", frames = {2, 3}, time = 400}
	}
	local function enemySpawn(mtype)
		if (mtype == "T1") then
			pos = math.random(-10000, 10000)
			local enemy = display.newSprite(enemyT1, enemySequenceData)
			enemy.xScale = 0.5 ; enemy.yScale = 0.5
			enemy.y = ccy + 140
			table.insert(enemyTable, enemy)
			enemy.myName = "T1Enemy"
			enemy.myPos = pos
			enemy.x = enemy.myPos
			middGround1:insert(enemy)
		else
			print("gah")
		end
	end
	enemySpawn("T1")
	enemySpawn("T1")
	enemySpawn("T1")
	enemySpawn("T1")
	enemySpawn("T1")
	enemySpawn("T1")
	enemySpawn("T1")
	enemySpawn("T1")
	local function enemyT1AI()
		for i = #enemyTable, 1, -1 do
			object = enemyTable[i]
			objectDistance = object.myPos - charPos
			local distanceCheck = 300
			if (objectDistance <= distanceCheck and objectDistance >= (distanceCheck * -1)) then
				if objectDistance <= distanceCheck and objectDistance >= 0 then
					transition.to(object, {x = object.x - 100, time = math.random(300, 500)})
					object.myPos = object.myPos - 100
					object:setSequence("walking")
					object:play()
					object.xScale = -0.5
				elseif objectDistance >= (distanceCheck * -1) and objectDistance <= 0 then
					transition.to(object, {x = object.x + 100, time = math.random(300, 500)})
					object.myPos = object.myPos + 100
					object:setSequence("walking")
					object:play()
					object.xScale = 0.5
				end
			else
				local randNum = math.random(-100, 100)
				if randNum >= 0 then
					object:setSequence("walking")
					object:play()
					object.xScale = 0.5
				elseif randNum <= 0 then
					object:setSequence("walking")
					object:play()
					object.xScale = -0.5
				end
				transition.to(object, {x = (object.x + randNum), time = math.random(300, 500)})
				object.myPos = object.myPos + (randNum)
			end
		end
	end
	-- -end enemies
	-- sensor declaration
	leftTouchSensor = display.newRect(ccx/8, ccy, display.contentWidth/5, display.contentHeight)
	leftTouchSensor.isVisible = false
	leftTouchSensor.isHitTestable = true
	rightTouchSensor = display.newRect((ccx*2)-(ccx/8), ccy, display.contentWidth/5, display.contentHeight)
	rightTouchSensor.isVisible = false
	rightTouchSensor.isHitTestable = true
	-- Image Scrolling Chunk
	local function moveLeft()
		-- BG
		print(charPos, character.x)
		if (charPos <= -10000) then
			if character.x <= 20 then
				print("at edge")
			else
				character.x = character.x - 10
			end
		elseif character.x < 480 then
			character.x = character.x + 10
		else
			charPos = charPos - 8
			backGround1.x = backGround1.x + 1
			backGround2.x = backGround2.x + 1
			if backGround1.x == display.contentWidth * 1 then
				backGround1.x = display.contentWidth * -1
			elseif backGround2.x == display.contentWidth * 1 then
				backGround2.x = display.contentWidth * -1
			end
			-- FG
			foreGround1.x = foreGround1.x + 10
			foreGround2.x = foreGround2.x + 10
			if foreGround1.x == display.contentWidth * 1 then
				foreGround1.x = display.contentWidth * -1
			elseif foreGround2.x == display.contentWidth * 1 then
				foreGround2.x = display.contentWidth * -1
			end
			middGround1.x = middGround1.x + 8
			middGround2.x = middGround2.x + 8
		end
	end
	local function moveRight()
		--BG
		print(charPos, character.x)
		if (charPos >= 10000) then
			if character.x >= 940 then
				print("at edge")
			else
				character.x = character.x + 10
			end
		elseif character.x > 480 then
			character.x = character.x - 10
		else
			charPos = charPos + 8
			backGround1.x = backGround1.x - 1
			backGround2.x = backGround2.x - 1
			if backGround1.x == display.contentWidth * -1 then
				backGround1.x = display.contentWidth * 1
			elseif backGround2.x == display.contentWidth * -1 then
				backGround2.x = display.contentWidth * 1
			end
			-- FG
			foreGround1.x = foreGround1.x - 10
			foreGround2.x = foreGround2.x - 10
			if foreGround1.x == display.contentWidth * -1 then
				foreGround1.x = display.contentWidth * 1
			elseif foreGround2.x == display.contentWidth * -1 then
				foreGround2.x = display.contentWidth * 1
			end
			middGround1.x = middGround1.x - 8
			middGround2.x = middGround2.x - 8
		end
	end
	local function runFuncLeft (event)
		if event.phase == "began" then
			character:setSequence("walking")
			character:play()
			character.xScale = 0.25
			Runtime:addEventListener("enterFrame", moveLeft)
		elseif (event.phase == "ended") then
			character:setSequence("standing")
			Runtime:removeEventListener("enterFrame", moveLeft)
		end
	end
	local function runFuncRight (event)
		if event.phase == "began" then
			character:setSequence("walking")
			character:play()
			character.xScale = -0.25
			Runtime:addEventListener("enterFrame", moveRight)
		elseif (event.phase == "ended") then
			character:setSequence("standing")
			Runtime:removeEventListener("enterFrame", moveRight)
		end
	end
	-- game event declaration
	gameLoop = timer.performWithDelay(math.random(600, 1000), enemyT1AI, 0)
	leftTouchSensor:addEventListener("touch", runFuncLeft)
	rightTouchSensor:addEventListener("touch", runFuncRight)
end

function hideMainMenu()
	menuPlayButton:removeEventListener("tap", optionsMenu)
	menuGroup.isVisible = false
end

local function initMainMenu()
	menuGroup = display.newGroup()
	menuTitle = display.newText("Noble", ccx, ccy-(ccy*0.75), 0, 0, Verdana, ccy-(ccy*0.75))
	menuGroup:insert(menuTitle)
	-- buttons init
	menuPlayButton = display.newText("New Game", ccx, ccy-(ccy*0.45), 0, 0, Verdana, ccy-(ccy*0.9))
	menuGroup:insert(menuPlayButton)
	menuOptionsButton = display.newText("Options", ccx, ccy-(ccy*0.25), 0, 0, Verdana, ccy-(ccy*0.9))
	menuGroup:insert(menuOptionsButton)
	-- main menu event declaration 
	menuOptionsButton:addEventListener("tap", optionsMenu)
	menuPlayButton:addEventListener("tap", gameInit)
	-- afterevent conditions
	saveDataFile = io.open(system.pathForFile("saveData.json", system.DocumentsDirectory))
	if saveDataFile then
		menuPlayButton.text = "Resume Game"
		menuPlayButton:removeEventListener("tap", optionsMenu)
		menuPlayButton:addEventListener("tap", gameInit)
		saveDataFile:close()
	else
		print(system.pathForFile("saveData.json", system.ResourceDirectory))
	end
end

print(display.pixelHeight .. " " .. display.pixelWidth)
print(system.pathForFile("saveData.json", system.ResourceDirectory))


initMainMenu()
