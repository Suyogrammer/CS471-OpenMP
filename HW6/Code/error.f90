subroutine error(nr,ns,eI,h_eff,errValue,errCheck)
  use xycoord   !use the module xycoord to set the mapping 
  implicit none
  integer, intent (in) :: nr, ns, errCheck
  integer :: i,j,eI
  real(kind = 8) :: hr,hs, detMat, JacobianMax
  real(kind = 8), dimension(:), allocatable :: r,s
  real(kind = 8), dimension(:,:), allocatable ::u,ur,us,ux,uy,w,integral
  real(kind = 8), intent (out):: h_eff(0:errCheck), errValue(0:errCheck)
  real(kind = 8), dimension(:,:), allocatable ::xc,yc,xr,yr,xs,ys,rx,sx,ry,sy,uxExact,uyExact,Jacobian,integrand

  ! Allocate memory for various arrays
  allocate(r(0:nr),s(0:ns),u(0:nr,0:ns),ur(0:nr,0:ns),us(0:nr,0:ns))
  allocate(xc(0:nr,0:ns),yc(0:nr,0:ns),xr(0:nr,0:ns),yr(0:nr,0:ns))
  allocate(xs(0:nr,0:ns),ys(0:nr,0:ns),rx(0:nr,0:ns))
  allocate(sx(0:nr,0:ns),ry(0:nr,0:ns),sy(0:nr,0:ns))
  allocate(ux(0:nr,0:ns),uy(0:nr,0:ns),integrand(0:nr,0:ns),w(0:nr,0:ns))
  allocate(uxExact(0:nr,0:ns),uyExact(0:nr,0:ns),Jacobian(0:nr,0:ns),integral(0:nr,0:ns))

  !Setting up the cartasian grid
  hr = 2.d0/dble(nr)
  hs = 2.d0/dble(ns)
  do i = 0,nr
     r(i) = -1.d0 + dble(i)*hr
  end do
  do i = 0,ns
     s(i) = -1.d0 + dble(i)*hs
  end do

  !Co-ordinate values
  do j = 0,ns
     do i = 0,nr
        xc(i,j) = x_coord(r(i),s(j))
        yc(i,j) = y_coord(r(i),s(j))
     end do
  end do

  call derivative(u,uxExact,uyExact,xc,yc,ns,nr)

  !$OMP PARALLEL SHARED(u,ur), PRIVATE(j,i)
  !$OMP SECTIONS


  ! Differentiate in the r-direction
  !$OMP SECTION
  do j = 0,ns
     call differentiate(u(0:nr,j),ur(0:nr,j),hr,nr)
  end do
  !$OMP SECTION
  do j = 0,ns
     call differentiate(xc(0:nr,j),xr(0:nr,j),hr,nr)
  end do
  !$OMP SECTION
  do j = 0,ns
     call differentiate(yc(0:nr,j),yr(0:nr,j),hr,nr)
  end do

  ! Differentiate in the s-direction
  !$OMP SECTION
  do i = 0,nr
     call differentiate(u(i,0:ns),us(i,0:ns),hs,ns)
  end do
  !$OMP SECTION
  do i = 0,nr
     call differentiate(xc(i,0:ns),xs(i,0:ns),hs,ns)
  end do
  !$OMP SECTION
  do i = 0,nr
     call differentiate(yc(i,0:ns),ys(i,0:ns),hs,ns)
  end do
  !$OMP END SECTIONS 
  !$OMP END PARALLEL

  ! Calculates the value of rx,ry,sx,and sy ans storing the Jacobian value.
  JacobianMax = 0.d0
  !$OMP PARALLEL DO PRIVATE(i,j)
  do j = 0, ns
     do i = 0, nr
        detMat = (xr(i,j)*ys(i,j)) - (xs(i,j)*yr(i,j))
        !write(*,*) detMat
        Jacobian(i,j) = detMat
        if (Jacobian(i,j) > JacobianMax) then
           JacobianMax = Jacobian(i,j)
        end if
        rx(i,j) = ys(i,j)/detMat
        sx(i,j) = -(yr(i,j)/detMat)
        ry(i,j) = -(xs(i,j)/detMat)
        sy(i,j) = xr(i,j)/detMat
     end do
  end do
  !$OMP END PARALLEL DO
    ! Finding the approximation values of ux and uy 
  !$OMP PARALLEL DO PRIVATE(i,j)
  do j = 0, ns
     do i = 0, nr
        ux(i,j) = ur(i,j)*rx(i,j) + us(i,j)*sx(i,j)
        uy(i,j) = ur(i,j)*ry(i,j) + us(i,j)*sy(i,j)
     end do
  end do
  !$OMP END PARALLEL DO

    ! Finding integrand expression
  !$OMP PARALLEL DO PRIVATE(i,j)
  do j = 0, ns
     do i = 0, nr
        integrand(i,j) = (ux(i,j) + uy(i,j) - (uxExact(i,j) + uyExact(i,j)))**2
        !print *, integrand(i,j)
        !integrand(i,j) = u(i,j)
     end do
  end do
  !$OMP END PARALLEL DO 

  !Weighting for matrix w
  !$omp parallel do private(i,j)
  do j = 0,ns   
     do i = 0,nr
        if ( j== 0.or.j==ns) then
          if (i == 0.or.i == nr) then
            w(i,j) = 0.25d0
          else
            w(i,j) = 0.5d0
          end if
        else if (i == 0.or.i==nr) then
          w(i,j) = 0.5d0
        else
          w(i,j) = 1.d0
        end if
     end do
  end do
  !$omp end parallel do

  !write (*,*) w
  !Finding error
  !$omp parallel do private(i,j)
  do j = 0,ns
     do i = 0,nr
        integral(i,j) = integrand(i,j)*w(i,j)*Jacobian(i,j)
     end do
  end do
  !$omp end parallel do

  errValue(eI) = hr*hs*sum(integral)
  h_eff(eI) = sqrt(hr*hs*JacobianMax)
  !print *, "max", JacobianMax
  !print *, "errVal=[", errorVal," ];"
  !print *, "errValArray = [errValArray ", " errVal];"
  !print *, "h_eff=[", h_eff," ];"
  !print *, "h_effArray=[h_effArray", " h_eff];"
  deallocate(r,s,u,ur,us)
  deallocate(xc,yc,xr,yr)
  deallocate(xs,ys,rx)
  deallocate(sx,ry,sy)
  deallocate(ux,uy,integrand,w)
  deallocate(uxExact,uyExact,Jacobian,integral)
end subroutine
