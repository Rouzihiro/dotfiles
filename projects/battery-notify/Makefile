# Compiler
CC      := gcc

# Output binary
TARGET  := battery-notify

# Installation directory
PREFIX  := $(HOME)/bin

# Compiler flags
CFLAGS  := -O2 -Wall -Wextra -pedantic $(shell pkg-config --cflags libnotify)

# Linker flags
LDLIBS  := $(shell pkg-config --libs libnotify)

# Source files
SRC     := battery-notify.c

.PHONY: all install uninstall clean run

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $< -o $@ $(LDLIBS)

install: $(TARGET)
	mkdir -p "$(PREFIX)"
	install -m 755 $(TARGET) "$(PREFIX)/$(TARGET)"
	@echo "Installed to $(PREFIX)/$(TARGET)"

uninstall:
	rm -f "$(PREFIX)/$(TARGET)"
	@echo "Removed $(PREFIX)/$(TARGET)"

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)
