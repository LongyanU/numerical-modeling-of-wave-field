        !COMPILER-GENERATED INTERFACE MODULE: Wed Apr 19 09:35:00 2017
        MODULE READ_FILE__genmod
          INTERFACE 
            SUBROUTINE READ_FILE(N_FILE,FILENAME,SEISMOGRAM)
              INTEGER(KIND=4) :: N_FILE
              CHARACTER(*) :: FILENAME
              CHARACTER(*) :: SEISMOGRAM(1:N_FILE)
            END SUBROUTINE READ_FILE
          END INTERFACE 
        END MODULE READ_FILE__genmod
