# set compiler and compile options
EXEC = hf
CXX = g++                             # use the GNU C++ compiler
OPTS =   -fopenmp	  				  # use openmp
CFLAGS = $(OPTS)                      # add compile flags
LDFLAGS = -fopenmp 					  # specify link flags here

# set a list of directories
OBJDIR = ./obj
BINDIR = ./bin
SRCDIR = ./src

# set the include folder where the .h files reside
CFLAGS += -I$(SRCDIR)

# specify OS-related stuff
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    CFLAGS  += -I/usr/local/Cellar/eigen/3.3.4/include/eigen3
	LDFLAGS +=
else
    CFLAGS += `pkg-config --cflags eigen3 libpng` -I/mingw64/include # include eigen, libpng and boost
	LDFLAGS += `pkg-config --libs libpng` # link libpng
endif

# add here the source files for the compilation
SOURCES = hf.cpp integrals.cpp solvers.cpp prelim_math.cpp dft.cpp quadrature.cpp lebedev.cpp

# create the obj variable by substituting the extension of the sources
# and adding a path
_OBJ = $(SOURCES:.cpp=.o)
OBJ = $(patsubst %,$(OBJDIR)/%,$(_OBJ))

all: $(BINDIR)/$(EXEC)

$(BINDIR)/$(EXEC): $(OBJ)
	$(CXX) -o $(BINDIR)/$(EXEC) $(OBJ) $(LIBDIR) $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	$(CXX) -c -o $@ $< $(CFLAGS)

clean:
	rm -vf $(BINDIR)/$(EXEC) $(OBJ)
