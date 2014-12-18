-- Mac模拟器的设置
MAC_SIMULATOR_WINDOW_WIDTH  = 768
MAC_SIMULATOE_WINDOW_HEIGHT = 1024
MAC_SIMULATOR_WINDOW_SCALE  = 0.5
MAC_SIMULATOR_RESOLUTION_WIDTH  = 640
MAC_SIMULATOR_RESOLUTION_HEIGHT = 960

GAME_FPS = 60

-- 总藤蔓数
VINE_COUNT = 10
-- 速率控制
VINE_SPEED_FACTOR = 5

-- 分段的一些参数
VINE_PART_INTERVAL = 1   -- 产生间隔，同时也影响老化
VINE_PART_LIFESPAN = 20  -- 生命周期
VINE_PART_GROWUP_TIME = 5  -- 生长期的时间
VINE_PART_SHRINK_TIME = 5  -- 萎缩期的时间
VINE_PART_SHRINK_SCALE = 0.7  -- 萎缩期到最终的scale
VINE_PART_OFFSET_ANGLE = 40   -- 两段间的偏折角度
VINE_PART_DEFLECTION_ANGLE = 30  -- 强制偏折角度范围

vines = {
	[1] = {
	    file = "res/vine_part_0.png",
	    inPoint = cc.p(5/55, 5/10),
	    outPoint = cc.p(50/55, 5/10),
	    inAngle = 0,
	    outAngle = 0,
    },
    [2] = {
	    file = "res/vine_part_1.png",
	    inPoint = cc.p(5/55, 5/10),
	    outPoint = cc.p(50/55, 5/10),
	    inAngle = 0,
	    outAngle = 0,
    },
    [3] = {
    	file = "res/vine_part_2.png",
	    inPoint = cc.p(15/73, 22/36),
	    outPoint = cc.p(44/73, 21/36),
	    inAngle = 47,
	    outAngle = -47,
    },
    [4] = {
    	file = "res/vine_part_3.png",
	    inPoint = cc.p(15/73, 14/36),
	    outPoint = cc.p(44/73, 15/36),
	    inAngle = -47,
	    outAngle = 47,
    },
    [5] = {
    	file = "res/vine_part_4.png",
	    inPoint = cc.p(19/66, 19/35),
	    outPoint = cc.p(53/66, 22/35),
	    inAngle = -31,
	    outAngle = 60,
    },
    [6] = {
    	file = "res/vine_part_5.png",
	    inPoint = cc.p(19/66, 16/35),
	    outPoint = cc.p(53/66, 13/35),
	    inAngle = 31,
	    outAngle = -60,
    },
}