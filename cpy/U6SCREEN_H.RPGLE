      //‚set new action
     dScreen_setAction...
     d                 pr
     d lActions                        *
     d ID                             1a   const
     d fControl                        n   const
     d pProc                           *   const procptr
     d text_                         30a   const varying options(*nopass)
      //‚get function key entitle
     d screen_getfkentitle...
     d                 pr           100a   varying
     d lActions                        *   const
      //‚get action from key pressed
     d screen_getActionfromkey...
     d                 pr              *   procptr
     d  lActions                       *   const
     d   kp                           1a   const
     d   fControl                     1n
      //‚set new option
     d screen_setOption...
     d                 pr
     d lOptions                        *
     d ID                             2a   const
     d pChkProc                        *   const procptr
     d pValProc                        *   const procptr
     d text_                         30a   const varying options(*nopass)
      //‚get options entitle
     d screen_getChoicesEntitle...
     d                 pr           100a   varying
     d lOptions                        *   const
      //‚get option from choice
     dScreen_GetOptionfromChoice...
     d                 pr              *
     d  lOptions                       *   const
     d  mychoice                      2a   const
      //‚get check procedure from option
     dScreen_GetCheckProcFromOption...
     d                 pr              *   procptr
     d  pOption                        *   const
      //‚get validation procedure from option
     dScreen_GetValidationProcFromOption...
     d                 pr              *   procptr
     d  pOption                        *   const
      //‚set sflend
     d screen_setSflend...
     d                 pr
     d  sflEnd                        7a
     d  atEnd                          n   const
      //‚control FK and eventualy perform action tied
     d screen_processFK...
     d                 pr
     d  pgmID                        10a   const
     d  lActions                       *   const
     d  FK                            1a   const
     d  pControl                       *   const procptr
