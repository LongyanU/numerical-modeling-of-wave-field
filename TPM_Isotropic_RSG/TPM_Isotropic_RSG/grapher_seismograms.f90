Subroutine grapher_seismograms(n_file,Nline,vx_file,vz_file,Inpath,Outpath)
  Implicit None
  Integer :: n_file
  Integer :: Nline
  Character(len=16) :: vx_file,vz_file
  Character(len=18) :: seismogram_x(1:n_file),seismogram_z(1:n_file)
  Real :: xtime(1:Nline,1:n_file),ztime(1:Nline,1:n_file)
  Real :: vx(1:Nline,1:n_file),vz(1:Nline,1:n_file)
  Character *(*) :: Inpath,Outpath
  Integer :: i
  
  Write(*,*) '正在执行归一化操作...'
  
  Call Read_file(n_file,vx_file,seismogram_x,Inpath)           !读取待操作文件的文件名
  Call Read_file(n_file,vz_file,seismogram_z,Inpath)
  
  Call Read_data(n_file,Nline,seismogram_x,xtime,vx,Inpath)    !读取待操作文件的数据
  Call Read_data(n_file,Nline,seismogram_z,ztime,vz,Inpath)
  
  Call Normalization(n_file,Nline,vx)                   !对待操作文件做归一化
  Call Normalization(n_file,Nline,vz)
  
  Call Shift(n_file,Nline,vx)                           !对归一化后数据进行整体等差平移
  Call Shift(n_file,Nline,vz)
  
  Call Output_data(n_file,Nline,seismogram_x,xtime,vx,Outpath)  !输出经过系列操作后的文件数据
  Call Output_data(n_file,Nline,seismogram_z,ztime,vz,Outpath)
  
  Write(*,*) 'Done...'
End Subroutine grapher_seismograms
  
  
Subroutine Read_file(n_file,filename,seismogram,Inpath)
  Implicit None
  Integer :: n_file
  Character *(*) filename
  Character *(*) :: seismogram(1:n_file)
  Integer :: i
  Character *(*) :: Inpath
  
  Open(11,file=Inpath//filename,status='old')
  Do i=1,n_file
    Read(11,*) seismogram(i)
  End Do
  Close(11)
  
End Subroutine Read_file


Subroutine Read_data(n_file,Nline,seismogram,time,v,Inpath)
  Implicit None
  Integer :: n_file
  Integer :: Nline
  Character *(*) :: seismogram(1:n_file)
  Real :: time(1:Nline,1:n_file)
  Real :: v(1:Nline,1:n_file)
  Integer :: i,j
  Character *(*) :: Inpath
  
  time=0.0
  v=0.0
  Do i=1,n_file
    Open(i+100,file=Inpath//seismogram(i),status='old')
  End Do
  
  Do j=1,n_file
    Do i=1,Nline
      Read(j+100,*) time(i,j),v(i,j)
    End Do
  End Do
  
  Do i=1,n_file
    Close(i+100)
  End Do
  
End Subroutine Read_data
  
  
Subroutine Normalization(n_file,Nline,v)
  Implicit None
  Integer :: n_file
  Integer :: Nline
  Real :: v(1:Nline,1:n_file)
  Real :: vmax
  Integer :: i,j
  
  vmax=0.0
  Do j=1,n_file
    Do i=1,Nline
      vmax=max(vmax,v(i,j))
    End Do
  End Do

  Do j=1,n_file
    Do i=1,Nline
      v(i,j)=v(i,j)/vmax
    End Do
  End Do
  
End Subroutine Normalization
  
  
Subroutine Shift(n_file,Nline,v)
  Implicit None
  Integer :: n_file
  Integer :: Nline
  Real :: v(1:Nline,1:n_file)
  Real :: k
  Integer :: i,j
  
  k=1.0
  Do j=1,n_file
    Do i=1,Nline
      v(i,j)=v(i,j)+k
    End Do
    k=k+1.0
  End Do
  
End Subroutine Shift
  

Subroutine Output_data(n_file,Nline,seismogram,time,v,Outpath)
  Implicit None
  Integer :: n_file
  Integer :: Nline
  Character *(*) :: seismogram(1:n_file)
  Real :: time(1:Nline,1:n_file)
  Real :: v(1:Nline,1:n_file)
  Character *(*) :: Outpath     !路径变量  
  Integer :: i,j
  
  Do i=1,n_file
    Open(i+100,file=Outpath//seismogram(i),status='replace')     !打开此路径
  End Do
  
  Do j=1,n_file
    Do i=1,Nline
      Write(j+100,*) time(i,j),v(i,j)
    End Do
  End Do
  
  Do i=1,n_file
    Close(i+100)
  End Do
  
End Subroutine Output_data
