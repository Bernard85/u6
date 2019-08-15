      /copy cpy,u6ds_h
      //‚------------------------------------------------------------------*
      //‚Command-related
      //‚-------------------------------------------------------------------
      //‚Command execute
     dqcmdexc          pr                  extpgm('QCMDEXC')
     d  cmd                        1024a   const
     d  cmdLen                       15p 5 const
      //‚-------------------------------------------------------------------
      //‚Memory related
      //‚-------------------------------------------------------------------
      //‚Copy bytes
     D memcpy          PR                  ExtProc('__memcpy')
     D   target                        *   Value
     D   source                        *   Value
     D   length                      10U 0 Value
      //‚Compare bytes
     D memcmp          PR            10i 0 ExtProc('__memcmp')
     D   adr1                          *   Value
     D   adr2                          *   Value
     D   length                      10U 0 Value
      //‚test a bit
     D tstbts          Pr            10i 0 ExtProc('tstbts')
     D  str                            *   Value
     D  offset                       10u 0 Value
      //‚Clear Bit in String
     d clrbts          pr                  extproc('_CLRBTS')
     d  str                            *   value
     d  offset                       10u 0 value
      //‚Set Bit in String
     d setbts          pr                  extproc('_SETBTS')
     d  str                            *   value
     d  offset                       10u 0 value
      //‚-------------------------------------------------------------------
      //‚ Integrated File System API
      //‚-------------------------------------------------------------------
      //‚Open file
     D open            PR            10I 0 extproc('open')
     D  path                           *   value options(*string)
     D  oflag                        10I 0 value
     D  mode                         10U 0 value options(*nopass)
     D  codepage                     10U 0 value options(*nopass)
      //‚owner authority
     D S_IRUSR         C                   256
     D S_IWUSR         C                   128
     D S_IXUSR         C                   64
      //‚group authority
     D S_IRGRP         C                   32
     D S_IWGRP         C                   16
     D S_IXGRP         C                   8
      //‚other people
     D S_IROTH         C                   4
     D S_IWOTH         C                   2
     D S_IXOTH         C                   1
      //‚Flags for use in open()
     D O_RDONLY        C                   1
     D O_WRONLY        C                   2
     D O_RDWR          C                   4
     D O_CREAT         C                   8
     D O_EXCL          C                   16
     D O_TRUNC         C                   64
     D O_APPEND        C                   256
     D O_CODEPAGE      C                   8388608
     D O_TEXTDATA      C                   16777216
     D O_CCSID         C                   32
      //‚positon
     D lseek           PR            10I 0 ExtProc('lseek')
     D   handle                      10I 0 value
     D   offset                      10I 0 value
     D   whence                      10I 0 value
      //‚Read IFS
     D read            PR            10I 0 extproc('read')
     D                               10I 0 value
     D                                 *   value
     D                               10U 0 value
      //‚Write file
     D write           PR            10I 0 extproc('write')
     D                               10I 0 value
     D                                 *   value
     D                               10U 0 value
      //‚close file
     D close           PR            10I 0 extproc('close')
     D                               10I 0 value
      //‚-------------------------------------------------------------------
      //‚ process directory
      //‚-------------------------------------------------------------------
      //‚directory entry
     D tDirEnt         ds                  qualified template
     D  reserv1                      16A
     D  fileno_gen_id                10U 0
     D  fileno                       10U 0
     D  reclen                       10U 0
     D  reserv3                      10I 0
     D  reserv4                       8A
     D  nlsinfo                      12A
     D   nls_ccsid                   10I 0 OVERLAY(nlsinfo:1)
     D   nls_cntry                    2A   OVERLAY(nlsinfo:5)
     D   nls_lang                     3A   OVERLAY(nlsinfo:7)
     D***amelen                      10U 0
     d  w2                            2a
     D  name                        640A   varying
      //‚open directory
     D opendir         PR              *   EXTPROC('opendir')
     D  dirname                        *   VALUE options(*string)
      //‚read directory
     D readdir         PR              *   EXTPROC('readdir')
     D  dirp                           *   VALUE
      //‚close directory
     D closedir        PR            10I 0 EXTPROC('closedir')
     D  dirp                           *   VALUE
      //‚Stat on a read item
     D stat            PR            10I 0 ExtProc('stat')
     D   path                          *   value options(*string)
     D   buf                               likeds(tStat)
      //‚bounded to stat proc
     D tStat           DS                  qualified template
     D  mode                         10U 0
     D  ino                          10U 0
     D  nlink                         5U 0
     D  reserved2                     5U 0
     D  uid                          10U 0
     D  gid                          10U 0
     D  size                         10I 0
     D  atime                        10I 0
     D  mtime                        10I 0
     D  ctime                        10I 0
     D  dev                          10U 0
     D  blksize                      10U 0
     D  allocsize                    10U 0
     D  objtype                      10A
     D  reserved3                     2A
     D  codepage                      5U 0
     D  ccsid                         5U 0
     D  rdev                         10U 0
     D  nlink32                      10U 0
     D  rdev64                       20U 0
     D  dev64                        20U 0
     D  reserved1                    36A
     D  ino_gen_id                   10U 0
      *
     d  priofb         s             10u 0
      //‚-------------------------------------------------------------------
      //‚Message
      //‚-------------------------------------------------------------------
      //‚Remove program message
     d qmhrmvpm        pr                  extpgm('QMHRMVPM')
     d                              276      const
     d                                9b 0   const
     d                                4      const
     d                               10      const
     d   apiErr                              like(tApiErr)
      //‚Send program message
     d qmhsndpm        PR                  extpgm('QMHSNDPM')
     d                                7    const
     d                               20    const
     d                            32767a   Const Options(*Varsize)
     d                                9b 0 const
     d                               10    const
     d                               10    const
     d                                9b 0 const
     d                                4    const
     d   apiErr                            like(tApiErr)
      //‚Send message
     D QMHSNDM         PR                  ExtPgm('QMHSNDM')
     D  MsgID                         7A   const
     D  QualMsgF                     20A   const
     D  MsgTxt                    32767A   const options(*varsize)
     D  MsgTxtLen                    10I 0 const
     D  MsgType                      10A   const
     D  MsgQueues                    20A   const dim(50) options(*varsize)
     D  NumQueues                    10I 0 const
     D  RpyQueue                     20A   const
     D  MsgKey                        4A
     d  apiErr                             like(tApiErr)
     D  CCSID                        10I 0 const options(*nopass)
      //‚-------------------------------------------------------------------
      //‚user space
      //‚-------------------------------------------------------------------
      //‚Create user space:
     D QUSCRTUS        Pr                  ExtPgm('QUSCRTUS')
     D                               20a   Const
     D                               10a   Const
     D                               10i 0 Const
     D                                1a   Const
     D                               10a   Const
     D                               50a   Const
     D                               10a   Const Options(*NoPass)
     D                            32767a         Options(*NoPass:*Varsize)
      //‚get pointer on user space
     D QUSPTRUS        PR                  ExtPgm('QUSPTRUS')
     D   UsrSpc                      20A   CONST
     D   Pointer                       *
      //‚delete user space
     D QUSDLTUS        Pr                  ExtPgm('QUSDLTUS')
     D                               20a   Const
     D                            32767a   Options(*VarSize)
      //‚-------------------------------------------------------------------
      //‚object + file description
      //‚-------------------------------------------------------------------
      //‚Retrieve object description
     D QUSROBJD_       Pr                  ExtPgm('QUSROBJD')
     D  RcvVar                    32767a         Options(*VarSize)
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
     D  Err                       32767a         Options(*VarSize)
      //‚list field description
     D quslfld_        Pr                  ExtPgm('QUSLFLD')
     D  SpcNamQ                      20a   Const
     D  FmtNam                        8a   Const
     D  FilNamQual                   20a   Const
     D  RcdFmtNam                    10a   Const
     D  OvrPrc                        1a   Const
     d  err                       32767a    Options(*NoPass:*Varsize)
      //‚-------------------------------------------------------------------
      //‚Dtaara proces
      //‚-------------------------------------------------------------------
      //‚Retrieve dtaara
     d qxxrtvda        pr                  extpgm('QXXRTVDA')
     d  dtaaraid                     20    const
     d  p                            10i 0 const
     d  l                            10i 0 const
     d  w2000                      2000a
      //‚change dtaara
     d qxxchgda        pr                  extpgm('QXXCHGDA')
     d  dtaaraid                     20    const
     d  p                            10i 0 const
     d  l                            10i 0 const
     d  w2000                      2000a
      //‚-------------------------------------------------------------------
      //‚Date manage
      //‚-------------------------------------------------------------------
     D Qwccvtdt        PR                  extpgm('QWCCVTDT')
     D                               10a   const
     D                                8a
     D                               10a   const
     D                               16a
     D b                                   like(ApiErr)
