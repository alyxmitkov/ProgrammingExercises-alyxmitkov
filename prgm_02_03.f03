      Program prgm_02_03
!
!     This program reads a file name from the command line, opens that
!     file, and loads a packed form of a symmetric matrix. Then, the packed
!     matrix is expanded assuming a column-wise lower-triangle form and
!     printed. Finally, the matrix is diagonalized using the LAPack routine
!     SSPEV. The eigenvalues and eigenvectors are printed.
!
!     The input file is expected to have the leading dimension (an integer
!     NDim) of the matrix on the first line. The next (NDim*(NDim+1))/2
!     lines each have one real number each given.
!
      Implicit None
      Integer::IIn=10,IError,NDim,i,j
      Real,Dimension(:),Allocatable::Array_Input,EVals,Temp_Vector
      Real,Dimension(:,:),Allocatable::Matrix,EVecs,Temp_Matrix
      Character(Len=256)::FileName
      External SymmetricPacked2Matrix_LowerPac, Print_Matrix_Full_Real
!
!     Begin by reading the input file name from the command line. Then,
!     open the file and read the input array, Array_Input.
!
      Call Get_Command_Argument(1,FileName)
      Open(Unit=IIn,File=TRIM(FileName),Status='OLD',IOStat=IError)
      If(IError.ne.0) then
        Write(*,*)' Error opening input file.'
        STOP
      endIf
      Read(IIn,*) NDim
      Allocate(Array_Input((NDim*(NDim+1))/2),Matrix(NDim,NDim))
      Allocate(EVals(NDim),EVecs(NDim,NDim),Temp_Vector(3*NDim))
      Allocate(Temp_Matrix(NDim,NDim))
!
! *************************************************************************
! WRITE CODE HERE TO READ THE ARRAY ELEMENTS FROM THE INPUT FILE.
! *************************************************************************
!
      do i = 1, (NDim*(NDim+1))/2
         read(IIn,*) Array_Input(i)
      end do
      Close(Unit=IIn)
!
!     Convert Array_Input to Matrix and print the matrix.
!
      Write(*,*)' The matrix loaded (column) lower-triangle packed:'
      Call SymmetricPacked2Matrix_LowerPac(NDim,Array_Input,Matrix)
      Call Print_Matrix_Full_Real(Matrix,NDim,NDim)
      Call SSPEV('V','L',NDim,Array_Input,EVals,EVecs,NDim,  &
        Temp_Vector,IError)
      If(IError.ne.0) then
        Write(*,*)' Failure in SSPEV.'
        STOP
      endIf
      Write(*,*)' EVals:'
      Call Print_Matrix_Full_Real(RESHAPE(EVals,(/1,NDim/)),1,NDim)
      Write(*,*)' EVecs:'
      Call Print_Matrix_Full_Real(EVecs,NDim,NDim)
!
      End Program prgm_02_03

      Subroutine SymmetricPacked2Matrix_LowerPac(NDim, AMat_in, AMat_out)
      Implicit None
      Integer, Intent(In) :: NDim
      Real, Intent(In) :: AMat_in((NDim*(NDim+1))/2)
      Real, Intent(Out) :: AMat_out(NDim, NDim)
      Integer :: i, j, k
!
      AMat_out = 0.0
!
      k = 1
      Do j = 1, NDim
        Do i = j, NDim
          AMat_out(I, j) = AMat_in(k)
          AMat_out(j, i) = AMat_in(k)
          k = k + 1
        End Do
      End Do
      End Subroutine SymmetricPacked2Matrix_LowerPac

      Subroutine Print_Matrix_Full_Real(AMat,M,N)
!
!     This subroutine prints a real matrix that is fully dimension - i.e.,
!     not stored in packed form. AMat is the matrix, which is dimensioned
!     (M,N).
!
!     The output of this routine is sent to unit number 6 (set by the local
!     parameter integer IOut).
!
!
!     Variable Declarations
!
      implicit none
      integer,intent(in)::M,N
      real,dimension(M,N),intent(in)::AMat
!
!     Local variables
      integer,parameter::IOut=6,NColumns=5
      integer::i,j,IFirst,ILast
!
 1000 Format(1x,A)
 2000 Format(5x,5(7x,I7))
 2010 Format(1x,I7,5F14.6)
!
      Do IFirst = 1,N,NColumns
        ILast = Min(IFirst+NColumns-1,N)
        write(IOut,2000) (i,i=IFirst,ILast)
        Do i = 1,M
          write(IOut,2010) i,(AMat(i,j),j=IFirst,ILast)
        endDo
      endDo
!
      Return
      End Subroutine Print_Matrix_Full_Real
