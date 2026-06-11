-- lua/plugins/config/snacks.lua
-- Modern UI/helper modules via snacks.nvim.

local DASHBOARD_WIDTH = 92
local COMPACT_DASHBOARD_COLUMNS = 110

local COMPACT_LEFT_PADDING = 2
local COMPACT_RIGHT_PADDING = 2

local MENU_WIDTH = 21
local MENU_WIDTH_COMPACT = 15
local LOGO_LEFT_GAP = 5
local LOGO_LEFT_GAP_COMPACT = 0

-- Right-side key column for dashboard menu shortcuts.
-- Increase this to move f/g/r/c... right.
-- Decrease this to move them left.
local KEY_COLUMN = 91
local KEY_COLUMN_COMPACT = 78

-- One space = one terminal column.
-- Change to "  " only if you want every logo pixel to become wider.
local PIXEL = " "

local LOGO_WIDTH = 0

-- Dashboard logo animation.
-- This version uses per-pixel wave highlights with simulated transparency.
local ANIMATE_LOGO = true
local ANIMATION_INTERVAL = 70 -- milliseconds; lower = smoother/faster, higher = lighter/slower

-- Experimental Milli blackhole overlay.
-- Requires:
--   { "amansingh-afk/milli.nvim", lazy = false }
--
-- This does NOT insert the blackhole as a dashboard section.
-- It draws the animation as virtual overlay text, so it does not move Recent Files / Projects.
-- It avoids drawing over existing dashboard text, so text stays visually in front.
local MILLI_BLACKHOLE_ENABLED = true
local MILLI_BLACKHOLE_ANIMATE = true
local MILLI_BLACKHOLE_SPLASH = "blackhole"
local MILLI_BLACKHOLE_START_DELAY = 350
local MILLI_BLACKHOLE_MIN_DELAY = 70

-- Positive = move right, negative = move left.
local MILLI_BLACKHOLE_SHIFT_RIGHT = 47

-- Where to begin vertically.
-- Calculated from the "Recent Files" line, then offset down.
local MILLI_BLACKHOLE_VERTICAL_OFFSET = 0

-- Used when Milli frame characters have no explicit colour run.
-- This prevents uncoloured parts of the blackhole from becoming white.
local MILLI_BLACKHOLE_FALLBACK_GRADIENT = {
	"#7B1E7A",
	"#A12A5E",
	"#D14A3A",
	"#E86D2D",
	"#F59E0B",
	"#F97316",
}

local STATIC_LOGO_COLORS = {
	B = "#4C9AD6",
	G = "#57A64A",
	K = "#05070A",
}

local WAVE_GRADIENT = {
	"#4C9AD6", -- blue
	"#5DADE2", -- light blue
	-- "#7AA2F7", -- soft blue
	-- "#89B4FA", -- bright blue
	-- "#CBA6F7", -- purple
	-- "#F5C2E7", -- pink
	-- "#FAB387", -- orange
	-- "#F9E2AF", -- yellow
	"#A6E3A1", -- green
	"#94E2D5", -- teal
}

local OUTLINE_COLOR = "#05070A"

-- Dashboard menu/UI colours.
-- Change DASHBOARD_DESC_COLOR if you want the left menu text to be another colour.
local DASHBOARD_DESC_COLOR = "#A6E3A1"
local DASHBOARD_TITLE_COLOR = "#89B4FA"

local DASHBOARD_ICON_COLORS = {
	find = "#89B4FA",
	grep = "#94E2D5",
	recent = "#A6E3A1",
	config = "#F9E2AF",
	git = "#FAB387",
	lazy = "#CBA6F7",
	mason = "#74C7EC",
	health = "#A6E3A1",
	quit = "#F38BA8",
	project = "#89B4FA",
}

-- Wave movement.
local LOGO_WAVE_X = 0.035
local LOGO_WAVE_Y = 0.085
local LOGO_WAVE_SPEED = 0.018
local LOGO_GREEN_OFFSET = 0.18

-- Simulated transparency.
-- Lower values = original blue/green colours are more visible.
-- Higher values = animated wave is stronger.
local LOGO_WAVE_OPACITY_MIN = 0.18
local LOGO_WAVE_OPACITY_MAX = 0.46

local logo_animation_frame = 0
local logo_animation_enabled = ANIMATE_LOGO
local logo_hl_cache = {}
local milli_blackhole_cache = nil
local milli_hl_cache = {}

local dashboard_logo_group = vim.api.nvim_create_augroup("DashboardLogoAnimation", {
	clear = true,
})

local milli_overlay_ns = vim.api.nvim_create_namespace("DashboardMilliBlackholeOverlay")

