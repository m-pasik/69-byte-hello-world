SOURCES = hello.asm
AS = nasm
ASFLAGS = -f bin
EXECUTABLES = ${SOURCES:.asm=}

all: ${EXECUTABLES}

%:%.asm
	${AS} ${ASFLAGS} -o $@ $<
	chmod +x $@

clean:
	rm -f ${EXECUTABLES}
