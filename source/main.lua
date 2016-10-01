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
	backMountains = display.newGroup() ; backMountains.distanceRatio = 0.3
	backTrees = display.newGroup() ; backTrees.distanceRatio = 0.6
	forePlayer = display.newGroup() ; forePlayer.distanceRatio = 1.0
	foreGround = display.newGroup() ; foreGround.distanceRatio = 1.3
	-- object declaration
	character = display.newImageRect("knightBase.png", 240, 656)
	character.x = ccx ; character.y = ccy
	character:scale(0.75, 0.75)
	forePlayer:insert(character)
	mountains = display.newImageRect("images/Mountain1.jpg", 1920, 1080)
	mountains.x = ccx ; mountains.y = ccy
	backMountains:insert(mountains)
	-- sensor declaration
	leftTouchSensor = display.newRect(ccx/8, ccy, 480, 1080)
	leftTouchSensor.isVisible = false
	leftTouchSensor.isHitTestable = true
	rightTouchSensor = display.newRect((ccx*2)-(ccx/8), ccy, 480, 1080)
	rightTouchSensor.isVisible = false
	rightTouchSensor.isHitTestable = true
	-- game event declaration
	leftTouchSensor:addEventListener("tap", charSelect)
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
