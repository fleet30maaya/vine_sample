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

function VinePart:getEndPosition()
	local ppx, ppy = self:getPosition()
    local prx = (self.outPointOfTangency.x - self.inPointOfTangency.x) * self:getPartSize().width * self:getScaleX()
    local pry = (self.outPointOfTangency.y - self.inPointOfTangency.y) * self:getPartSize().height * self:getScaleY()
    local radius = math.sqrt(prx*prx + pry*pry)
    prx = radius * math.cos(-self:getRotation() / 180 * math.pi)
    pry = radius * math.sin(-self:getRotation() / 180 * math.pi)

    return cc.p(ppx+prx, ppy+pry)
end

function VinePart:initParam(param)
	self.manager    = param.manager  -- 管理者，vine对象或layer
	self.parentPart = param.parent   -- 父节点，通常用于坐标修正
	self.childPart  = nil            -- 子结点，通常只用于引用
	self.rotateAnlge = param.rotation

    if param.position then
    	self:setPosition(param.position)
    end

	self.lifeSpan = 1000.0
	self.liveTime = 0.0

	self.inPointOfTangency  = cc.p(5/55, 5/10)   -- 随sprite而变
	self.outPointOfTangency = cc.p(50/55, 5/10)  -- 随sprite而变
end

function VinePart:initSprite()
    self.stick = cc.Sprite:create("res/vine_part_0.png")
	self.stick:setAnchorPoint(self.inPointOfTangency)
	self:addChild(self.stick)

	self:setScale(0.0, 0.0)
	self:setRotation(self.rotateAnlge)
end

function VinePart:update(dTime)
	self.liveTime = self.liveTime + dTime
	if self.liveTime > self.lifeSpan then
		return false
	end

    -- 修正坐标
    if self.parentPart then
    	self:setPosition(self.parentPart:getEndPosition())
    end

    -- 修正缩放
    if self.liveTime < 5 then
    	self:setScale(self.liveTime / 5, self.liveTime / 5)
    end 

    -- 修正颜色
    local colorChannel = 255 - 155 * (self.liveTime / self.lifeSpan)
    self.stick:setColor(cc.c3b(colorChannel, colorChannel, colorChannel))

    return true
end
