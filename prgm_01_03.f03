Program prgm_01_03
!
!     This program reads two 3x3 matrices from a user-provided input file. After the
!     file is opened and read, it is closed and then printed. The product of the two matrixes is printed !     as well.
!
!
      implicit none
      integer,parameter::inFileUnitA=10,inFileUnitB=11
      integer::errorFlag,i
      real,dimension(3,3)::matrixInA,matrixInB,matrixProduct
      character(len=128)::fileNameA,fileNameB
!
!
!     Start by asking the user for the names of the data files, A and B.
!
      write(*,*)' What is the name of the first input data file?'
      read(*,*) fileNameA
!
!
      write(*,*)' What is the name of the second input data file?'
      read(*,*) fileNameB
!
!
!     Open the data file and read matrixInA from that file.
!
      open(unit=inFileUnitA,file=TRIM(fileNameA),status='old',  &
        iostat=errorFlag)
      if(errorFlag.ne.0) then
        write(*,*)' There was a problem opening input file 1.'
        goto 999
      endIf
      do i = 1,3
        read(inFileUnitA,*) matrixInA(1,i),matrixInA(2,i),matrixInA(3,i)
      endDo
      close(inFileUnitA)
!
      open(unit=inFileUnitB, file=TRIM(fileNameB),status='old', &
       iostat=errorFlag)
      if(errorFlag.ne.0) then
       write(*,*)' There was a problem opening input file 2.'
       goto 999
      endIf
      do i = 1, 3
       read(inFileUnitB,*) matrixInB(1,i), matrixInB(2,i), matrixInB(3,i)
      endDo
      close(inFileUnitB)
!
!
!     Call the subroutine PrintMatrix to print matrixInA.
!
      call PrintMatrix3x3(matrixInA)
!
!     Call the subroutine PrintMatrix to print matrixInB.
!
      call PrintMatrix3x3(matrixInB)
!
!     Using MatMul to print the matrix product.
!
!
      matrixProduct = MatMul(matrixInA,matrixInB)
      call PrintMatrix3x3(matrixProduct)
!
!
  999 continue
      End Program prgm_01_03


      Subroutine PrintMatrix3x3(matrix)
!

!     This subroutine prints a 3x3 real matrix. The output is written to StdOut.
!
      implicit none
      real,dimension(3,3),intent(in)::matrix
      integer::i
!
!     Format statements.
!
 1000 format(3(2x,f5.1))
!
!     Do the printing job.
!
      write(*,*)' Printing Matrix'
!
      do i = 1, 3
	write(*,1000) matrix(i,1), matrix(i,2), matrix(i,3)
      end do
!
!
      return
      End Subroutine PrintMatrix3x3

