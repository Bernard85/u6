      //‚open ifs for reading
     Difs_openForRead...
     D                 Pr            10i 0
     D path                         255A   varying  const
      //‚position in stmf
     D ifs_lSeek       Pr            10i 0
     D   hDta                        10I 0 value
     D   offset                      10I 0 value
     D   whence_                     10I 0 value options(*nopass)
      //‚read ifs
     D ifs_Read        Pr            10i 0
     D  hstmf                        10i 0 const
     d  pBuffer                        *   const
     d  sBuffer                      10i 0 const
      //‚open ifs for writing
     Difs_openForwrite...
     D                 PR            10i 0
     D path                         255A   const varying
      //‚ open ifs for storing
     Difs_openForStore...
     D                 PR            10i 0
     D path                         255A   varying const
      //‚Close IFS
     Difs_close        PR
     D hSTMF                         10i 0 const
      //‚Write one line
     Difs_println      Pr
     D hSTMF                         10i 0 const
     D buffer                     65535A   const varying
      //‚Write String
     Difs_print        Pr
     D hSTMF                         10i 0 const
     D buffer                     65535A   const varying
      //‚Copy bytes
     D ifs_memCpy      Pr
     D   target                        *   Value
     D   source                        *   Value
     D   length                      10U 0 Value
      //‚memory changed
     D ifs_memchg      Pr              n
     D   adr1                          *   Value
     D   adr2                          *   Value
     D   length                      10U 0 Value
      //‚Test a bit
     D ifs_testBit     Pr              n
     D   str                           *   Value
     D   offset                      10u 0 Value
      //‚Set a bit
     D ifs_setbit      Pr
     D   str                           *   Value
     D   offset                      10u 0 Value
     D   status                        N   const
      //‚Browse files in a folder
     d ifs_browseFiles...
     d                 pr
     d  path                           *   const options(*string)
     d  pProcFile                      *   const procptr
      //‚get file extension
     d ifs_getFileExtension...
     d                 pr            10a   varying
     d  path                        255a   const varying
