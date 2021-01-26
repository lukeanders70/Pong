local data = {
    name_display = "Steaming Desert",
    name = "steaming-desert",
    map = "world1-animated",
    nodes = {
        {type = "level", x = 110, y = 167, id = 1},
        {type = "level", x = 161, y = 167, id = 2},
        {type = "corner", x = 214, y = 167},
        {type = "level", x = 214, y = 145, id = 3},
        {type = "level", x = 214, y = 223, id = 4}
    },
    paths = {
        {1, 2},
        {2, 3},
        {3, 4},
        {3, 5}
    }
}

return data