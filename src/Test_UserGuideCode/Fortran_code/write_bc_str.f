      program write_bc_str
      use cgns
c
c   Opens an existing CGNS file that contains a simple 3-D 
c   structured grid, and adds BC definitions (defined
c   over a range of points = PointRange)
c
c   The CGNS grid file 'grid.cgns' must already exist
c   (created using write_grid_str.f).  Note: whether the 
c   existing CGNS file has a flow solution in it already or
c   not is irrelevant.
c
c   This program uses the fortran convention that all
c   variables beginning with the letters i-n are integers,
c   by default, and all others are real
c
c   Example compilation for this program is (change paths if needed!):
c   Note: when using the cgns module file, you must use the SAME fortran compiler 
c   used to compile CGNS (see make.defs file)
c   ...or change, for example, via environment "setenv FC ifort"
c
c   ifort -I ../.. -c write_bc_str.f
c   ifort -o write_bc_str write_bc_str.o -L ../../lib -lcgns
c
c   (../../lib is the location where the compiled
c   library libcgns.a is located)
c
c   The following is no longer supported; now superceded by "use cgns":
c     include 'cgnslib_f.h'
c   Note Windows machines need to include cgnswin_f.h
c
      integer(cgsize_t) isize(3,3),ipnts(3,2)
      character zonename*32
c
      write(6,'('' Program write_bc_str'')')
      if (CG_BUILD_64BIT) then
        write(6,'('' ...using 64-bit mode for particular integers'')')
      end if
c
c  WRITE BOUNDARY CONDITIONS TO EXISTING CGNS FILE
c  open CGNS file for modify
      call cg_open_f('grid.cgns',CG_MODE_MODIFY,index_file,ier)
      if (ier .ne. CG_OK) call cg_error_exit_f
c  we know there is only one base (real working code would check!)
      index_base=1
c  we know there is only one zone (real working code would check!)
      index_zone=1
c   get zone size (and name - although not needed here)
      call cg_zone_read_f(index_file,index_base,index_zone,zonename,
     + isize,ier)
      write(6,'('' zonename='',a32)') zonename
      ilo=1
      ihi=isize(1,1)
      jlo=1
      jhi=isize(2,1)
      klo=1
      khi=isize(3,1)
c  write boundary conditions for ilo face, defining range first
c  (user can give any name)
c  lower point of range
      ipnts(1,1)=ilo
      ipnts(2,1)=jlo
      ipnts(3,1)=klo
c  upper point of range
      ipnts(1,2)=ilo
      ipnts(2,2)=jhi
      ipnts(3,2)=khi
      call cg_boco_write_f(index_file,index_base,index_zone,'Ilo',
     + BCTunnelInflow,PointRange,2_cgsize_t,ipnts,index_bc,ier)
c  write boundary conditions for ihi face, defining range first
c  (user can give any name)
c  lower point of range
      ipnts(1,1)=ihi
      ipnts(2,1)=jlo
      ipnts(3,1)=klo
c  upper point of range
      ipnts(1,2)=ihi
      ipnts(2,2)=jhi
      ipnts(3,2)=khi
      call cg_boco_write_f(index_file,index_base,index_zone,'Ihi',
     + BCExtrapolate,PointRange,2_cgsize_t,ipnts,index_bc,ier)
c  write boundary conditions for jlo face, defining range first
c  (user can give any name)
c  lower point of range
      ipnts(1,1)=ilo
      ipnts(2,1)=jlo
      ipnts(3,1)=klo
c  upper point of range
      ipnts(1,2)=ihi
      ipnts(2,2)=jlo
      ipnts(3,2)=khi
      call cg_boco_write_f(index_file,index_base,index_zone,'Jlo',
     + BCWallInviscid,PointRange,2_cgsize_t,ipnts,index_bc,ier)
c  write boundary conditions for jhi face, defining range first
c  (user can give any name)
c  lower point of range
      ipnts(1,1)=ilo
      ipnts(2,1)=jhi
      ipnts(3,1)=klo
c  upper point of range
      ipnts(1,2)=ihi
      ipnts(2,2)=jhi
      ipnts(3,2)=khi
      call cg_boco_write_f(index_file,index_base,index_zone,'Jhi',
     + BCWallInviscid,PointRange,2_cgsize_t,ipnts,index_bc,ier)
c  write boundary conditions for klo face, defining range first
c  (user can give any name)
c  lower point of range
      ipnts(1,1)=ilo
      ipnts(2,1)=jlo
      ipnts(3,1)=klo
c  upper point of range
      ipnts(1,2)=ihi
      ipnts(2,2)=jhi
      ipnts(3,2)=klo
      call cg_boco_write_f(index_file,index_base,index_zone,'Klo',
     + BCWallInviscid,PointRange,2_cgsize_t,ipnts,index_bc,ier)
c  write boundary conditions for khi face, defining range first
c  (user can give any name)
c  lower point of range
      ipnts(1,1)=ilo
      ipnts(2,1)=jlo
      ipnts(3,1)=khi
c  upper point of range
      ipnts(1,2)=ihi
      ipnts(2,2)=jhi
      ipnts(3,2)=khi
      call cg_boco_write_f(index_file,index_base,index_zone,'Khi',
     + BCWallInviscid,PointRange,2_cgsize_t,ipnts,index_bc,ier)
c  close CGNS file
      call cg_close_f(index_file,ier)
      write(6,'('' Successfully added BCs (PointRange) to file'',
     +  '' grid.cgns'')')
      stop
      end