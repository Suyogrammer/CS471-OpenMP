#FC = gfortran         #on local machine
FC = ifort             #on Stampede2

FFLAGS = -O3 -fopenmp #on local machine optimized
#FFLAGS = -g -fopenmp  #on local machine debugging

FFLAGS = -O3 -qopenmp  #on Stampede2
.PHONY: clean

DEPS=homework6.o xycoord.o printdble.o differentiate.o error.o
all: homework6

%.mod:%.f90
	$(FC) $(FFLAGS) -c $<

%.o:%.f90 xycoord.mod
	$(FC) $(FFLAGS) -c $<

homework6:$(DEPS) xycoord.mod
	$(FC) $(FFLAGS) -o $@ $(DEPS)

grid.eps:coupled.txt plotgrid.m
	matlab -nosplash -nodisplay -nodesktop < plotgrid.m
	echo


clean:
	rm -f *.o *.mod
