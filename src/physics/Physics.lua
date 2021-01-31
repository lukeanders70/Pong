local Physics = {}

Physics.GRAVITY = 1524 -- pixels per seconds squared
Physics.MAX_VELOCITY = 10000 -- pixels per seconds (in any one dimension)
Physics.FRICTION = 1000


function Physics.update(moveable, dt, blockBelow)

    moveable.velocity.x = math.min(
        moveable.velocity.x + (moveable.acceleration.x * dt), 
        Physics.MAX_VELOCITY
    )
    local usedAccelectionY = moveable.acceleration.y
    if moveable.gravity and (not blockBelow) then
        usedAccelectionY = usedAccelectionY + Physics.GRAVITY
    end
    moveable.velocity.y = math.min(
        moveable.velocity.y + (usedAccelectionY * dt),
        Physics.MAX_VELOCITY
    )

    if not moveable.noFriction then
        moveable.velocity.x = Physics.applyFriction(moveable.velocity.x, dt)
    end

    moveable.x = moveable.x + (moveable.velocity.x * dt)
    moveable.y = moveable.y + (moveable.velocity.y * dt)

    Physics.ZeroIfLow(moveable)
end

function Physics.applyFriction(velocityX, dt)
    if velocityX > 0 then
        return math.max(velocityX - (Physics.FRICTION * dt), 0)
    elseif velocityX < 0 then
        return math.min(velocityX + (Physics.FRICTION * dt), 0)
    else
        return 0
    end
end

-- if velocity or acceleration is really low, we just want to push it to zero
function Physics.ZeroIfLow(moveable)
    if math.abs(moveable.acceleration.x) < 1 then
        moveable.acceleration.x = 0
    end
    if math.abs(moveable.acceleration.y) < 1 then
        moveable.acceleration.y = 0
    end
    if math.abs(moveable.velocity.x) < 1 then
        moveable.velocity.x = 0
    end
    if math.abs(moveable.velocity.y) < 1 then
        moveable.velocity.y = 0
    end
end

return Physics