-- 最简单的完整藤蔓
-- 向着目的地延伸

require "src/item/vinePart"

BasicVine = class("BasicVine")

function BasicVine:ctor()
	self.partList = {}

	self.bornTimeCount = 0.0
end

function BasicVine:initWithParam(param)
    self.sourcePosition = param.srcPos
	self.targetPosition = param.tgtPos        -- 目标坐标
	self.bornInverval   = param.bornInterval  -- 生出下一个part的间隔
    self.maxAngleOffset = param.angleOffset   -- 两段间的最大角度差
end

function BasicVine:setCanvas(canvas)
	self.canvas = canvas
end

function BasicVine:setTargetPosition(position)
	self.targetPosition = cc.p(position.x, position.y)
    cclog("New Target: " .. position.x .. ", " .. position.y)
end

function BasicVine:start()
    local part = VinePart:new({manager = self,
                               position = self.sourcePosition,
                               rotation = 0})
    self.canvas:addChild(part)

    -- 设定角度
    -- TODO 

    table.insert(self.partList, part)
end

function BasicVine:update(dTime)
	-- update & death
    for i,v in ipairs(self.partList) do
   		if not v:update(dTime) then
	    	-- disconnect parent/child
	    	if v.childPart then
	    		v.childPart.parentPart = nil
	    	end

            -- remove from list
    		table.remove(self.partList, i)
	    	v:removeFromParent()
    	end
    end

    -- born new
    self.bornTimeCount = self.bornTimeCount + dTime
    if self.bornTimeCount > self.bornInverval then
    	self.bornTimeCount = self.bornTimeCount - self.bornInverval

        self:bornNewOne()
    end
end

function BasicVine:bornNewOne()
    -- create new part
    local part = VinePart:new({manager = self,
                               position = self.sourcePosition,
                               rotation = self.partList[#self.partList]:getRotation()+10,
                               parent = self.partList[#self.partList]})
    self.canvas:addChild(part)

    -- connect parent/child
    self.partList[#self.partList].childPart = part

    table.insert(self.partList, part)
end

