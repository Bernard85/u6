      //‚flag to indicate the screen need to refreshed
     dscreen_FlagToRefresh...
     d                 s               n
      //‚function key
     d kFK             c                   const('k')
     d tFK             ds                  qualified
     d  kItem                         1a   inz(kFK)
     d  key                           1a   varying
     d  fControl                       n
     d  pFunction                      *   procptr
      //‚function key context
     d kFKC            c                   const('c')
     d tFKC            ds                  qualified
     d  kItem                         1a   inz(kFKC)
     d  NO                            3u 0
     d  libel                        30a   varying
      //‚Option
     d kOption         c                   const('o')
     d tOption         ds                  qualified
     d  kItem                         1a   inz(kOption)
     d  id                            2a   varying
     d  pValProc                       *   procptr
     d  pChkProc                       *   procptr
     d  text                         30a   varying
