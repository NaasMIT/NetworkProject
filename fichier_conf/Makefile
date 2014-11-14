CC      = gcc
CFLAGS  = -Wall -Wextra -Werror -Wfatal-errors
CFLAGS += -pedantic -pedantic-errors
CFLAGS += -std=gnu99
CFLAGS += -g
LDFLAGS =
SRC     = $(wildcard *.c)
OBJ     = $(SRC:.c=.o)
BIN     = client

all: $(BIN)

$(BIN): $(OBJ)
	@echo 'Building' $(BIN)
	@$(CC) -o $@ $^ $(LDFLAGS)
	@echo 'Built successfully'

%.o: %.c
	@echo 'Building $@ from $<'
	@$(CC) -o $@ -c $< $(CFLAGS)

run:
	@./$(BIN)

dbg:
	@gdb $(BIN)

mem:
	@valgrind ./$(BIN)

clean:
	@rm -rf $(OBJ) $(BIN)
