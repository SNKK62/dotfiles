local hotkey = require("hs.hotkey")
local window = require("hs.window")
local screen = require("hs.screen")
local mouse = require("hs.mouse")
local timer = require("hs.timer")
local alert = require("hs.alert")
local chooser = require("hs.chooser")
local wf = require("hs.window.filter")
local menubar = require("hs.menubar")

-- Single source of truth for "target screen"
local lastFocusedScreen = nil
-- Windows currently being moved between screens
local moving = {}

local function updateLastFocusedScreen(w)
	if w and w:isStandard() and w:screen() then
		lastFocusedScreen = w:screen()
	end
end

local function targetScreen()
	-- 1) focused window screen
	local w = window.focusedWindow()
	if w and w:isStandard() and w:screen() then
		lastFocusedScreen = w:screen()
		return lastFocusedScreen
	end

	-- 2) last focused screen
	if lastFocusedScreen then
		return lastFocusedScreen
	end

	-- 3) fallback to mouse screen
	local p = mouse.absolutePosition()
	return screen.find(p) or screen.mainScreen()
end

local function sortedScreens()
	local screens = screen.allScreens()
	table.sort(screens, function(a, b)
		local fa, fb = a:fullFrame(), b:fullFrame()
		if fa.x ~= fb.x then
			return fa.x < fb.x
		end
		return fa.y < fb.y
	end)
	return screens
end

local function moveMouseToWindowCenter(w)
	local f = w:frame()
	mouse.setAbsolutePosition({ x = f.x + f.w * 0.5, y = f.y + f.h * 0.5 })
end

local function moveMouseToScreenCenter(scr)
	local f = scr:fullFrame()
	mouse.setAbsolutePosition({ x = f.x + f.w * 0.5, y = f.y + f.h * 0.5 })
end