local function is_compact_dashboard()
	return (vim.o.columns or DASHBOARD_WIDTH) <= COMPACT_DASHBOARD_COLUMNS
end

local function current_available_width()
	local columns = vim.o.columns or DASHBOARD_WIDTH

	if is_compact_dashboard() then
		return math.max(1, math.min(DASHBOARD_WIDTH, columns - 2))
	end

	return DASHBOARD_WIDTH
end

local function current_left_padding()
	return is_compact_dashboard() and COMPACT_LEFT_PADDING or 0
end

local function current_right_padding()
	return is_compact_dashboard() and COMPACT_RIGHT_PADDING or 0
end

local function current_menu_width()
	return is_compact_dashboard() and MENU_WIDTH_COMPACT or MENU_WIDTH
end

local function current_key_column()
	if is_compact_dashboard() then
		return math.max(1, current_available_width() - current_right_padding())
	end

	return KEY_COLUMN
end

local function current_logo_left_gap(left_padding, icon_width, menu_width)
	if not is_compact_dashboard() then
		return LOGO_LEFT_GAP
	end

	local before_logo = left_padding + icon_width + menu_width
	local logo_right_edge = current_key_column() - 1

	return math.max(LOGO_LEFT_GAP_COMPACT, logo_right_edge - before_logo - LOGO_WIDTH)
end

-- local function current_logo_left_gap(left_padding, icon_width, menu_width)
-- 	if not is_compact_dashboard() then
-- 		return LOGO_LEFT_GAP
-- 	end
--
-- 	local before_logo = left_padding + icon_width + menu_width
-- 	local logo_right_edge = current_key_column() - 1
--
-- 	return math.max(LOGO_LEFT_GAP_COMPACT, logo_right_edge - before_logo - LOGO_WIDTH)
-- end

local function display_width(line)
	return vim.fn.strdisplaywidth(line)
end

local function pad_right(line, width)
	local padding = math.max(width - display_width(line), 0)
	return line .. string.rep(" ", padding)
end

local function center_line(line, width)
	local padding = math.max(width - display_width(line), 0)
	local left = math.floor(padding / 2)
	local right = padding - left

	return string.rep(" ", left) .. line .. string.rep(" ", right)
end

local function left_pad_width(content_width, total_width)
	return math.max(math.floor((total_width - content_width) / 2), 0)
end

local function clean_pixel(ch)
	if ch == "B" or ch == "G" or ch == "K" then
		return ch
	end

	return " "
end

local function hex_to_rgb(hex)
	hex = hex:gsub("#", "")

	return {
		r = tonumber(hex:sub(1, 2), 16),
		g = tonumber(hex:sub(3, 4), 16),
		b = tonumber(hex:sub(5, 6), 16),
	}
end

local function rgb_to_hex(rgb)
	return string.format("#%02X%02X%02X", rgb.r, rgb.g, rgb.b)
end

local function lerp(a, b, t)
	return a + ((b - a) * t)
end

local function blend_hex(a, b, t)
	local ca = hex_to_rgb(a)
	local cb = hex_to_rgb(b)

	return rgb_to_hex({
		r = math.floor(lerp(ca.r, cb.r, t) + 0.5),
		g = math.floor(lerp(ca.g, cb.g, t) + 0.5),
		b = math.floor(lerp(ca.b, cb.b, t) + 0.5),
	})
end

local function sample_gradient(t)
	t = t % 1

	local count = #WAVE_GRADIENT
	local scaled = t * count
	local index = math.floor(scaled) + 1
	local next_index = index + 1

	if next_index > count then
		next_index = 1
	end

	local local_t = scaled - math.floor(scaled)

	return blend_hex(WAVE_GRADIENT[index], WAVE_GRADIENT[next_index], local_t)
end

local function sample_milli_fallback_gradient(t)
	t = t % 1

	local count = #MILLI_BLACKHOLE_FALLBACK_GRADIENT
	local scaled = t * count
	local index = math.floor(scaled) + 1
	local next_index = index + 1

	if next_index > count then
		next_index = 1
	end

	local local_t = scaled - math.floor(scaled)

	return blend_hex(MILLI_BLACKHOLE_FALLBACK_GRADIENT[index], MILLI_BLACKHOLE_FALLBACK_GRADIENT[next_index], local_t)
end

local function milli_fallback_color(col, row)
	local phase = (col * 0.018) + (row * 0.055) + (logo_animation_frame * 0.01)
	return sample_milli_fallback_gradient(phase)
end

