function love.load()
    windF = require 'libaries.windfield'
    animationModule = require "libaries.anim8"
    MapHandler = require "libaries.sti"
    cameraHandler = require "libaries.camera"

    World = windF.newWorld(0, 0)

    love.graphics.setDefaultFilter("nearest", "nearest")
    TheMap = MapHandler('maps/map.lua')
    cam = cameraHandler()

    player = {}
    
    player.collider = World:newBSGRectangleCollider(400,250, 40 , 60, 3)
    player.collider:setFixedRotation(true)
    player.x = 400
    player.y = 200
    player.speed = 250
    player.spritesheet = love.graphics.newImage('sprites/player-sheet.png')
    player.grid = animationModule.newGrid( 12, 18, player.spritesheet:getWidth(), player.spritesheet:getHeight() )
    
    AnimationTime = 0.25
    player.animations = {}
    player.animations.down = animationModule.newAnimation( player.grid('1-4', 1), AnimationTime)
    player.animations.left = animationModule.newAnimation( player.grid('1-4', 2), AnimationTime)
    player.animations.right = animationModule.newAnimation( player.grid('1-4', 3), AnimationTime)
    player.animations.up = animationModule.newAnimation( player.grid('1-4', 4), AnimationTime)

    player.anim = player.animations.left

    walls = {}

    if TheMap.layers["Walls"] then
        for i, obj in pairs(TheMap.layers["Walls"].objects) do 
            local wall = World:newRectangleCollider(obj.x, obj.y ,obj.width,obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end
end

 function love.update(dt)
    local isMoving = false
    
    local vx = 0 
    local vy = 0 


    if love.keyboard.isDown("right") then 
        vx =  player.speed
        player.anim = player.animations.right
        isMoving = true
    end
    if love.keyboard.isDown("left") then 
        vx =  player.speed * -1
        player.anim = player.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("down") then 
       vy =  player.speed
        player.anim = player.animations.down
        isMoving = true
    end
    if love.keyboard.isDown("up") then 
        vy =  player.speed * -1
        player.anim = player.animations.up
        isMoving = true
    end

    player.collider:setLinearVelocity(vx,vy)

    if isMoving == false then 
        player.anim:gotoFrame(2)
    
    end

    World:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

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
        TheMap:drawLayer(TheMap.layers["Floor"])
        player.anim:draw(player.spritesheet, player.x, player.y, nil, 3, nil, 6, 9)
        TheMap:drawLayer(TheMap.layers["Plants"])
        TheMap:drawLayer(TheMap.layers["Props"])
        TheMap:drawLayer(TheMap.layers["Bulidings"])
        World:draw()
    cam:detach()
    

 end