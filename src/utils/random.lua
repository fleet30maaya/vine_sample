-- 伪随机算法
-- 放在lua里还可以更新，很好很好
Random = class("Random")

function Random:ctor()
    self.seed = 10284  -- 瞎写的
    self.last = self.seed
    self.count = 0
    
    self.a = 16807;
    self.m = 2147483647;
    self.c = 0;
end

function Random:setSeed(seed)
    self.seed = seed
    self.last = self.seed
    self.count = 0
end

function Random:getNext()
    self.last = math.floor(math.abs((self.last * self.a + self.c) % self.m))
    return self.last
end

function Random:nextFloat0_1()
    local newInt = self:getNext()
    return newInt / self.m
end

