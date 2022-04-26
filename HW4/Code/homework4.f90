program hwk4
  use xycoord ! use the module xycoord to set the mapping 
  implicit none !NOTE: use module-name must preceed the implicit none

  integer :: nr,ns,i,j

  real(kind = 8) :: hr,hs,det,integral,val,error
  real(kind = 8), dimension(:,:), allocatable :: jacobproduct

  real(kind = 8), dimension(:), allocatable :: r,s
  real(kind = 8), dimension(:,:), allocatable :: u
  real(kind = 8), dimension(:,:), allocatable :: xc,yc
  real(kind = 8), dimension(:,:), allocatable :: xr,xs
  real(kind = 8), dimension(:,:), allocatable :: yr,ys
  real(kind = 8), dimension(:,:), allocatable :: jacob
  real(kind = 8), dimension(:,:), allocatable :: uxex, uyex

  nr = 30
  ns = 60

  ! Allocate memory for the various arrays
  allocate(r(0:nr),s(0:ns),u(0:nr,0:ns))
  allocate(xc(0:nr,0:ns),yc(0:nr,0:ns))
  allocate(xr(0:nr,0:ns),xs(0:nr,0:ns),yr(0:nr,0:ns),ys(0:nr,0:ns))
  allocate(jacob(0:nr,0:ns))
  allocate(uxex(0:nr,0:ns),uyex(0:nr,0:ns))
  allocate(jacobproduct(0:nr,0:ns))

  hr = 2.d0/dble(nr)
  hs = 2.d0/dble(ns)
  do i = 0,nr
     r(i) = -1.d0 + dble(i)*hr
  end do
  do i = 0,ns
     s(i) = -1.d0 + dble(i)*hs
  end do

  do j = 0,ns
     do i = 0,nr
        xc(i,j) = x_coord(r(i),s(j))
        yc(i,j) = y_coord(r(i),s(j))
     end do
  end do
  call  printdble2d(xc,nr,ns,'x.txt')
  call  printdble2d(yc,nr,ns,'y.txt')

  ! Differentiate x and y with respect to r
  do i = 0,ns
    call differentiate(xc(0:nr,i),xr(0:nr,i),hr,nr)
    call differentiate(yc(0:nr,i),yr(0:nr,i),hr,nr)
  end do
  ! Differentiate x and y with respect to s
  do i = 0,nr
    call differentiate(xc(i,0:ns),xs(i,0:ns),hs,ns)
    call differentiate(yc(i,0:ns),ys(i,0:ns),hs,ns)
 end do

  do j = 0,ns
     do i = 0,nr

      ! FUNCTION 1:
      ! u(i,j) = sin(xc(i,j))*cos(yc(i,j))

      ! FUNCTION 2:
      ! u(i,j) = exp(xc(i,j)+yc(i,j))

      ! FUNCTION 3:
       u(i,j) = xc(i,j)**2.d0 + yc(i,j)**2.d0
     end do
  end do

  ! Calculate Jacobian 
  do j = 0, ns
    do i = 0, nr
      jacob(i,j) = xr(i,j)*ys(i,j) - xs(i,j)*yr(i,j)
    end do
  end do

  ! Store the elements of the Jacobian multiplied by the elements of u.
  do j = 0,ns
    do i = 0,nr
      jacobproduct(i,j) = u(i,j)*jacob(i,j)
    end do
  end do

  ! Integrate using trapezoidal rule
  integral = 0.d0
  do i = 0, nr
    call trap(1.d0, -1.d0, jacobproduct(i,0:ns), ns, val)
    integral = integral + val
  end do
  integral = integral*hr
  write(*,*) "integral value=", integral
end program hwk4

