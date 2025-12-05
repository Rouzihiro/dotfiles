# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
RED := \033[0;31m
CYAN := \033[0;36m
MAGENTA := \033[0;35m
NC := \033[0m # No Color

# Script directory and paths
SCRIPT_DIR := $(shell pwd)
INSTALL_DIR := $(SCRIPT_DIR)/.github/dots-bootstrap.sh
THEME_SCRIPT := $(SCRIPT_DIR)/install-themes.sh

# Additional scripts in .local/bin
ZORRO_SCRIPTS := $(SCRIPT_DIR)/.local/bin/zorro-scripts
QUICK_ACTIONS := $(SCRIPT_DIR)/.local/bin/quick-actions
DOTFILES_SCRIPTS := $(SCRIPT_DIR)/.local/bin/dotfiles-scripts

# Third script - assets installer
THIRD_SCRIPT := $(SCRIPT_DIR)/.github/assets.sh

.PHONY: help run select select-preview bootstrap themes assets zorro quick dots clean check menu

# Default target - when you run just 'make', it runs the fzf selector
.DEFAULT_GOAL := run

# Show help with script paths
help:
	@echo -e "$(YELLOW)════════════════════════════════════════════════════════════════════════$(NC)"
	@echo -e "$(BLUE)                 Dotfiles Management System (6 scripts)                   $(NC)"
	@echo -e "$(YELLOW)════════════════════════════════════════════════════════════════════════$(NC)"
	@echo ""
	@echo -e "$(YELLOW)Available targets:$(NC)"
	@echo -e "  $(GREEN)make run$(NC)          - Interactive fzf selection menu"
	@echo -e "  $(GREEN)make select$(NC)       - Alternative fzf selection"
	@echo -e "  $(GREEN)make select-preview$(NC) - FZF with script preview"
	@echo ""
	@echo -e "$(YELLOW)Direct script execution:$(NC)"
	@echo -e "  $(GREEN)make bootstrap$(NC)    - $(CYAN)Main Installer$(NC) - Setup dotfiles (run once)"
	@echo -e "  $(GREEN)make themes$(NC)       - $(CYAN)Themes Installer$(NC) - Install themes"
	@echo -e "  $(GREEN)make assets$(NC)       - $(CYAN)Assets Installer$(NC) - Theme files/icons/wallpapers"
	@echo -e "  $(GREEN)make zorro$(NC)        - $(CYAN)Theme Scripts$(NC) - Theme related scripts"
	@echo -e "  $(GREEN)make quick$(NC)        - $(CYAN)Quick Actions$(NC) - System & tool config (rofi)"
	@echo -e "  $(GREEN)make dots$(NC)         - $(CYAN)Misc Scripts$(NC) - Various dotfiles scripts"
	@echo ""
	@echo -e "$(YELLOW)Utilities:$(NC)"
	@echo -e "  $(GREEN)make check$(NC)        - Check if all scripts exist"
	@echo -e "  $(GREEN)make clean$(NC)        - Clean temporary files"
	@echo -e "  $(GREEN)make menu$(NC)         - Simple text menu"
	@echo -e "  $(GREEN)make help$(NC)         - Show this help"
	@echo ""
	@echo -e "$(YELLOW)Script paths:$(NC)"
	@echo -e "  $(CYAN)1.$(NC) $(MAGENTA)dots-bootstrap.sh$(NC)   - $(INSTALL_DIR)"
	@echo -e "  $(CYAN)2.$(NC) $(MAGENTA)install-themes.sh$(NC)   - $(THEME_SCRIPT)"
	@echo -e "  $(CYAN)3.$(NC) $(MAGENTA)assets.sh$(NC)          - $(THIRD_SCRIPT)"
	@echo -e "  $(CYAN)4.$(NC) $(MAGENTA)zorro-scripts$(NC)      - $(ZORRO_SCRIPTS)"
	@echo -e "  $(CYAN)5.$(NC) $(MAGENTA)quick-actions$(NC)      - $(QUICK_ACTIONS)"
	@echo -e "  $(CYAN)6.$(NC) $(MAGENTA)dotfiles-scripts$(NC)   - $(DOTFILES_SCRIPTS)"
	@echo -e "$(YELLOW)════════════════════════════════════════════════════════════════════════$(NC)"

# Main fzf selection target (6 options) with descriptions
run: check
	@echo -e "$(YELLOW)📦 Dotfiles Management System$(NC)"
	@echo -e "$(BLUE)Select a script to run:$(NC)"
	@choice=$$(echo -e "1. dots-bootstrap.sh     - Main Installer (run once to setup dotfiles)\n2. install-themes.sh   - Themes Installer\n3. assets.sh           - Install assets (theme-files/icons/wallpapers)\n4. zorro-scripts       - Theme related scripts (.local/bin/zorro-scripts)\n5. quick-actions       - Beautiful system & tool configuration menu (rofi)\n6. dotfiles-scripts    - Misc scripts (run once)" | \
	fzf --height=60% --border --prompt="Choose script [1-6] > " \
	--header="📁 $(BLUE)Dotfiles Management$(NC) | $(notdir $(SCRIPT_DIR))" \
	--ansi | \
	cut -d'.' -f1); \
	case $$choice in \
		1) echo -e "$(GREEN)🚀 Running Main Installer (dots-bootstrap.sh)...$(NC)" && "$(INSTALL_DIR)" || true;; \
		2) echo -e "$(GREEN)🎨 Running Themes Installer (install-themes.sh)...$(NC)" && "$(THEME_SCRIPT)" || true;; \
		3) echo -e "$(GREEN)📦 Running Assets Installer (assets.sh)...$(NC)" && "$(THIRD_SCRIPT)" || true;; \
		4) echo -e "$(GREEN)🦊 Running Theme Scripts (zorro-scripts)...$(NC)" && "$(ZORRO_SCRIPTS)" || true;; \
		5) echo -e "$(GREEN)⚡ Running Quick Actions (quick-actions)...$(NC)" && "$(QUICK_ACTIONS)" || true;; \
		6) echo -e "$(GREEN)📁 Running Misc Scripts (dotfiles-scripts)...$(NC)" && "$(DOTFILES_SCRIPTS)" || true;; \
		*) echo -e "$(YELLOW)No selection made$(NC)";; \
	esac

