# Makefile in einem Unterverzeichnis
include ../Makefile.rules

OBJ = main.o cmdline.o index.o lexic.o controller.o indexparser.o stringutil.o fileutil.o

all: $(OBJ)

clean:
	rm -f $(OBJ)