local function focusNextMonitor()
	local screens = sortedScreens()
	if #screens <= 1 then
		return
	end

	local cur = targetScreen()

	local idx = nil
	for i, s in ipairs(screens) do
		if s:id() == cur:id() then
			idx = i
			break
		end
	end
	if not idx then
		return
	end

	local nextScr = screens[(idx % #screens) + 1]

	-- Focus a window on the next screen, then move mouse to it
	for _, w in ipairs(window.orderedWindows()) do
		if w and w:isStandard() and w:screen() and w:screen():id() == nextScr:id() then
			w:raise()
			w:focus()
			updateLastFocusedScreen(w)
			moveMouseToWindowCenter(w)
			return
		end
	end

	-- No window -> move mouse to screen center and remember it
	lastFocusedScreen = nextScr
	moveMouseToScreenCenter(nextScr)
end

-- ========= Config =========

local WORKSPACE_KEYS = { "1", "2", "3", "4", "b", "c", "n", "t" }
local WORKSPACE_NAMES = { "1", "2", "3", "4", "Browser", "Chat", "Note", "Terminal" }

-- ========= State =========
-- state[screenUUID] = { active = 1..N, ws = { [1]={winId,...}, [2]={...}, ... } }

local state = {}

-- ========= Helpers =========

local function screenOfInterest()
	-- Determine target screen by mouse position (stable even on empty desktop)
	local p = mouse.absolutePosition()
	return screen.find(p) or screen.mainScreen()
end

local function screenOfFocus()
	-- Prefer the screen of the currently focused window
	local w = window.focusedWindow()
	if w and w:isStandard() and w:screen() then
		return w:screen()
	end
	-- Fallback to mouse-based screen
	return screenOfInterest()
end

local function screenKey(scr)
	return scr:getUUID()
end

local function ensureScreenState(scr)
	local key = screenKey(scr)
	if state[key] then
		return state[key]
	end

	local s = { active = 1, ws = {}, lastFocused = {} }
	for i = 1, #WORKSPACE_KEYS do
		s.ws[i] = {}
		s.lastFocused[i] = nil
	end
	state[key] = s
	return s
end

local function isUsableWindow(w)
	return w and w:isStandard() and w:application() and w:role() == "AXWindow"
end

local function focusedWindow()
	local w = window.focusedWindow()
	if isUsableWindow(w) then
		return w
	end
	return nil
end

local function cleanupDeadWindows(scr)
	local s = ensureScreenState(scr)

	-- Build a set of currently existing window IDs for quick membership test
	local alive = {}
	for _, w in ipairs(window.allWindows()) do
		if isUsableWindow(w) then
			alive[w:id()] = true
		end
	end

	for i = 1, #WORKSPACE_KEYS do
		local newList = {}
		for _, id in ipairs(s.ws[i]) do
			if alive[id] then
				table.insert(newList, id)
			end
		end
		s.ws[i] = newList
	end
end

local function findIndex(list, value)
	for i, v in ipairs(list) do
		if v == value then
			return i
		end
	end
	return nil
end

local function removeFromAllWorkspaces(scr, winId)
	local s = ensureScreenState(scr)
	for i = 1, #WORKSPACE_KEYS do
		local list = s.ws[i]
		local idx = findIndex(list, winId)
		if idx then
			table.remove(list, idx)
		end
	end
end

local function isWindowInAnyWorkspace(s, winId)
	for i = 1, #WORKSPACE_KEYS do
		if findIndex(s.ws[i], winId) then
			return true
		end
	end
	return false
end

local function autoAssignUnownedWindowsToWs1(scr)
	local s = ensureScreenState(scr)
	cleanupDeadWindows(scr)

	-- Collect standard windows on this screen in a stable order
	for _, w in ipairs(window.orderedWindows()) do
		if isUsableWindow(w) and w:screen() and w:screen():id() == scr:id() then
			local id = w:id()
			-- Skip windows that are in the middle of a cross-screen move
			if moving[id] then
				goto continue
			end
			if not isWindowInAnyWorkspace(s, id) then
				table.insert(s.ws[1], id)
			end
		end
		::continue::
	end
end

local function focusWindowById(winId)
	local w = window.get(winId)
	if isUsableWindow(w) then
		w:focus()
		return true
	end
	return false
end

local function updateLastFocusedForActiveWorkspace(scr, winId)
	local s = ensureScreenState(scr)
	if s.active and s.ws[s.active] then
		s.lastFocused[s.active] = winId
	end
end

local function pruneLastFocused(scr)
	local s = ensureScreenState(scr)
	for i = 1, #WORKSPACE_KEYS do
		local id = s.lastFocused[i]
		if id and not window.get(id) then
			s.lastFocused[i] = nil
		end
	end
end

-- ======================
-- Debug helpers
-- ======================

local function winLabelById(id)
	local w = window.get(id)
	if not w then
		return ("<dead:%s>"):format(tostring(id))
	end
	local app = w:application() and w:application():name() or "?"
	local title = w:title() or ""
	if #title > 30 then
		title = title:sub(1, 30) .. "…"
	end
	return ("%s(%d): %s"):format(app, id, title)
end

local function dumpStateForScreen(scr)
	local key = scr:getUUID()
	local s = state[key]
	if not s then
		return ("Screen %s: <no state>"):format(scr:name() or "?")
	end

	local lines = {}
	local wsName = WORKSPACE_NAMES[s.active] or "?"
	table.insert(lines, ("Screen %s active=%s"):format(scr:name() or "?", wsName))

	for i = 1, #WORKSPACE_KEYS do
		local list = s.ws[i]
		wsName = WORKSPACE_NAMES[i] or "?"
		if #list > 0 then
			local first = winLabelById(list[1])
			table.insert(lines, ("  %s: %d windows | first=%s"):format(wsName, #list, first))
		else
			table.insert(lines, ("  %s: 0 windows"):format(wsName))
		end
	end

	local fw = window.focusedWindow()
	if fw then
		local fid = fw:id()
		local inWs = nil
		for i = 1, #WORKSPACE_KEYS do
			local idx = findIndex(s.ws[i], fid)
			if idx then
				inWs = ("%s[%d]"):format(WORKSPACE_NAMES[i], idx)
				break
			end
		end
		table.insert(lines, ("Focused: %s"):format(winLabelById(fid)))
		table.insert(lines, ("Focused belongs: %s"):format(inWs or "<none>"))
	else
		table.insert(lines, "Focused: <none>")
	end

	return table.concat(lines, "\n")
end

local function showDebug()
	for _, scr in ipairs(screen.allScreens()) do
		cleanupDeadWindows(scr)
	end

	local scr = targetScreen()
	local msg = dumpStateForScreen(scr)

	alert.show(msg, 3)
end

-- ======================
-- Debug: show active workspace contents
-- ======================

local function showActiveWorkspace()
	local scr = targetScreen()
	local s = ensureScreenState(scr)
	cleanupDeadWindows(scr)
	autoAssignUnownedWindowsToWs1(scr)

	local wsIndex = s.active
	local wsName = WORKSPACE_NAMES[wsIndex] or "?"
	local list = s.ws[wsIndex]

	local lines = {}
	table.insert(lines, string.format("Screen: %s\nActive workspace: %s", scr:name() or "?", wsName))

	if #list == 0 then
		table.insert(lines, "  (empty)")
	else
		for i, winId in ipairs(list) do
			local w = window.get(winId)
			if w then
				local app = w:application() and w:application():name() or "?"
				local title = w:title() or ""
				if #title > 40 then
					title = title:sub(1, 40) .. "…"
				end
				table.insert(lines, string.format("  %d. %s — %s", i, app, title))
			else
				table.insert(lines, string.format("  %d. <dead window: %s>", i, tostring(winId)))
			end
		end
	end

	local msg = table.concat(lines, "\n")
	alert.show(msg, 3)
end

-- ========= Menubar integration =========
local bar = menubar.new()
if bar then
	bar:setClickCallback(function()
		showDebug()
		showActiveWorkspace()
	end)
end

-- caffeine workspace label in menubar
local function updateWorkspaceLabelInBar(activeWorkspaceIndex)
	bar:setTitle(WORKSPACE_NAMES[activeWorkspaceIndex])
end

local function updateActiveWorkspace(s, n)
	s.active = n
	updateWorkspaceLabelInBar(n)
end
-- ========= Core actions =========

local function activateWorkspace(n)
	local scr = targetScreen()
	local s = ensureScreenState(scr)
	cleanupDeadWindows(scr)
	autoAssignUnownedWindowsToWs1(scr)
	pruneLastFocused(scr)

	local list = s.ws[n]
	if #list == 0 then
		-- Do not activate empty workspace
		return
	end

	-- Only now we change active
	updateActiveWorkspace(s, n)

	-- Prefer last focused window in this workspace (no reordering)
	local lastId = s.lastFocused[n]
	if lastId and focusWindowById(lastId) then
		return
	end

	-- Fallback: first window in insertion order
	focusWindowById(list[1])
	s.lastFocused[n] = list[1]
end

local function moveFocusedWindowToWorkspace(n)
	local w = focusedWindow()
	if not w then
		return
	end

	local scr = targetScreen()

	local s = ensureScreenState(scr)
	cleanupDeadWindows(scr)
	autoAssignUnownedWindowsToWs1(scr)
	pruneLastFocused(scr)

	local id = w:id()

	-- Detect source workspace before removal
	local src = nil
	for i = 1, #WORKSPACE_KEYS do
		if findIndex(s.ws[i], id) then
			src = i
			break
		end
	end

	-- Remove from any workspace, then append to destination (stable insertion order)
	removeFromAllWorkspaces(scr, id)
	table.insert(s.ws[n], id)

	-- Clear last viewed of the source workspace (as requested)
	if src then
		s.lastFocused[src] = nil
	end

	-- Activate destination workspace and set last viewed to this window
	updateActiveWorkspace(s, n)
	s.lastFocused[n] = id

	-- Keep focus unchanged
	w:focus()
end

local function focusNextPrevInActiveWorkspace(delta)
	local w = focusedWindow()
	if not w then
		return
	end

	local scr = targetScreen()
	local s = ensureScreenState(scr)
	autoAssignUnownedWindowsToWs1(scr)
	cleanupDeadWindows(scr)

	local list = s.ws[s.active]
	if #list == 0 then
		return
	end

	local id = w:id()
	local idx = findIndex(list, id)
	if not idx then
		-- If focused window not in list, fall back to first window
		focusWindowById(list[1])
		updateLastFocusedForActiveWorkspace(scr, list[1])
		return
	end

	local nextIdx = idx + delta
	if nextIdx < 1 or nextIdx > #list then
		return -- no wrap
	end

	local ok = focusWindowById(list[nextIdx])
	if ok then
		updateLastFocusedForActiveWorkspace(scr, list[nextIdx])
	end
end

local function reorderFocusedWindowInActiveWorkspace(delta)
	local w = focusedWindow()
	if not w then
		return
	end

	local scr = targetScreen()
	local s = ensureScreenState(scr)
	autoAssignUnownedWindowsToWs1(scr)
	cleanupDeadWindows(scr)

	local list = s.ws[s.active]
	if #list <= 1 then
		return
	end

	local id = w:id()
	local idx = findIndex(list, id)
	if not idx then
		return
	end

	local swapIdx = idx + delta
	if swapIdx < 1 or swapIdx > #list then
		return -- at edge: do nothing, no wrap
	end

	-- Swap positions
	list[idx], list[swapIdx] = list[swapIdx], list[idx]

	-- Keep focus on the same window
	w:focus()
end

-- Auto-activate the workspace that contains the newly focused window (no :start() needed)
local function workspaceIndexForWindow(scr, winId)
	local s = ensureScreenState(scr)
	for i = 1, #WORKSPACE_KEYS do
		if findIndex(s.ws[i], winId) then
			return i
		end
	end
	return nil
end

local function setActiveWorkspaceForFocusedWindow(w)
	local winId = w:id()
	if moving[winId] then
		return
	end
	if not w or not isUsableWindow(w) then
		return
	end

	-- Avoid changing active state while chooser is visible
	if WsChooser and WsChooser:isVisible() then
		return
	end

	local scr = targetScreen()
	if not scr then
		return
	end

	local s = ensureScreenState(scr)
	cleanupDeadWindows(scr)

	local winId = w:id()
	local idx = workspaceIndexForWindow(scr, winId)

	if not idx then
		-- Unowned windows go to ws1 by default (stable insertion order)
		removeFromAllWorkspaces(scr, winId)
		table.insert(s.ws[1], winId)
		idx = 1
	end

	updateActiveWorkspace(s, idx)
	s.lastFocused[idx] = winId
end

-- UI chooser for active workspace windows (alt(+shift)+tab)
WsChooser = chooser.new(function(choice)
	-- Called when user confirms selection (e.g., Enter)
	if not choice then
		return
	end

	-- Debug: confirm callback is firing
	-- Comment out later if you want
	-- alert.show("Selected: " .. (choice.text or "?"), 0.6)

	local w = window.get(choice.winId)
	if w and w:isStandard() then
		local app = w:application()
		if app then
			app:activate(true)
		end
		w:raise()
		w:focus()
	end
end)

WsChooser:searchSubText(true)

local function buildActiveWorkspaceChoices(reverse)
	local scr = targetScreen()
	local s = ensureScreenState(scr)

	cleanupDeadWindows(scr)
	autoAssignUnownedWindowsToWs1(scr)

	local wsIndex = s.active
	local list = s.ws[wsIndex]

	local choices = {}
	for i, winId in ipairs(list) do
		local w = window.get(winId)
		if w and w:isStandard() then
			local app = w:application() and w:application():name() or "?"
			local title = w:title() or ""
			table.insert(choices, {
				text = string.format("%d. %s", i, app),
				subText = title,
				winId = winId,
			})
		end
	end

	if reverse then
		local rev = {}
		for i = #choices, 1, -1 do
			table.insert(rev, choices[i])
		end
		choices = rev
	end

	return choices
end

local function showActiveWorkspaceChooser(reverse)
	local choices = buildActiveWorkspaceChoices(reverse)
	WsChooser:choices(choices)
	WsChooser:query("")

	-- Ensure a row is selected BEFORE showing
	local selected = 1
	local fw = window.focusedWindow()
	if fw and fw:isStandard() then
		local fid = fw:id()
		for i, c in ipairs(choices) do
			if c.winId == fid then
				selected = i
				break
			end
		end
	end

	WsChooser:selectedRow(selected)
	WsChooser:show()
end

-- =======Monitor config=======
-- Move focused window to the other monitor, keeping the same pseudo-workspace index

local function indexOfScreen(screens, scr)
	for i, s in ipairs(screens) do
		if s:id() == scr:id() then
			return i
		end
	end
	return nil
end

local function workspaceIndexForWindowOnScreen(scr, winId)
	local s = ensureScreenState(scr)
	for i = 1, #WORKSPACE_KEYS do
		if findIndex(s.ws[i], winId) then
			return i
		end
	end
	return nil
end

local function removeFromAllWorkspacesOnScreen(scr, winId)
	local s = ensureScreenState(scr)
	for i = 1, #WORKSPACE_KEYS do
		local list = s.ws[i]
		local idx = findIndex(list, winId)
		if idx then
			table.remove(list, idx)
		end
	end
end

local function moveFocusedWindowToOtherMonitorSameWorkspace()
	local w = focusedWindow()
	if not w then
		return
	end

	local curScr = targetScreen()
	if not curScr then
		return
	end

	local screens = screen.allScreens()
	if #screens <= 1 then
		return
	end

	local curIdx = indexOfScreen(screens, curScr)
	if not curIdx then
		return
	end

	-- Choose "the other" screen:
	-- - If exactly 2 screens, this picks the other one
	-- - If 3+, cycles to next
	local dstScr = screens[(curIdx % #screens) + 1]

	local winId = w:id()

	-- Ensure states are sane
	local srcState = ensureScreenState(curScr)
	local dstState = ensureScreenState(dstScr)
	cleanupDeadWindows(curScr)
	cleanupDeadWindows(dstScr)
	autoAssignUnownedWindowsToWs1(curScr)
	autoAssignUnownedWindowsToWs1(dstScr)
	pruneLastFocused(curScr)
	pruneLastFocused(dstScr)

	-- Determine source workspace index (where this window currently belongs)
	local srcWs = workspaceIndexForWindowOnScreen(curScr, winId) or srcState.active or 1
	if srcWs < 1 or srcWs > #WORKSPACE_KEYS then
		srcWs = 1
	end

	-- Remove from source screen workspaces
	removeFromAllWorkspacesOnScreen(curScr, winId)
	srcState.lastFocused[srcWs] = nil

	-- Move the actual window to destination screen
	w:moveToScreen(dstScr)

	local _winId = w:id()
	moving[_winId] = true

	-- Remove from source bookkeeping *before* moving
	removeFromAllWorkspacesOnScreen(curScr, _winId)
	srcState.lastFocused[srcWs] = nil

	-- Move the actual window
	w:moveToScreen(dstScr)

	-- Finalize after macOS updates window->screen association
	timer.doAfter(0.08, function()
		-- Ensure it is not re-added to the old screen by any watcher/timer
		removeFromAllWorkspacesOnScreen(curScr, _winId)

		-- Ensure destination bookkeeping is clean, then add
		removeFromAllWorkspacesOnScreen(dstScr, _winId)
		table.insert(dstState.ws[srcWs], _winId)

		-- Activate destination workspace and mark last viewed
		updateActiveWorkspace(dstState, srcWs)
		dstState.lastFocused[srcWs] = _winId

		-- Focus the moved window
		w:raise()
		w:focus()

		moving[_winId] = nil
	end)

	-- Add to destination screen's same workspace index (stable insertion order)
	removeFromAllWorkspacesOnScreen(dstScr, _winId)
	table.insert(dstState.ws[srcWs], _winId)

	-- Activate destination workspace and mark last viewed
	dstState.active = srcWs
	dstState.lastFocused[srcWs] = _winId

	-- Focus the moved window
	w:raise()
	w:focus()

	-- If you have a menubar updater, refresh it
	updateActiveWorkspace(dstState, srcWs)
end

-- Migrate windows from removed screens to the remaining screen, keeping the same pseudo-workspace index

local lastScreenCount = #screen.allScreens()

local function migrateAllToSingleScreen()
	local screens = screen.allScreens()
	if #screens ~= 1 then
		return
	end

	local dstScr = screens[1]
	local dstKey = dstScr:getUUID()
	local dstState = ensureScreenState(dstScr)

	cleanupDeadWindows(dstScr)
	autoAssignUnownedWindowsToWs1(dstScr)
	pruneLastFocused(dstScr)

	-- Build a set of alive window IDs for validation
	local alive = {}
	for _, w in ipairs(window.allWindows()) do
		if isUsableWindow(w) then
			alive[w:id()] = true
		end
	end

	-- IMPORTANT: iterate over state keys (including removed screens)
	for srcKey, srcState in pairs(state) do
		if srcKey ~= dstKey then
			for wsIdx = 1, #WORKSPACE_KEYS do
				local list = srcState.ws[wsIdx] or {}
				for _, winId in ipairs(list) do
					if alive[winId] then
						local w = window.get(winId)
						if isUsableWindow(w) then
							-- macOS usually already moved windows to the remaining screen,
							-- but moveToScreen is safe and ensures consistency.
							w:moveToScreen(dstScr)

							-- Put into the same workspace index on destination (append, stable order)
							removeFromAllWorkspaces(dstScr, winId)
							table.insert(dstState.ws[wsIdx], winId)
						end
					end
				end

				-- Clear source bookkeeping
				srcState.ws[wsIdx] = {}
				srcState.lastFocused[wsIdx] = nil
			end
		end
	end

	-- Keep destination active valid; do not activate empty workspaces
	local a = dstState.active or 1
	if a < 1 or a > #WORKSPACE_KEYS then
		a = 1
	end
	if #dstState.ws[a] == 0 then
		for i = 1, #WORKSPACE_KEYS do
			if #dstState.ws[i] > 0 then
				a = i
				break
			end
		end
	end

	updateActiveWorkspace(dstState, a)
end

-- Screen watcher: detect 2+ -> 1 transition
local displayWatcher = screen.watcher.new(function()
	local n = #screen.allScreens()
	if lastScreenCount > 1 and n == 1 then
		-- Delay slightly to let macOS reattach windows
		timer.doAfter(0.3, function()
			migrateAllToSingleScreen()
		end)
	end
	lastScreenCount = n
end)

displayWatcher:start()

-- ========= Hotkeys =========
-- -- ctrl + s : focus next monitor
hotkey.bind({ "ctrl", "cmd" }, "s", function()
	focusNextMonitor()
end)

-- ctrl + cmd + shift + s
hotkey.bind({ "ctrl", "cmd", "shift" }, "s", function()
	moveFocusedWindowToOtherMonitorSameWorkspace()
end)
--
-- alt+tab => show chooser (normal order)
hotkey.bind({ "alt" }, "tab", function()
	showActiveWorkspaceChooser(false)
end)

-- alt+shift+tab => show chooser (reverse order)
hotkey.bind({ "alt", "shift" }, "tab", function()
	showActiveWorkspaceChooser(true)
end)

hotkey.bind({ "alt" }, "w", function()
	showDebug()
end)
hotkey.bind({ "alt", "shift" }, "w", function()
	showActiveWorkspace()
end)

-- alt + N: activate workspace N on the screen under mouse cursor
for i, k in ipairs(WORKSPACE_KEYS) do
	hotkey.bind({ "alt" }, k, function()
		activateWorkspace(i)
	end)

	-- alt + shift + N: move focused window to workspace N (same screen as the window)
	hotkey.bind({ "alt", "shift" }, k, function()
		moveFocusedWindowToWorkspace(i)
	end)
end

-- cmd + ctrl + h/l: focus prev/next within active workspace (based on focused window's screen)
hotkey.bind({ "cmd", "ctrl" }, "h", function()
	focusNextPrevInActiveWorkspace(-1)
end)

hotkey.bind({ "cmd", "ctrl" }, "l", function()
	focusNextPrevInActiveWorkspace(1)
end)

-- cmd + ctrl + shift + h/l: reorder focused window within active workspace (no wrap, keep focus)
hotkey.bind({ "cmd", "ctrl", "shift" }, "h", function()
	reorderFocusedWindowInActiveWorkspace(-1)
end)

hotkey.bind({ "cmd", "ctrl", "shift" }, "l", function()
	reorderFocusedWindowInActiveWorkspace(1)
end)

-- ========= Auto cleanup =========

-- Periodic cleanup in case windows close without focus changes
timer.doEvery(5, function()
	for _, scr in ipairs(screen.allScreens()) do
		cleanupDeadWindows(scr)
		autoAssignUnownedWindowsToWs1(scr)
	end
end)

-- ========== Start watchers =========

-- Global window filter; subscribing is enough (no start() call)
local focusWatcher = wf.new(nil)
focusWatcher:subscribe(wf.windowFocused, function(w)
	updateLastFocusedScreen(w)
	setActiveWorkspaceForFocusedWindow(w)
end)