# Alternative selection with better formatting
select: check
	@echo -e "$(YELLOW)📦 Dotfiles Management System$(NC)"
	@echo -e "$(BLUE)Select a script to run:$(NC)"
	@scripts="dots-bootstrap.sh:Main Installer (run once to setup dotfiles)\ninstall-themes.sh:Themes Installer\nassets.sh:Install assets (theme-files/icons/wallpapers)\nzorro-scripts:Theme related scripts (.local/bin/zorro-scripts)\nquick-actions:Beautiful system & tool configuration menu (rofi)\ndotfiles-scripts:Misc scripts (run once)"; \
	choice=$$(echo -e $$scripts | \
	fzf --height=60% --border \
	--prompt="Choose > " \
	--header="📂 $(BLUE)Available Scripts$(NC) (6 total)" \
	--preview-window=right:50% \
	--preview='\
	if [ "{}" = "dots-bootstrap.sh:Main Installer (run once to setup dotfiles)" ]; then \
		echo -e "$(CYAN)1. $(MAGENTA)Main Installer$(NC)"; \
		echo -e "$(YELLOW)Desc:$(NC) Run once to setup dotfiles"; \
		echo "📍 $(INSTALL_DIR)"; \
		echo ""; echo "$(GREEN)Preview:$(NC)"; echo "════════════════"; \
		head -15 "$(INSTALL_DIR)" 2>/dev/null || echo "Script not found"; \
	elif [ "{}" = "install-themes.sh:Themes Installer" ]; then \
		echo -e "$(CYAN)2. $(MAGENTA)Themes Installer$(NC)"; \
		echo -e "$(YELLOW)Desc:$(NC) Install themes"; \
		echo "📍 $(THEME_SCRIPT)"; \
		echo ""; echo "$(GREEN)Preview:$(NC)"; echo "════════════════"; \
		head -15 "$(THEME_SCRIPT)" 2>/dev/null || echo "Script not found"; \
	elif [ "{}" = "assets.sh:Install assets (theme-files/icons/wallpapers)" ]; then \
		echo -e "$(CYAN)3. $(MAGENTA)Assets Installer$(NC)"; \
		echo -e "$(YELLOW)Desc:$(NC) Install theme files, icons, wallpapers"; \
		echo "📍 $(THIRD_SCRIPT)"; \
		echo ""; echo "$(GREEN)Preview:$(NC)"; echo "════════════════"; \
		head -15 "$(THIRD_SCRIPT)" 2>/dev/null || echo "Script not found"; \
	elif [ "{}" = "zorro-scripts:Theme related scripts (.local/bin/zorro-scripts)" ]; then \
		echo -e "$(CYAN)4. $(MAGENTA)Theme Scripts$(NC)"; \
		echo -e "$(YELLOW)Desc:$(NC) Theme related scripts"; \
		echo "📍 $(ZORRO_SCRIPTS)"; \
		echo ""; echo "$(GREEN)Preview:$(NC)"; echo "════════════════"; \
		head -15 "$(ZORRO_SCRIPTS)" 2>/dev/null || echo "Script not found"; \
	elif [ "{}" = "quick-actions:Beautiful system & tool configuration menu (rofi)" ]; then \
		echo -e "$(CYAN)5. $(MAGENTA)Quick Actions$(NC)"; \
		echo -e "$(YELLOW)Desc:$(NC) System & tool configuration menu (rofi)"; \
		echo "📍 $(QUICK_ACTIONS)"; \
		echo ""; echo "$(GREEN)Preview:$(NC)"; echo "════════════════"; \
		head -15 "$(QUICK_ACTIONS)" 2>/dev/null || echo "Script not found"; \
	elif [ "{}" = "dotfiles-scripts:Misc scripts (run once)" ]; then \
		echo -e "$(CYAN)6. $(MAGENTA)Misc Scripts$(NC)"; \
		echo -e "$(YELLOW)Desc:$(NC) Various dotfiles scripts"; \
		echo "📍 $(DOTFILES_SCRIPTS)"; \
		echo ""; echo "$(GREEN)Preview:$(NC)"; echo "════════════════"; \
		head -15 "$(DOTFILES_SCRIPTS)" 2>/dev/null || echo "Script not found"; \
	fi' | \
	cut -d':' -f1); \
	case $$choice in \
		"dots-bootstrap.sh") echo -e "$(GREEN)🚀 Running Main Installer...$(NC)" && "$(INSTALL_DIR)" || true;; \
		"install-themes.sh") echo -e "$(GREEN)🎨 Running Themes Installer...$(NC)" && "$(THEME_SCRIPT)" || true;; \
		"assets.sh") echo -e "$(GREEN)📦 Running Assets Installer...$(NC)" && "$(THIRD_SCRIPT)" || true;; \
		"zorro-scripts") echo -e "$(GREEN)🦊 Running Theme Scripts...$(NC)" && "$(ZORRO_SCRIPTS)" || true;; \
		"quick-actions") echo -e "$(GREEN)⚡ Running Quick Actions...$(NC)" && "$(QUICK_ACTIONS)" || true;; \
		"dotfiles-scripts") echo -e "$(GREEN)📁 Running Misc Scripts...$(NC)" && "$(DOTFILES_SCRIPTS)" || true;; \
		*) echo -e "$(YELLOW)No selection made$(NC)";; \
	esac

