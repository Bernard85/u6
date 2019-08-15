      //‚Journal entry family
     d kJrnEnCt        c                   const('E')
     d kJeCode         c                   const('c')
     d kJeType         c                   const('t')
      *
     d tJrnEnCt        ds                  qualified
     d  kind                          1    inz(kJrnEnCt)
     d  text                         50    varying
     d tJeCode         ds                  qualified
     d  kind                          1    inz(kJeCode)
     d  ID                            1    varying
     d  text                         50    varying
     d tJeType         ds                  qualified
     d  kind                          1    inz(kJeType)
     d  ID                            2    varying
     d  formatID                     10    varying
     d  text                         50    varying
      //‚get item form JOURNAL ENTRY code/type  family
     denct_XMLinput...
     d                 pr              *
     d   ND                                const likeDs(xml_nodeDefine)
