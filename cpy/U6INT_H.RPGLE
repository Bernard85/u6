      //�Error                                                              --
     dkErr             c                    const('e')
     dtErr             ds                  qualified
     d kind                           1a   inz(kErr)
     d pStr                            *   inz(*null)
      //�constante                                                          --
     dkCst             c                    const('c')
     dtCst             ds                  qualified
     d kind                           1a   inz(kCst)
     d pStr                            *   inz(*null)
      //�procedure                                                          --
     dkProc            c                    const('p')
     dtProc            ds                  qualified
     d kind                           1a   inz(kProc)
     d ID                            25a   varying
     d pAddr                           *   procptr
      //�set of characters
     d min             c                   const('abcdefghijklmnopqrstuvwxyz')
     d maj             c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     d num             c                   const('0123456789')
     d spec            c                   const('$%_#')
      //�Populate string with variables
     d int_replaceAll...
     d                 pr           255a   varying
     d source                       255a   const varying
     d v1                           255a   const varying options(*nopass)
     d v2                           255a   const varying options(*nopass)
     d v3                           255a   const varying options(*nopass)
     d v4                           255a   const varying options(*nopass)
     d v5                           255a   const varying options(*nopass)
     d v6                           255a   const varying options(*nopass)
     d v7                           255a   const varying options(*nopass)
     d v8                           255a   const varying options(*nopass)
      //�get string from field
     d int_getpStrFromField...
     d                 pr              *
     d  lField                         *   const
     d  pBuffer                        *   const
     d  owned                          n
     d  length                        5u 0
      //� Alloc string
     dint_allocString  pr              *
     d  String                     2048a   const varying
     d  owned                          n
     d  len                           5u 0
      //�edit numeric
     d int_editNumeric...
     d                 pr            32a   varying
     d  pBuffer                        *   const
     d  field                              const likeDs(tField)
      //�edit integer
     d int_editInteger...
     d                 pr            32a   varying
     d  pBuffer                        *   const
     d  field                              const likeDs(tField)
      //�get minus of 2 values
     d int_getMin      pr             5u 0
     d  v1                            5u 0 const
     d  v2                            5u 0 const
      //�Complete with space/dot at left
     d int_AddSpaceDot...
     d                 pr           255a   varying
     d  source                      255a   const varying
     d  lastPos                       3u 0 const
      //�Scan from Right
     D int_ScanR       pr             3u 0
     D  charFound                    10A   const varying
     D  String                      255A   const varying
     d  fromPos_                      3u 0 const options(*nopass)
      //�get string from formula
     d int_getStringFromFormula...
     d                 pr         32000a   varying
     d  pBuffer_                       *   const
     d  pField_                        *   const
      //�get string from formula
     d int_getStringFromFormula2...
     d                 pr         32000a   varying
     d  lFormula                       *   const
     d  curBuffer                     3u 0 const options(*nopass)
      //�load procedures
     dint_LoadProcs    pr
      //�pre-load the formula
     d int_loadFormula...
     d                 pr              *
     d  formula                    1000a   varying const
     d  lRep                           *   const
      //�get string from argument
     d int_getStringFromArg...
     d                 pr         32000a   varying
     d  lArg                           *   const
     d  curBuffer                     3u 0 const options(*nopass)