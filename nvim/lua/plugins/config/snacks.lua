-- lua/plugins/config/snacks.lua
-- Modern UI/helper modules via snacks.nvim.

local DASHBOARD_WIDTH = 92
local MENU_WIDTH = 21
local LOGO_LEFT_GAP = 0

-- Right-side key column for dashboard menu shortcuts.
-- Increase this to move f/g/r/c... right.
-- Decrease this to move them left.
local KEY_COLUMN = 91

-- One space = one terminal column.
-- Change to "  " only if you want every logo pixel to become wider.
local PIXEL = " "

-- Dashboard logo animation.
-- This version uses per-pixel wave highlights with simulated transparency.
local ANIMATE_LOGO = true
local ANIMATION_INTERVAL = 70 -- milliseconds; lower = smoother/faster, higher = lighter/slower

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

local dashboard_logo_group = vim.api.nvim_create_augroup("DashboardLogoAnimation", {
	clear = true,
})

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

local function dashboard_header(lines, subtitle)
	local width = 0

	for _, line in ipairs(lines) do
		width = math.max(width, display_width(line))
	end

	local out = { "" }

	for _, line in ipairs(lines) do
		table.insert(out, pad_right(line, width))
	end

	table.insert(out, "")
	table.insert(out, center_line(subtitle, width))

	return table.concat(out, "\n")
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

local function update_logo_highlights()
	set_static_logo_hl()

	for name, item in pairs(logo_hl_cache) do
		vim.api.nvim_set_hl(0, name, logo_hl_opts(item.x, item.y, item.top, item.bottom))
	end
end

set_static_logo_hl()

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

-- Compact Neovim-style mark.
--
-- Each visible dashboard row is made from TWO rows below:
--   odd row  = top half of terminal pixels
--   even row = bottom half of terminal pixels
--
-- B = blue/fill pixel
-- G = green/fill pixel
-- K = dark outline pixel
-- space = transparent dashboard background
--
-- The animation colours B/G pixels per position, producing a smooth wave.
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

local LOGO_WIDTH = logo_width * display_width(PIXEL)

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

local function dashboard_item(icon, key, desc, action, logo_row)
	local icon_text = icon or "  "

	local text = {
		{ icon_text, hl = "SnacksDashboardIcon" },
		{ desc or "", hl = "SnacksDashboardDesc", width = MENU_WIDTH },
		{ string.rep(" ", LOGO_LEFT_GAP), width = LOGO_LEFT_GAP },
	}

	for _, part in ipairs(logo_text(logo_row)) do
		table.insert(text, part)
	end

	local used_width = display_width(icon_text) + MENU_WIDTH + LOGO_LEFT_GAP + LOGO_WIDTH
	local key_gap = math.max(KEY_COLUMN - used_width, 1)

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

		preset = {
			header = dashboard_header({
				"██ ███    ██  █████  ██████  ██    ██  ██████  ███████",
				"██ ████   ██ ██   ██ ██   ██ ██    ██ ██    ██ ██",
				"██ ██ ██  ██ ███████ ██████  ██    ██ ██    ██ ███████",
				"██ ██  ██ ██ ██   ██ ██   ██  ██  ██  ██    ██      ██",
				"██ ██   ████ ██   ██ ██   ██   ████    ██████  ███████",
			}, "Mac Pro M3 • lazy.nvim • LSP • formatting • Git"),

			keys = {
				dashboard_item(" ", "f", " Find file", ":Telescope find_files", 1),
				dashboard_item(nil, nil, nil, nil, 2),
				dashboard_item(" ", "g", " Live grep", ":Telescope live_grep", 3),
				dashboard_item(nil, nil, nil, nil, 4),
				dashboard_item(" ", "r", " Recent files", ":Telescope oldfiles", 5),
				dashboard_item(nil, nil, nil, nil, 6),
				dashboard_item(
					" ",
					"c",
					" Open config",
					":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
					7
				),
				dashboard_item(nil, nil, nil, nil, 8),
				dashboard_item(" ", "G", " LazyGit", ":lua Snacks.lazygit()", 9),
				dashboard_item(nil, nil, nil, nil, 10),
				dashboard_item("󰒲 ", "l", " Lazy plugins", ":Lazy", 11),
				dashboard_item(nil, nil, nil, nil, 12),
				dashboard_item("󰏖 ", "m", " Mason tools", ":Mason", 13),
				dashboard_item(nil, nil, nil, nil, 14),
				dashboard_item(" ", "h", " Health check", ":checkhealth", 15),
				dashboard_item(nil, nil, nil, nil, 16),
				dashboard_item(" ", "q", " Quit", ":qa", 17),
			},
		},

		sections = {
			{ section = "header" },

			-- gap = 0 because spacer rows are inserted manually above.
			-- This keeps menu spacing normal while keeping the logo compact.
			{ section = "keys", gap = 0, padding = 1 },

			{
				icon = " ",
				title = "Recent Files",
				section = "recent_files",
				indent = 2,
				padding = { 1, 1 },
			},
			{
				icon = " ",
				title = "Projects",
				section = "projects",
				indent = 2,
				padding = { 1, 1 },
			},
			{ section = "startup" },
		},
	},
}
