      //‚Ling type
     d tLink           Ds                  qualified
     d  kType                         1a   inz(kLink)
     d  Parent                         *   inz(*null)
     d  First                          *   inz(*null)
     d  Next                           *   inz(*null)
     d  Prev                           *   inz(*null)
     d  level                         3i 0 inz(0)
     d  Item                           *   inz(*null)
     d  Option                        2a   inz('')
     d  flag                          1a   inz(X'00')
      //‚flag definition
     d  fOpen          c                   const(0)
      //‚ToolBox used during tree definition
     d tTreeBox        ds                  qualified
     d   lRoot                         *   inz(*null)
     d   lCur                          *   inz(*null)
     d   pXXX_getItem                  *   procptr
