FC=gfortran

FFLAGS = -O3
SRC = homework4.f90 differentiate.f90 integral_omegaR.f90 printdble.f90 trap.f90 xycoord.f90

OBJ=${SRC:.f90=.o}
%.o: %.f90
	$(FC) $(FFLAGS) -o $@ -c $<
homework4.out: $(OBJ)
	$(FC) $(FFLAGS) -o $@ $(OBJ)

clean:
	@rm -f *.mod *.o maths

