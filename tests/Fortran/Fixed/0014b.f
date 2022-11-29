      module othermodule
      end module
      module onemoremodule
      end module
      module testmodule
        contains
        function foo0(N) result(K)
          !$acc routine
          implicit none
          integer :: N, K
          integer :: meaningoflife
          K = 42 + N
        end function
        function foo1(N)
          !$acc routine
          implicit none
          integer :: N
          integer :: foo1
          foo1 = 42 + N
        end function
        subroutine foo2(N, R)
          implicit none
          integer, intent(in) :: N
          integer, intent(out) :: R
          !$acc routine
          R = N + R
        end subroutine
        subroutine foo3(N, R)
          integer, intent(in) :: N
          integer, intent(out) :: R
          !$acc routine
          R = N + R
        end subroutine
        subroutine foo4(N, R)
          integer, intent(in) :: N
          integer, intent(out) :: R

          !$acc routine

          R = N + R
        end subroutine
        subroutine foo5(N, R)
          !$acc routine
          use iso_c_binding
          use othermodule
          use onemoremodule
          implicit none
          integer, intent(in) :: N
          integer, intent(out) :: R
          R = N + R
        end subroutine
      end module

      program app
        use testmodule
        integer :: res1, res2
        integer :: N

        !$acc serial copyout(res1, res2)
        res1 = foo0(N)
        res2 = foo1(res1)
        call foo2(N, res1)
        call foo3(N, res2)
        call foo4(res1, res2)
        call foo5(res2, res1)
        !$acc end serial

        write (*,*) res1 .eq. res2
      end program
