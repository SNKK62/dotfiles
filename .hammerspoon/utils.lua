local utils = {}

--Predicate that checks if a window belongs to a screen
utils.isInScreen = function(screen, win)
	return win:screen() == screen
end
utils.isInScreenAndHasTitle = function(screen, win)
	return utils.isInScreen(screen, win) and #win:title() > 0
end

return utils
