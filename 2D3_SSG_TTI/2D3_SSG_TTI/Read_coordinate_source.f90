!-----------------------------------------------
!���ܣ�
!    ��ȡ��Դ����
!���������
!    Input_file_source   ����Դ�����ļ�source.dat�ļ�������
!    x_coordinate_source ����Դx����
!    z_coordinate_source ����Դz����
!-----------------------------------------------
Subroutine Read_coordinate_source(Input_file_source,x_coordinate_source,z_coordinate_source)
  Implicit None
  Character *(*) Input_file_source
  Real :: x_coordinate_source,z_coordinate_source
  Open(12,file=Input_file_source,status='old')
  Read(12,*) x_coordinate_source,z_coordinate_source
  Close(12)
End Subroutine Read_coordinate_source