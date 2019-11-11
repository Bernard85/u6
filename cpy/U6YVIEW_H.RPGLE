      //˜View
     d kYView          c                   const('y')
     d tYView          ds                  qualified
     d  kind                          1a   inz(kYView)
     d  ID                           10a   varying
     d  lFmt                           *
     d  lForm                          *
     d  armTop                             likeds(tArm)
     d  armBot                             likeds(tArm)

     d tArm            ds                  qualified
     d  lVariant                       *   inz(*null)
     d  segment                       5u 0 inz(0)
     d  most                           n   inz(*off)
      //‚get vertical View
     d yview_getYView  pr              *
     d  lYViews                        *
     d  lForms                         *
     d  lFmts                          *
     d  ID                           10a   const varying
     d  fAppli                        1a   const options(*nopass)
