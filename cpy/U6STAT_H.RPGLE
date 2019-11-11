      //‚Statistic family
     d kStats          c                   const('S')
     d kStat           c                   const('s')
     d kModel          c                   const('m')
      *
     d tStats          ds                  qualified
     d  kind                          1    inz(kStats)
     d tStat           ds                  qualified
     d  kind                          1    inz(kStat)
     d  ID                           10    varying
     d  text                         50    varying
     d  formula                      50    varying
     d  lFormula                       *
     d  lModels                        *
     d tModel          ds                  qualified
     d  kind                          1    inz(kModel)
     d  ID                           50    varying
     d  statID                       10    varying
     d  count                         5u 0 inz(0)
     d  text                         50    varying
      //‚get item for STAT family for Xml parser
     d stat_XmlInput...
     d                 pr              *
     d   ND                                const likeDs(xml_nodeDefine)