local function pixel_color(ch, x, y)
	ch = clean_pixel(ch)

	if ch == " " then
		return nil
	end

	if ch == "K" then
		return OUTLINE_COLOR
	end

	local base_color = STATIC_LOGO_COLORS[ch]

	if not logo_animation_enabled then
		return base_color
	end

	local offset = ch == "G" and LOGO_GREEN_OFFSET or 0
	local phase = (logo_animation_frame * LOGO_WAVE_SPEED) + (x * LOGO_WAVE_X) + (y * LOGO_WAVE_Y) + offset

	local wave_color = sample_gradient(phase)

	-- Simulated alpha:
	-- base blue/green remains underneath, animated gradient is blended on top.
	local wave = 0.5 + (0.5 * math.sin((phase % 1) * math.pi * 2))
	local opacity = LOGO_WAVE_OPACITY_MIN + ((LOGO_WAVE_OPACITY_MAX - LOGO_WAVE_OPACITY_MIN) * wave)

	return blend_hex(base_color, wave_color, opacity)
end

local function logo_hl_name(x, y, top, bottom)
	top = clean_pixel(top)
	bottom = clean_pixel(bottom)

	top = top == " " and "T" or top
	bottom = bottom == " " and "T" or bottom

	return string.format("DashboardLogoPx_%02d_%02d_%s_%s", y, x, top, bottom)
end

local function logo_hl_opts(x, visible_row, top, bottom)
	top = clean_pixel(top)
	bottom = clean_pixel(bottom)

	local opts = {}

	local top_color = pixel_color(top, x, (visible_row * 2) - 1)
	local bottom_color = pixel_color(bottom, x, visible_row * 2)

	if top ~= " " and bottom ~= " " then
		if top == bottom then
			opts.fg = top_color
		else
			opts.fg = top_color
			opts.bg = bottom_color
		end
	elseif top ~= " " then
		opts.fg = top_color
	elseif bottom ~= " " then
		opts.fg = bottom_color
	end

	return opts
end

local function set_static_logo_hl()
	vim.api.nvim_set_hl(0, "DashboardLogoBlueBlock", {
		fg = STATIC_LOGO_COLORS.B,
		bg = STATIC_LOGO_COLORS.B,
	})

	vim.api.nvim_set_hl(0, "DashboardLogoGreenBlock", {
		fg = STATIC_LOGO_COLORS.G,
		bg = STATIC_LOGO_COLORS.G,
	})

	vim.api.nvim_set_hl(0, "DashboardLogoBlackBlock", {
		fg = STATIC_LOGO_COLORS.K,
		bg = STATIC_LOGO_COLORS.K,
	})
end

local function set_dashboard_ui_hl()
	vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = DASHBOARD_DESC_COLOR })
	vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = DASHBOARD_TITLE_COLOR })

	vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = DASHBOARD_ICON_COLORS.find })
	vim.api.nvim_set_hl(0, "DashboardIconFind", { fg = DASHBOARD_ICON_COLORS.find })
	vim.api.nvim_set_hl(0, "DashboardIconGrep", { fg = DASHBOARD_ICON_COLORS.grep })
	vim.api.nvim_set_hl(0, "DashboardIconRecent", { fg = DASHBOARD_ICON_COLORS.recent })
	vim.api.nvim_set_hl(0, "DashboardIconConfig", { fg = DASHBOARD_ICON_COLORS.config })
	vim.api.nvim_set_hl(0, "DashboardIconGit", { fg = DASHBOARD_ICON_COLORS.git })
	vim.api.nvim_set_hl(0, "DashboardIconLazy", { fg = DASHBOARD_ICON_COLORS.lazy })
	vim.api.nvim_set_hl(0, "DashboardIconMason", { fg = DASHBOARD_ICON_COLORS.mason })
	vim.api.nvim_set_hl(0, "DashboardIconHealth", { fg = DASHBOARD_ICON_COLORS.health })
	vim.api.nvim_set_hl(0, "DashboardIconQuit", { fg = DASHBOARD_ICON_COLORS.quit })
	vim.api.nvim_set_hl(0, "DashboardIconProject", { fg = DASHBOARD_ICON_COLORS.project })
	vim.api.nvim_set_hl(0, "DashboardStartupIcon", { fg = "#F9E2AF" })
	vim.api.nvim_set_hl(0, "DashboardStartupText", { fg = "#89B4FA" })
	vim.api.nvim_set_hl(0, "DashboardStartupNumber", { fg = "#F5C2E7" })
end

