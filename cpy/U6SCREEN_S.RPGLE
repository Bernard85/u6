      //‚Action
     d kAction         c                   const('a')
     d tAction         ds                  qualified
     d  kItem                         1a   inz(kAction)
     d  id                            1a   varying
     d  fControl                       n
     d  pProc                          *   procptr
     d  text                         30a   varying
      //‚Option
     d kOption         c                   const('o')
     d tOption         ds                  qualified
     d  kItem                         1a   inz(kOption)
     d  id                            2a   varying
     d  pValProc                       *   procptr
     d  pChkProc                       *   procptr
     d  text                         30a   varying
