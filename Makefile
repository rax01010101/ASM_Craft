TARGET    = build/voxels
SRC_DIR   = src
OBJ_DIR   = build

ASM       = nasm
ASM_FLAGS = -f elf64
LD        = gcc
LD_FLAGS  = -no-pie -lSDL2 -lGL -lm

SOURCES   = $(SRC_DIR)/data.asm $(SRC_DIR)/math.asm $(SRC_DIR)/renderer.asm $(SRC_DIR)/main.asm $(SRC_DIR)/physics.asm

OBJECTS   = $(patsubst $(SRC_DIR)/%.asm,$(OBJ_DIR)/%.o,$(SOURCES))

all: directories $(TARGET)

$(TARGET): $(OBJECTS)
	$(LD) $(OBJECTS) -o $(TARGET) $(LD_FLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

directories:
	@mkdir -p $(OBJ_DIR)

run: all
	./$(TARGET)

clean:
	rm -rf $(OBJ_DIR)

.PHONY: all clean directories run
