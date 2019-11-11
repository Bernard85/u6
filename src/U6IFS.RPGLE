     H nomain
     D/copy cpy,u6int_h

     D/copy cpy,u6ibm_h
     D/copy cpy,u6xml_h
     D/copy cpy,u6fmt_h

      //‚------------------------------------------------------------------*
      //‚open ifs for reading
      //‚--------------------------------------------------------------------
     pifs_openForRead...
     p                 b                   export
     Difs_openForRead...
     D                 PI            10i 0
     D path                         255A   varying  const
      *
     D hSTMF           S             10i 0 inz(0)
       hSTMF=open(path:O_rdonly+o_TextData);
       return hSTMF;
     p                 e
      //‚--------------------------------------------------------------------
      //‚position in ifs
      //‚--------------------------------------------------------------------
     pifs_lSeek        b                   export
     D ifs_lSeek       PI            10i 0
     D   hDta                        10I 0 value
     D   offset                      10I 0 value
     D   whence_                     10I 0 value options(*nopass)
      *
     D   whence        s             10I 0 inz(0)
       if %parms()=3;
         whence=whence_;
       endIf;
       return lseek(hDta:offset:whence);
     p                 e
      //‚--------------------------------------------------------------------
      //‚read ifs
      //‚--------------------------------------------------------------------
     pifs_Read         b                   export
     D ifs_Read        PI            10i 0
     D  hstmf                        10i 0 const
     d  pBuffer                        *   const
     d  sBuffer                      10i 0 const
       return Read(HSTMF:pbuffer:sBuffer);
     p                 e
      //‚--------------------------------------------------------------------
      //‚open ifs for writing
      //‚--------------------------------------------------------------------
     pifs_openForWrite...
     p                 b                   export
     Difs_openForWrite...
     D                 PI            10i 0
     D path                         255A   varying  const
      *
     D hSTMF           S             10i 0 inz(0)
       hSTMF=open(path:O_CREAT+O_WRONLY+O_CODEPAGE:
                  S_IWUSR+S_IRUSR+S_IRGRP+S_IROTH:819);
       priofb=Close(hSTMF);
       hSTMF=open(path:O_WRONLY+O_TEXTDATA+O_Trunc);
       return hSTMF;
     P                 E
      //‚--------------------------------------------------------------------
      //‚open ifs for store
      //‚--------------------------------------------------------------------
     pifs_openForStore...
     p                 b                   export
     Difs_openForStore...
     D                 PI            10i 0
     D path                         255A   varying  const
      *
     D hSTMF           S             10i 0 inz(0)
       hSTMF=open(path:O_CREAT+O_WRONLY:
                  S_IWUSR+S_IRUSR+S_IRGRP+S_IROTH);
       priofb=Close(hSTMF);
       hSTMF=open(path:O_WRONLY+           O_Trunc);
       return hSTMF;
     P                 E
      //‚--------------------------------------------------------------------
      //‚close                                                              ----
      //‚--------------------------------------------------------------------
     pifs_close        b                   export
     D                 PI
     D hSTMF                         10i 0          const
       priofb=close(hSTMF);
     P                 E
      //‚--------------------------------------------------------------------
      //‚write 1 row + crlf
      //‚--------------------------------------------------------------------
     pifs_println      B                   export
     Difs_println      PI
     D hSTMF                         10i 0          const
     D buffer_                    65535A   varying  const
      *
     D buffer          S          65535A   varying
       buffer=buffer_+x'0d25';
       priofb=write(hSTMF:%addr(buffer)+2:%len(buffer));
     P                 E
      //‚--------------------------------------------------------------------
      //‚write
      //‚--------------------------------------------------------------------
     pifs_print        B                   export
     Difs_print        PI
     D hSTMF                         10i 0          const
     D buffer_                    65535A   varying  const
      *
     D buffer          S          65535A   varying
       buffer=buffer_;
       priofb=write(hSTMF:%addr(buffer)+2:%len(buffer));
     P                 E
      //‚--------------------------------------------------------------------
      //‚Copy bytes
      //‚--------------------------------------------------------------------
     pifs_memCpy       b                   export
     D ifs_memCpy      Pi
     D   target                        *   Value
     D   source                        *   Value
     D   length                      10U 0 Value
       memCpy(target:source:length);
     P                 E
      //‚--------------------------------------------------------------------
      //‚memory changed ?
      //‚--------------------------------------------------------------------
     pifs_memchg       b                   export
     D ifs_memchg      Pi              n
     D   adr1                          *   Value
     D   adr2                          *   Value
     D   length                      10U 0 Value
       return memCmp(adr1:adr2:length)<>0;
     P                 E
      //‚--------------------------------------------------------------------
      //‚Test a bit
      //‚--------------------------------------------------------------------
     pifs_testBit      b                   export
     D ifs_testBit     Pi              n
     D   str                           *   Value
     D   offset                      10u 0 Value
       return tstbts(str:offset)<>0;
     P                 E
      //‚--------------------------------------------------------------------
      //‚Set a bit
      //‚--------------------------------------------------------------------
     pifs_setbit       b                   export
     D ifs_setbit      Pi
     D   str                           *   Value
     D   offset                      10u 0 Value
     D   status                        N   const
       if status;
         setbts(str:offset);
       else;
         clrbts(str:offset);
       endIf;
     P                 E
      //‚--------------------------------------------------------------------
      //‚Browse files in a folder
      //‚--------------------------------------------------------------------
     pifs_browseFiles...
     p                 b                   export
     d ifs_browseFiles...
     d                 pi
     d  path                           *   const options(*string)
     d  pProcFile                      *   const procptr
      *
     d pDir            s               *
     D dirEnt          ds                  likeDs(tDirEnt) based(pDirEnt)
     D statDs          ds                  likeDs(tStatDS)
     d wPath           s            255a   varying
      *
     d procFile        pr                  extproc(pProcFile)
     d  wPAth                       255a   const varying
       //‚Open and read folder
       pDir=OpenDir(path);
       dow pDir<>*null;
         pDirEnt=readDir(pDir);
         if pDirEnt=*null;
           leave;
         endIf;
         //
         if DirEnt.Name='.' or DirEnt.Name='..' or DirEnt.Name='';
           iter;
         endif;
         //
         wPath=%str(path)+DirEnt.Name;
         stat(wPath:statds);
         if statds.objtype='*STMF';
           procFile(DirEnt.Name);
         endIf;
       endDo;
       CloseDir(pDir);
     p                 e
      //‚--------------------------------------------------------------------
      //‚get file extension
      //‚--------------------------------------------------------------------
     pifs_getFileExtension...
     p                 b                   export
     d ifs_getFileExtension...
     d                 pi            10a   varying
     d  path                        255a   const varying
      *
     d p               s              3u 0
       p=int_scanR('.':path);
       if p=0 or p=%len(path);
         return '';
       endIf;
       return %subst(path:p+1);
     p                 e
