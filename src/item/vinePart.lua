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
    -- 如果处在缩短逻辑中，那么当前坐标就是需要的值
    if self.ageing then
        return self:getPosition()
    end

    -- 通常逻辑，返回的是结束点对应的坐标
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

	self.lifeSpan = VINE_PART_LIFESPAN
	self.liveTime = 0.0

    self.vineIndex = math.random(3, 6)

	self.inPointOfTangency  = vines[self.vineIndex].inPoint   -- 随sprite而变
	self.outPointOfTangency = vines[self.vineIndex].outPoint  -- 随sprite而变
end

function VinePart:initSprite()
    self.stick = cc.Sprite:create(vines[self.vineIndex].file)
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
    if self.liveTime < VINE_PART_GROWUP_TIME then
        -- 最初的阶段逐渐增大
    	self:setScale(self.liveTime / VINE_PART_GROWUP_TIME, self.liveTime / VINE_PART_GROWUP_TIME)
    elseif self.liveTime > self.lifeSpan - VINE_PART_SHRINK_TIME then
        -- 最后阶段萎缩
        self:setScaleY(1.0 - (self.liveTime-(self.lifeSpan-VINE_PART_SHRINK_TIME))/VINE_PART_SHRINK_TIME * (1-VINE_PART_SHRINK_SCALE))
    end

    -- 最后阶段的缩短逻辑，时间和产生part的间隔是一致的
    -- 前提是已经没有了parent part
    if self.liveTime > self.lifeSpan - VINE_PART_INTERVAL
        and self.parentPart == nil then
        -- 开始缩短的瞬间，转换自己的锚点
        -- 同时此刻起，getEndPosition的逻辑也会起变化
        if not self.ageing then
            self:setPosition(self:getEndPosition())
            self.stick:setAnchorPoint(self.outPointOfTangency)

            self.ageing = true
        end
        self:setScaleX(1.0 - (self.liveTime-(self.lifeSpan-VINE_PART_INTERVAL))/VINE_PART_INTERVAL)
    end

    -- 修正颜色
    local colorChannel = 255 - 155 * (self.liveTime / self.lifeSpan)
    self.stick:setColor(cc.c3b(colorChannel, colorChannel, colorChannel))

    return true
end