# FZF with preview (all 6 scripts) - Enhanced with descriptions
select-preview: check
	@if command -v fzf >/dev/null 2>&1; then \
		echo -e "$(YELLOW)📦 Dotfiles Management System$(NC)"; \
		echo -e "$(BLUE)Select a script to run (with preview):$(NC)"; \
		choice=$$(printf '%s\n%s\n%s\n%s\n%s\n%s' \
			"dots-bootstrap.sh:🚀 Main Installer - Run once to setup dotfiles" \
			"install-themes.sh:🎨 Themes Installer - Install themes and color schemes" \
			"assets.sh:📦 Assets Installer - Install theme files, icons, wallpapers" \
			"zorro-scripts:🦊 Theme Scripts - Theme related scripts (.local/bin/)" \
			"quick-actions:⚡ Quick Actions - Beautiful system & tool config menu (rofi)" \
			"dotfiles-scripts:📁 Misc Scripts - Various dotfiles scripts (run once)" | \
		fzf --height=65% --border \
			--prompt="Choose script [1-6] > " \
			--header="📂 $(BLUE)Dotfiles Management System$(NC) | $(shell basename $(SCRIPT_DIR))" \
			--preview='\
			SCRIPT="$$(echo {} | cut -d: -f1)"; \
			case "$$SCRIPT" in \
				"dots-bootstrap.sh") \
					echo -e "$(CYAN)1. 🚀 $(MAGENTA)Main Installer$(NC)"; \
					echo -e "$(YELLOW)Description:$(NC) Run once to setup dotfiles"; \
					echo -e "$(YELLOW)When to use:$(NC) First time setup"; \
					echo -e "$(BLUE)Path:$(NC) $(INSTALL_DIR)"; \
					echo ""; echo -e "$(GREEN)Preview:$(NC)"; echo "════════════════════════"; \
					head -25 "$(INSTALL_DIR)" 2>/dev/null | sed "s/^/  /" || echo -e "  $(RED)Script not found$(NC)"; \
					;; \
				"install-themes.sh") \
					echo -e "$(CYAN)2. 🎨 $(MAGENTA)Themes Installer$(NC)"; \
					echo -e "$(YELLOW)Description:$(NC) Install themes and color schemes"; \
					echo -e "$(YELLOW)When to use:$(NC) After main install, to apply themes"; \
					echo -e "$(BLUE)Path:$(NC) $(THEME_SCRIPT)"; \
					echo ""; echo -e "$(GREEN)Preview:$(NC)"; echo "════════════════════════"; \
					head -25 "$(THEME_SCRIPT)" 2>/dev/null | sed "s/^/  /" || echo -e "  $(RED)Script not found$(NC)"; \
					;; \
				"assets.sh") \
					echo -e "$(CYAN)3. 📦 $(MAGENTA)Assets Installer$(NC)"; \
					echo -e "$(YELLOW)Description:$(NC) Install theme files, icons, wallpapers"; \
					echo -e "$(YELLOW)When to use:$(NC) After themes, to get visual assets"; \
					echo -e "$(BLUE)Path:$(NC) $(THIRD_SCRIPT)"; \
					echo ""; echo -e "$(GREEN)Preview:$(NC)"; echo "════════════════════════"; \
					head -25 "$(THIRD_SCRIPT)" 2>/dev/null | sed "s/^/  /" || echo -e "  $(RED)Script not found$(NC)"; \
					;; \
				"zorro-scripts") \
					echo -e "$(CYAN)4. 🦊 $(MAGENTA)Theme Scripts$(NC)"; \
					echo -e "$(YELLOW)Description:$(NC) Theme related scripts collection"; \
					echo -e "$(YELLOW)When to use:$(NC) Theme management and tweaks"; \
					echo -e "$(BLUE)Path:$(NC) $(ZORRO_SCRIPTS)"; \
					echo -e "$(BLUE)Location:$(NC) .local/bin/zorro-scripts"; \
					echo ""; echo -e "$(GREEN)Preview:$(NC)"; echo "════════════════════════"; \
					head -25 "$(ZORRO_SCRIPTS)" 2>/dev/null | sed "s/^/  /" || echo -e "  $(RED)Script not found$(NC)"; \
					;; \
				"quick-actions") \
					echo -e "$(CYAN)5. ⚡ $(MAGENTA)Quick Actions$(NC)"; \
					echo -e "$(YELLOW)Description:$(NC) Beautiful system & tool configuration menu (rofi)"; \
					echo -e "$(YELLOW)When to use:$(NC) Interactive configuration and tools"; \
					echo -e "$(BLUE)Path:$(NC) $(QUICK_ACTIONS)"; \
					echo -e "$(BLUE)Location:$(NC) .local/bin/quick-actions"; \
					echo ""; echo -e "$(GREEN)Preview:$(NC)"; echo "════════════════════════"; \
					head -25 "$(QUICK_ACTIONS)" 2>/dev/null | sed "s/^/  /" || echo -e "  $(RED)Script not found$(NC)"; \
					;; \
				"dotfiles-scripts") \
					echo -e "$(CYAN)6. 📁 $(MAGENTA)Misc Scripts$(NC)"; \
					echo -e "$(YELLOW)Description:$(NC) Various dotfiles scripts (run once)"; \
					echo -e "$(YELLOW)When to use:$(NC) Additional setup and utilities"; \
					echo -e "$(BLUE)Path:$(NC) $(DOTFILES_SCRIPTS)"; \
					echo -e "$(BLUE)Location:$(NC) .local/bin/dotfiles-scripts"; \
					echo ""; echo -e "$(GREEN)Preview:$(NC)"; echo "════════════════════════"; \
					head -25 "$(DOTFILES_SCRIPTS)" 2>/dev/null | sed "s/^/  /" || echo -e "  $(RED)Script not found$(NC)"; \
					;; \
			esac' | \
		cut -d':' -f1); \
		case $$choice in \
			"dots-bootstrap.sh") \
				echo -e "$(GREEN)🚀 Running Main Installer...$(NC)"; \
				echo -e "$(YELLOW)Description:$(NC) Run once to setup dotfiles"; \
				echo -e "$(BLUE)Path:$(NC) $(INSTALL_DIR)"; \
				chmod +x "$(INSTALL_DIR)" 2>/dev/null; \
				"$(INSTALL_DIR)" || true;; \
			"install-themes.sh") \
				echo -e "$(GREEN)🎨 Running Themes Installer...$(NC)"; \
				echo -e "$(YELLOW)Description:$(NC) Install themes and color schemes"; \
				echo -e "$(BLUE)Path:$(NC) $(THEME_SCRIPT)"; \
				chmod +x "$(THEME_SCRIPT)" 2>/dev/null; \
				"$(THEME_SCRIPT)" || true;; \
			"assets.sh") \
				echo -e "$(GREEN)📦 Running Assets Installer...$(NC)"; \
				echo -e "$(YELLOW)Description:$(NC) Install theme files, icons, wallpapers"; \
				echo -e "$(BLUE)Path:$(NC) $(THIRD_SCRIPT)"; \
				chmod +x "$(THIRD_SCRIPT)" 2>/dev/null; \
				"$(THIRD_SCRIPT)" || true;; \
			"zorro-scripts") \
				echo -e "$(GREEN)🦊 Running Theme Scripts...$(NC)"; \
				echo -e "$(YELLOW)Description:$(NC) Theme related scripts"; \
				echo -e "$(BLUE)Path:$(NC) $(ZORRO_SCRIPTS)"; \
				echo -e "$(BLUE)Location:$(NC) .local/bin/zorro-scripts"; \
				chmod +x "$(ZORRO_SCRIPTS)" 2>/dev/null; \
				"$(ZORRO_SCRIPTS)" || true;; \
			"quick-actions") \
				echo -e "$(GREEN)⚡ Running Quick Actions...$(NC)"; \
				echo -e "$(YELLOW)Description:$(NC) System & tool configuration menu (rofi)"; \
				echo -e "$(BLUE)Path:$(NC) $(QUICK_ACTIONS)"; \
				echo -e "$(BLUE)Location:$(NC) .local/bin/quick-actions"; \
				chmod +x "$(QUICK_ACTIONS)" 2>/dev/null; \
				"$(QUICK_ACTIONS)" || true;; \
			"dotfiles-scripts") \
				echo -e "$(GREEN)📁 Running Misc Scripts...$(NC)"; \
				echo -e "$(YELLOW)Description:$(NC) Various dotfiles scripts"; \
				echo -e "$(BLUE)Path:$(NC) $(DOTFILES_SCRIPTS)"; \
				echo -e "$(BLUE)Location:$(NC) .local/bin/dotfiles-scripts"; \
				chmod +x "$(DOTFILES_SCRIPTS)" 2>/dev/null; \
				"$(DOTFILES_SCRIPTS)" || true;; \
			*) echo -e "$(YELLOW)No selection made$(NC)";; \
		esac \
	else \
		echo -e "$(YELLOW)fzf not found. Please install fzf first.$(NC)"; \
		echo "Installation options:"; \
		echo "  Debian/Ubuntu: sudo apt install fzf"; \
		echo "  macOS: brew install fzf"; \
		echo "  Arch: sudo pacman -S fzf"; \
	fi

