local data = {
    name = "Steaming Desert",
    map = "world1",
    nodes = {
        {type = "level", x = 30, y = 30, id = 1},
        {type = "level", x = 40, y = 30, id = 2},
        {type = "corner", x = 30, y = 40},
        {type = "level", x = 40, y = 40, id = 3},
        {type = "level", x = 50, y = 40, id = 4}
    },
    paths = {
        {1, 2},
        {1, 3},
        {3, 4},
        {4, 5}
    }
}

return data