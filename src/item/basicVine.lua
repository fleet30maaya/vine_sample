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
end

function BasicVine:setCanvas(canvas)
	self.canvas = canvas
end

function BasicVine:setTargetPosition(position)
	self.targetPosition = cc.p(position.x, position.y)
end

function BasicVine:start()
    local part = VinePart:new({manager = self, position = self.sourcePosition})
    self.canvas:addChild(part)

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

        -- create new part
        local part = VinePart:new({manager = self,
                                   position = self.sourcePosition,
                                   parent = self.partList[#self.partList]})
        self.canvas:addChild(part)

        -- connect parent/child
        self.partList[#self.partList].childPart = part

        table.insert(self.partList, part)

    end

end