# Direct script execution targets - Updated with descriptions
bootstrap: check
	@if [ -f "$(INSTALL_DIR)" ]; then \
		echo -e "$(GREEN)🚀 Running Main Installer (dots-bootstrap.sh)...$(NC)"; \
		echo -e "$(YELLOW)Description:$(NC) Run once to setup dotfiles"; \
		echo -e "$(BLUE)Path:$(NC) $(INSTALL_DIR)"; \
		chmod +x "$(INSTALL_DIR)" 2>/dev/null; \
		"$(INSTALL_DIR)" || true; \
	else \
		echo -e "$(RED)❌ Script not found: $(INSTALL_DIR)$(NC)"; \
	fi

themes: check
	@if [ -f "$(THEME_SCRIPT)" ]; then \
		echo -e "$(GREEN)🎨 Running Themes Installer (install-themes.sh)...$(NC)"; \
		echo -e "$(YELLOW)Description:$(NC) Install themes and color schemes"; \
		echo -e "$(BLUE)Path:$(NC) $(THEME_SCRIPT)"; \
		chmod +x "$(THEME_SCRIPT)" 2>/dev/null; \
		"$(THEME_SCRIPT)" || true; \
	else \
		echo -e "$(RED)❌ Script not found: $(THEME_SCRIPT)$(NC)"; \
	fi

