local StatePoints = {}

function StatePoints.levelOne() 
    GlobalState.stateMachine:add('play', {levelId = 1, worldName = "steaming-desert"})
end

function StatePoints.worldOne() 
    GlobalState.stateMachine:add('map', {worldName = "steaming-desert"})
end

return StatePoints