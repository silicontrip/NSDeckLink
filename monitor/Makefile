CFLAGS=-g -fsanitize=address -F /Library/Frameworks -I /Library/Frameworks
CC=/usr/local/Cellar/llvm/19.1.4/bin/clang
LFLAGS= -fsanitize=address -framework foundation -framework AudioToolbox -F /Library/Frameworks -framework DeckLinkAPI -framework NSDeckLink

# Object files
OBJ=monitor.o

all: monitor


%.o: %.m
	$(CC) $(CFLAGS) -c $< -o $@

monitor: main.o
	$(CC)  $(LFLAGS) $(OBJ) -o monitor

clean:
	rm -f monitor main.o