assets: check
	@if [ -f "$(THIRD_SCRIPT)" ]; then \
		echo -e "$(GREEN)📦 Running Assets Installer (assets.sh)...$(NC)"; \
		echo -e "$(YELLOW)Description:$(NC) Install theme files, icons, wallpapers"; \
		echo -e "$(BLUE)Path:$(NC) $(THIRD_SCRIPT)"; \
		chmod +x "$(THIRD_SCRIPT)" 2>/dev/null; \
		"$(THIRD_SCRIPT)" || true; \
	else \
		echo -e "$(RED)❌ Script not found: $(THIRD_SCRIPT)$(NC)"; \
		echo -e "$(YELLOW)Expected location:$(NC) .github/assets.sh"; \
	fi

zorro: check
	@if [ -f "$(ZORRO_SCRIPTS)" ]; then \
		echo -e "$(GREEN)🦊 Running Theme Scripts (zorro-scripts)...$(NC)"; \
		echo -e "$(YELLOW)Description:$(NC) Theme related scripts"; \
		echo -e "$(BLUE)Path:$(NC) $(ZORRO_SCRIPTS)"; \
		echo -e "$(YELLOW)Location:$(NC) .local/bin/zorro-scripts"; \
		chmod +x "$(ZORRO_SCRIPTS)" 2>/dev/null; \
		"$(ZORRO_SCRIPTS)" || true; \
	else \
		echo -e "$(RED)❌ Script not found: $(ZORRO_SCRIPTS)$(NC)"; \
		echo -e "$(YELLOW)Expected location:$(NC) .local/bin/zorro-scripts"; \
	fi

