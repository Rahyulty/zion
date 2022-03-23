function love.load()
    animationModule = require "libaries.anim8"
    MapHandler = require "libaries.sti"
    cameraHandler = require "libaries.camera"


    love.graphics.setDefaultFilter("nearest", "nearest")
    TheMap = MapHandler('maps/map.lua')
    cam = cameraHandler()

    player = {}
    
    player.x = 400
    player.y = 200
    player.speed = 3.5
    player.spritesheet = love.graphics.newImage('sprites/player-sheet.png')
    player.grid = animationModule.newGrid( 12, 18, player.spritesheet:getWidth(), player.spritesheet:getHeight() )
    
    AnimationTime = 0.1
    player.animations = {}
    player.animations.down = animationModule.newAnimation( player.grid('1-4', 1), AnimationTime)
    player.animations.left = animationModule.newAnimation( player.grid('1-4', 2), AnimationTime)
    player.animations.right = animationModule.newAnimation( player.grid('1-4', 3), AnimationTime)
    player.animations.up = animationModule.newAnimation( player.grid('1-4', 4), AnimationTime)

    player.anim = player.animations.left

end

 function love.update(dt)
    local isMoving = false

    if love.keyboard.isDown("right") then 
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    end
    if love.keyboard.isDown("left") then 
        player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("down") then 
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end
    if love.keyboard.isDown("up") then 
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    if isMoving == false then 
        player.anim:gotoFrame(2)
    
    end

    player.anim:update(dt)
    cam:lookAt(player.x , player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    
    local mw = TheMap.width * TheMap.tilewidth
    local mh = TheMap.height * TheMap.tileheight

    if cam.x < w/ 2 then 
        cam.x = w /2 
    end

    if cam.y < h / 2 then
        cam.y = h / 2
    end


    if cam.x > (mw - w /2 ) then 
        cam.x = (mw - w /2 )
    end

    if cam.y > (mh - h / 2) then
        cam.y = (mh - h / 2)
    end

 end

 function love.draw()
    cam:attach()
        TheMap:drawLayer(TheMap.layers["Grass"])
        player.anim:draw(player.spritesheet, player.x, player.y, nil, 3, nil, 6, 9)
        TheMap:drawLayer(TheMap.layers["Plants"])
        TheMap:drawLayer(TheMap.layers["Props"])
    cam:detach()
    

 end