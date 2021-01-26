local Constants = {
	WINDOW_WIDTH = 1920,
	WINDOW_HIGHT = 1080,

	VIRTUAL_WIDTH = 512,
	VIRTUAL_HEIGHT = 288,

	TILE_SIZE = 32,
	colors = {
		lightGrey = {213, 213, 213, 255},
		white = {255, 255, 255, 255}
	}
}

Constants.SCALE_MULTIPLIER = Constants.WINDOW_WIDTH / Constants.VIRTUAL_WIDTH

return Constants