quick: check
	@if [ -f "$(QUICK_ACTIONS)" ]; then \
		echo -e "$(GREEN)⚡ Running Quick Actions (quick-actions)...$(NC)"; \
		echo -e "$(YELLOW)Description:$(NC) Beautiful system & tool configuration menu (rofi)"; \
		echo -e "$(BLUE)Path:$(NC) $(QUICK_ACTIONS)"; \
		echo -e "$(YELLOW)Location:$(NC) .local/bin/quick-actions"; \
		chmod +x "$(QUICK_ACTIONS)" 2>/dev/null; \
		"$(QUICK_ACTIONS)" || true; \
	else \
		echo -e "$(RED)❌ Script not found: $(QUICK_ACTIONS)$(NC)"; \
		echo -e "$(YELLOW)Expected location:$(NC) .local/bin/quick-actions"; \
	fi

dots: check
	@if [ -f "$(DOTFILES_SCRIPTS)" ]; then \
		echo -e "$(GREEN)📁 Running Misc Scripts (dotfiles-scripts)...$(NC)"; \
		echo -e "$(YELLOW)Description:$(NC) Various dotfiles scripts (run once)"; \
		echo -e "$(BLUE)Path:$(NC) $(DOTFILES_SCRIPTS)"; \
		echo -e "$(YELLOW)Location:$(NC) .local/bin/dotfiles-scripts"; \
		chmod +x "$(DOTFILES_SCRIPTS)" 2>/dev/null; \
		"$(DOTFILES_SCRIPTS)" || true; \
	else \
		echo -e "$(RED)❌ Script not found: $(DOTFILES_SCRIPTS)$(NC)"; \
		echo -e "$(YELLOW)Expected location:$(NC) .local/bin/dotfiles-scripts"; \
	fi

