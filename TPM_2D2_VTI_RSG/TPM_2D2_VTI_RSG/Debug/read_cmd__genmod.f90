        !COMPILER-GENERATED INTERFACE MODULE: Wed Apr 26 20:06:26 2017
        MODULE READ_CMD__genmod
          INTERFACE 
            SUBROUTINE READ_CMD(CMDFILE,XMIN,XMAX,ZMIN,ZMAX,            &
     &THICKNESS_PML,DELT_X,DELT_Z,DELT_H,REFLECT_COEFFICIENT,GEOPHONE_Z,&
     &GEOPHONE_X1,GEOPHONE_X2,FRE_WAVELET,DELAY_SOURCE_T0,NT,DELT_T,    &
     &N_SOURCE,INPUT_FILE_SOURCE,INPUT_FILE_MODELPAR,OUTPUT_FILE_SNAPX, &
     &OUTPUT_FILE_SNAPZ,OUTPUT_FILE_RECORDX,OUTPUT_FILE_RECORDZ)
              CHARACTER(*) :: CMDFILE
              REAL(KIND=4) :: XMIN
              REAL(KIND=4) :: XMAX
              REAL(KIND=4) :: ZMIN
              REAL(KIND=4) :: ZMAX
              REAL(KIND=4) :: THICKNESS_PML
              REAL(KIND=4) :: DELT_X
              REAL(KIND=4) :: DELT_Z
              REAL(KIND=4) :: DELT_H
              REAL(KIND=4) :: REFLECT_COEFFICIENT
              REAL(KIND=4) :: GEOPHONE_Z
              REAL(KIND=4) :: GEOPHONE_X1
              REAL(KIND=4) :: GEOPHONE_X2
              REAL(KIND=4) :: FRE_WAVELET
              REAL(KIND=4) :: DELAY_SOURCE_T0
              INTEGER(KIND=4) :: NT
              REAL(KIND=4) :: DELT_T
              INTEGER(KIND=4) :: N_SOURCE
              CHARACTER(*) :: INPUT_FILE_SOURCE
              CHARACTER(*) :: INPUT_FILE_MODELPAR
              CHARACTER(*) :: OUTPUT_FILE_SNAPX
              CHARACTER(*) :: OUTPUT_FILE_SNAPZ
              CHARACTER(*) :: OUTPUT_FILE_RECORDX
              CHARACTER(*) :: OUTPUT_FILE_RECORDZ
            END SUBROUTINE READ_CMD
          END INTERFACE 
        END MODULE READ_CMD__genmod
