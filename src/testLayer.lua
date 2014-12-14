require "src/item/basicVine"

TestLayer = class("cc.Layer",
	function()
		local layer = cc.Layer:create()

		TestLayer.initParam(layer)
		TestLayer.initSprite(layer)
		TestLayer.initTouch(layer)
        TestLayer.scheduleUpdate(layer)

		return layer
    end)

function TestLayer:initParam()
	self.partList = {}
end

function TestLayer:initSprite()
	local size = getScreenSize()

	local backSprite = cc.Sprite:create("res/white_2x2.png")
	backSprite:setPosition(size.width/2, size.height/2)
	backSprite:setScale(size.width/2, size.height/2)
	backSprite:setColor(cc.c3b(200, 200, 200))
	self:addChild(backSprite)

    self.vine = BasicVine:new()
    self.vine:initWithParam({srcPos = cc.p(size.width/2, size.height/2),
    	                     tgtPos = cc.p(0, 0),
    	                     bornInterval = 1.0})
    self.vine:setCanvas(self)
    self.vine:start()
end

function TestLayer:initTouch()
    --触摸事件
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    local function onTouchBegan(touch, event)
        self.vine:setTargetPosition(touch:getLocation())
        return true
    end

    local function onTouchMoved(touch, event)
        return
    end

    local function onTouchEnded(touch, event)
        return
    end

    local function onTouchCancelled(touch, event)
        return
    end

    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    listener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
    
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function TestLayer:scheduleUpdate()
    function doUpdate(dTime)
    	self.vine:update(dTime)
    end
    self:scheduleUpdateWithPriorityLua(doUpdate, 0)
end