local function update_logo_highlights()
	set_static_logo_hl()
	set_dashboard_ui_hl()

	for name, item in pairs(logo_hl_cache) do
		vim.api.nvim_set_hl(0, name, logo_hl_opts(item.x, item.y, item.top, item.bottom))
	end
end

set_static_logo_hl()
set_dashboard_ui_hl()

vim.api.nvim_create_autocmd("ColorScheme", {
	group = dashboard_logo_group,
	callback = update_logo_highlights,
})

local dashboard_logo_timer

local function animate_dashboard_logo()
	if not logo_animation_enabled then
		return
	end

	logo_animation_frame = logo_animation_frame + 1
	update_logo_highlights()
	pcall(vim.cmd, "redraw")
end

local function start_dashboard_logo_animation()
	if dashboard_logo_timer or not ANIMATE_LOGO then
		return
	end

	local uv = vim.uv or vim.loop
	dashboard_logo_timer = uv.new_timer()

	dashboard_logo_timer:start(
		ANIMATION_INTERVAL,
		ANIMATION_INTERVAL,
		vim.schedule_wrap(function()
			animate_dashboard_logo()
		end)
	)
end

local function stop_dashboard_logo_animation()
	if not dashboard_logo_timer then
		return
	end

	dashboard_logo_timer:stop()
	dashboard_logo_timer:close()
	dashboard_logo_timer = nil
end

vim.api.nvim_create_user_command("DashboardLogoAnimationToggle", function()
	logo_animation_enabled = not logo_animation_enabled

	update_logo_highlights()
	pcall(vim.cmd, "redraw")

	if logo_animation_enabled then
		vim.notify("Dashboard logo animation enabled", vim.log.levels.INFO)
	else
		vim.notify("Dashboard logo animation disabled", vim.log.levels.INFO)
	end
end, {
	desc = "Toggle dashboard logo colour animation",
})

vim.api.nvim_create_user_command("DashboardLogoAnimationStep", function()
	logo_animation_frame = logo_animation_frame + 1
	update_logo_highlights()
	pcall(vim.cmd, "redraw")
end, {
	desc = "Step dashboard logo animation by one frame",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = dashboard_logo_group,
	callback = stop_dashboard_logo_animation,
})

start_dashboard_logo_animation()

local function logo_hl(x, visible_row, top, bottom)
	top = clean_pixel(top)
	bottom = clean_pixel(bottom)

	local name = logo_hl_name(x, visible_row, top, bottom)

	if not logo_hl_cache[name] then
		logo_hl_cache[name] = {
			x = x,
			y = visible_row,
			top = top,
			bottom = bottom,
		}
	end

	vim.api.nvim_set_hl(0, name, logo_hl_opts(x, visible_row, top, bottom))

	return name
end

local function repeat_pixel(char)
	return string.rep(char, display_width(PIXEL))
end

local function half_pixel(top, bottom, x, visible_row)
	top = clean_pixel(top)
	bottom = clean_pixel(bottom)

	if top == " " and bottom == " " then
		return { PIXEL, width = display_width(PIXEL) }
	end

	if top ~= " " and bottom ~= " " then
		if top == bottom then
			return { repeat_pixel("█"), hl = logo_hl(x, visible_row, top, bottom) }
		end

		return { repeat_pixel("▀"), hl = logo_hl(x, visible_row, top, bottom) }
	end

	if top ~= " " then
		return { repeat_pixel("▀"), hl = logo_hl(x, visible_row, top, bottom) }
	end

	return { repeat_pixel("▄"), hl = logo_hl(x, visible_row, top, bottom) }
end