# Check if all scripts exist
check:
	@echo -e "$(YELLOW)🔍 Checking all 6 dotfiles scripts...$(NC)"
	@echo -e "$(BLUE)Current directory:$(NC) $(SCRIPT_DIR)"
	@echo ""
	
	@# Counter for found scripts
	@found=0; total=6; \
	\
	check_script() { \
		if [ -f "$$1" ]; then \
			echo -e "$(GREEN)✓ Found:$(NC) $$2"; \
			echo -e "  $(YELLOW)Description:$(NC) $$3"; \
			echo -e "  $(BLUE)Path:$(NC) $$1"; \
			found=$$((found + 1)); \
		else \
			echo -e "$(RED)✗ Missing:$(NC) $$2"; \
			echo -e "  $(YELLOW)Description:$(NC) $$3"; \
			echo -e "  $(BLUE)Expected:$(NC) $$1"; \
		fi; \
		echo ""; \
	}; \
	\
	check_script "$(INSTALL_DIR)" "Main Installer" "Run once to setup dotfiles"; \
	check_script "$(THEME_SCRIPT)" "Themes Installer" "Install themes and color schemes"; \
	check_script "$(THIRD_SCRIPT)" "Assets Installer" "Install theme files, icons, wallpapers"; \
	check_script "$(ZORRO_SCRIPTS)" "Theme Scripts" "Theme related scripts (.local/bin/)"; \
	check_script "$(QUICK_ACTIONS)" "Quick Actions" "System & tool config menu (rofi)"; \
	check_script "$(DOTFILES_SCRIPTS)" "Misc Scripts" "Various dotfiles scripts"; \
	\
	echo -e "$(YELLOW)📊 Summary:$(NC) $${found}/$${total} scripts found"; \
	if [ $${found} -eq $${total} ]; then \
		echo -e "$(GREEN)✅ All dotfiles scripts are present!$(NC)"; \
	elif [ $${found} -eq 0 ]; then \
		echo -e "$(RED)❌ No scripts found! Check your paths.$(NC)"; \
	else \
		echo -e "$(YELLOW)⚠️  Some scripts are missing.$(NC)"; \
	fi

# Clean temporary files
clean:
	@echo -e "$(YELLOW)🧹 Cleaning temporary files...$(NC)"
	@rm -f *.tmp *.log *.bak 2>/dev/null || true
	@echo -e "$(GREEN)✓ Done$(NC)"

# Simple text menu (no fzf required) - Enhanced with descriptions
menu:
	@echo -e "$(YELLOW)══════════════════════════════════════════════════════════════$(NC)"
	@echo -e "$(BLUE)            Dotfiles Management Menu (6 options)               $(NC)"
	@echo -e "$(YELLOW)══════════════════════════════════════════════════════════════$(NC)"
	@echo ""
	@echo -e "$(CYAN)1$(NC)) $(MAGENTA)Main Installer$(NC)       - Run once to setup dotfiles"
	@echo -e "$(CYAN)2$(NC)) $(MAGENTA)Themes Installer$(NC)     - Install themes and color schemes"
	@echo -e "$(CYAN)3$(NC)) $(MAGENTA)Assets Installer$(NC)     - Install theme files/icons/wallpapers"
	@echo -e "$(CYAN)4$(NC)) $(MAGENTA)Theme Scripts$(NC)        - Theme related scripts (.local/bin/)"
	@echo -e "$(CYAN)5$(NC)) $(MAGENTA)Quick Actions$(NC)        - System & tool config menu (rofi)"
	@echo -e "$(CYAN)6$(NC)) $(MAGENTA)Misc Scripts$(NC)         - Various dotfiles scripts"
	@echo -e "$(CYAN)c$(NC)) $(MAGENTA)check$(NC)               - Check all scripts"
	@echo -e "$(CYAN)h$(NC)) $(MAGENTA)help$(NC)                - Show help"
	@echo -e "$(CYAN)q$(NC)) $(MAGENTA)quit$(NC)                - Exit"
	@echo ""
	@printf "$(YELLOW)Choose [1-6, c, h, q]: $(NC)"; \
	read choice; \
	case $$choice in \
		1) make bootstrap;; \
		2) make themes;; \
		3) make assets;; \
		4) make zorro;; \
		5) make quick;; \
		6) make dots;; \
		c|C) make check;; \
		h|H) make help;; \
		q|Q) echo "Goodbye!";; \
		*) echo "Invalid choice. Try again.";; \
	esac

# Quick run all (for testing)
test-all:
	@echo -e "$(YELLOW)🧪 Testing all dotfiles scripts...$(NC)"
	@for target in bootstrap themes assets zorro quick dots; do \
		echo ""; \
		echo -e "$(YELLOW)────────────────────────────────────$(NC)"; \
		echo -e "$(BLUE)Testing: make $$target$(NC)"; \
		make $$target 2>/dev/null || true; \
	done
	@echo ""; \
	echo -e "$(YELLOW)════════════════════════════════════════$(NC)"; \
	echo -e "$(GREEN)All tests completed!$(NC)"
