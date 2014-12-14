-- 藤蔓的一段

VinePart = class("cc.Node",
    function(obj, param)
    	local node = cc.Node:create()

        VinePart.initParam(node, param)
        VinePart.initSprite(node)

        return node
	end)

function VinePart:getPartSize()
	if self.stick then
    	return self.stick:getContentSize()
    end

    return cc.size(0, 0)
end

function VinePart:initParam(param)
	self.manager    = param.manager  -- 管理者，vine对象或layer
	self.parentPart = param.parent   -- 父节点，通常用于坐标修正
	self.childPart  = nil            -- 子结点，通常只用于引用

    if param.position then
    	self:setPosition(param.position)
    end

	self.lifeSpan = 10.0
	self.liveTime = 0.0

	self.inPointOfTangency  = cc.p(5/10, 5/55)   -- 随sprite而变
	self.outPointOfTangency = cc.p(5/10, 50/55)  -- 随sprite而变
end

function VinePart:initSprite()
    self.stick = cc.Sprite:create("res/vine_part_0.png")
	self.stick:setAnchorPoint(self.inPointOfTangency)
	self:addChild(self.stick)

	self.stick:setScale(0.0, 0.0)
end

function VinePart:update(dTime)
	self.liveTime = self.liveTime + dTime
	if self.liveTime > self.lifeSpan then
		return false
	end

    -- 修正坐标
    if self.parentPart then
    	local ppx, ppy = self.parentPart:getPosition()
    	local prx = (self.outPointOfTangency.x - self.inPointOfTangency.x) * self.parentPart:getPartSize().width * self.parentPart:getScaleX()
    	local pry = (self.outPointOfTangency.y - self.inPointOfTangency.y) * self.parentPart:getPartSize().height * self.parentPart:getScaleY()
    	self:setPosition(ppx+prx, ppy+pry)
    end

    -- 修正缩放
    if self.liveTime < 1.5 then
    	self.stick:setScale(self.liveTime / 1.5, self.liveTime / 1.5)
    end 

    -- 修正颜色
    local colorChannel = 255 - 155 * (self.liveTime / self.lifeSpan)
    self.stick:setColor(cc.c3b(colorChannel, colorChannel, colorChannel))

    return true
end