local logo_pixels = {
	"        KKK                 KKK",
	"       KKBKK                KGKK",
	"      KKBBGKK               KGGKK",
	"     KKBBBGGKK              KGGGKK",
	"    KKBBBBGGGKK             KGGGGKK",
	"   KKBBBBBGGGGKK            KGGGGGKK",
	"  KKBBBBBBGGGGGKK           KGGGGGGKK",
	" KKBBBBBBBGGGGGGKK          KGGGGGGGKK",
	"KKBBBBBBBBGGGGGGGKK         KGGGGGGGGKK",
	"KBBBBBBBBBGGGGGGGGKK        KGGGGGGGGGK",
	"KBBBBBBBBBGGGGGGGGGKK       KGGGGGGGGGK",
	"KBBBBBBBBBGGGGGGGGGGKK      KGGGGGGGGGK",
	"KBBBBBBBBBGGGGGGGGGGGKK     KGGGGGGGGGK",
	"KBBBBBBBBBKGGGGGGGGGGGKK    KGGGGGGGGGK",
	"KBBBBBBBBBKKGGGGGGGGGGGKK   KGGGGGGGGGK",
	"KBBBBBBBBBKKKGGGGGGGGGGGKK  KGGGGGGGGGK",
	"KBBBBBBBBBKKKKGGGGGGGGGGGKK KGGGGGGGGGK",
	"KBBBBBBBBBK KKKGGGGGGGGGGGKKKGGGGGGGGGK",
	"KBBBBBBBBBK  KKKGGGGGGGGGGGKKGGGGGGGGGK",
	"KBBBBBBBBBK   KKKGGGGGGGGGGGKGGGGGGGGGK",
	"KBBBBBBBBBK    KKKGGGGGGGGGGGGGGGGGGGGK",
	"KBBBBBBBBBK     KKKGGGGGGGGGGGGGGGGGGGK",
	"KBBBBBBBBBK      KKKGGGGGGGGGGGGGGGGGGK",
	"KBBBBBBBBBK       KKKGGGGGGGGGGGGGGGGGK",
	"KKBBBBBBBBK        KKKGGGGGGGGGGGGGGGKK",
	"KKKBBBBBBBK         KKKGGGGGGGGGGGGGKKK",
	" KKKBBBBBBK          KKKGGGGGGGGGGGKKK",
	"  KKKBBBBBK           KKKGGGGGGGGGKKK",
	"   KKKBBBBK            KKKGGGGGGGKKK",
	"    KKKBBBK             KKKGGGGGKKK",
	"     KKKBBK              KKKGGGKKK",
	"      KKKBK               KKKGKKK",
	"       KKKK                KKKKK",
	"        KKK                 KKK",
}

local logo_width = 0
for _, row in ipairs(logo_pixels) do
	logo_width = math.max(logo_width, display_width(row))
end

LOGO_WIDTH = logo_width * display_width(PIXEL)

local function logo_text(row)
	local top = logo_pixels[(row * 2) - 1]
	local bottom = logo_pixels[row * 2]

	if not top and not bottom then
		return {
			{ string.rep(" ", LOGO_WIDTH), width = LOGO_WIDTH },
		}
	end

	top = pad_right(top or "", logo_width)
	bottom = pad_right(bottom or "", logo_width)

	local text = {}

	for i = 1, logo_width do
		table.insert(text, half_pixel(top:sub(i, i), bottom:sub(i, i), i, row))
	end

	return text
end

local function dashboard_item(icon, key, desc, action, logo_row, icon_hl)
	local icon_text = icon or "  "
	local menu_width = current_menu_width()
	local left_padding = current_left_padding()
	local icon_width = display_width(icon_text)
	local logo_left_gap = current_logo_left_gap(left_padding, icon_width, menu_width)

	local text = {
		{ string.rep(" ", left_padding), width = left_padding },
		{ icon_text, hl = icon_hl or "SnacksDashboardIcon" },
		{ desc or "", hl = "SnacksDashboardDesc", width = menu_width },
		{ string.rep(" ", logo_left_gap), width = logo_left_gap },
	}

	for _, part in ipairs(logo_text(logo_row)) do
		table.insert(text, part)
	end

	local used_width = left_padding + icon_width + menu_width + logo_left_gap + LOGO_WIDTH
	local key_gap = math.max(current_key_column() - used_width, 1)

	table.insert(text, { string.rep(" ", key_gap), width = key_gap })

	if key and key ~= "" then
		table.insert(text, { key, hl = "SnacksDashboardKey" })
	end

	local item = {
		text = text,
	}

	if key and key ~= "" then
		item.key = key
	end

	if action and action ~= "" then
		item.action = action
	end

	return item
end

local function milli_hl(fg_hex, bg_hex)
	fg_hex = fg_hex or "#D14A3A"
	bg_hex = bg_hex or "NONE"

	local key = fg_hex .. "_" .. bg_hex
	if milli_hl_cache[key] then
		return milli_hl_cache[key]
	end

	local name = "DashboardMilli_" .. fg_hex:gsub("#", "") .. "_" .. bg_hex:gsub("#", "")

	local spec = {}
	if fg_hex ~= "NONE" then
		spec.fg = fg_hex
	end
	if bg_hex ~= "NONE" then
		spec.bg = bg_hex
	end

	vim.api.nvim_set_hl(0, name, spec)
	milli_hl_cache[key] = name

	return name
end

