return function()
	require("utils").set_highlights("neotree", {
		NeoTreeNormal = { bg = "none" },
		NeoTreeNormalNC = { bg = "none" },
		NeoTreeEndOfBuffer = { bg = "none" },
	})
	require("neo-tree").setup({
		auto_clean_after_session_restore = true,
		close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		neo_tree_popup_input_ready = false, -- Enable normal mode for input dialogs.
		open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
		sort_case_insensitive = false, -- used when sorting files and directories in the tree
		sort_function = nil, -- use a custom function for sorting files and directories in the tree
		-- sort_function = function (a,b)
		--       if a.type == b.type then
		--           return a.path > b.path
		--       else
		--           return a.type > b.type
		--       end
		--   end , -- this sorts files and directories descendantly
		default_component_configs = {
			container = {
				enable_character_fade = true,
			},
			indent = {
				indent_size = 2,
				padding = 1, -- extra padding on left hand side
				-- indent guides
				with_markers = true,
				indent_marker = "│",
				last_indent_marker = "└",
				highlight = "NeoTreeIndentMarker",
				-- expander config, needed for nesting files
				with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "󰜌",
				-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
				-- then these will never be used.
				default = "*",
				highlight = "NeoTreeFileIcon",
			},
			modified = {
				symbol = "[+]",
				highlight = "NeoTreeModified",
			},
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
				highlight = "NeoTreeFileName",
			},
			git_status = {
				symbols = {
					-- Change type
					added = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
					modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
					deleted = "✖", -- this can only be used in the git_status source
					renamed = "󰁕", -- this can only be used in the git_status source
					-- Status type
					untracked = "",
					ignored = "",
					unstaged = "󰄱",
					staged = "",
					conflict = "",
				},
			},
			-- If you don't want to use these columns, you can set `enabled = false` for each of them individually
			file_size = {
				enabled = true,
				required_width = 64, -- min width of window required to show this column
			},
			type = {
				enabled = true,
				required_width = 122, -- min width of window required to show this column
			},
			last_modified = {
				enabled = true,
				required_width = 88, -- min width of window required to show this column
			},
			created = {
				enabled = true,
				required_width = 110, -- min width of window required to show this column
			},
			symlink_target = {
				enabled = false,
			},
		},
		-- A list of functions, each representing a global custom command
		-- that will be available in all sources (if not overridden in `opts[source_name].commands`)
		-- see `:h neo-tree-custom-commands-global`
		commands = {},
		window = {
			width = 40,
			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = {
				["<cr>"] = {
					"open",
					nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
				},
				["<2-LeftMouse>"] = "open",
				["e"] = "open",
				["<esc>"] = "cancel", -- close preview or floating neo-tree window
				["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
				-- Read `# Preview Mode` for more information
				["L"] = "focus_preview",
				["s"] = "open_split",
				["v"] = "open_vsplit",
				["q"] = "close_window",
				["R"] = "refresh",
				["i"] = "show_file_details",
				["h"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
				["oc"] = { "order_by_created", nowait = false },
				["od"] = { "order_by_diagnostics", nowait = false },
				["om"] = { "order_by_modified", nowait = false },
				["on"] = { "order_by_name", nowait = false },
				["os"] = { "order_by_size", nowait = false },
				["ot"] = { "order_by_type", nowait = false },
				-- ["S"] = "split_with_window_picker",
				-- ["s"] = "vsplit_with_window_picker",
				-- ["t"] = "open_tabnew",
				-- ["<cr>"] = "open_drop",
				-- ["t"] = "open_tab_drop",
				-- ["w"] = "open_with_window_picker",
				-- ["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
				-- ["l"] = "open",
				-- ["h"] = "close_node",
				-- ['C'] = 'close_all_subnodes',
				-- ["H"] = "close_all_nodes",
				-- ["Z"] = "expand_all_nodes",
			},
		},
		nesting_rules = {},
		filesystem = {
			filtered_items = {
				visible = false, -- when true, they will just be displayed differently than normal items
				show_hidden_count = true,
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_hidden = false, -- only works on Windows for hidden files/directories
				hide_by_name = {
					"node_modules",
				},
				hide_by_pattern = { -- uses glob style patterns
					--"*.meta",
					--"*/src/*/tsconfig.json",
				},
				always_show = { -- remains visible even if other settings would normally hide it
					".gitignore",
					".eslintrc.json",
					".prettierrc.json",
					".markuplintrc.json",
				},
				never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
					".DS_Store",
					--"thumbs.db"
					".git",
				},
				never_show_by_pattern = { -- uses glob style patterns
					--".null-ls_*",
				},
			},
			follow_current_file = {
				enabled = true, -- This will find and focus the file in the active buffer every time
				--               -- the current file is changed while the tree is open.
				leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
			},
			group_empty_dirs = false, -- when true, empty folders will be grouped together
			hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
			-- in whatever position is specified in window.position
			-- "open_current",  -- netrw disabled, opening a directory opens within the
			-- window like netrw would, regardless of window.position
			-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
			use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
			-- instead of relying on nvim autocmd events.
			window = {
				mappings = {
					["a"] = {
						"add",
						-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc).
						-- see `:h neo-tree-file-actions` for details
						-- some commands may take optional config options, see `:h neo-tree-mappings` for details
						config = {
							show_path = "none", -- "none", "relative", "absolute"
						},
					},
					["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
					["d"] = "delete",
					["r"] = "rename",
					["p"] = "paste_from_clipboard",
					["x"] = "cut_to_clipboard",
					["y"] = "copy_to_clipboard",
					["Y"] = function(state)
						-- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
						-- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local filename = node.name
						local modify = vim.fn.fnamemodify

						local results = {
							filepath,
							modify(filepath, ":."),
							modify(filepath, ":~"),
							filename,
							modify(filename, ":r"),
							modify(filename, ":e"),
						}

						vim.ui.select({
							"1. Absolute path: " .. results[1],
							"2. Path relative to CWD: " .. results[2],
							"3. Path relative to HOME: " .. results[3],
							"4. Filename: " .. results[4],
							"5. Filename without extension: " .. results[5],
							"6. Extension of the filename: " .. results[6],
						}, { prompt = "Choose to copy to clipboard:" }, function(choice)
							local i = tonumber(choice:sub(1, 1))
							local result = results[i]
							vim.fn.setreg("+", result)
							vim.notify("Copied: " .. result)
						end)
					end,
					["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
					-- ["c"] = {
					--  "copy",
					--  config = {
					--    show_path = "none" -- "none", "relative", "absolute"
					--  }
					--}
					["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
					["<bs>"] = "navigate_up",
					["."] = "set_root",
					["<C-f>"] = "close_window",
					["H"] = "toggle_hidden",
					["g"] = "fuzzy_finder",
					["G"] = "fuzzy_finder_directory",
					["/"] = "filter_on_submit",
					["<Esc>"] = "clear_filter",
					[">"] = "prev_source", -- file system <-> git
					["<"] = "prev_source",
					-- ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
					-- ["D"] = "fuzzy_sorter_directory",
					-- ["[g"] = "prev_git_modified",
					-- ["]g"] = "next_git_modified",
				},
				fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
					["<down>"] = "move_cursor_down",
					["<C-j>"] = "move_cursor_down",
					["<up>"] = "move_cursor_up",
					["<C-k>"] = "move_cursor_up",
				},
			},

			commands = {}, -- Add a custom command or override a global one using the same function name
		},
		git_status = {
			window = {
				mappings = {
					["<C-f>"] = "next_source", -- to file system
					["<CS-G>"] = "close_window",
					["ga"] = "git_add_file",
					["gA"] = "git_add_all",
					["gu"] = "git_unstage_file",
					["gr"] = "git_revert_file",
					["gc"] = "git_commit",
					["gp"] = "git_push",
					[">"] = "next_source", -- file system <-> git
					["<"] = "next_source",
					-- ["gg"] = "git_commit_and_push",
				},
			},
		},
		-- buffers is disabled now
		-- buffers = {
		-- 	follow_current_file = {
		-- 		enabled = true, -- This will find and focus the file in the active buffer every time
		-- 		--              -- the current file is changed while the tree is open.
		-- 		leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
		-- 	},
		-- 	group_empty_dirs = true, -- when true, empty folders will be grouped together
		-- 	show_unloaded = true,
		-- 	window = {
		-- 		mappings = {
		-- 			["<C-f>"] = "prev_source", -- to file system
		-- 			["<CS-B>"] = "close_window",
		-- 			["d"] = "buffer_delete",
		-- 		},
		-- 	},
		-- },
	})
end
