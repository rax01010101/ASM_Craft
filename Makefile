# --- Makefile ---
TARGET    = build/voxels
SRC_DIR   = src
OBJ_DIR   = build

ASM       = nasm
ASM_FLAGS = -f elf64
LD        = gcc
LD_FLAGS  = -no-pie -lSDL2 -lGL -lm

# List files explicitly to ensure correct linking order if needed, 
# though wildcards usually work fine here.
SOURCES   = $(SRC_DIR)/data.asm $(SRC_DIR)/math.asm $(SRC_DIR)/renderer.asm $(SRC_DIR)/main.asm
OBJECTS   = $(OBJ_DIR)/data.o $(OBJ_DIR)/math.o $(OBJ_DIR)/renderer.o $(OBJ_DIR)/main.o

# The default action: build the binary
all: directories $(TARGET)

# Link the objects into the final binary inside the build/ folder
$(TARGET): $(OBJECTS)
	$(LD) $(OBJECTS) -o $(TARGET) $(LD_FLAGS)

# Pattern rule: Compile each .asm in src/ to a .o in build/
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

# Create build directory if it doesn't exist
directories:
	@mkdir -p $(OBJ_DIR)

# Run the project from the root directory
run: all
	./$(TARGET)

# Clean up build artifacts
clean:
	rm -rf $(OBJ_DIR)

.PHONY: all clean directories run
