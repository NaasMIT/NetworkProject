CC      = colorgcc
#CFLAGS  = -Wall 
CFLAGS  = -Wextra -Werror -Wfatal-errors
CFLAGS += -pedantic -pedantic-errors
CFLAGS += -std=gnu99
CFLAGS += -g
LDFLAGS = 
SRC     = $(wildcard *.c)
OBJ     = $(SRC:.c=.o)
TARGET  = prog
RM      = rm -rf

all: $(TARGET)

$(TARGET): $(OBJ)
	@echo 'Building' $(TARGET)
	@$(CC) -o $@ $^ $(LDFLAGS)
	@echo 'Built successfully'

%.o: %.c
	@echo 'Building $@ from $<'
	@$(CC) -o $@ -c $< $(CFLAGS)

run:
	@./$(TARGET)

dbg:
	@gdb -tui $(TARGET)

mem:
	@valgrind ./$(TARGET)

clean:
	@$(RM) $(OBJ) $(TARGET)
