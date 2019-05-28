Subroutine Wave_Field_Modeling(delt_x,delt_z,delt_h,reflect_coefficient,fre_wavelet,delay_source_t0,nt,delt_t,&
                           n_source,ige,ig1,ig2,nx,nz,ml,is,js,Input_file_modelpar,Output_file_snapx,&
                           Output_file_snapz,Output_file_recordx,Output_file_recordz)
  Implicit None
  Real :: delt_x,delt_z,delt_h
  Real :: reflect_coefficient
  Real :: fre_wavelet,delay_source_t0
  Integer :: nt
  Real :: delt_t
  Integer :: n_source
  Real :: ige,ig1,ig2
  Integer :: nx,nz,ml
  Integer :: is,js
  Character *(*) :: Input_file_modelpar
  Character *(*) :: Output_file_snapx,Output_file_snapz
  Character *(*) :: Output_file_recordx,Output_file_recordz
  Real :: C(6,6)                                                  !VTI���ʵ��Գ���
  Real :: density(-ml:nx+ml,-ml:nz+ml)
  Real :: vp(-ml:nx+ml,-ml:nz+ml),vs(-ml:nx+ml,-ml:nz+ml)
  Real :: vx(-ml:nx+ml,-ml:nz+ml,2),vy(-ml:nx+ml,-ml:nz+ml,2),&
          vz(-ml:nx+ml,-ml:nz+ml,2)                               !vx,vz�ֱ���x�����ٶȷ�����z�����ٶȷ���
  Real :: txx(-ml:nx+ml,-ml:nz+ml,2),tzz(-ml:nx+ml,-ml:nz+ml,2),&
          txz(-ml:nx+ml,-ml:nz+ml,2),txy(-ml:nx+ml,-ml:nz+ml,2),&
          tyz(-ml:nx+ml,-ml:nz+ml,2)                              !txx,tzz,txz�ֱ�������Ӧ������
  Real :: vxxi1(ml,-ml:nz+ml,2),vxxi2(ml,-ml:nz+ml,2),&	          !���� �߽� 
          vxxj1(-ml:nx+ml,ml,2),vxxj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽� 
  Real :: vxzi1(ml,-ml:nz+ml,2),vxzi2(ml,-ml:nz+ml,2),&	          !���� �߽� 
          vxzj1(-ml:nx+ml,ml,2),vxzj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽� 
  Real :: vzxi1(ml,-ml:nz+ml,2),vzxi2(ml,-ml:nz+ml,2),&	          !���� �߽� 
          vzxj1(-ml:nx+ml,ml,2),vzxj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽� 
  Real :: vzzi1(ml,-ml:nz+ml,2),vzzi2(ml,-ml:nz+ml,2),&	          !���� �߽� 
          vzzj1(-ml:nx+ml,ml,2),vzzj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽� 
  Real :: vyxi1(ml,-ml:nz+ml,2),vyxi2(ml,-ml:nz+ml,2),&	          !���� �߽� 
          vyxj1(-ml:nx+ml,ml,2),vyxj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽� 
  Real :: vyzi1(ml,-ml:nz+ml,2),vyzi2(ml,-ml:nz+ml,2),&	          !���� �߽� 
          vyzj1(-ml:nx+ml,ml,2),vyzj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽� 
  Real :: t1xi1(ml,-ml:nz+ml,2),t1xi2(ml,-ml:nz+ml,2),&           !���� �߽� 
          t1xj1(-ml:nx+ml,ml,2),t1xj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�      t1=txx
  Real :: t1zi1(ml,-ml:nz+ml,2),t1zi2(ml,-ml:nz+ml,2),&           !���� �߽�
          t1zj1(-ml:nx+ml,ml,2),t1zj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: t2xi1(ml,-ml:nz+ml,2),t2xi2(ml,-ml:nz+ml,2),&           !���� �߽�	    t2=tzz  
          t2xj1(-ml:nx+ml,ml,2),t2xj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: t2zi1(ml,-ml:nz+ml,2),t2zi2(ml,-ml:nz+ml,2),&           !���� �߽�
          t2zj1(-ml:nx+ml,ml,2),t2zj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�        
  Real :: t3xi1(ml,-ml:nz+ml,2),t3xi2(ml,-ml:nz+ml,2),&           !���� �߽�	    t3=txz
          t3xj1(-ml:nx+ml,ml,2),t3xj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: t3zi1(ml,-ml:nz+ml,2),t3zi2(ml,-ml:nz+ml,2),&           !���� �߽�
          t3zj1(-ml:nx+ml,ml,2),t3zj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: t4xi1(ml,-ml:nz+ml,2),t4xi2(ml,-ml:nz+ml,2),&           !���� �߽�	    t4=txy
          t4xj1(-ml:nx+ml,ml,2),t4xj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: t4zi1(ml,-ml:nz+ml,2),t4zi2(ml,-ml:nz+ml,2),&           !���� �߽�
          t4zj1(-ml:nx+ml,ml,2),t4zj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: t5xi1(ml,-ml:nz+ml,2),t5xi2(ml,-ml:nz+ml,2),&           !���� �߽�	    t5=tyz
          t5xj1(-ml:nx+ml,ml,2),t5xj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: t5zi1(ml,-ml:nz+ml,2),t5zi2(ml,-ml:nz+ml,2),&           !���� �߽�
          t5zj1(-ml:nx+ml,ml,2),t5zj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: vxt(nx,nt),vyt(nx,nt),vzt(nx,nt)                        !vxt,vzt�ֱ��ǵ����¼x������z����
  Real :: xx,zz
  Real :: vum,vdm,vlm,vrm
  Real :: dx,dz
  Real :: qx(1:ml),qz(1:ml)
  Real :: qxd(1:ml),qzd(1:ml)
  Real :: r1,r2
  Integer(Kind=2) :: head(120)
  Integer(Kind=2) :: irecl1,irecl2                                !д���һ�ʼ�¼�ĳ���
  Integer :: ii1,ii2,jj1,jj2                                      !��Դ����Χ
  Real :: ef1,ef2,ef3,ef4                                         !��ַ���ϵ��
  Integer :: nt2,it,iit
  Integer :: n_file,n_file2                                              !��Ҫ�������ļ�����(��С��999)
  Character(len=9) :: filename1_x,filename1_y,filename1_z
  Character(len=11) :: filename2_x,filename2_y,filename2_z
  Character(len=4) :: file_extension
  Character *(80) :: Output_filename_x,Output_filename_y,Output_filename_z
  Character(len=16) :: vx_file,vy_file,vz_file
  Character(len=16),Allocatable :: snapshot_x(:),snapshot_y(:),snapshot_z(:)    !�������Ķ���ļ����ļ���
  Character(len=18),Allocatable :: seismogram_x(:),seismogram_y(:),seismogram_z(:)
  Real :: time
  Real :: fx,fz
  Real :: dxz
  Real :: fc0
  Real :: a1,a2,a3,a4
  Real :: b1,b2,b3,b4
  Real :: c1,c2,c3,c4
  Real :: d1,d2,d3,d4
  Real :: e1,e2,e3,e4
  Real :: f1,f2,f3,f4
  Real :: s1,s2
  Integer :: nx1,nz1
  Integer :: count
  Integer :: irec
  Integer :: ii
  Real :: a11,a12,a13,a14,a21,a22,a23,a24
  Real :: b11,b12,b13,b14,b21,b22,b23,b24
  Real :: d11,d12,d13,d14,d21,d22,d23,d24
  Real :: e11,e12,e13,e14,e21,e22,e23,e24
  Real :: f11,f12,f13,f14,f21,f22,f23,f24
  Integer :: i,j,k
  Character(len=14) :: outpath
  
  outpath='Output_Result\'
  
  r1=delt_t/delt_x
  r2=delt_t/delt_z
  
  Open(110,file='����.dat',status='replace')
  Open(13,file=Input_file_modelpar,status='old')
  Read(13,*)
  
  Do i=1,6
    Read(13,*) C(i,:)
    Write(110,'(6E12.3/)') C(i,:)
  End Do
  
  Read(13,*)
  Read(13,*)
  
  Do j=1,nz
    Do i=1,nx
      Read(13,*) xx,zz,density(i,j)
      Write(110,'(3E12.3/)') xx,zz,density(i,j)
    End Do
  End Do
  
  Close(13)
  Close(110)
  
  Do j=1,nz
    Do i=1,nx
      vp(i,j)=sqrt(C(3,3)/density(i,j))
      vs(i,j)=sqrt(C(5,5)/density(i,j))
    End Do
  End Do
  
  Open(11,file='vvvvvvvvvvv.dat')
  Do j=1,nz
    Do i=1,nx
      Write(11,*) vp(i,j),vs(i,j)
    End Do
  End Do
  Close(11)
  
  vum=0.0
  Do i=-ml,nx+ml
    Do j=-ml,0
      density(i,j)=density(i,1)
      vp(i,j)=vp(i,1)
      vs(i,j)=vs(i,1)
      vum=max(vum,vp(i,j))
    End Do
  End Do
  
  vdm=0.0
  Do i=-ml,nx+ml
    Do j=nz+1,nz+ml
      density(i,j)=density(i,nz)
      vp(i,j)=vp(i,nz)
      vs(i,j)=vs(i,nz)
    End Do
  End Do
  
  vlm=0.0
  Do j=-ml,nz+ml
    Do i=-ml,0
      density(i,j)=density(1,j)
      vp(i,j)=vp(1,j)
      vs(i,j)=vs(1,j)
      vlm=max(vlm,vp(1,j))
    End Do
  End Do
  
  vrm=0.0
  Do j=-ml,nz+ml
    Do i=nx+1,ml+nx
      density(i,j)=density(nx,j)
      vp(i,j)=vp(nx,j)
      vs(i,j)=vs(nx,j)
      vrm=max(vrm,vp(i,j))
    End Do
  End Do
  
  dx=3.0*log(1.0/reflect_coefficient)*vlm/(2.0*ml*delt_x)
  dz=3.0*log(1.0/reflect_coefficient)*vlm/(2.0*ml*delt_z)
  Do i=1,ml
    qx(i)=delt_t*dx*((ml-i)*delt_x/(ml*delt_x))**2
    qz(i)=delt_t*dz*((ml-i)*delt_z/(ml*delt_z))**2
    qxd(i)=1.0/(1.0+qx(i))
    qzd(i)=1.0/(1.0+qz(i))
  End Do
    
  vx=0.0;vy=0.0;vz=0.0	  
  txx=0.0;tzz=0.0;txz=0.0;txy=0.0;tyz=0.0
  vxxi1=0.0;vxxi2=0.0;vxxj1=0.0;vxxj2=0.0
  vxzi1=0.0;vxzi2=0.0;vxzj1=0.0;vxzj2=0.0
  vzxi1=0.0;vzxi2=0.0;vzxj1=0.0;vzxj2=0.0
  vzzi1=0.0;vzzi2=0.0;vzzj1=0.0;vzzj2=0.0
  vyxi1=0.0;vyxi2=0.0;vyxj1=0.0;vyxj2=0.0
  vyzi1=0.0;vyzi2=0.0;vyzj1=0.0;vyzj2=0.0
  t1xi1=0.0;t1xi2=0.0;t1xj1=0.0;t1xj2=0.0
  t1zi1=0.0;t1zi2=0.0;t1zj1=0.0;t1zj2=0.0
  t2xi1=0.0;t2xi2=0.0;t2xj1=0.0;t2xj2=0.0
  t2zi1=0.0;t2zi2=0.0;t2zj1=0.0;t2zj2=0.0
  t3xi1=0.0;t3xi2=0.0;t3xj1=0.0;t3xj2=0.0
  t3zi1=0.0;t3zi2=0.0;t3zj1=0.0;t3zj2=0.0
  t4xi1=0.0;t4xi2=0.0;t4xj1=0.0;t4xj2=0.0
  t4zi1=0.0;t4zi2=0.0;t4zj1=0.0;t4zj2=0.0
  t5xi1=0.0;t5xi2=0.0;t5xj1=0.0;t5xj2=0.0
  t5zi1=0.0;t5zi2=0.0;t5zj1=0.0;t5zj2=0.0

