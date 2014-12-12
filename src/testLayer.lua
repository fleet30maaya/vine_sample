TestLayer = class("cc.Layer",
	function()
		local layer = cc.Layer:create()
		TestLayer.initSprite(layer)
		TestLayer.initTouch(layer)

		return layer
    end)

function TestLayer:initSprite()
	local size = getScreenSize()

	local backSprite = cc.Sprite:create("res/white_2x2.png")
	backSprite:setPosition(size.width/2, size.height/2)
	backSprite:setScale(size.width/2, size.height/2)
	self:addChild(backSprite)
end

function TestLayer:initTouch()
end