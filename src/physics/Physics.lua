local Physics = {}

Physics.GRAVITY = 1024 -- pixels per seconds squared
Physics.MAX_VELOCITY = 10000 -- pixels per seconds (in any one dimension)
Physics.FRICTION = 50000


function Physics.update(moveable, dt)

    if (moveable.acceleration.x == 0) then
        if moveable.velocity.x > 0 then
            moveable.acceleration.x = moveable.acceleration.x - (Physics.FRICTION * dt)
        elseif moveable.velocity.x < 0 then
            moveable.acceleration.x = moveable.acceleration.x + (Physics.FRICTION * dt)
        end
    end

    moveable.velocity.x = math.min(
        moveable.velocity.x + (moveable.acceleration.x * dt), 
        Physics.MAX_VELOCITY
    )
    moveable.velocity.y = math.min(
        moveable.velocity.y + (moveable.acceleration.y * dt),
        Physics.MAX_VELOCITY
    )

    moveable.lastX = moveable.x
    moveable.lastY = moveable.y

    moveable.x = moveable.x + (moveable.velocity.x * dt)
    moveable.y = moveable.y + (moveable.velocity.y * dt)

    Physics.ZeroIfLow(moveable)
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
        moveable.velocity.x =0
    end
    if math.abs(moveable.velocity.y) < 1 then
        moveable.velocity.y =0
    end
end

return Physics