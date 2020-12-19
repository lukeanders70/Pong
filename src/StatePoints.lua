local StatePoints = {}

function StatePoints.levelOne() 
    GlobalState.stateMachine:add('play', {levelId = 1})
end

return StatePoints