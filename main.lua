--[[
          Testgame

  This game is for testing purposes, as I want to start with Love2D
]]
currentLevel = ""
_G['level'] = {}
player = {}
function love.load()
  --EXPERIMENTAL: load a file, as level
  currentLevel = "first.lvl"
  a, err = love.filesystem.load("/"..currentLevel)
  if not a then
    love.graphics.print(err, 400, 300)
  else
    a()
    --[[platform.width = love.graphics.getWidth()    -- This makes the platform as wide as the whole game window.
  	platform.height = love.graphics.getHeight()/2  -- This makes the platform as tall as the whole game window.

          -- This is the coordinates where the platform will be rendered.
  	platform.x = 0                               -- This starts drawing the platform at the left edge of the game window.
  	platform.y = love.graphics.getHeight()/2]]           -- This starts drawing the platform at the very middle of the game window

    --set player coordinates and load the picture
    player.x = love.graphics.getWidth()/2
    player.y = love.graphics.getHeight()/2
    player.img = love.graphics.newImage("mario.png")
    --set the movement speed of the player
    player.speed = 200
    --player jumping (+gravity)
    player.ground = player.y      --makes the player land on the platform
    player.y_velocity = 0         --if the player hasn't jumped yet
    player.jump_height = -300     --maximum height
    player.gravity = -800         --descend at this rate
  end
        -- This is the height and the width of the platform.
	end

function love.update(dt)
  if love.keyboard.isDown("d") then
    --check if player jumps while moving
    if love.keyboard.isDown("space") then
      if player.y_velocity == 0 then
        player.y_velocity = player.jump_height
      end
    end
    if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
      player.x = player.x+(player.speed*dt)
    end
  elseif love.keyboard.isDown("a") then
    --check if player jumps while moving
    if love.keyboard.isDown("space") then
      if player.y_velocity == 0 then
        player.y_velocity = player.jump_height
      end
    end
    if player.x > 0 then
      player.x = player.x-(player.speed*dt)
    end
  elseif love.keyboard.isDown("space") then
    if player.y_velocity == 0 then
      player.y_velocity = player.jump_height
    end
  end
  if player.y_velocity ~= 0 then
    player.y = player.y + player.y_velocity*dt
    player.y_velocity = player.y_velocity - player.gravity*dt
  end

  if player.y > player.ground then
    player.y_velocity = 0
    player.y = player.ground
  end
end

function love.draw()
	--[[
  love.graphics.setColor(255, 255, 255)        -- This sets the platform color to white. (The parameters are in RGB Color format).

        -- The platform will now be drawn as a white rectangle while taking in the variables we declared above.
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
  --draw player
  love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 32)
  ]]
  _G.level.draw()
end