local function load_milli_blackhole_data()
	if milli_blackhole_cache ~= nil then
		return milli_blackhole_cache
	end

	milli_blackhole_cache = false

	if not MILLI_BLACKHOLE_ENABLED then
		return nil
	end

	local ok_milli, milli = pcall(require, "milli")
	if not ok_milli then
		return nil
	end

	local ok_data, data = pcall(function()
		return milli.load({ splash = MILLI_BLACKHOLE_SPLASH })
	end)

	if not ok_data or type(data) ~= "table" or type(data.frames) ~= "table" or type(data.frames[1]) ~= "table" then
		return nil
	end

	milli_blackhole_cache = data

	return milli_blackhole_cache
end

local function milli_frame_cols(data, frame)
	if type(data.cols) == "number" and data.cols > 0 then
		return data.cols
	end

	local cols = 0
	for _, line in ipairs(frame or {}) do
		cols = math.max(cols, display_width(line))
	end

	return cols
end

local function find_dashboard_line(buf, text)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	for i, line in ipairs(lines) do
		if line:find(text, 1, true) then
			return i - 1
		end
	end

	return nil
end

local function milli_start_row(buf, data)
	local recent = find_dashboard_line(buf, "Recent Files")
	local frame = data.frames[1]
	local frame_rows = #frame

	if recent then
		return math.max(recent + MILLI_BLACKHOLE_VERTICAL_OFFSET, 0)
	end

	local total = vim.api.nvim_buf_line_count(buf)
	return math.max(math.floor((total - frame_rows) / 2), 0)
end

local function milli_start_col(data, frame)
	local cols = milli_frame_cols(data, frame)
	local centered = left_pad_width(cols, DASHBOARD_WIDTH)

	return math.max(centered + MILLI_BLACKHOLE_SHIFT_RIGHT, 0)
end

local function split_chars(line)
	return vim.fn.split(line, "\\zs")
end

local function char_at_display_col(line, target_col)
	local col = 0

	for _, ch in ipairs(split_chars(line)) do
		local width = math.max(display_width(ch), 1)

		if target_col >= col and target_col < col + width then
			return ch
		end

		col = col + width
	end

	return " "
end

local function is_blank_at_col(line, target_col)
	local ch = char_at_display_col(line, target_col)

	return ch == nil or ch == "" or ch:match("%s") ~= nil
end

local function is_near_white(hex)
	if type(hex) ~= "string" or not hex:match("^#%x%x%x%x%x%x$") then
		return false
	end

	local rgb = hex_to_rgb(hex)

	return rgb.r >= 220 and rgb.g >= 220 and rgb.b >= 220
end

local function normalize_milli_colors(fg, bg, col, row)
	if not fg or fg == "NONE" or is_near_white(fg) then
		fg = milli_fallback_color(col, row)
	end

	if is_near_white(bg) then
		bg = "NONE"
	end

	return fg, bg
end

local function milli_hl_for_col(runs, col, row)
	if type(runs) == "table" then
		for _, run in ipairs(runs) do
			local start_col = run[1] or 0
			local end_col = run[2] or start_col

			if col >= start_col and col < end_col then
				local fg, bg = normalize_milli_colors(run[3], run[4], col, row)
				return milli_hl(fg, bg)
			end
		end
	end

	return milli_hl(milli_fallback_color(col, row), "NONE")
end

local function flush_segment(buf, row, col, text, hl)
	if text == "" or not col or not hl then
		return
	end

	pcall(vim.api.nvim_buf_set_extmark, buf, milli_overlay_ns, row, 0, {
		virt_text = {
			{ text, hl },
		},
		virt_text_pos = "overlay",
		virt_text_win_col = col,
		hl_mode = "replace",
		priority = 5,
	})
end

local function draw_milli_overlay_line(buf, row, existing, frame_line, runs, start_col, frame_row)
	local frame_col = 0
	local active_text = ""
	local active_col = nil
	local active_hl = nil

	for _, ch in ipairs(split_chars(frame_line)) do
		local width = math.max(display_width(ch), 1)
		local target_col = start_col + frame_col
		local visible_char = ch ~= nil and ch ~= "" and ch:match("%s") == nil
		local can_draw = visible_char

		for offset = 0, width - 1 do
			if not is_blank_at_col(existing, target_col + offset) then
				can_draw = false
				break
			end
		end

		if can_draw then
			local hl = milli_hl_for_col(runs, frame_col, frame_row)

			if active_col and active_hl == hl and active_col + display_width(active_text) == target_col then
				active_text = active_text .. ch
			else
				flush_segment(buf, row, active_col, active_text, active_hl)
				active_col = target_col
				active_text = ch
				active_hl = hl
			end
		else
			flush_segment(buf, row, active_col, active_text, active_hl)
			active_col = nil
			active_text = ""
			active_hl = nil
		end

		frame_col = frame_col + width
	end

	flush_segment(buf, row, active_col, active_text, active_hl)
