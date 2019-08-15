      //‚FORM family
     d kForm           c                   const('f')
     d kPanel          c                   const('p')
     d kLabel          c                   const('l')
      //‚form
     d tForm           ds                  qualified
     d  kind                          1    inz(kForm)
     d  ID                           10    varying
     d  text                        128    varying
      //‚panel
     d tPanel          ds                  qualified
     d  kind                          1    inz(kPanel)
     d  text                        128    varying
      //‚label
     d tLabel          ds                  qualified
     d  kind                          1    inz(kLabel)
     d  text                         50    varying
     d  formula                      50    varying
     d  lFormula                       *
     d  maxWidth                      5u 0
     d  input                          n   inz(*off)
      //‚get item form JOURNAL family
     dform_XMLinput...
     d                 pr              *
     d   ND                                const likeDs(xml_nodeDefine)
      //‚set item for FORM family
     dform_XMLoutput   pr                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      //‚get form from list
     dform_getForm     pr              *
     d  lForms                         *
     d  formID                       10a   const varying
