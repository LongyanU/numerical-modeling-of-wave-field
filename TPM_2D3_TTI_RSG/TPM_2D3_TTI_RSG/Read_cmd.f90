!------------------------------------------------------------
!���ܣ���ȡ�����ļ�����    
!    cmdfile            : �����ļ�FDM_SSG.cmd�ļ�������
!    xmin               : x������Сֵ
!    xmax               : x�������ֵ
!    zmin               : z������Сֵ
!    zmax               : z�������ֵ
!    thickness_PML      : ���ƥ�����
!    delt_x             : x���򲽳�
!    delt_z             : z���򲽳�
!    delt_h             : ���ƥ��㲽��
!    geophone_x         : �첨��x����
!    geophone_z1        : �첨��z1����
!    geophone_z2        : �첨��z2����
!    fre_wavelet        : ��Դ�Ӳ���Ƶ
!    delay_source_t0    : ��Դ�����ӳ�ʱ��
!    nt                 : ��������
!    delt_t             : ����ʱ����
!    n_source           : ��Դ����
!    Input_file_source  : ��Դ�ļ�source.dat�ļ�������
!-----------------------------------------------------
Subroutine Read_cmd(cmdfile,xmin,xmax,zmin,zmax,thickness_PML,delt_x,delt_z,delt_h,reflect_coefficient,&
                geophone_z,geophone_x1,geophone_x2,fre_wavelet,delay_source_t0,nt,delt_t,n_source,&
                Input_file_source,Input_file_modelpar,Output_file_snapx,Output_file_snapz,&
                Output_file_recordx,Output_file_recordz)
  Implicit None
  Character *(*) :: cmdfile
  Real :: xmin,xmax,zmin,zmax
  Real :: thickness_PML,delt_x,delt_z,delt_h
  Real :: reflect_coefficient
  Real :: geophone_z,geophone_x1,geophone_x2
  Real :: fre_wavelet,delay_source_t0
  Integer :: nt
  Real :: delt_t
  Integer :: n_source
  Character *(*) :: Input_file_source
  Character *(*) :: Input_file_modelpar
  Character *(*) :: Output_file_snapx,Output_file_snapz
  Character *(*) :: Output_file_recordx,Output_file_recordz
  Open(11,file=cmdfile,status='old') 
  Read(11,*) xmin,xmax,zmin,zmax
  Read(11,*) thickness_PML,delt_x,delt_z,delt_h
  Read(11,*) reflect_coefficient
  Read(11,*) geophone_z,geophone_x1,geophone_x2
  Read(11,*) fre_wavelet,delay_source_t0
  Read(11,*) nt
  Read(11,*) delt_t
  Read(11,*) n_source
  Read(11,*) Input_file_source
  Read(11,*) Input_file_modelpar
  Read(11,*) Output_file_snapx
  Read(11,*) Output_file_snapz
  Read(11,*) Output_file_recordx
  Read(11,*) Output_file_recordz
  Close(11)
End Subroutine Read_cmd