end

local function draw_milli_blackhole_frame(buf, data, index)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	local frame = data.frames[index]
	if type(frame) ~= "table" then
		return
	end

	local colors = data.colors and data.colors[index]
	local start_row = milli_start_row(buf, data)
	local start_col = milli_start_col(data, frame)

	vim.api.nvim_buf_clear_namespace(buf, milli_overlay_ns, 0, -1)

	for row_i, line in ipairs(frame) do
		local row = start_row + row_i - 1

		if row >= 0 and row < vim.api.nvim_buf_line_count(buf) then
			local existing = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
			draw_milli_overlay_line(buf, row, existing, line, colors and colors[row_i], start_col, row_i)
		end
	end
end

local function stop_milli_blackhole_animation(buf)
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	vim.b[buf].milli_blackhole_generation = (vim.b[buf].milli_blackhole_generation or 0) + 1
	vim.b[buf].milli_blackhole_started = false
	vim.api.nvim_buf_clear_namespace(buf, milli_overlay_ns, 0, -1)
end

local function start_milli_blackhole_animation(buf)
	if not MILLI_BLACKHOLE_ENABLED or not MILLI_BLACKHOLE_ANIMATE then
		return
	end

	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	if vim.b[buf].milli_blackhole_started then
		return
	end

	local data = load_milli_blackhole_data()
	if not data then
		return
	end

	local generation = (vim.b[buf].milli_blackhole_generation or 0) + 1
	vim.b[buf].milli_blackhole_generation = generation
	vim.b[buf].milli_blackhole_started = true

	vim.defer_fn(function()
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end

		local index = 1

		local function step()
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end

			if vim.bo[buf].filetype ~= "snacks_dashboard" then
				return
			end

			if vim.b[buf].milli_blackhole_generation ~= generation then
				return
			end

			draw_milli_blackhole_frame(buf, data, index)

			index = index + 1
			if index > #data.frames then
				index = 1
			end

			local delay = data.delays and data.delays[index] or 100
			delay = math.max(delay, MILLI_BLACKHOLE_MIN_DELAY)

			vim.defer_fn(step, delay)
		end

		step()
	end, MILLI_BLACKHOLE_START_DELAY)
end

vim.api.nvim_create_autocmd("User", {
	group = dashboard_logo_group,
	pattern = { "SnacksDashboardOpened", "SnacksDashboardUpdatePost" },
	callback = function()
		vim.schedule(function()
			local buf = vim.api.nvim_get_current_buf()

			if vim.bo[buf].filetype == "snacks_dashboard" then
				start_milli_blackhole_animation(buf)
			end
		end)
	end,
})

local function dashboard_header_items()
	local lines = {
		"██ ███    ██  █████  ██████  ██    ██  ██████  ███████",
		"██ ████   ██ ██   ██ ██   ██ ██    ██ ██    ██ ██",
		"██ ██ ██  ██ ███████ ██████  ██    ██ ██    ██ ███████",
		"██ ██  ██ ██ ██   ██ ██   ██  ██  ██  ██    ██      ██",
		"██ ██   ████ ██   ██ ██   ██   ████    ██████  ███████",
	}

	local subtitle = "Mac Pro M3 • lazy.nvim • LSP • formatting • Git"
	local width = 0

	for _, line in ipairs(lines) do
		width = math.max(width, display_width(line))
	end

	local left = left_pad_width(width, DASHBOARD_WIDTH)

	if is_compact_dashboard() then
		left = math.max(
			current_left_padding(),
			current_available_width() - width - current_right_padding()
		)
	end

	local items = {}

	table.insert(items, {
		text = {
			{ "", hl = "SnacksDashboardHeader" },
		},
	})

	for _, line in ipairs(lines) do
		local rendered = string.rep(" ", left) .. pad_right(line, width)

		table.insert(items, {
			text = {
				{ rendered, hl = "SnacksDashboardHeader" },
			},
		})
	end

	table.insert(items, {
		text = {
			{ "", hl = "SnacksDashboardHeader" },
		},
	})

	local rendered_subtitle = string.rep(" ", left) .. center_line(subtitle, width)

	table.insert(items, {
		text = {
			{ rendered_subtitle, hl = "SnacksDashboardHeader" },
		},
	})

	table.insert(items, {
		text = {
			{ "", hl = "SnacksDashboardHeader" },
		},
	})

	return items
end

