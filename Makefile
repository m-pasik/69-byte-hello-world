SOURCE = hello.asm
AS = nasm
ASFLAGS = -f bin
EXECUTABLE = hello

all: ${EXECUTABLE}

${EXECUTABLE}:${SOURCE}
	${AS} ${ASFLAGS} -o $@ $<
	chmod +x $@

clean:
	rm -f ${EXECUTABLE}
