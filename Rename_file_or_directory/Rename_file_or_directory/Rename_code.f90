Program Main
  Integer :: i, n
  Integer :: rename, status
  Character(len=18) file1,file2
  
  file1='hello'         !���file2ָ�����ļ��Ѵ��ڣ���file2��file1����������ͬ���ļ����ͣ�
  file2='hello world'   !���ұ���λ����ͬ���ļ�ϵͳ�С����file2�Ѵ��ڣ�Ӧ�Ƚ���ɾ����
    
  status = rename(file1,file2)
  if ( status .ne. 0 ) stop 'rename: error'

End Program Main