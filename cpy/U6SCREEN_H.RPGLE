      //‚set new function key
     dScreen_setFK     pr
     d lFKs                            *
     d key                            1a   const
     d fControl                        n   const
     d pFunction                       *   const procptr
     d libel0                        30a   const varying options(*nopass)
     d libel1                        30a   const varying options(*nopass)
     d libel2                        30a   const varying options(*nopass)
      //‚screen need to be refreshed
     d screen_toRefresh...
     d                 pr              n
      //‚get function key entitle
     d screen_getfkentitle...
     d                 pr           123a   varying
     d lFKs                            *   const
      //‚control FK and eventualy perform function tied
     d screen_processFK...
     d                 pr
     d  pgmID                        10a   const
     d  lFKs                           *   const
     d  key                           1a   const
     d  pControl                       *   const procptr
      //‚get function key context
     d screen_getFKcontext...
     d                 pr             1a
     d  lFKs                           *   const
     d  key                           1a   const
      //‚set function key context
     d screen_setFKcontext...
     d                 pr
     d  lFKs                           *   const
     d  key                           1a   const
     d  context                       1a   const
      //‚set new option
     d screen_setOption...
     d                 pr
     d lOptions                        *
     d ID                             2a   const
     d text_                         30a   const varying options(*nopass)
      //‚get options entitle
     d screen_getChoicesEntitle...
     d                 pr           100a   varying
     d lOptions                        *   const
      //‚set sflend
     d screen_setSflend...
     d                 pr
     d  sflEnd                        7a
     d  atEnd                          n   const