!----------------���ɲ��������ļ�����ʼ-------------------------
  n_file=int(nt/400)   !��������������ո����ļ���
  Allocate(snapshot_x(1:n_file),snapshot_y(1:n_file),snapshot_z(1:n_file))
  filename1_x='snapshotx'
  filename1_y='snapshoty'
  filename1_z='snapshotz'
  file_extension='.sgy'
  Output_filename_x='snapshots_x.txt'
  Output_filename_y='snapshots_y.txt'
  Output_filename_z='snapshots_z.txt'
  
  Call Create_file(n_file,filename1_x,file_extension,snapshot_x,Output_filename_x)
  Call Create_file(n_file,filename1_y,file_extension,snapshot_y,Output_filename_y)
  Call Create_file(n_file,filename1_z,file_extension,snapshot_z,Output_filename_z)
  
  n_file2=int(ig2/20.0+0.5)
  Allocate(seismogram_x(1:n_file2),seismogram_y(1:n_file2),seismogram_z(1:n_file2))
  filename2_x='seismogramx'
  filename2_y='seismogramy'
  filename2_z='seismogramz'
  file_extension='.dat'
  Output_filename_x='seismogram_x.txt'
  Output_filename_y='seismogram_y.txt'
  Output_filename_z='seismogram_z.txt'
  
  Call Create_file(n_file2,filename2_x,file_extension,seismogram_x(:),Output_filename_x)
  Call Create_file(n_file2,filename2_y,file_extension,seismogram_y(:),Output_filename_y)
  Call Create_file(n_file2,filename2_z,file_extension,seismogram_z(:),Output_filename_z)
