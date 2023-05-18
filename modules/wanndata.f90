!
!   wanndata.f90
!   
!
!   Created by Chao Cao on 01/03/14.
!   Copyright 2013 __MyCompanyName__. All rights reserved.
!

MODULE wanndata
  !
  use constants
  !
  IMPLICIT NONE

  INTEGER norb
  INTEGER nrpt

  COMPLEX(DP), ALLOCATABLE :: ham(:,:,:)

  REAL(DP), ALLOCATABLE :: weight(:)

  REAL(DP), ALLOCATABLE :: rvec(:,:)
  !
CONTAINS

SUBROUTINE read_reduced_ham(seed)
!   
  USE para
  USE constants
  !
  IMPLICIT NONE
  !
  CHARACTER(len=80) seed
  INTEGER t1, t2, t3, t4, iw, nwann
  INTEGER, ALLOCATABLE :: wt(:)
  REAL(DP) a, b
  !
  if (inode.eq.0) then
    write(stdout, *) " # Reading file "//trim(seed)//"_hr.rdat"
    !
    open(unit=fin, file=trim(seed)//"_hr.rdat")
    !
    read(fin, *)
    read(fin, *) norb
    read(fin, *) nrpt
    !
    write(stdout, *) " #  Dimensions:"
    write(stdout, *) "    # of orbitals:", norb
    write(stdout, *) "    # of real-space grid:", nrpt
  endif
  !
  CALL para_sync(norb)
  CALL para_sync(nrpt)
  !
  allocate(ham(1:norb, 1:norb, 1:nrpt))
  allocate(weight(1:nrpt))
  allocate(rvec(1:3, 1:nrpt))
  !
  ham(:,:,:)=0.d0
  !
  if (inode.eq.0) then
    allocate(wt(1:nrpt))
    read(fin, '(15I5)') (wt(iw),iw=1,nrpt)
    weight(:)=wt(:)
    deallocate(wt)

    !tmp1 = nrpt/15
    !tmp2 = nrpt - 15*tmp1
    !do i = 1,tmp1
    !    read(fin,*) weight(15*i-14:15*i:1)
    !end do
    !if (tmp2 /= 0) then
    !    read(fin,*) weight(15*tmp1+1:15*tmp1+tmp2:1)
    !endif

    !
    do iw=1, nrpt
      read(fin, '(3I5)') t1, t2, t3
      rvec(1, iw)=t1
      rvec(2, iw)=t2
      rvec(3, iw)=t3
    enddo
    !
    read(fin, *) nwann
    !
    do iw=1, nwann
      read(fin, *) t1, t2, t3, t4, a, b
      ham(t1, t2, t3)=CMPLX(a, b)
      ham(t2, t1, t4)=CMPLX(a,-b)
    enddo
    !
    close(unit=fin)
    write(stdout, *) " # Done."
  endif
  !
  CALL para_sync(ham, norb, norb, nrpt)
  CALL para_sync(weight, nrpt)
  CALL para_sync(rvec, 3, nrpt)
  !
END SUBROUTINE

SUBROUTINE read_ham(seed)
!
  USE para
  USE constants
  !
  IMPLICIT NONE
  !
  CHARACTER(len=80) seed
  INTEGER irpt, iorb, jorb, t1, t2, t3, t4, t5, i, tmp1, tmp2
  INTEGER, ALLOCATABLE :: wt(:)
  REAL(DP) a, b
  !
  if (inode.eq.0) then
    write(stdout, *) " # Reading file "//trim(seed)//"_hr.dat"
    !
    open(unit=fin, file=trim(seed)//"_hr.dat")
    !
    read(fin, *)
    read(fin, *) norb
    read(fin, *) nrpt
    !
    write(stdout, *) " #  Dimensions:"
    write(stdout, *) "    # of orbitals:", norb
    write(stdout, *) "    # of real-space grid:", nrpt
  endif
  !
  CALL para_sync(norb)
  CALL para_sync(nrpt)
  !
  allocate(ham(1:norb, 1:norb, 1:nrpt))
  allocate(weight(1:nrpt))
  allocate(rvec(1:3, 1:nrpt))
  !
  if (inode.eq.0) then
    !allocate(wt(1:nrpt))
    !read(fin, '(15I5)') (wt(irpt),irpt=1,nrpt)
    !weight(:)=wt(:)
    !deallocate(wt)
    tmp1 = nrpt/15
    tmp2 = nrpt - 15*tmp1
    do i = 1,tmp1
        read(fin,*) weight(15*i-14:15*i:1)
    end do
    if (tmp2 /= 0) then
        read(fin,*) weight(15*tmp1+1:15*tmp1+tmp2:1)
    endif
    !
    do irpt=1, nrpt
      do iorb=1, norb
        do jorb=1, norb
          read(fin, *) t1, t2, t3, t4, t5, a, b
          if ((iorb.eq.1).and.(jorb.eq.1)) then
            rvec(1, irpt)=t1
            rvec(2, irpt)=t2
            rvec(3, irpt)=t3
          endif
          ham(iorb, jorb, irpt)=CMPLX(a,b)
        enddo
      enddo
    enddo
    !
    close(unit=fin)
    write(stdout, *) " # Done."
  endif

  !write(*,*) "weight"
  !do irpt  = 1,nrpt
  !    write(*,*) weight(irpt)
  !end do
  !write(*,*) "end weight"
  !
  CALL para_sync(ham, norb, norb, nrpt)
  CALL para_sync(weight, nrpt)
  CALL para_sync(rvec, 3, nrpt)
  !
END SUBROUTINE

SUBROUTINE finalize_wann()
  !
  IMPLICIT NONE
  !
  if (allocated(ham)) deallocate(ham)
  if (allocated(weight)) deallocate(weight)
  if (allocated(rvec)) deallocate(rvec)
  !
END SUBROUTINE


END MODULE

