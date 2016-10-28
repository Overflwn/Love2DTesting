--[[
        [EXTENDED VERSION]

    This game is a version of a tutorial in the wiki (http://osmstudios.com/tutorials/your-first-love2d-game-in-200-lines-part-1-of-3)

    What I added:

    - Score and HP display at the top left
    - Fixed enemy spawns (they spawned outside of the screen)
    - Added in HP
    - Enemy bullets do damage to your HP (-5 each)
    - Enemies spawn bullets
    - Fixed enemy spawns again (they just popped in at the top)
    - Fixed death screen (player could continue shooting and moving invisible)
    (Maybe later: sound effects and some music)


    ~Piorjade @2016

    ~Original game by osmstudios
]]
-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
isAlive = true
score = 0
hp = 100
debug = false
player = { x = 200, y = 710, speed = 250, img = nil }
-- Timers
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.2 
canShootTimer = canShootTimerMax
hit = false
hitTimerMax = 0.2
hitTimer = hitTimerMax
-- Image Storage
bulletImg = nil
-- Entity Storage
bullets = {} -- array of current bullets being drawn and updated
eBullets = {} --array of current bullets created by enemies
--More timers
createEnemyTimerMax = 0.6
createEnemyTimer = createEnemyTimerMax
-- More images
enemyImg = nil -- Like other images we'll pull this in during out love.load function
-- More storage
enemies = {} -- array of current enemies on screen
function love.load(arg)
  player.img = love.graphics.newImage('assets/Aircraft_01.png')
  bulletImg = love.graphics.newImage('assets/bullet.png')
  enemyImg = love.graphics.newImage('assets/enemy.png')
  --we now have an asset ready to be used inside Love
end
function love.update(dt)

  canShootTimer = canShootTimer - (1*dt)
  hitTimer = hitTimer - (1*dt)
  -- update the positions of bullets
  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y - (250 * dt)

    if bullet.y < 0 then -- remove bullets when they pass off the screen
      table.remove(bullets, i)
    end
  end
  for i, bullet in ipairs(eBullets) do
    bullet.y = bullet.y + (250 * dt)
    if bullet.y > love.graphics.getHeight() then
      table.remove(eBullets, i)
    end
  end
  if canShootTimer < 0 then
    canShoot = true
  end
  if hitTimer < 0 then
    hit = false
  end

  if not hit then
    player.img = love.graphics.newImage('assets/Aircraft_01.png')
  end

  createEnemyTimer = createEnemyTimer - (1 * dt)
  if createEnemyTimer < 0 then
    createEnemyTimer = createEnemyTimerMax

    -- Create an enemy
    randomNumber = math.random(10, love.graphics.getWidth() - enemyImg:getWidth())
    newEnemy = { x = randomNumber, y = -(enemyImg:getHeight()), img = enemyImg }
    table.insert(enemies, newEnemy)
  end
  if love.keyboard.isDown("left") and isAlive then
    if player.x > 0 then -- binds us to the map
      player.x = player.x - (player.speed*dt)
    end
  elseif love.keyboard.isDown("right") and isAlive then
    if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
      player.x = player.x + (player.speed*dt)
    end
  end
  if love.keyboard.isDown('space', 'rctrl', 'lctrl', 'ctrl') and canShoot and isAlive then
  -- Create some bullets
    newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg }
    table.insert(bullets, newBullet)
    canShoot = false
    canShootTimer = canShootTimerMax
  end
  -- update the positions of enemies
  for i, enemy in ipairs(enemies) do
    enemy.y = enemy.y + (200 * dt)
    local rdm = math.random(1, 100)
    if enemy.y > 850 then -- remove enemies when they pass off the screen
      table.remove(enemies, i)
    end
    if rdm <= 2 then
      newBullet = {x = enemy.x + (enemy.img:getWidth()/2), y = enemy.y + (enemy.img:getHeight()), img = bulletImg}
      table.insert(eBullets, newBullet)
    end
  end
  -- run our collision detection
  -- Since there will be fewer enemies on screen than bullets we'll loop them first
  -- Also, we need to see if the enemies hit our player
  for i, enemy in ipairs(enemies) do
    for j, bullet in ipairs(bullets) do
      if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
        table.remove(bullets, j)
        table.remove(enemies, i)
        score = score + 1
      end
    end
    for j, bullet in ipairs(eBullets) do
      if CheckCollision(player.x, player.y, player.img:getWidth(), player.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
        table.remove(eBullets, j)
        hp = hp-5
        player.img = love.graphics.newImage('assets/Aircraft_01_hit.png')
        hitTimer = hitTimerMax
        hit = true
      end
    end

    if CheckCollision(enemy.x+10, enemy.y+10, enemy.img:getWidth()-10, enemy.img:getHeight()-10, player.x, player.y, player.img:getWidth(), player.img:getHeight()) 
    and isAlive then
      table.remove(enemies, i)
      isAlive = false
    elseif hp < 1 then
      isAlive = false
    end
  end

  if not isAlive and love.keyboard.isDown('r') then
    -- remove all our bullets and enemies from screen
    bullets = {}
    eBullets = {}
    enemies = {}

    -- reset timers
    canShootTimer = canShootTimerMax
    createEnemyTimer = createEnemyTimerMax

    -- move player back to default position
    player.x = 50
    player.y = 710

    -- reset our game state
    score = 0
    isAlive = true
    hp = 100
  end
end
function love.draw(dt)
  if isAlive then
    love.graphics.draw(player.img, player.x, player.y)
    love.graphics.print("Score: "..tostring(score), 10, 10)
    love.graphics.print("HP: "..tostring(hp), 10, 25)
  else
    love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
  end
  for i, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
  end
  for i, bullet in ipairs(eBullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
  end
  for i, enemy in ipairs(enemies) do
    love.graphics.draw(enemy.img, enemy.x, enemy.y)
  end
end
