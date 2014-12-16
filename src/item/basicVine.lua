-- 最简单的完整藤蔓
-- 向着目的地延伸

require "src/item/vinePart"

BasicVine = class("BasicVine")

function BasicVine:ctor()
	self.partList = {}

	self.bornTimeCount = 0.0
    self.random = Random:new()
    self.random:setSeed(os.time() + math.random(1, 1000))
end

function BasicVine:initWithParam(param)
    self.sourcePosition = param.srcPos
	self.targetPosition = param.tgtPos        -- 目标坐标
	self.bornInverval   = param.bornInterval  -- 生出下一个part的间隔
    self.maxAngleOffset = param.angleOffset   -- 两段间的最大角度差，决定了藤蔓的“硬度”
    self.originalAngle  = param.oriAngle      -- 最初的朝向角度
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
    part:setRotation(self.originalAngle)
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

        self:bornNewOne()
    end
end

function BasicVine:bornNewOne()
    local lastPart = self.partList[#self.partList]

    -- 设定角度
    local lastAngle = lastPart:getRotation()
    local newAngle   = lastAngle

    local lastX, lastY = lastPart:getPosition()
    local tgtX,  tgtY  = self.targetPosition.x, self.targetPosition.y
    if (lastX-tgtX)*(lastX-tgtX) + (lastY-tgtY)*(lastY-tgtY) < 20*20 then
        -- 如果距离目标点太近，就随便指个方向
        newAngle = lastAngle + (-self.maxAngleOffset + self.random:nextFloat0_1() * self.maxAngleOffset*2)
    else
        -- 首先，计算一下到目标点的角度吧
        local angleToTgt = 90
        if lastX == tgtX then
            if lastY > tgtY then
                angleToTgt = -90
            else
                angleToTgt = 90
            end
        else
            angleToTgt = math.atan((tgtY-lastY) / (tgtX-lastX))
            -- tan的问题就是得修正180度的事……值域(-90, 90)
            if tgtX < lastX then
                angleToTgt = angleToTgt + math.pi
            end
        end
        newAngle = -angleToTgt/math.pi * 180
    end
    -- 然后，按照最大转弯角度限制一下
    while newAngle > 180 do newAngle = newAngle - 360 end
    while newAngle < -180 do newAngle = newAngle + 360 end
    while lastAngle > 180 do lastAngle = lastAngle - 360 end
    while lastAngle < -180 do lastAngle = lastAngle + 360 end
    
    -- 可能的角度有两个，要都考虑进去
    local minAngle = 0
    local angle1 = newAngle - lastAngle
    local angle2 = 360 - math.abs(angle1)
    if angle1 >= 0 and angle2 > 0 then
        angle2 = -angle2
    elseif angle1 < 0 and angle2 < 0 then
        angle2 = -angle2
    end
    if math.abs(angle1) >= math.abs(angle2) then
        minAngle = angle2
    else
        minAngle = angle1
    end

    -- 角度限制
    if minAngle > self.maxAngleOffset then
        newAngle = lastAngle + self.maxAngleOffset
    elseif minAngle < -self.maxAngleOffset then
        newAngle = lastAngle - self.maxAngleOffset
    end

    -- 随机偏折
    newAngle = newAngle + (-VINE_PART_DEFLECTION_ANGLE + self.random:nextFloat0_1() * VINE_PART_DEFLECTION_ANGLE * 2)

    -- create new part
    local part = VinePart:new({manager = self,
                               position = self.sourcePosition,
                               rotation = newAngle,
                               parent = lastPart})
    self.canvas:addChild(part)

    -- connect parent/child
    self.partList[#self.partList].childPart = part

    table.insert(self.partList, part)
end

