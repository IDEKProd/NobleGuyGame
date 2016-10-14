local json = require("json")

local ccx = display.contentCenterX
local ccy = display.contentCenterY

local highscore
local money

-- internal function declaration
local function charSelect()
	hideMainMenu()
	print("It works")
end

local function gameInit()
	hideMainMenu()
	backGround1 = display.newGroup()
	backGround1.x = ccx
	backGround2 = display.newGroup()
	backGround2.x = ccx - display.contentWidth
	-- object declaration
	-- -character
	local sheetData1 = { width=240, height=656, numFrames=3, sheetContentWidth=720, sheetContentHeight=656 }
	local knightBase = graphics.newImageSheet( "knightSheet.png", sheetData1 )
	local characterSequenceData = {
		{ name = "standing", start = 1, count = 1 },
		{ name = "walking", frames = {2, 3}, time = 300}
	}
	character = display.newSprite(knightBase, characterSequenceData)
	character.x = ccx ; character.y = ccy
	character:scale(0.25, 0.25)
	-- -end character
	mountains = display.newImageRect("mountains.png", 960, 540)
	mountains.x = ccx ; mountains.y = ccy
	mountains2 = display.newImageRect("mountains.png", 960, 540)
	mountains2.x = ccx ; mountains2.y = ccy
	backGround1:insert(mountains)
	backGround2:insert(mountains2)
	-- sensor declaration
	leftTouchSensor = display.newRect(ccx/8, ccy, 480, 1080)
	leftTouchSensor.isVisible = false
	leftTouchSensor.isHitTestable = true
	rightTouchSensor = display.newRect((ccx*2)-(ccx/8), ccy, 480, 1080)
	rightTouchSensor.isVisible = false
	rightTouchSensor.isHitTestable = true
	--fuckery
	print(display.contentWidth)
	local function moveLeft()
		backGround1.x = backGround1.x + 5
		backGround2.x = backGround2.x + 5
		if backGround1.x == display.contentWidth * 1 then
			backGround1.x = display.contentWidth * -1
		end
		if backGround2.x == display.contentWidth * 1 then
			backGround2.x = display.contentWidth * -1
		end
	end
	local function runFuncLeft (event)
		if event.phase == "began" then
			character:setSequence("walking")
			character:play()
			Runtime:addEventListener("enterFrame", moveLeft)
		elseif (event.phase == "ended") then
			character:setSequence("standing")
			Runtime:removeEventListener("enterFrame", moveLeft)
		end
	end
	--fuckery
	-- game event declaration
	leftTouchSensor:addEventListener("touch", runFuncLeft)
end

function hideMainMenu()
	menuPlayButton:removeEventListener("tap", charSelect)
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
	menuPlayButton:addEventListener("tap", charSelect)
	-- afterevent conditions
	saveDataFile = io.open(system.pathForFile("saveData.json", system.DocumentsDirectory))
	if saveDataFile then
		menuPlayButton.text = "Resume Game"
		menuPlayButton:removeEventListener("tap", charSelect)
		menuPlayButton:addEventListener("tap", gameInit)
		saveDataFile:close()
	else
		print(system.pathForFile("saveData.json", system.DocumentsDirectory))
	end
end

initMainMenu()