!----------------���ɲ��������ļ�������-------------------------

  head(58)=nz+2*ml+1
  head(59)=2000
  irecl1=(nz+2*ml+1)*4+240
  
  Do i=1,n_file
    Open(i+100,file=outpath//snapshot_x(i),form='binary',access='direct',status='replace',recl=irecl1)
    Open(i+200,file=outpath//snapshot_y(i),form='binary',access='direct',status='replace',recl=irecl1)
    Open(i+300,file=outpath//snapshot_z(i),form='binary',access='direct',status='replace',recl=irecl1)
  End Do
  
  Do i=1,n_file2
    Open(i+400,file=outpath//seismogram_x(i),status='replace')
    Open(i+500,file=outpath//seismogram_y(i),status='replace')
    Open(i+600,file=outpath//seismogram_z(i),status='replace')
  End Do

  nt2=nt*2
  ii1=max(1,is-10)       
  ii2=min(nx,is+10)      
  jj1=max(1,js-10)       
  jj2=min(nz,js+10)      
  ef1=1225.0/1024.0      
  ef2=245.0/3072.0       
  ef3=441.0/46080.0      
  ef4=5.0/7168.0
  fx=0.0
  
  Do it=1,nt2
    If(mod(it,2).ne.0) Then   !����������������в���
      iit=(it+1)/2.0
      time=(iit-1)*delt_t          
      Call source_force(fre_wavelet,delay_source_t0,time,fc0)	!������Դ���� 
      Do j=1,nz
        Do i=1,nx
          
          If(iit.le.300) Then
            If(i.ge.ii1.and.i.le.ii2.and.j.ge.jj1.and.j.le.jj2) Then
              dxz=((i-is)**2+(j-js)**2)*0.1               
              fx=fc0*exp(-dxz)
              fz=fc0*exp(-dxz)
            End If
          End If
          
	        a1=txx(i,j,2)-txx(i-1,j,2)
	        a2=txx(i+1,j,2)-txx(i-2,j,2)
	        a3=txx(i+2,j,2)-txx(i-3,j,2)
	        a4=txx(i+3,j,2)-txx(i-4,j,2)
          b1=txz(i,j,2)-txz(i,j-1,2)
          b2=txz(i,j+1,2)-txz(i,j-2,2)
          b3=txz(i,j+2,2)-txz(i,j-3,2)
          b4=txz(i,j+3,2)-txz(i,j-4,2)
	        c1=tzz(i,j+1,2)-tzz(i,j,2)
	        c2=tzz(i,j+2,2)-tzz(i,j-1,2)
	        c3=tzz(i,j+3,2)-tzz(i,j-2,2)
	        c4=tzz(i,j+4,2)-tzz(i,j-3,2)
          d1=txz(i+1,j,2)-txz(i,j,2)
          d2=txz(i+2,j,2)-txz(i-1,j,2)
          d3=txz(i+3,j,2)-txz(i-2,j,2)
          d4=txz(i+4,j,2)-txz(i-3,j,2)
          e1=txy(i,j,2)-txy(i-1,j,2)
          e2=txy(i+1,j,2)-txy(i-2,j,2)
          e3=txy(i+2,j,2)-txy(i-3,j,2)
          e4=txy(i+3,j,2)-txy(i-4,j,2)
          f1=tyz(i,j,2)-tyz(i,j-1,2)
          f2=tyz(i,j+1,2)-tyz(i,j-2,2)
          f3=tyz(i,j+2,2)-tyz(i,j-3,2)
          f4=tyz(i,j+3,2)-tyz(i,j-4,2)
          vx(i,j,2)=vx(i,j,1)+1/density(i,j)*(r1*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)+r2*(ef1*b1-ef2*b2+ef3*b3-ef4*b4))+fx
          vy(i,j,2)=vy(i,j,1)+1/density(i,j)*(r1*(ef1*e1-ef2*e2+ef3*e3-ef4*e4)+r2*(ef1*f1-ef2*f2+ef3*f3-ef4*f4))
          vz(i,j,2)=vz(i,j,1)+1/density(i,j)*(r1*(ef1*d1-ef2*d2+ef3*d3-ef4*d4)+r2*(ef1*c1-ef2*c2+ef3*c3-ef4*c4))
        End Do
      End Do
      
      Do j=1,nz          !i=1--->-(ml-1), i=ml--->0	 ��߽�
        Do i=4,ml
	        a1=txx(-ml+i,j,2)-txx(-ml+i-1,j,2)    !vxx����
	        a2=txx(-ml+i+1,j,2)-txx(-ml+i-2,j,2)
	        a3=txx(-ml+i+2,j,2)-txx(-ml+i-3,j,2)
	        a4=txx(-ml+i+3,j,2)-txx(-ml+i-4,j,2)
	        s1=1/density(-ml+i,j)*r1*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=(1.0-0.5*qx(i))*vxxi1(i,j,1)			
	        vxxi1(i,j,2)=(s1+s2)*qxd(i)           
            
	        a1=txz(-ml+i,j,2)-txz(-ml+i,j-1,2)    !vxz����
	        a2=txz(-ml+i,j+1,2)-txz(-ml+i,j-2,2)
	        a3=txz(-ml+i,j+2,2)-txz(-ml+i,j-3,2)
	        a4=txz(-ml+i,j+3,2)-txz(-ml+i,j-4,2)
	        s1=1/density(-ml+i,j)*r2*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=0.0
	        vxzi1(i,j,2)=vxzi1(i,j,1)+(s1+s2)     
	        vx(-ml+i,j,2)=vxxi1(i,j,2)+vxzi1(i,j,2)
            
	        b1=txz(-ml+i+1,j,2)-txz(-ml+i,j,2)
	        b2=txz(-ml+i+2,j,2)-txz(-ml+i-1,j,2)
	        b3=txz(-ml+i+3,j,2)-txz(-ml+i-3,j,2)
	        b4=txz(-ml+i+4,j,2)-txz(-ml+i-4,j,2)
	        s1=1/density(-ml+i,j)*r1*(ef1*b1-ef2*b2+ef3*b3-ef4*b4)
	        s2=(1.0-0.5*qx(i))*vzxi1(i,j,1)
	        vzxi1(i,j,2)=(s1+s2)*qxd(i)
            
	        b1=tzz(-ml+i,j+1,2)-tzz(-ml+i,j,2)
	        b2=tzz(-ml+i,j+2,2)-tzz(-ml+i,j-1,2)
	        b3=tzz(-ml+i,j+3,2)-tzz(-ml+i,j-2,2)
	        b4=tzz(-ml+i,j+4,2)-tzz(-ml+i,j-3,2)
	        s1=1/density(-ml+i,j)*r2*(ef1*b1-ef2*b2+ef3*b3-ef4*b4)
	        s2=0.0
	        vzzi1(i,j,2)=vzzi1(i,j,1)+(s1+s2)
	        vz(-ml+i,j,2)=vzxi1(i,j,2)+vzzi1(i,j,2)
            
          a1=txy(-ml+i,j,2)-txy(-ml+i-1,j,2)    !vyx����
	        a2=txy(-ml+i+1,j,2)-txy(-ml+i-2,j,2)
	        a3=txy(-ml+i+2,j,2)-txy(-ml+i-3,j,2)
	        a4=txy(-ml+i+3,j,2)-txy(-ml+i-4,j,2)
	        s1=1/density(-ml+i,j)*r1*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=(1.0-0.5*qx(i))*vyxi1(i,j,1)			
	        vyxi1(i,j,2)=(s1+s2)*qxd(i)           
            
	        a1=tyz(-ml+i,j,2)-tyz(-ml+i,j-1,2)    !vyz����
	        a2=tyz(-ml+i,j+1,2)-tyz(-ml+i,j-2,2)
	        a3=tyz(-ml+i,j+2,2)-tyz(-ml+i,j-3,2)
	        a4=tyz(-ml+i,j+3,2)-tyz(-ml+i,j-4,2)
	        s1=1/density(-ml+i,j)*r2*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=0.0
	        vyzi1(i,j,2)=vyzi1(i,j,1)+(s1+s2)     
	        vy(-ml+i,j,2)=vyxi1(i,j,2)+vyzi1(i,j,2)
        End Do
      End Do
      
      Do j=1,nz
        Do i=1,ml
          vxxi1(i,j,1)=vxxi1(i,j,2)
          vxzi1(i,j,1)=vxzi1(i,j,2)
          vyxi1(i,j,1)=vyxi1(i,j,2)
          vyzi1(i,j,1)=vyzi1(i,j,2)
          vzxi1(i,j,1)=vzxi1(i,j,2)
          vzzi1(i,j,1)=vzzi1(i,j,2)
        End Do
      End Do
      
      nx1=nx+ml+1
      Do j=1,nz      !i=1--->-(ml-1), i=ml--->nx+1	  �ұ߽�
        Do i=ml,5,-1
          a1=txx(nx1-i,j,2)-txx(nx1-i-1,j,2)
	        a2=txx(nx1-i+1,j,2)-txx(nx1-i-2,j,2)
	        a3=txx(nx1-i+2,j,2)-txx(nx1-i-3,j,2)
	        a4=txx(nx1-i+3,j,2)-txx(nx1-i-4,j,2)
	        s1=1/density(nx1-i,j)*r1*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=(1.0-0.5*qx(i))*vxxi2(i,j,1)
	        vxxi2(i,j,2)=(s1+s2)*qxd(i)
            
	        a1=txz(nx1-i,j,2)-txz(nx1-i,j-1,2)
	        a2=txz(nx1-i,j+1,2)-txz(nx1-i,j-2,2)
	        a3=txz(nx1-i,j+2,2)-txz(nx1-i,j-3,2)
	        a4=txz(nx1-i,j+3,2)-txz(nx1-i,j-4,2)
	        s1=1/density(nx1-i,j)*r2*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=0.0
	        vxzi2(i,j,2)=vxzi2(i,j,1)+(s1+s2)
	        vx(nx1-i,j,2)=vxxi2(i,j,2)+vxzi2(i,j,2)
            
	        b1=txz(nx1-i+1,j,2)-txz(nx1-i,j,2)
	        b2=txz(nx1-i+2,j,2)-txz(nx1-i-1,j,2)
	        b3=txz(nx1-i+3,j,2)-txz(nx1-i-3,j,2)
	        b4=txz(nx1-i+4,j,2)-txz(nx1-i-4,j,2)
	        s1=1/density(nx1-i,j)*r1*(ef1*b1-ef2*b2+ef3*b3-ef4*b4)
	        s2=(1.0-0.5*qx(i))*vzxi2(i,j,1)
	        vzxi2(i,j,2)=(s1+s2)*qxd(i)
            
	        b1=tzz(nx1-i,j+1,2)-tzz(nx1-i,j,2)
	        b2=tzz(nx1-i,j+2,2)-tzz(nx1-i,j-1,2)
	        b3=tzz(nx1-i,j+3,2)-tzz(nx1-i,j-2,2)
	        b4=tzz(nx1-i,j+4,2)-tzz(nx1-i,j-3,2)
	        s1=1/density(nx1-i,j)*r2*(ef1*b1-ef2*b2+ef3*b3-ef4*b4)
	        s2=0.0
	        vzzi2(i,j,2)=vzzi2(i,j,1)+(s1+s2)
	        vz(nx1-i,j,2)=vzxi2(i,j,2)+vzzi2(i,j,2)
            
          a1=txy(nx1-i,j,2)-txy(nx1-i-1,j,2)        !vyx����
	        a2=txy(nx1-i+1,j,2)-txy(nx1-i-2,j,2)
	        a3=txy(nx1-i+2,j,2)-txy(nx1-i-3,j,2)
	        a4=txy(nx1-i+3,j,2)-txy(nx1-i-4,j,2)
	        s1=1/density(nx1-i,j)*r1*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=(1.0-0.5*qx(i))*vyxi2(i,j,1)
	        vyxi2(i,j,2)=(s1+s2)*qxd(i)
            
	        a1=tyz(nx1-i,j,2)-tyz(nx1-i,j-1,2)        !vyz����
	        a2=tyz(nx1-i,j+1,2)-tyz(nx1-i,j-2,2)
	        a3=tyz(nx1-i,j+2,2)-tyz(nx1-i,j-3,2)
	        a4=tyz(nx1-i,j+3,2)-tyz(nx1-i,j-4,2)
	        s1=1/density(nx1-i,j)*r2*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=0.0
	        vyzi2(i,j,2)=vyzi2(i,j,1)+(s1+s2)
	        vy(nx1-i,j,2)=vyxi2(i,j,2)+vyzi2(i,j,2)
        End Do
      End Do
      
      Do j=1,nz
        Do i=1,ml
	        vxxi2(i,j,1)=vxxi2(i,j,2)	    
	        vxzi2(i,j,1)=vxzi2(i,j,2)
          vyxi2(i,j,1)=vyxi2(i,j,2)	    
	        vyzi2(i,j,1)=vyzi2(i,j,2)
	        vzxi2(i,j,1)=vzxi2(i,j,2)	    
	        vzzi2(i,j,1)=vzzi2(i,j,2)
        End Do
      End Do
      
      Do j=4,ml                   ! j=ml--->0	 �ϱ߽�
        Do i=-ml+4,nx+ml-4
	        k=ml
	        if(i.le.0) k=ml+i       !��������1��3��7��9  
	        if(i.gt.nx) k=nx+ml-i+1
	        a1=txx(i,-ml+j,2)-txx(i-1,-ml+j,2)
	        a2=txx(i+1,-ml+j,2)-txx(i-2,-ml+j,2)
	        a3=txx(i+2,-ml+j,2)-txx(i-3,-ml+j,2)
	        a4=txx(i+3,-ml+j,2)-txx(i-4,-ml+j,2)
	        s1=1/density(i,-ml+j)*r1*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=(1.0-0.5*qx(k))*vxxj1(i,j,1)			
	        vxxj1(i,j,2)=(s1+s2)*qxd(k)
            
	        a1=txz(i,-ml+j,2)-txz(i,-ml+j-1,2)
	        a2=txz(i,-ml+j+1,2)-txz(i,-ml+j-2,2)
	        a3=txz(i,-ml+j+2,2)-txz(i,-ml+j-3,2)
	        a4=txz(i,-ml+j+3,2)-txz(i,-ml+j-4,2)
	        s1=1/density(i,-ml+j)*r2*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
          s2=(1.0-0.5*qx(j))*vxzj1(i,j,1)
	        vxzj1(i,j,2)=(s1+s2)*qxd(j)
	        vx(i,-ml+j,2)=vxxj1(i,j,2)+vxzj1(i,j,2)
            
	        b1=txz(i+1,-ml+j,2)-txz(i,-ml+j,2)
	        b2=txz(i+2,-ml+j,2)-txz(i-1,-ml+j,2)
	        b3=txz(i+3,-ml+j,2)-txz(i-3,-ml+j,2)
	        b4=txz(i+4,-ml+j,2)-txz(i-4,-ml+j,2)
	        s1=1/density(i,-ml+j)*r1*(ef1*b1-ef2*b2+ef3*b3-ef4*b4)
	        s2=(1.0-0.5*qx(k))*vzxj1(i,j,1)
	        vzxj1(i,j,2)=(s1+s2)*qxd(k)
            
	        b1=tzz(i,-ml+j+1,2)-tzz(i,-ml+j,2)
	        b2=tzz(i,-ml+j+2,2)-tzz(i,-ml+j-1,2)
	        b3=tzz(i,-ml+j+3,2)-tzz(i,-ml+j-2,2)
	        b4=tzz(i,-ml+j+4,2)-tzz(i,-ml+j-3,2)
          s1=1/density(i,-ml+j)*r2*(ef1*b1-ef2*b2+ef3*b3-ef4*b4)
          s2=(1.0-0.5*qx(j))*vzzj1(i,j,1)
	        vzzj1(i,j,2)=(s1+s2)*qxd(j)
	        vz(i,-ml+j,2)=vzxj1(i,j,2)+vzzj1(i,j,2)
            
          a1=txy(i,-ml+j,2)-txy(i-1,-ml+j,2)
	        a2=txy(i+1,-ml+j,2)-txy(i-2,-ml+j,2)
	        a3=txy(i+2,-ml+j,2)-txy(i-3,-ml+j,2)
	        a4=txy(i+3,-ml+j,2)-txy(i-4,-ml+j,2)
	        s1=1/density(i,-ml+j)*r1*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=(1.0-0.5*qx(k))*vyxj1(i,j,1)			
	        vyxj1(i,j,2)=(s1+s2)*qxd(k)
            
	        a1=tyz(i,-ml+j,2)-tyz(i,-ml+j-1,2)
	        a2=tyz(i,-ml+j+1,2)-tyz(i,-ml+j-2,2)
	        a3=tyz(i,-ml+j+2,2)-tyz(i,-ml+j-3,2)
	        a4=tyz(i,-ml+j+3,2)-tyz(i,-ml+j-4,2)
	        s1=1/density(i,-ml+j)*r2*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
          s2=(1.0-0.5*qx(j))*vyzj1(i,j,1)
	        vyzj1(i,j,2)=(s1+s2)*qxd(j)
	        vy(i,-ml+j,2)=vyxj1(i,j,2)+vyzj1(i,j,2)
        End Do
      End Do
      
      Do j=1,ml
        Do i=-ml,nx+ml
	        vxxj1(i,j,1)=vxxj1(i,j,2)   	    
	        vxzj1(i,j,1)=vxzj1(i,j,2)
          vyxj1(i,j,1)=vyxj1(i,j,2)   	    
	        vyzj1(i,j,1)=vyzj1(i,j,2)
	        vzxj1(i,j,1)=vzxj1(i,j,2)   	    
	        vzzj1(i,j,1)=vzzj1(i,j,2)
        End Do
      End Do
      
      nz1=nz+ml+1
      Do j=ml,5,-1                !i=1--->-(ml-1), i=ml--->nx+1	  �±߽�
        Do i=-ml+4,nx+ml-4
	        k=ml
	        if(i.le.0) k=ml+i         !��������1��3��7��9  
	        if(i.gt.nx) k=nx+ml-i+1
	        a1=txx(i,nz1-j,2)-txx(i-1,nz1-j,2)
	        a2=txx(i+1,nz1-j,2)-txx(i-2,nz1-j,2)
	        a3=txx(i+2,nz1-j,2)-txx(i-3,nz1-j,2)
	        a4=txx(i+3,nz1-j,2)-txx(i-4,nz1-j,2)
	        s1=1/density(i,nz1-j)*r1*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=(1.0-0.5*qx(k))*vxxj2(i,j,1)			
	        vxxj2(i,j,2)=(s1+s2)*qxd(k)
            
	        a1=txz(i,nz1-j,2)-txz(i,nz1-j-1,2)
	        a2=txz(i,nz1-j+1,2)-txz(i,nz1-j-2,2)
	        a3=txz(i,nz1-j+2,2)-txz(i,nz1-j-3,2)
	        a4=txz(i,nz1-j+3,2)-txz(i,nz1-j-4,2)
	        s1=1/density(i,nz1-j)*r2*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=(1.0-0.5*qx(j))*vxzj2(i,j,1)
	        vxzj2(i,j,2)=(s1+s2)*qxd(j)
	        vx(i,nz1-j,2)=vxxj2(i,j,2)+vxzj2(i,j,2)
            
	        b1=txz(i+1,nz1-j,2)-txz(i,nz1-j,2)
	        b2=txz(i+2,nz1-j,2)-txz(i-1,nz1-j,2)
	        b3=txz(i+3,nz1-j,2)-txz(i-3,nz1-j,2)
	        b4=txz(i+4,nz1-j,2)-txz(i-4,nz1-j,2)
	        s1=1/density(i,nz1-j)*r1*(ef1*b1-ef2*b2+ef3*b3-ef4*b4)
	        s2=(1.0-0.5*qx(k))*vzxj2(i,j,1)
	        vzxj2(i,j,2)=(s1+s2)*qxd(k)
            
	        b1=tzz(i,nz1-j+1,2)-tzz(i,nz1-j,2)
	        b2=tzz(i,nz1-j+2,2)-tzz(i,nz1-j-1,2)
	        b3=tzz(i,nz1-j+3,2)-tzz(i,nz1-j-2,2)
	        b4=tzz(i,nz1-j+4,2)-tzz(i,nz1-j-3,2)
	        s1=1/density(i,nz1-j)*r2*(ef1*b1-ef2*b2+ef3*b3-ef4*b4)
	        s2=(1.0-0.5*qx(j))*vzzj2(i,j,1)
	        vzzj2(i,j,2)=(s1+s2)*qxd(j)
	        vz(i,nz1-j,2)=vzxj2(i,j,2)+vzzj2(i,j,2)
            
          a1=txy(i,nz1-j,2)-txy(i-1,nz1-j,2)
	        a2=txy(i+1,nz1-j,2)-txy(i-2,nz1-j,2)
	        a3=txy(i+2,nz1-j,2)-txy(i-3,nz1-j,2)
	        a4=txy(i+3,nz1-j,2)-txy(i-4,nz1-j,2)
	        s1=1/density(i,nz1-j)*r1*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=(1.0-0.5*qx(k))*vyxj2(i,j,1)			
	        vyxj2(i,j,2)=(s1+s2)*qxd(k)
            
	        a1=tyz(i,nz1-j,2)-tyz(i,nz1-j-1,2)
	        a2=tyz(i,nz1-j+1,2)-tyz(i,nz1-j-2,2)
	        a3=tyz(i,nz1-j+2,2)-tyz(i,nz1-j-3,2)
	        a4=tyz(i,nz1-j+3,2)-tyz(i,nz1-j-4,2)
	        s1=1/density(i,nz1-j)*r2*(ef1*a1-ef2*a2+ef3*a3-ef4*a4)
	        s2=(1.0-0.5*qx(j))*vyzj2(i,j,1)
	        vyzj2(i,j,2)=(s1+s2)*qxd(j)
	        vy(i,nz1-j,2)=vyxj2(i,j,2)+vyzj2(i,j,2)
        End Do
      End Do
      
      Do j=1,ml
        Do i=-ml,nx+ml
	        vxxj2(i,j,1)=vxxj2(i,j,2)    	    
	        vxzj2(i,j,1)=vxzj2(i,j,2)
          vyxj2(i,j,1)=vyxj2(i,j,2)    	    
	        vyzj2(i,j,1)=vyzj2(i,j,2)
	        vzxj2(i,j,1)=vzxj2(i,j,2)  
	        vzzj2(i,j,1)=vzzj2(i,j,2)
        End Do
      End Do

      Do j=-ml,nz+ml     
        Do i=-ml,nx+ml   
          vx(i,j,1)=vx(i,j,2)   !��ǰһʱ�̼���Ĳ���ֵvx(i,j,2)��ֵ��vx(i,j,1)
          vy(i,j,1)=vy(i,j,2)
          vz(i,j,1)=vz(i,j,2)  
        End Do
      End Do
    
      Do i=1,nx
        vxt(i,iit)=vx(i,ige,2)    !��������Ϊ0��ǰһʱ�̵Ĳ���ֵ��ֵ��������Ϊ0�ļ첨��
        vyt(i,iit)=vy(i,ige,2)
        vzt(i,iit)=vz(i,ige,2)
      End Do
      
      Open(13,file='serial.dat')
      Do i=1,n_file2              !����ϳɵ���ͼ
        j=6+(i-1)*20
        Write(13,*) j
        Write(i+400,*) time,vxt(j,iit)
        Write(i+500,*) time,vyt(j,iit)
        Write(i+600,*) time,vzt(j,iit)
      End Do
      Close(13)
      
      If(mod(iit,400).eq.0) Then
        k=0
        Do i=-ml,nx+ml     
          k=k+1
          count=int(iit/400)
          Write(count+100,rec=k) head,(vx(i,j,2),j=-ml,nz+ml) !�����������
          Write(count+200,rec=k) head,(vy(i,j,2),j=-ml,nz+ml)
          Write(count+300,rec=k) head,(vz(i,j,2),j=-ml,nz+ml) 
        End Do
      End If
      
      If(mod(iit,10).eq.0) Write(*,*) iit,vx(is,js,2)
      
    Else
      iit=it/2.0
      
      Do j=1,nz
        Do i=1,nx            
          a11=vx(i+1,j,2)-vx(i,j,2)       !txx---vx/x
          a12=vx(i+2,j,2)-vx(i-1,j,2)
          a13=vx(i+3,j,2)-vx(i-2,j,2)
          a14=vx(i+4,j,2)-vx(i-3,j,2)
          a21=vz(i,j,2)-vz(i,j-1,2)       !txx---vz/z
          a22=vz(i,j+1,2)-vz(i,j-2,2)
          a23=vz(i,j+2,2)-vz(i,j-3,2)
          a24=vz(i,j+3,2)-vz(i,j-4,2)
          b11=vz(i,j,2)-vz(i,j-1,2)       !tzz---vz/z
          b12=vz(i,j+1,2)-vz(i,j-2,2)
          b13=vz(i,j+2,2)-vz(i,j-3,2)
          b14=vz(i,j+3,2)-vz(i,j-4,2)
          b21=vx(i+1,j,2)-vx(i,j,2)       !tzz---vx/x
          b22=vx(i+2,j,2)-vx(i-1,j,2)
          b23=vx(i+3,j,2)-vx(i-2,j,2)
          b24=vx(i+4,j,2)-vx(i-3,j,2)
          d11=vx(i,j+1,2)-vx(i,j,2)       !txz---vx/z
          d12=vx(i,j+2,2)-vx(i,j-1,2)
          d13=vx(i,j+3,2)-vx(i,j-2,2)
          d14=vx(i,j+4,2)-vx(i,j-3,2)
          d21=vz(i,j,2)-vz(i-1,j,2)       !txz---vz/x
          d22=vz(i+1,j,2)-vz(i-2,j,2)
          d23=vz(i+2,j,2)-vz(i-3,j,2)
          d24=vz(i+3,j,2)-vz(i-4,j,2)
          e11=vy(i,j+1,2)-vy(i,j,2)  
          e12=vy(i,j+2,2)-vy(i,j-1,2)
          e13=vy(i,j+3,2)-vy(i,j-2,2)
          e14=vy(i,j+4,2)-vy(i,j-3,2)
          e21=vy(i+1,j,2)-vy(i,j,2)  
          e22=vy(i+2,j,2)-vy(i-1,j,2)
          e23=vy(i+3,j,2)-vy(i-2,j,2)
          e24=vy(i+4,j,2)-vy(i-3,j,2)
          f11=vy(i,j,2)-vy(i,j-1,2)  
          f12=vy(i,j+1,2)-vy(i,j-2,2)
          f13=vy(i,j+2,2)-vy(i,j-3,2)
          f14=vy(i,j+3,2)-vy(i,j-4,2)
          f21=vy(i+1,j,2)-vy(i,j,2)  
          f22=vy(i+2,j,2)-vy(i-1,j,2)
          f23=vy(i+3,j,2)-vy(i-2,j,2)
          f24=vy(i+4,j,2)-vy(i-3,j,2)
          txx(i,j,2)=txx(i,j,1)+r1*C(1,1)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+r2*C(1,3)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
                                r2*C(1,4)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)+r1*C(1,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
                                r2*C(1,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+r1*C(1,6)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
          tzz(i,j,2)=tzz(i,j,1)+r1*C(1,3)*(ef1*b21-ef2*b22+ef3*b23-ef4*b24)+r2*C(3,3)*(ef1*b11-ef2*b12+ef3*b13-ef4*b14)+&
                                r2*C(3,4)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)+r1*C(3,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
                                r2*C(3,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+r1*C(3,6)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
          txz(i,j,2)=txz(i,j,1)+r1*C(1,5)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+r2*C(3,5)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
                                r2*C(4,5)*(ef1*f11-ef2*f12+ef3*f13-ef4*f14)+r1*C(5,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
                                r2*C(5,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+r1*C(5,6)*(ef1*f21-ef2*f22+ef3*f23-ef4*f24)
          txy(i,j,2)=txy(i,j,1)+r1*C(1,6)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+r2*C(3,6)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
                                r2*C(4,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)+r1*C(5,6)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
                                r2*C(5,6)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+r1*C(6,6)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
          tyz(i,j,2)=tyz(i,j,1)+r1*C(1,4)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+r2*C(3,4)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
                                r2*C(4,4)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)+r1*C(4,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
                                r2*C(4,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+r1*C(4,6)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
        End Do
      End Do
      
      Do j=1,nz                   !i=1--->-(ml-1), i=ml--->0	  ��߽�
        Do i=4,ml
	        a11=vx(-ml+i+1,j,2)-vx(-ml+i,j,2)     !txx_x����
          a12=vx(-ml+i+2,j,2)-vx(-ml+i-1,j,2)
	        a13=vx(-ml+i+3,j,2)-vx(-ml+i-2,j,2)
	        a14=vx(-ml+i+4,j,2)-vx(-ml+i-3,j,2)
          d11=vz(-ml+i,j,2)-vz(-ml+i-1,j,2)
          d12=vz(-ml+i+1,j,2)-vz(-ml+i-2,j,2)
          d13=vz(-ml+i+2,j,2)-vz(-ml+i-3,j,2)
          d14=vz(-ml+i+3,j,2)-vz(-ml+i-4,j,2)
          e11=vy(-ml+i+1,j,2)-vy(-ml+i,j,2)  
          e12=vy(-ml+i+2,j,2)-vy(-ml+i-1,j,2)
          e13=vy(-ml+i+3,j,2)-vy(-ml+i-2,j,2)
          e14=vy(-ml+i+4,j,2)-vy(-ml+i-3,j,2)
	        s1=r1*C(1,1)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(1,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(1,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(i))*t1xi1(i,j,1)
	        t1xi1(i,j,2)=(s1+s2)*qxd(i)
          
	        a21=vz(-ml+i,j,2)-vz(-ml+i,j-1,2)     !txx_z����
          a22=vz(-ml+i,j+1,2)-vz(-ml+i,j-2,2)
	        a23=vz(-ml+i,j+2,2)-vz(-ml+i,j-3,2)
	        a24=vz(-ml+i,j+3,2)-vz(-ml+i,j-4,2)
          d21=vx(-ml+i,j+1,2)-vx(-ml+i,j,2)
          d22=vx(-ml+i,j+2,2)-vx(-ml+i,j-1,2)
          d23=vx(-ml+i,j+3,2)-vx(-ml+i,j-2,2)
          d24=vx(-ml+i,j+4,2)-vx(-ml+i,j-3,2)
          e21=vy(-ml+i,j+1,2)-vy(-ml+i,j,2)
          e22=vy(-ml+i,j+2,2)-vy(-ml+i,j-1,2)
          e23=vy(-ml+i,j+3,2)-vy(-ml+i,j-2,2)
          e24=vy(-ml+i,j+4,2)-vy(-ml+i,j-3,2)
          s1=r2*C(1,3)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(1,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(1,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=0.0 
	        t1zi1(i,j,2)=t1zi1(i,j,1)+s1+s2
	        txx(-ml+i,j,2)=t1xi1(i,j,2)+t1zi1(i,j,2)
          
	        a11=vx(-ml+i+1,j,2)-vx(-ml+i,j,2)     !tzz_x����
          a12=vx(-ml+i+2,j,2)-vx(-ml+i-1,j,2)
	        a13=vx(-ml+i+3,j,2)-vx(-ml+i-2,j,2)
	        a14=vx(-ml+i+4,j,2)-vx(-ml+i-3,j,2)
          d11=vz(-ml+i,j,2)-vz(-ml+i-1,j,2)
          d12=vz(-ml+i+1,j,2)-vz(-ml+i-2,j,2)
          d13=vz(-ml+i+2,j,2)-vz(-ml+i-3,j,2)
          d14=vz(-ml+i+3,j,2)-vz(-ml+i-4,j,2)
          e11=vy(-ml+i+1,j,2)-vy(-ml+i,j,2)  
          e12=vy(-ml+i+2,j,2)-vy(-ml+i-1,j,2)
          e13=vy(-ml+i+3,j,2)-vy(-ml+i-2,j,2)
          e14=vy(-ml+i+4,j,2)-vy(-ml+i-3,j,2)
	        s1=r1*C(1,3)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(3,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(3,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
          s2=(1.0-0.5*qx(i))*t2xi1(i,j,1)
	        t2xi1(i,j,2)=(s1+s2)*qxd(i)
          
	        a21=vz(-ml+i,j,2)-vz(-ml+i,j-1,2)     !tzz_z����
          a22=vz(-ml+i,j+1,2)-vz(-ml+i,j-2,2)
	        a23=vz(-ml+i,j+2,2)-vz(-ml+i,j-3,2)
	        a24=vz(-ml+i,j+3,2)-vz(-ml+i,j-4,2)
          d21=vx(-ml+i,j+1,2)-vx(-ml+i,j,2)
          d22=vx(-ml+i,j+2,2)-vx(-ml+i,j-1,2)
          d23=vx(-ml+i,j+3,2)-vx(-ml+i,j-2,2)
          d24=vx(-ml+i,j+4,2)-vx(-ml+i,j-3,2)
          e21=vy(-ml+i,j+1,2)-vy(-ml+i,j,2)
          e22=vy(-ml+i,j+2,2)-vy(-ml+i,j-1,2)
          e23=vy(-ml+i,j+3,2)-vy(-ml+i,j-2,2)
          e24=vy(-ml+i,j+4,2)-vy(-ml+i,j-3,2)
	        s1=r2*C(3,3)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(3,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(3,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
          s2=0.0
	        t2zi1(i,j,2)=t2zi1(i,j,1)+s1+s2
	        tzz(-ml+i,j,2)=t2xi1(i,j,2)+t2zi1(i,j,2)
          
          a11=vx(-ml+i+1,j,2)-vx(-ml+i,j,2)     !txz_x����
          a12=vx(-ml+i+2,j,2)-vx(-ml+i-1,j,2)
          a13=vx(-ml+i+3,j,2)-vx(-ml+i-2,j,2)
          a14=vx(-ml+i+4,j,2)-vx(-ml+i-3,j,2)
	        d11=vz(-ml+i,j,2)-vz(-ml+i-1,j,2)
          d12=vz(-ml+i+1,j,2)-vz(-ml+i-2,j,2)
	        d13=vz(-ml+i+2,j,2)-vz(-ml+i-3,j,2)
	        d14=vz(-ml+i+3,j,2)-vz(-ml+i-4,j,2)
          e11=vy(-ml+i+1,j,2)-vy(-ml+i,j,2)  
          e12=vy(-ml+i+2,j,2)-vy(-ml+i-1,j,2)
          e13=vy(-ml+i+3,j,2)-vy(-ml+i-2,j,2)
          e14=vy(-ml+i+4,j,2)-vy(-ml+i-3,j,2)
	        s1=r1*C(1,5)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(5,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(5,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(i))*t3xi1(i,j,1)
	        t3xi1(i,j,2)=(s1+s2)*qxd(i)
	        
          a21=vz(-ml+i,j,2)-vz(-ml+i,j-1,2)     !txz_z����
          a22=vz(-ml+i,j+1,2)-vz(-ml+i,j-2,2)
          a23=vz(-ml+i,j+2,2)-vz(-ml+i,j-3,2)
          a24=vz(-ml+i,j+3,2)-vz(-ml+i,j-4,2)
	        d21=vx(-ml+i,j+1,2)-vx(-ml+i,j,2)
          d22=vx(-ml+i,j+2,2)-vx(-ml+i,j-1,2)
	        d23=vx(-ml+i,j+3,2)-vx(-ml+i,j-2,2)
	        d24=vx(-ml+i,j+4,2)-vx(-ml+i,j-3,2)
          e21=vy(-ml+i,j+1,2)-vy(-ml+i,j,2)
          e22=vy(-ml+i,j+2,2)-vy(-ml+i,j-1,2)
	        e23=vy(-ml+i,j+3,2)-vy(-ml+i,j-2,2)
	        e24=vy(-ml+i,j+4,2)-vy(-ml+i,j-3,2)
	        s1=r2*C(3,5)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(5,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(4,5)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=0.0
	        t3zi1(i,j,2)=t3zi1(i,j,1)+s1+s2
	        txz(-ml+i,j,2)=t3xi1(i,j,2)+t3zi1(i,j,2)

          a11=vx(-ml+i+1,j,2)-vx(-ml+i,j,2)     !txy_x����
          a12=vx(-ml+i+2,j,2)-vx(-ml+i-1,j,2)
	        a13=vx(-ml+i+3,j,2)-vx(-ml+i-2,j,2)
	        a14=vx(-ml+i+4,j,2)-vx(-ml+i-3,j,2)
          d11=vz(-ml+i,j,2)-vz(-ml+i-1,j,2)
          d12=vz(-ml+i+1,j,2)-vz(-ml+i-2,j,2)
          d13=vz(-ml+i+2,j,2)-vz(-ml+i-3,j,2)
          d14=vz(-ml+i+3,j,2)-vz(-ml+i-4,j,2)
          e11=vy(-ml+i+1,j,2)-vy(-ml+i,j,2)  
          e12=vy(-ml+i+2,j,2)-vy(-ml+i-1,j,2)
          e13=vy(-ml+i+3,j,2)-vy(-ml+i-2,j,2)
          e14=vy(-ml+i+4,j,2)-vy(-ml+i-3,j,2)
	        s1=r1*C(1,6)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(5,6)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(6,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(i))*t4xi1(i,j,1)
	        t4xi1(i,j,2)=(s1+s2)*qxd(i)
          
	        a21=vz(-ml+i,j,2)-vz(-ml+i,j-1,2)     !txy_z����
          a22=vz(-ml+i,j+1,2)-vz(-ml+i,j-2,2)
	        a23=vz(-ml+i,j+2,2)-vz(-ml+i,j-3,2)
	        a24=vz(-ml+i,j+3,2)-vz(-ml+i,j-4,2)
          d21=vx(-ml+i,j+1,2)-vx(-ml+i,j,2)
          d22=vx(-ml+i,j+2,2)-vx(-ml+i,j-1,2)
          d23=vx(-ml+i,j+3,2)-vx(-ml+i,j-2,2)
          d24=vx(-ml+i,j+4,2)-vx(-ml+i,j-3,2)
          e21=vy(-ml+i,j+1,2)-vy(-ml+i,j,2)
          e22=vy(-ml+i,j+2,2)-vy(-ml+i,j-1,2)
          e23=vy(-ml+i,j+3,2)-vy(-ml+i,j-2,2)
          e24=vy(-ml+i,j+4,2)-vy(-ml+i,j-3,2)
          s1=r2*C(3,6)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(5,6)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(4,6)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=0.0 
	        t4zi1(i,j,2)=t4zi1(i,j,1)+s1+s2
	        txy(-ml+i,j,2)=t4xi1(i,j,2)+t4zi1(i,j,2)
          
          a11=vx(-ml+i+1,j,2)-vx(-ml+i,j,2)     !tyz_x����
          a12=vx(-ml+i+2,j,2)-vx(-ml+i-1,j,2)
          a13=vx(-ml+i+3,j,2)-vx(-ml+i-2,j,2)
          a14=vx(-ml+i+4,j,2)-vx(-ml+i-3,j,2)
	        d11=vz(-ml+i,j,2)-vz(-ml+i-1,j,2)
          d12=vz(-ml+i+1,j,2)-vz(-ml+i-2,j,2)
	        d13=vz(-ml+i+2,j,2)-vz(-ml+i-3,j,2)
	        d14=vz(-ml+i+3,j,2)-vz(-ml+i-4,j,2)
          e11=vy(-ml+i+1,j,2)-vy(-ml+i,j,2)  
          e12=vy(-ml+i+2,j,2)-vy(-ml+i-1,j,2)
          e13=vy(-ml+i+3,j,2)-vy(-ml+i-2,j,2)
          e14=vy(-ml+i+4,j,2)-vy(-ml+i-3,j,2)
	        s1=r1*C(1,4)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(4,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(4,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(i))*t5xi1(i,j,1)
	        t5xi1(i,j,2)=(s1+s2)*qxd(i)
	        
          a21=vz(-ml+i,j,2)-vz(-ml+i,j-1,2)     !tyz_z����
          a22=vz(-ml+i,j+1,2)-vz(-ml+i,j-2,2)
          a23=vz(-ml+i,j+2,2)-vz(-ml+i,j-3,2)
          a24=vz(-ml+i,j+3,2)-vz(-ml+i,j-4,2)
	        d21=vx(-ml+i,j+1,2)-vx(-ml+i,j,2)
          d22=vx(-ml+i,j+2,2)-vx(-ml+i,j-1,2)
	        d23=vx(-ml+i,j+3,2)-vx(-ml+i,j-2,2)
	        d24=vx(-ml+i,j+4,2)-vx(-ml+i,j-3,2)
          e21=vy(-ml+i,j+1,2)-vy(-ml+i,j,2)
          e22=vy(-ml+i,j+2,2)-vy(-ml+i,j-1,2)
	        e23=vy(-ml+i,j+3,2)-vy(-ml+i,j-2,2)
	        e24=vy(-ml+i,j+4,2)-vy(-ml+i,j-3,2)
	        s1=r2*C(3,4)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(4,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(4,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=0.0
	        t5zi1(i,j,2)=t5zi1(i,j,1)+s1+s2
	        tyz(-ml+i,j,2)=t5xi1(i,j,2)+t5zi1(i,j,2)
        End Do
      End Do
      
      Do j=1,nz
        Do i=1,ml
	        t1xi1(i,j,1)=t1xi1(i,j,2)
	        t1zi1(i,j,1)=t1zi1(i,j,2)
	        t2xi1(i,j,1)=t2xi1(i,j,2)
	        t2zi1(i,j,1)=t2zi1(i,j,2)
	        t3xi1(i,j,1)=t3xi1(i,j,2)
	        t3zi1(i,j,1)=t3zi1(i,j,2)
          t4xi1(i,j,1)=t4xi1(i,j,2)
	        t4zi1(i,j,1)=t4zi1(i,j,2)
	        t5xi1(i,j,1)=t5xi1(i,j,2)
	        t5zi1(i,j,1)=t5zi1(i,j,2)
        End Do
      End Do
      
      nx1=nx+ml+1
      Do j=1,nz                !i=1--->-(ml-1), i=ml--->nx+1 �ұ߽�
        Do i=ml,5,-1
	        a11=vx(nx1-i+1,j,2)-vx(nx1-i,j,2)     !txx_x����
          a12=vx(nx1-i+2,j,2)-vx(nx1-i-1,j,2)
	        a13=vx(nx1-i+3,j,2)-vx(nx1-i-2,j,2)
	        a14=vx(nx1-i+4,j,2)-vx(nx1-i-3,j,2)
          d11=vz(nx1-i,j,2)-vz(nx1-i-1,j,2)
          d12=vz(nx1-i+1,j,2)-vz(nx1-i-2,j,2)
          d13=vz(nx1-i+2,j,2)-vz(nx1-i-3,j,2)
          d14=vz(nx1-i+3,j,2)-vz(nx1-i-4,j,2)
          e11=vy(nx1-i+1,j,2)-vy(nx1-i,j,2)
          e12=vy(nx1-i+2,j,2)-vy(nx1-i-1,j,2)
	        e13=vy(nx1-i+3,j,2)-vy(nx1-i-2,j,2)
	        e14=vy(nx1-i+4,j,2)-vy(nx1-i-3,j,2)
	        s1=r1*C(1,1)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(1,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(1,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(i))*t1xi2(i,j,1)
	        t1xi2(i,j,2)=(s1+s2)*qxd(i)
          
	        a21=vz(nx1-i,j,2)-vz(nx1-i,j-1,2)     !txx_z����
          a22=vz(nx1-i,j+1,2)-vz(nx1-i,j-2,2)
	        a23=vz(nx1-i,j+2,2)-vz(nx1-i,j-3,2)
	        a24=vz(nx1-i,j+3,2)-vz(nx1-i,j-4,2)
          d21=vx(nx1-i,j+1,2)-vx(nx1-i,j,2)
          d22=vx(nx1-i,j+2,2)-vx(nx1-i,j-1,2)
          d23=vx(nx1-i,j+3,2)-vx(nx1-i,j-2,2)
          d24=vx(nx1-i,j+4,2)-vx(nx1-i,j-3,2)
          e21=vy(nx1-i,j+1,2)-vy(nx1-i,j,2)
          e22=vy(nx1-i,j+2,2)-vy(nx1-i,j-1,2)
          e23=vy(nx1-i,j+3,2)-vy(nx1-i,j-2,2)
          e24=vy(nx1-i,j+4,2)-vy(nx1-i,j-3,2)
	        s1=r2*C(1,3)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(1,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(1,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=0.0 
	        t1zi2(i,j,2)=t1zi2(i,j,1)+s1+s2
	        txx(nx1-i,j,2)=t1xi2(i,j,2)+t1zi2(i,j,2)
          
	        a11=vx(nx1-i+1,j,2)-vx(nx1-i,j,2)     !tzz_x����
          a12=vx(nx1-i+2,j,2)-vx(nx1-i-1,j,2)
	        a13=vx(nx1-i+3,j,2)-vx(nx1-i-2,j,2)
	        a14=vx(nx1-i+4,j,2)-vx(nx1-i-3,j,2)
          d11=vz(nx1-i,j,2)-vz(nx1-i-1,j,2)
          d12=vz(nx1-i+1,j,2)-vz(nx1-i-2,j,2)
          d13=vz(nx1-i+2,j,2)-vz(nx1-i-3,j,2)
          d14=vz(nx1-i+3,j,2)-vz(nx1-i-4,j,2)
          e11=vy(nx1-i+1,j,2)-vy(nx1-i,j,2)
          e12=vy(nx1-i+2,j,2)-vy(nx1-i-1,j,2)
	        e13=vy(nx1-i+3,j,2)-vy(nx1-i-2,j,2)
	        e14=vy(nx1-i+4,j,2)-vy(nx1-i-3,j,2)
	        s1=r1*C(1,3)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(3,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(3,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
            s2=(1.0-0.5*qx(i))*t2xi2(i,j,1)
	        t2xi2(i,j,2)=(s1+s2)*qxd(i)
          
	        a21=vz(nx1-i,j,2)-vz(nx1-i,j-1,2)     !tzz_z����
          a22=vz(nx1-i,j+1,2)-vz(nx1-i,j-2,2)
	        a23=vz(nx1-i,j+2,2)-vz(nx1-i,j-3,2)
	        a24=vz(nx1-i,j+3,2)-vz(nx1-i,j-4,2)
          d21=vx(nx1-i,j+1,2)-vx(nx1-i,j,2)
          d22=vx(nx1-i,j+2,2)-vx(nx1-i,j-1,2)
          d23=vx(nx1-i,j+3,2)-vx(nx1-i,j-2,2)
          d24=vx(nx1-i,j+4,2)-vx(nx1-i,j-3,2)
          e21=vy(nx1-i,j+1,2)-vy(nx1-i,j,2)
          e22=vy(nx1-i,j+2,2)-vy(nx1-i,j-1,2)
          e23=vy(nx1-i,j+3,2)-vy(nx1-i,j-2,2)
          e24=vy(nx1-i,j+4,2)-vy(nx1-i,j-3,2)
	        s1=r2*C(3,3)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(3,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(3,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=0.0
	        t2zi2(i,j,2)=t2zi2(i,j,1)+s1+s2
	        tzz(nx1-i,j,2)=t2xi2(i,j,2)+t2zi2(i,j,2)
          
          a11=vx(nx1-i+1,j,2)-vx(nx1-i,j,2)     !txz_x����
          a12=vx(nx1-i+2,j,2)-vx(nx1-i-1,j,2)
          a13=vx(nx1-i+3,j,2)-vx(nx1-i-2,j,2)
          a14=vx(nx1-i+4,j,2)-vx(nx1-i-3,j,2)
	        d11=vz(nx1-i,j,2)-vz(nx1-i-1,j,2)
          d12=vz(nx1-i+1,j,2)-vz(nx1-i-2,j,2)
	        d13=vz(nx1-i+2,j,2)-vz(nx1-i-3,j,2)
	        d14=vz(nx1-i+3,j,2)-vz(nx1-i-4,j,2)
          e11=vy(nx1-i+1,j,2)-vy(nx1-i,j,2)
          e12=vy(nx1-i+2,j,2)-vy(nx1-i-1,j,2)
          e13=vy(nx1-i+3,j,2)-vy(nx1-i-2,j,2)
          e14=vy(nx1-i+4,j,2)-vy(nx1-i-3,j,2)
	        s1=r1*C(1,5)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(5,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(5,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(i))*t3xi2(i,j,1)
	        t3xi2(i,j,2)=(s1+s2)*qxd(i)
	        
          a21=vz(nx1-i,j,2)-vz(nx1-i,j-1,2)     !txz_z����
          a22=vz(nx1-i,j+1,2)-vz(nx1-i,j-2,2)
          a23=vz(nx1-i,j+2,2)-vz(nx1-i,j-3,2)
          a24=vz(nx1-i,j+3,2)-vz(nx1-i,j-4,2)
	        d21=vx(nx1-i,j+1,2)-vx(nx1-i,j,2)
          d22=vx(nx1-i,j+2,2)-vx(nx1-i,j-1,2)
	        d23=vx(nx1-i,j+3,2)-vx(nx1-i,j-2,2)
	        d24=vx(nx1-i,j+4,2)-vx(nx1-i,j-3,2)
          e21=vy(nx1-i,j+1,2)-vy(nx1-i,j,2)
          e22=vy(nx1-i,j+2,2)-vy(nx1-i,j-1,2)
	        e23=vy(nx1-i,j+3,2)-vy(nx1-i,j-2,2)
	        e24=vy(nx1-i,j+4,2)-vy(nx1-i,j-3,2)
	        s1=r2*C(3,5)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(5,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(5,6)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
          s2=0.0
	        t3zi2(i,j,2)=t3zi2(i,j,1)+s1+s2
	        txz(nx1-i,j,2)=t3xi2(i,j,2)+t3zi2(i,j,2)
          
          a11=vx(nx1-i+1,j,2)-vx(nx1-i,j,2)     !txy_x����
          a12=vx(nx1-i+2,j,2)-vx(nx1-i-1,j,2)
	        a13=vx(nx1-i+3,j,2)-vx(nx1-i-2,j,2)
	        a14=vx(nx1-i+4,j,2)-vx(nx1-i-3,j,2)
          d11=vz(nx1-i,j,2)-vz(nx1-i-1,j,2)
          d12=vz(nx1-i+1,j,2)-vz(nx1-i-2,j,2)
          d13=vz(nx1-i+2,j,2)-vz(nx1-i-3,j,2)
          d14=vz(nx1-i+3,j,2)-vz(nx1-i-4,j,2)
          e11=vy(nx1-i+1,j,2)-vy(nx1-i,j,2)
          e12=vy(nx1-i+2,j,2)-vy(nx1-i-1,j,2)
	        e13=vy(nx1-i+3,j,2)-vy(nx1-i-2,j,2)
	        e14=vy(nx1-i+4,j,2)-vy(nx1-i-3,j,2)
	        s1=r1*C(1,6)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(5,6)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(6,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(i))*t4xi2(i,j,1)
	        t4xi2(i,j,2)=(s1+s2)*qxd(i)
          
	        a21=vz(nx1-i,j,2)-vz(nx1-i,j-1,2)     !txy_z����
          a22=vz(nx1-i,j+1,2)-vz(nx1-i,j-2,2)
	        a23=vz(nx1-i,j+2,2)-vz(nx1-i,j-3,2)
	        a24=vz(nx1-i,j+3,2)-vz(nx1-i,j-4,2)
          d21=vx(nx1-i,j+1,2)-vx(nx1-i,j,2)
          d22=vx(nx1-i,j+2,2)-vx(nx1-i,j-1,2)
          d23=vx(nx1-i,j+3,2)-vx(nx1-i,j-2,2)
          d24=vx(nx1-i,j+4,2)-vx(nx1-i,j-3,2)
          e21=vy(nx1-i,j+1,2)-vy(nx1-i,j,2)
          e22=vy(nx1-i,j+2,2)-vy(nx1-i,j-1,2)
          e23=vy(nx1-i,j+3,2)-vy(nx1-i,j-2,2)
          e24=vy(nx1-i,j+4,2)-vy(nx1-i,j-3,2)
	        s1=r2*C(3,6)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(5,6)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(4,6)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=0.0 
	        t4zi2(i,j,2)=t4zi2(i,j,1)+s1+s2
	        txy(nx1-i,j,2)=t4xi2(i,j,2)+t4zi2(i,j,2)
          
          a11=vx(nx1-i+1,j,2)-vx(nx1-i,j,2)     !tyz_x����
          a12=vx(nx1-i+2,j,2)-vx(nx1-i-1,j,2)
          a13=vx(nx1-i+3,j,2)-vx(nx1-i-2,j,2)
          a14=vx(nx1-i+4,j,2)-vx(nx1-i-3,j,2)
	        d11=vz(nx1-i,j,2)-vz(nx1-i-1,j,2)
          d12=vz(nx1-i+1,j,2)-vz(nx1-i-2,j,2)
	        d13=vz(nx1-i+2,j,2)-vz(nx1-i-3,j,2)
	        d14=vz(nx1-i+3,j,2)-vz(nx1-i-4,j,2)
          e11=vy(nx1-i+1,j,2)-vy(nx1-i,j,2)
          e12=vy(nx1-i+2,j,2)-vy(nx1-i-1,j,2)
          e13=vy(nx1-i+3,j,2)-vy(nx1-i-2,j,2)
          e14=vy(nx1-i+4,j,2)-vy(nx1-i-3,j,2)
	        s1=r1*C(1,4)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(4,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(4,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(i))*t5xi2(i,j,1)
	        t5xi2(i,j,2)=(s1+s2)*qxd(i)
	        
          a21=vz(nx1-i,j,2)-vz(nx1-i,j-1,2)     !tyz_z����
          a22=vz(nx1-i,j+1,2)-vz(nx1-i,j-2,2)
          a23=vz(nx1-i,j+2,2)-vz(nx1-i,j-3,2)
          a24=vz(nx1-i,j+3,2)-vz(nx1-i,j-4,2)
	        d21=vx(nx1-i,j+1,2)-vx(nx1-i,j,2)
          d22=vx(nx1-i,j+2,2)-vx(nx1-i,j-1,2)
	        d23=vx(nx1-i,j+3,2)-vx(nx1-i,j-2,2)
	        d24=vx(nx1-i,j+4,2)-vx(nx1-i,j-3,2)
          e21=vy(nx1-i,j+1,2)-vy(nx1-i,j,2)
          e22=vy(nx1-i,j+2,2)-vy(nx1-i,j-1,2)
	        e23=vy(nx1-i,j+3,2)-vy(nx1-i,j-2,2)
	        e24=vy(nx1-i,j+4,2)-vy(nx1-i,j-3,2)
	        s1=r2*C(3,4)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(4,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(4,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=0.0
	        t5zi2(i,j,2)=t5zi2(i,j,1)+s1+s2
	        tyz(nx1-i,j,2)=t5xi2(i,j,2)+t5zi2(i,j,2)
        End Do
      End Do
      
      Do j=1,nz
        Do i=1,ml
	        t1xi2(i,j,1)=t1xi2(i,j,2)
	        t1zi2(i,j,1)=t1zi2(i,j,2)
	        t2xi2(i,j,1)=t2xi2(i,j,2)
	        t2zi2(i,j,1)=t2zi2(i,j,2)
	        t3xi2(i,j,1)=t3xi2(i,j,2)
	        t3zi2(i,j,1)=t3zi2(i,j,2)
          t4xi2(i,j,1)=t4xi2(i,j,2)
	        t4zi2(i,j,1)=t4zi2(i,j,2)
	        t5xi2(i,j,1)=t5xi2(i,j,2)
	        t5zi2(i,j,1)=t5zi2(i,j,2)
        End Do
      End Do
      
      Do j=4,ml                   ! j=ml--->0	  �ϱ߽�
        Do i=-ml+4,nx+ml-4
          k=ml
          if(i.le.0) k=ml+i
          if(i.gt.nx) k=nx+ml-i+1
	        a11=vx(i+1,-ml+j,2)-vx(i,-ml+j,2)     !txx_x����
          a12=vx(i+2,-ml+j,2)-vx(i-1,-ml+j,2)
	        a13=vx(i+3,-ml+j,2)-vx(i-2,-ml+j,2)
	        a14=vx(i+4,-ml+j,2)-vx(i-3,-ml+j,2)
          d11=vz(i,-ml+j,2)-vz(i-1,-ml+j,2)
          d12=vz(i+1,-ml+j,2)-vz(i-2,-ml+j,2)
          d13=vz(i+2,-ml+j,2)-vz(i-3,-ml+j,2)
          d14=vz(i+3,-ml+j,2)-vz(i-4,-ml+j,2)
          e11=vy(i+1,-ml+j,2)-vy(i,-ml+j,2)
          e12=vy(i+2,-ml+j,2)-vy(i-1,-ml+j,2)
	        e13=vy(i+3,-ml+j,2)-vy(i-2,-ml+j,2)
	        e14=vy(i+4,-ml+j,2)-vy(i-3,-ml+j,2)
	        s1=r1*C(1,1)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(1,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(1,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(k))*t1xj1(i,j,1)
	        t1xj1(i,j,2)=(s1+s2)*qxd(k)
          
	        a21=vz(i,-ml+j,2)-vz(i,-ml+j-1,2)     !txx_z����
          a22=vz(i,-ml+j+1,2)-vz(i,-ml+j-2,2)
	        a23=vz(i,-ml+j+2,2)-vz(i,-ml+j-3,2)
	        a24=vz(i,-ml+j+3,2)-vz(i,-ml+j-4,2)
          d21=vx(i,-ml+j+1,2)-vx(i,-ml+j,2)
          d22=vx(i,-ml+j+2,2)-vx(i,-ml+j-1,2)
          d23=vx(i,-ml+j+3,2)-vx(i,-ml+j-2,2)
          d24=vx(i,-ml+j+4,2)-vx(i,-ml+j-3,2)
          e21=vy(i,-ml+j+1,2)-vy(i,-ml+j,2)
          e22=vy(i,-ml+j+2,2)-vy(i,-ml+j-1,2)
          e23=vy(i,-ml+j+3,2)-vy(i,-ml+j-2,2)
          e24=vy(i,-ml+j+4,2)-vy(i,-ml+j-3,2)
          s1=r2*C(1,3)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(1,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(1,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
          s2=(1.0-0.5*qx(j))*t1zj1(i,j,1) 
	        t1zj1(i,j,2)=(s1+s2)*qxd(j)
	        txx(i,-ml+j,2)=t1xj1(i,j,2)+t1zj1(i,j,2)
          
	        a11=vx(i+1,-ml+j,2)-vx(i,-ml+j,2)     !tzz_x����
          a12=vx(i+2,-ml+j,2)-vx(i-1,-ml+j,2)
	        a13=vx(i+3,-ml+j,2)-vx(i-2,-ml+j,2)
	        a14=vx(i+4,-ml+j,2)-vx(i-3,-ml+j,2)
          d11=vz(i,-ml+j,2)-vz(i-1,-ml+j,2)
          d12=vz(i+1,-ml+j,2)-vz(i-2,-ml+j,2)
          d13=vz(i+2,-ml+j,2)-vz(i-3,-ml+j,2)
          d14=vz(i+3,-ml+j,2)-vz(i-4,-ml+j,2)
          e11=vy(i+1,-ml+j,2)-vy(i,-ml+j,2)
          e12=vy(i+2,-ml+j,2)-vy(i-1,-ml+j,2)
	        e13=vy(i+3,-ml+j,2)-vy(i-2,-ml+j,2)
	        e14=vy(i+4,-ml+j,2)-vy(i-3,-ml+j,2)
	        s1=r1*C(1,3)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(3,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(3,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
          s2=(1.0-0.5*qx(k))*t2xj1(i,j,1)
	        t2xj1(i,j,2)=(s1+s2)*qxd(k)
           
	        a21=vz(i,-ml+j,2)-vz(i,-ml+j-1,2)     !tzz_z����
          a22=vz(i,-ml+j+1,2)-vz(i,-ml+j-2,2)
	        a23=vz(i,-ml+j+2,2)-vz(i,-ml+j-3,2)
	        a24=vz(i,-ml+j+3,2)-vz(i,-ml+j-4,2)
          d21=vx(i,-ml+j+1,2)-vx(i,-ml+j,2)
          d22=vx(i,-ml+j+2,2)-vx(i,-ml+j-1,2)
          d23=vx(i,-ml+j+3,2)-vx(i,-ml+j-2,2)
          d24=vx(i,-ml+j+4,2)-vx(i,-ml+j-3,2)
          e21=vy(i,-ml+j+1,2)-vy(i,-ml+j,2)
          e22=vy(i,-ml+j+2,2)-vy(i,-ml+j-1,2)
          e23=vy(i,-ml+j+3,2)-vy(i,-ml+j-2,2)
          e24=vy(i,-ml+j+4,2)-vy(i,-ml+j-3,2)
          s1=r2*C(3,3)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(3,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(3,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
          s2=(1.0-0.5*qx(j))*t2zj1(i,j,1)
          t2zj1(i,j,2)=(s1+s2)*qxd(j)
          tzz(i,-ml+j,2)=t2xj1(i,j,2)+t2zj1(i,j,2)
          
          a11=vx(i+1,-ml+j,2)-vx(i,-ml+j,2)     !txz_x����
          a12=vx(i+2,-ml+j,2)-vx(i-1,-ml+j,2)
          a13=vx(i+3,-ml+j,2)-vx(i-2,-ml+j,2)
          a14=vx(i+4,-ml+j,2)-vx(i-3,-ml+j,2)
	        d11=vz(i,-ml+j,2)-vz(i-1,-ml+j,2)
          d12=vz(i+1,-ml+j,2)-vz(i-2,-ml+j,2)
	        d13=vz(i+2,-ml+j,2)-vz(i-3,-ml+j,2)
	        d14=vz(i+3,-ml+j,2)-vz(i-4,-ml+j,2)
          e11=vy(i+1,-ml+j,2)-vy(i,-ml+j,2)
          e12=vy(i+2,-ml+j,2)-vy(i-1,-ml+j,2)
          e13=vy(i+3,-ml+j,2)-vy(i-2,-ml+j,2)
          e14=vy(i+4,-ml+j,2)-vy(i-3,-ml+j,2)
	        s1=r1*C(1,5)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(5,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(5,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(k))*t3xj1(i,j,1)
	        t3xj1(i,j,2)=(s1+s2)*qxd(k)
	        
          a21=vz(i,-ml+j,2)-vz(i,-ml+j-1,2)     !txz_z����
          a22=vz(i,-ml+j+1,2)-vz(i,-ml+j-2,2)
          a23=vz(i,-ml+j+2,2)-vz(i,-ml+j-3,2)
          a24=vz(i,-ml+j+3,2)-vz(i,-ml+j-4,2)
	        d21=vx(i,-ml+j+1,2)-vx(i,-ml+j,2)
          d22=vx(i,-ml+j+2,2)-vx(i,-ml+j-1,2)
	        d23=vx(i,-ml+j+3,2)-vx(i,-ml+j-2,2)
	        d24=vx(i,-ml+j+4,2)-vx(i,-ml+j-3,2)
          e21=vy(i,-ml+j+1,2)-vy(i,-ml+j,2)
          e22=vy(i,-ml+j+2,2)-vy(i,-ml+j-1,2)
	        e23=vy(i,-ml+j+3,2)-vy(i,-ml+j-2,2)
	        e24=vy(i,-ml+j+4,2)-vy(i,-ml+j-3,2)
	        s1=r2*C(3,5)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(5,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(4,5)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
          s2=(1.0-0.5*qx(j))*t3zj1(i,j,1)
          t3zj1(i,j,2)=(s1+s2)*qxd(j)
          txz(i,-ml+j,2)=t3xj1(i,j,2)+t3zj1(i,j,2)
          
          a11=vx(i+1,-ml+j,2)-vx(i,-ml+j,2)     !txy_x����
          a12=vx(i+2,-ml+j,2)-vx(i-1,-ml+j,2)
	        a13=vx(i+3,-ml+j,2)-vx(i-2,-ml+j,2)
	        a14=vx(i+4,-ml+j,2)-vx(i-3,-ml+j,2)
          d11=vz(i,-ml+j,2)-vz(i-1,-ml+j,2)
          d12=vz(i+1,-ml+j,2)-vz(i-2,-ml+j,2)
          d13=vz(i+2,-ml+j,2)-vz(i-3,-ml+j,2)
          d14=vz(i+3,-ml+j,2)-vz(i-4,-ml+j,2)
          e11=vy(i+1,-ml+j,2)-vy(i,-ml+j,2)
          e12=vy(i+2,-ml+j,2)-vy(i-1,-ml+j,2)
	        e13=vy(i+3,-ml+j,2)-vy(i-2,-ml+j,2)
	        e14=vy(i+4,-ml+j,2)-vy(i-3,-ml+j,2)
	        s1=r1*C(1,6)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(5,6)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(6,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(k))*t4xj1(i,j,1)
	        t4xj1(i,j,2)=(s1+s2)*qxd(k)
          
	        a21=vz(i,-ml+j,2)-vz(i,-ml+j-1,2)     !txy_z����
          a22=vz(i,-ml+j+1,2)-vz(i,-ml+j-2,2)
	        a23=vz(i,-ml+j+2,2)-vz(i,-ml+j-3,2)
	        a24=vz(i,-ml+j+3,2)-vz(i,-ml+j-4,2)
          d21=vx(i,-ml+j+1,2)-vx(i,-ml+j,2)
          d22=vx(i,-ml+j+2,2)-vx(i,-ml+j-1,2)
          d23=vx(i,-ml+j+3,2)-vx(i,-ml+j-2,2)
          d24=vx(i,-ml+j+4,2)-vx(i,-ml+j-3,2)
          e21=vy(i,-ml+j+1,2)-vy(i,-ml+j,2)
          e22=vy(i,-ml+j+2,2)-vy(i,-ml+j-1,2)
          e23=vy(i,-ml+j+3,2)-vy(i,-ml+j-2,2)
          e24=vy(i,-ml+j+4,2)-vy(i,-ml+j-3,2)
          s1=r2*C(3,6)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(5,6)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(4,6)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
          s2=(1.0-0.5*qx(j))*t4zj1(i,j,1) 
	        t4zj1(i,j,2)=(s1+s2)*qxd(j)
	        txy(i,-ml+j,2)=t4xj1(i,j,2)+t4zj1(i,j,2)
          
          a11=vx(i+1,-ml+j,2)-vx(i,-ml+j,2)     !tyz_x����
          a12=vx(i+2,-ml+j,2)-vx(i-1,-ml+j,2)
          a13=vx(i+3,-ml+j,2)-vx(i-2,-ml+j,2)
          a14=vx(i+4,-ml+j,2)-vx(i-3,-ml+j,2)
	        d11=vz(i,-ml+j,2)-vz(i-1,-ml+j,2)
          d12=vz(i+1,-ml+j,2)-vz(i-2,-ml+j,2)
	        d13=vz(i+2,-ml+j,2)-vz(i-3,-ml+j,2)
	        d14=vz(i+3,-ml+j,2)-vz(i-4,-ml+j,2)
          e11=vy(i+1,-ml+j,2)-vy(i,-ml+j,2)
          e12=vy(i+2,-ml+j,2)-vy(i-1,-ml+j,2)
          e13=vy(i+3,-ml+j,2)-vy(i-2,-ml+j,2)
          e14=vy(i+4,-ml+j,2)-vy(i-3,-ml+j,2)
	        s1=r1*C(1,4)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(4,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(4,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(k))*t5xj1(i,j,1)
	        t5xj1(i,j,2)=(s1+s2)*qxd(k)
	        
          a21=vz(i,-ml+j,2)-vz(i,-ml+j-1,2)     !tyz_z����
          a22=vz(i,-ml+j+1,2)-vz(i,-ml+j-2,2)
          a23=vz(i,-ml+j+2,2)-vz(i,-ml+j-3,2)
          a24=vz(i,-ml+j+3,2)-vz(i,-ml+j-4,2)
	        d21=vx(i,-ml+j+1,2)-vx(i,-ml+j,2)
          d22=vx(i,-ml+j+2,2)-vx(i,-ml+j-1,2)
	        d23=vx(i,-ml+j+3,2)-vx(i,-ml+j-2,2)
	        d24=vx(i,-ml+j+4,2)-vx(i,-ml+j-3,2)
          e21=vy(i,-ml+j+1,2)-vy(i,-ml+j,2)
          e22=vy(i,-ml+j+2,2)-vy(i,-ml+j-1,2)
	        e23=vy(i,-ml+j+3,2)-vy(i,-ml+j-2,2)
	        e24=vy(i,-ml+j+4,2)-vy(i,-ml+j-3,2)
	        s1=r2*C(3,4)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(4,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(4,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
          s2=(1.0-0.5*qx(j))*t5zj1(i,j,1)
          t5zj1(i,j,2)=(s1+s2)*qxd(j)
          tyz(i,-ml+j,2)=t5xj1(i,j,2)+t5zj1(i,j,2)
        End Do
      End Do
      
      Do j=1,ml
        Do i=-ml,nx+ml
	        t1xj1(i,j,1)=t1xj1(i,j,2)
	        t1zj1(i,j,1)=t1zj1(i,j,2)
	        t2xj1(i,j,1)=t2xj1(i,j,2)
	        t2zj1(i,j,1)=t2zj1(i,j,2)
	        t3xj1(i,j,1)=t3xj1(i,j,2)
	        t3zj1(i,j,1)=t3zj1(i,j,2)
          t4xj1(i,j,1)=t4xj1(i,j,2)
	        t4zj1(i,j,1)=t4zj1(i,j,2)
	        t5xj1(i,j,1)=t5xj1(i,j,2)
	        t5zj1(i,j,1)=t5zj1(i,j,2)
        End Do
      End Do
      
      nz1=nz+ml+1
      Do j=ml,5,-1                ! j=ml--->nz+1 �±߽�
        Do i=-ml+4,nx+ml-4
	        k=ml
	        if(i.le.0) k=ml+i
	        if(i.gt.nx) k=nx+ml-i+1
	        a11=vx(i+1,nz1-j,2)-vx(i,nz1-j,2)     !txx_x����
          a12=vx(i+2,nz1-j,2)-vx(i-1,nz1-j,2)
          a13=vx(i+3,nz1-j,2)-vx(i-2,nz1-j,2)
	        a14=vx(i+4,nz1-j,2)-vx(i-3,nz1-j,2)
          d11=vz(i,nz1-j,2)-vz(i-1,nz1-j,2)
          d12=vz(i+1,nz1-j,2)-vz(i-2,nz1-j,2)
          d13=vz(i+2,nz1-j,2)-vz(i-3,nz1-j,2)
          d14=vz(i+3,nz1-j,2)-vz(i-4,nz1-j,2)
          e11=vy(i+1,nz1-j,2)-vy(i,nz1-j,2)
          e12=vy(i+2,nz1-j,2)-vy(i-1,nz1-j,2)
	        e13=vy(i+3,nz1-j,2)-vy(i-2,nz1-j,2)
	        e14=vy(i+4,nz1-j,2)-vy(i-3,nz1-j,2)
	        s1=r1*C(1,1)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(1,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(1,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(k))*t1xj2(i,j,1)
	        t1xj2(i,j,2)=(s1+s2)*qxd(k)
         
	        a21=vz(i,nz1-j,2)-vz(i,nz1-j-1,2)     !txx_z����
          a22=vz(i,nz1-j+1,2)-vz(i,nz1-j-2,2)
	        a23=vz(i,nz1-j+2,2)-vz(i,nz1-j-3,2)
	        a24=vz(i,nz1-j+3,2)-vz(i,nz1-j-4,2)
          d21=vx(i,nz1-j+1,2)-vx(i,nz1-j,2)
          d22=vx(i,nz1-j+2,2)-vx(i,nz1-j-1,2)
          d23=vx(i,nz1-j+3,2)-vx(i,nz1-j-2,2)
          d24=vx(i,nz1-j+4,2)-vx(i,nz1-j-3,2)
          e21=vy(i,nz1-j+1,2)-vy(i,nz1-j,2)
          e22=vy(i,nz1-j+2,2)-vy(i,nz1-j-1,2)
          e23=vy(i,nz1-j+3,2)-vy(i,nz1-j-2,2)
          e24=vy(i,nz1-j+4,2)-vy(i,nz1-j-3,2)
	        s1=r2*C(1,3)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(1,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(1,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=(1.0-0.5*qx(j))*t1zj2(i,j,1) 
	        t1zj2(i,j,2)=(s1+s2)*qxd(j)
	        txx(i,nz1-j,2)=t1xj2(i,j,2)+t1zj2(i,j,2)
         
	        a11=vx(i+1,nz1-j,2)-vx(i,nz1-j,2)     !tzz_x����
          a12=vx(i+2,nz1-j,2)-vx(i-1,nz1-j,2)
	        a13=vx(i+3,nz1-j,2)-vx(i-2,nz1-j,2)
	        a14=vx(i+4,nz1-j,2)-vx(i-3,nz1-j,2)
          d11=vz(i,nz1-j,2)-vz(i-1,nz1-j,2)
          d12=vz(i+1,nz1-j,2)-vz(i-2,nz1-j,2)
          d13=vz(i+2,nz1-j,2)-vz(i-3,nz1-j,2)
          d14=vz(i+3,nz1-j,2)-vz(i-4,nz1-j,2)
          e11=vy(i+1,nz1-j,2)-vy(i,nz1-j,2)
          e12=vy(i+2,nz1-j,2)-vy(i-1,nz1-j,2)
	        e13=vy(i+3,nz1-j,2)-vy(i-2,nz1-j,2)
	        e14=vy(i+4,nz1-j,2)-vy(i-3,nz1-j,2)
	        s1=r1*C(1,3)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(3,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(3,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
          s2=(1.0-0.5*qx(k))*t2xj2(i,j,1)
	        t2xj2(i,j,2)=(s1+s2)*qxd(k)
         
	        a21=vz(i,nz1-j,2)-vz(i,nz1-j-1,2)     !tzz_z����
          a22=vz(i,nz1-j+1,2)-vz(i,nz1-j-2,2)
	        a23=vz(i,nz1-j+2,2)-vz(i,nz1-j-3,2)
	        a24=vz(i,nz1-j+3,2)-vz(i,nz1-j-4,2)
          d21=vx(i,nz1-j+1,2)-vx(i,nz1-j,2)
          d22=vx(i,nz1-j+2,2)-vx(i,nz1-j-1,2)
          d23=vx(i,nz1-j+3,2)-vx(i,nz1-j-2,2)
          d24=vx(i,nz1-j+4,2)-vx(i,nz1-j-3,2)
          e21=vy(i,nz1-j+1,2)-vy(i,nz1-j,2)
          e22=vy(i,nz1-j+2,2)-vy(i,nz1-j-1,2)
          e23=vy(i,nz1-j+3,2)-vy(i,nz1-j-2,2)
          e24=vy(i,nz1-j+4,2)-vy(i,nz1-j-3,2)
	        s1=r2*C(3,3)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(3,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(3,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=(1.0-0.5*qx(j))*t2zj2(i,j,1)
	        t2zj2(i,j,2)=(s1+s2)*qxd(j)
	        tzz(i,nz1-j,2)=t2xj2(i,j,2)+t2zj2(i,j,2)
         
          a11=vx(i+1,nz1-j,2)-vx(i,nz1-j,2)     !txz_x����
          a12=vx(i+2,nz1-j,2)-vx(i-1,nz1-j,2)
          a13=vx(i+3,nz1-j,2)-vx(i-2,nz1-j,2)
          a14=vx(i+4,nz1-j,2)-vx(i-3,nz1-j,2)
	        d11=vz(i,nz1-j,2)-vz(i-1,nz1-j,2)
          d12=vz(i+1,nz1-j,2)-vz(i-2,nz1-j,2)
	        d13=vz(i+2,nz1-j,2)-vz(i-3,nz1-j,2)
	        d14=vz(i+3,nz1-j,2)-vz(i-4,nz1-j,2)
          e11=vy(i+1,nz1-j,2)-vy(i,nz1-j,2)
          e12=vy(i+2,nz1-j,2)-vy(i-1,nz1-j,2)
          e13=vy(i+3,nz1-j,2)-vy(i-2,nz1-j,2)
          e14=vy(i+4,nz1-j,2)-vy(i-3,nz1-j,2)
	        s1=r1*C(1,5)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(5,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(5,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(k))*t3xj2(i,j,1)
	        t3xj2(i,j,2)=(s1+s2)*qxd(k)
	       
          a21=vz(i,nz1-j,2)-vz(i,nz1-j-1,2)     !txz_z����
          a22=vz(i,nz1-j+1,2)-vz(i,nz1-j-2,2)
          a23=vz(i,nz1-j+2,2)-vz(i,nz1-j-3,2)
          a24=vz(i,nz1-j+3,2)-vz(i,nz1-j-4,2)
	        d21=vx(i,nz1-j+1,2)-vx(i,nz1-j,2)
          d22=vx(i,nz1-j+2,2)-vx(i,nz1-j-1,2)
	        d23=vx(i,nz1-j+3,2)-vx(i,nz1-j-2,2)
	        d24=vx(i,nz1-j+4,2)-vx(i,nz1-j-3,2)
          e21=vy(i,nz1-j+1,2)-vy(i,nz1-j,2)
          e22=vy(i,nz1-j+2,2)-vy(i,nz1-j-1,2)
	        e23=vy(i,nz1-j+3,2)-vy(i,nz1-j-2,2)
	        e24=vy(i,nz1-j+4,2)-vy(i,nz1-j-3,2)
	        s1=r2*C(3,5)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(5,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(4,5)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=(1.0-0.5*qx(j))*t3zj2(i,j,1)
	        t3zj2(i,j,2)=(s1+s2)*qxd(j)
	        txz(i,nz1-j,2)=t3xj2(i,j,2)+t3zj2(i,j,2)
          
          a11=vx(i+1,nz1-j,2)-vx(i,nz1-j,2)     !txy_x����
          a12=vx(i+2,nz1-j,2)-vx(i-1,nz1-j,2)
	        a13=vx(i+3,nz1-j,2)-vx(i-2,nz1-j,2)
	        a14=vx(i+4,nz1-j,2)-vx(i-3,nz1-j,2)
          d11=vz(i,nz1-j,2)-vz(i-1,nz1-j,2)
          d12=vz(i+1,nz1-j,2)-vz(i-2,nz1-j,2)
          d13=vz(i+2,nz1-j,2)-vz(i-3,nz1-j,2)
          d14=vz(i+3,nz1-j,2)-vz(i-4,nz1-j,2)
          e11=vy(i+1,nz1-j,2)-vy(i,nz1-j,2)
          e12=vy(i+2,nz1-j,2)-vy(i-1,nz1-j,2)
	        e13=vy(i+3,nz1-j,2)-vy(i-2,nz1-j,2)
	        e14=vy(i+4,nz1-j,2)-vy(i-3,nz1-j,2)
	        s1=r1*C(1,6)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(5,6)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(6,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(k))*t4xj2(i,j,1)
	        t4xj2(i,j,2)=(s1+s2)*qxd(k)
          
	        a21=vz(i,nz1-j,2)-vz(i,nz1-j-1,2)     !txy_z����
          a22=vz(i,nz1-j+1,2)-vz(i,nz1-j-2,2)
	        a23=vz(i,nz1-j+2,2)-vz(i,nz1-j-3,2)
	        a24=vz(i,nz1-j+3,2)-vz(i,nz1-j-4,2)
          d21=vx(i,nz1-j+1,2)-vx(i,nz1-j,2)
          d22=vx(i,nz1-j+2,2)-vx(i,nz1-j-1,2)
          d23=vx(i,nz1-j+3,2)-vx(i,nz1-j-2,2)
          d24=vx(i,nz1-j+4,2)-vx(i,nz1-j-3,2)
          e21=vy(i,nz1-j+1,2)-vy(i,nz1-j,2)
          e22=vy(i,nz1-j+2,2)-vy(i,nz1-j-1,2)
          e23=vy(i,nz1-j+3,2)-vy(i,nz1-j-2,2)
          e24=vy(i,nz1-j+4,2)-vy(i,nz1-j-3,2)
	        s1=r2*C(3,6)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(5,6)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(4,6)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=(1.0-0.5*qx(j))*t4zj2(i,j,1) 
	        t4zj2(i,j,2)=(s1+s2)*qxd(j)
	        txy(i,nz1-j,2)=t4xj2(i,j,2)+t4zj2(i,j,2)
          
          a11=vx(i+1,nz1-j,2)-vx(i,nz1-j,2)     !tyz_x����
          a12=vx(i+2,nz1-j,2)-vx(i-1,nz1-j,2)
          a13=vx(i+3,nz1-j,2)-vx(i-2,nz1-j,2)
          a14=vx(i+4,nz1-j,2)-vx(i-3,nz1-j,2)
	        d11=vz(i,nz1-j,2)-vz(i-1,nz1-j,2)
          d12=vz(i+1,nz1-j,2)-vz(i-2,nz1-j,2)
	        d13=vz(i+2,nz1-j,2)-vz(i-3,nz1-j,2)
	        d14=vz(i+3,nz1-j,2)-vz(i-4,nz1-j,2)
          e11=vy(i+1,nz1-j,2)-vy(i,nz1-j,2)
          e12=vy(i+2,nz1-j,2)-vy(i-1,nz1-j,2)
          e13=vy(i+3,nz1-j,2)-vy(i-2,nz1-j,2)
          e14=vy(i+4,nz1-j,2)-vy(i-3,nz1-j,2)
	        s1=r1*C(1,4)*(ef1*a11-ef2*a12+ef3*a13-ef4*a14)+&
             r1*C(4,5)*(ef1*d11-ef2*d12+ef3*d13-ef4*d14)+&
             r1*C(4,6)*(ef1*e11-ef2*e12+ef3*e13-ef4*e14)
	        s2=(1.0-0.5*qx(k))*t5xj2(i,j,1)
	        t5xj2(i,j,2)=(s1+s2)*qxd(k)
	       
          a21=vz(i,nz1-j,2)-vz(i,nz1-j-1,2)     !tyz_z����
          a22=vz(i,nz1-j+1,2)-vz(i,nz1-j-2,2)
          a23=vz(i,nz1-j+2,2)-vz(i,nz1-j-3,2)
          a24=vz(i,nz1-j+3,2)-vz(i,nz1-j-4,2)
	        d21=vx(i,nz1-j+1,2)-vx(i,nz1-j,2)
          d22=vx(i,nz1-j+2,2)-vx(i,nz1-j-1,2)
	        d23=vx(i,nz1-j+3,2)-vx(i,nz1-j-2,2)
	        d24=vx(i,nz1-j+4,2)-vx(i,nz1-j-3,2)
          e21=vy(i,nz1-j+1,2)-vy(i,nz1-j,2)
          e22=vy(i,nz1-j+2,2)-vy(i,nz1-j-1,2)
	        e23=vy(i,nz1-j+3,2)-vy(i,nz1-j-2,2)
	        e24=vy(i,nz1-j+4,2)-vy(i,nz1-j-3,2)
	        s1=r2*C(3,4)*(ef1*a21-ef2*a22+ef3*a23-ef4*a24)+&
             r2*C(4,5)*(ef1*d21-ef2*d22+ef3*d23-ef4*d24)+&
             r2*C(4,4)*(ef1*e21-ef2*e22+ef3*e23-ef4*e24)
	        s2=(1.0-0.5*qx(j))*t5zj2(i,j,1)
	        t5zj2(i,j,2)=(s1+s2)*qxd(j)
	        tyz(i,nz1-j,2)=t5xj2(i,j,2)+t5zj2(i,j,2)
        End Do
      End Do
      
      Do j=1,ml
        Do i=-ml,nx+ml
	        t1xj2(i,j,1)=t1xj2(i,j,2)
	        t1zj2(i,j,1)=t1zj2(i,j,2)
	        t2xj2(i,j,1)=t2xj2(i,j,2)
	        t2zj2(i,j,1)=t2zj2(i,j,2)
	        t3xj2(i,j,1)=t3xj2(i,j,2)
	        t3zj2(i,j,1)=t3zj2(i,j,2)
          t4xj2(i,j,1)=t4xj2(i,j,2)
	        t4zj2(i,j,1)=t4zj2(i,j,2)
	        t5xj2(i,j,1)=t5xj2(i,j,2)
	        t5zj2(i,j,1)=t5zj2(i,j,2)
        End Do
      End Do

      Do j=-ml,nz+ml   
        Do i=-ml,nx+ml 
          txx(i,j,1)=txx(i,j,2)
          tzz(i,j,1)=tzz(i,j,2)
          txz(i,j,1)=txz(i,j,2)
          txy(i,j,1)=txy(i,j,2)
          tyz(i,j,1)=tyz(i,j,2)
        End Do
      End Do 
      
    End If
  End Do
  
  Do i=1,n_file
    Close(i+100)
    Close(i+200)
    Close(i+300)
  End Do
  
  Do i=1,n_file2
    Close(i+400)
    Close(i+500)
    Close(i+600)
  End Do
  
  irecl2=nt*4+240
  head(58)=nt
  head(59)=delt_t*1000000
  
  Open(16,file=outpath//'synthetic_seismic_record_x.sgy',form='binary',access='direct',status='replace',recl=irecl2)
  Open(17,file=outpath//'synthetic_seismic_record_y.sgy',form='binary',access='direct',status='replace',recl=irecl2)
  Open(18,file=outpath//'synthetic_seismic_record_z.sgy',form='binary',access='direct',status='replace',recl=irecl2)
  
  Do i=ig1,ig2
    ii=i-ig1+1
    Write(16,rec=ii) head,(vxt(i,j),j=1,nt)
    Write(17,rec=ii) head,(vyt(i,j),j=1,nt)
    Write(18,rec=ii) head,(vzt(i,j),j=1,nt)
  End Do
  
  Close(16)
  Close(17)
  Close(18)
  
  vx_file='seismogram_x.txt'
  vy_file='seismogram_y.txt'
  vz_file='seismogram_z.txt'
  
  Call grapher_seismograms(n_file2,nt,vx_file,vy_file,vz_file)
  
End Subroutine Wave_Field_Modeling