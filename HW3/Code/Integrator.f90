program Integrator
  
  implicit none
  double precision :: xl, xr, h, pi, error, Intt1, Intt2, Intg1, Intg2, Intt1pre, Intt2pre, Intg1pre, Intg2pre
  integer :: n, n1, i1 
  double precision, dimension(:), Allocatable :: x1,funct1,funct2,x2,funcg1,funcg2,w
  n = 20 
  pi = acos(-1d0)
  xl = -1d0
  xr = 1d0
  Intt1pre = 1.00d3
  Intt2pre = 1.00d3
  Intg1pre = 1.00d3
  Intg2pre = 1.00d3
  error = 1000d0
  n1 = 1
  do while (error > 10d-10)
     h = (xr - xl)/dble(n1)
     allocate(x1(0:n1),funct1(0:n1),funct2(0:n1),x2(0:n1),funcg1(0:n1),funcg2(0:n1),w(0:n1))
     call lglnodes(x2,w,n1)
     do i1 = 0,n1
        x1(i1) = xl + dble(i1)*h
     end do
     funct1 = exp(cos(pi*x1))
     funct2 = exp(cos(pi*pi*x1))
     funcg1 = exp(cos(pi*x2))
     funcg2 = exp(cos(pi*pi*x2))
     call Trapezoidal(n1,funct1,h,Intt1)
     call Trapezoidal(n1,funct2,h,Intt2)
     call Gauss_Quadrature(funcg1,w,n1,Intg1)
     call Gauss_Quadrature(funcg2,w,n1,Intg2)
     write(*,*) n1,",",abs(Intt1-Intt1pre) ,",", abs(Intt2-Intt2pre),",",abs(Intg1-Intg1pre) ,",", abs(Intg2-Intg2pre)
     error = max(abs(Intt1 - Intt1pre),abs(Intt2-Intt2pre),abs(Intg1-Intg1pre) , abs(Intg2-Intg2pre))
     Intt1pre = Intt1
     Intt2pre = Intt2
     Intg1pre = Intg1
     Intg2pre = Intg2
     deallocate(x1,funct1,funct2,x2,funcg1,funcg2,w)
     n1 = n1+1
  end do
   
contains

  subroutine Trapezoidal(n,f,h,I)
    implicit none
    integer, intent(in) :: n
    double precision, intent(in) :: h
    double precision, dimension(0:n), intent(in) :: f
    double precision, intent(out) :: I
    integer :: i1

   ! I = 0d0
    I = sum(f)
    I = I - (f(0)+f(n))/2d0
    I = I * h
    
  end subroutine Trapezoidal

  subroutine Gauss_Quadrature(f,w,n,I)
    implicit none
    integer, intent(in) :: n
    double precision, dimension(0:n), intent(in) :: f,w
    double precision, intent(out) :: I
    integer :: i1

    I = 0d0
    do i1 = 0,n
       I = I + f(i1)*w(i1)
    end do
    
    
  end subroutine Gauss_Quadrature
  
  
end program Integrator

