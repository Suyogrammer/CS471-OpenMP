subroutine error2d(ux, uy, uxex, uyex, jacob, nr, ns, err)
  implicit none
  integer :: i,j
  integer, intent(in) :: nr,ns
  real(kind = 8), intent(in) :: ux(0:nr,0:ns), uy(0:nr,0:ns)
  real(kind = 8), intent(in) :: uxex(0:nr,0:ns), uyex(0:nr,0:ns)
  real(kind = 8), intent(in) :: jacob(0:nr,0:ns)
  real(kind = 8), intent(out) :: err
  real(kind = 8), dimension(:,:), allocatable :: e2d
  real(kind = 8) :: val
  !integer :: i,j

  allocate(e2d(0:nr,0:ns))

  do j = 0,ns
    do i = 0,nr
      e2d(i,j) = ((ux(i,j) + uy(i,j) - (uxex(i,j) + uyex(i,j)))**2)
      e2d(i,j) = e2d(i,j)*jacob(i,j)
    end do
  end do

 ! err = 0.d0
  do i = 0,nr
    call trap(1.d0, -1.d0, e2d(i,0:ns), ns, val)
    err = err + val
  end do
  err = (err * (2.d0/dble(nr)))**(0.5d0)
end subroutine error2d