local function dashboard_keys_items()
	return {
		dashboard_item(" ", "f", " Find file", ":Telescope find_files", 1, "DashboardIconFind"),
		dashboard_item(nil, nil, nil, nil, 2),

		dashboard_item(" ", "g", " Live grep", ":Telescope live_grep", 3, "DashboardIconGrep"),
		dashboard_item(nil, nil, nil, nil, 4),

		dashboard_item(" ", "r", " Recent files", ":Telescope oldfiles", 5, "DashboardIconRecent"),
		dashboard_item(nil, nil, nil, nil, 6),

		dashboard_item(
			" ",
			"c",
			" Open config",
			":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
			7,
			"DashboardIconConfig"
		),
		dashboard_item(nil, nil, nil, nil, 8),

		dashboard_item(" ", "G", " LazyGit", ":lua Snacks.lazygit()", 9, "DashboardIconGit"),
		dashboard_item(nil, nil, nil, nil, 10),

		dashboard_item("󰒲 ", "l", " Lazy plugins", ":Lazy", 11, "DashboardIconLazy"),
		dashboard_item(nil, nil, nil, nil, 12),

		dashboard_item("󰏖 ", "m", " Mason tools", ":Mason", 13, "DashboardIconMason"),
		dashboard_item(nil, nil, nil, nil, 14),

		dashboard_item(" ", "h", " Health check", ":checkhealth", 15, "DashboardIconHealth"),
		dashboard_item(nil, nil, nil, nil, 16),

		dashboard_item(" ", "q", " Quit", ":qa", 17, "DashboardIconQuit"),

		-- Extra visual gap before Recent Files.
		dashboard_item(nil, nil, nil, nil, 18),
	}
end

local function dashboard_startup_items()
	local loaded = "?"
	local count = "?"
	local startuptime = "?"

	local ok_lazy, lazy = pcall(require, "lazy")

	if ok_lazy then
		local stats = lazy.stats()

		loaded = tostring(stats.loaded or "?")
		count = tostring(stats.count or "?")

		if type(stats.startuptime) == "number" then
			startuptime = string.format("%.2f", stats.startuptime)
		end
	end

	local plain = "⚡ Neovim loaded " .. loaded .. "/" .. count .. " plugins in " .. startuptime .. "ms"
	local text_width = display_width(plain)

	local left = left_pad_width(text_width, DASHBOARD_WIDTH)

	if is_compact_dashboard() then
		left = math.max(
			current_left_padding(),
			current_available_width() - text_width - current_right_padding()
		)
	end

	return {
		{
			text = {
				{ string.rep(" ", left), width = left },
				{ "⚡ ", hl = "DashboardStartupIcon" },
				{ "Neovim loaded ", hl = "DashboardStartupText" },
				{ loaded, hl = "DashboardStartupNumber" },
				{ "/", hl = "DashboardStartupText" },
				{ count, hl = "DashboardStartupNumber" },
				{ " plugins in ", hl = "DashboardStartupText" },
				{ startuptime, hl = "DashboardStartupNumber" },
				{ "ms", hl = "DashboardStartupText" },
			},
		},
	}
end

vim.api.nvim_create_autocmd("VimResized", {
	group = dashboard_logo_group,
	callback = function()
		vim.schedule(function()
			local buf = vim.api.nvim_get_current_buf()

			if vim.bo[buf].filetype ~= "snacks_dashboard" then
				return
			end

			stop_milli_blackhole_animation(buf)

			pcall(function()
				Snacks.dashboard.update()
			end)

			pcall(vim.cmd, "redraw")

			vim.defer_fn(function()
				if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "snacks_dashboard" then
					start_milli_blackhole_animation(buf)
				end
			end, MILLI_BLACKHOLE_START_DELAY)
		end)
	end,
})

return {
	bigfile = {
		enabled = true,
		size = 1.5 * 1024 * 1024,
		line_length = 1000,
	},

	quickfile = {
		enabled = true,
	},

	input = {
		enabled = true,
	},

	lazygit = {
		enabled = true,
		configure = true,
		config = {
			os = { editPreset = "nvim-remote" },
			gui = {
				nerdFontsVersion = "3",
			},
		},
	},

	dashboard = {
		enabled = true,
		width = DASHBOARD_WIDTH,

		preset = {},

		sections = {
			dashboard_header_items,
			dashboard_keys_items,

			{
				icon = " ",
				icon_hl = "DashboardIconRecent",
				title = "Recent Files",
				section = "recent_files",
				indent = 2,
				padding = { 1, 0 },
			},
			{
				icon = " ",
				icon_hl = "DashboardIconProject",
				title = "Projects",
				section = "projects",
				indent = 2,
				padding = { 1, 0 },
			},

			dashboard_startup_items,
		},
	},
}
