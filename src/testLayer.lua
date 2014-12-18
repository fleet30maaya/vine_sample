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

	self.targetSprite = cc.Sprite:create("res/target.png")
	self.targetSprite:setPosition(size.width/2, size.height/2)
	self:addChild(self.targetSprite, 1)

    self.vines = {}
    for i = 1, VINE_COUNT do
        local vine = BasicVine:new()
        vine:initWithParam({srcPos = cc.p(size.width/2 + math.random(-50, 50), size.height/2 + math.random(-50, 50)),
                            tgtPos = cc.p(size.width/2, size.height/2),
                            bornInterval = VINE_PART_INTERVAL,
                            oriAngle = math.random(0, 100) / 100 * 360,
                            angleOffset = VINE_PART_OFFSET_ANGLE})
        vine:setCanvas(self)
        vine:start()
        table.insert(self.vines, vine)
    end
end

function TestLayer:initTouch()
    --触摸事件
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    local function onTouchBegan(touch, event)
        self.targetSprite:setPosition(touch:getLocation())
        for k, v in pairs(self.vines) do
            v:setTargetPosition(cc.p(touch:getLocation().x + math.random(-100, 100),
                                     touch:getLocation().y + math.random(-100, 100)))
        end
        return true
    end

    local function onTouchMoved(touch, event)
        self.targetSprite:setPosition(touch:getLocation())
        for k, v in pairs(self.vines) do
            v:setTargetPosition(cc.p(touch:getLocation().x + math.random(-100, 100),
                                     touch:getLocation().y + math.random(-100, 100)))
        end
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
        for k, v in pairs(self.vines) do
            v:update(dTime * VINE_SPEED_FACTOR)
        end
    end
    self:scheduleUpdateWithPriorityLua(doUpdate, 0)
end

