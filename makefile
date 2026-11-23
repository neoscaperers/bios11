CC 		= pdp11-aout-gcc
OBJCOPY	= pdp11-aout-objcopy
CFLAGS 	= -nostdlib -ffreestanding -s -Ttext=0x1000 -msoft-float
SRCS 	= ./src
TARGET 	= bios11
FILES	= $(SRCS)/start.s $(SRCS)/main.c $(SRCS)/cons.h
OBJS	= $(addsuffix .o, $(basename $(FILES)))

all: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)
	$(OBJCOPY) -O binary $(TARGET) $(TARGET).raw

%.o: %.c
	$(CC) $(CFLAGS) -c $^ -o $@

%.o: %.S 
	$(CC) $(CFLAGS) -c $^ -o $@

clean:
	rm $(OBJS) $(TARGET)*