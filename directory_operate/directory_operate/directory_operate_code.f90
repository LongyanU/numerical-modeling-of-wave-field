Program directory_operate
  Implicit None
  Integer(kind=4) :: getcwd,changedirQQ,status,istat     !�˴���getcwd,changedirQQ������������
  Character(len=64) :: dirname                           !Ҳ��ֱ��ʹ��Use IFPORT����������getcwd,changedirQQ
  
  status = getcwd( dirname )                             !��ȡ��ǰ����Ŀ¼
  If ( status .ne. 0 ) stop 'getcwd: error'
  
  istat=changedirQQ('dir_test')                          !�ı䵱ǰ����Ŀ¼��'dir_test'
                                                         !ע�⣺�˴����Ҳ���'dir_test'�ļ��У���Ὣ'print.txt'�ļ�
                                                         !�������ǰ����Ŀ¼
  
  Open(11,file='print.txt',status='replace')             !����ȡ�ĵ�ǰ����Ŀ¼�ַ��������&
  Write(11,*) dirname                                    !�ı䵱ǰ����Ŀ¼���Ŀ¼'dir_test'�е�'print.txt'�ļ�
  Close(11)
  
End Program directory_operate