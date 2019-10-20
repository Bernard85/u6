      //˜View
     d kXView          c                   const('v')
     d tXView          ds                  qualified
     d  kind                          1a   inz(kXView)
     d  ID                           10a   varying
     d  hdrColor                      1a   inz(x'22')
     d  detColor                      1a   inz(x'20')
     d  chgColor                      1a   inz(x'29')
     d  hdrs                        131a   varying inz('')
     d  lfmt                           *
     d  lGrid                          *
     d  left                               likeds(tLimit)
     d  right                              likeds(tLimit)
     d  leftColID                    10A   varying
      *
     d tLimit          ds                  qualified
     d  lColumn                        *   inz(*null)
     d  pos                           5u 0 inz(0)
     d  width                         3u 0 inz(0)
     d  most                           n   inz(*off)
      //‚get View
     d xview_getXView  pr              *
     d  lXViews                        *
     d  lGrids                         *
     d  lFmt                           *   const
      //‚load view
     dxview_loadXView  pr              *
     d  lXViews                        *   const
     d  lGrids                         *
     d  lFmt                           *   const
      //‚set headers
     d xview_setHdrs   pr           131a   varying
     d  xView                              likeds(tXView)
     d pos                            5u 0 value
      //‚position to the most left position
     dxview_PosToMostLeft...
     d                 pr
     d  XView                              likeDs(tXView)
     d  width                         3u 0 const
      //‚position to the left
     dxview_PosAtLeft  pr
     d  XView                              likeDs(tXView)
     d  width                         3u 0 value
     d  lColumn                        *   const
     d  pos                           3u 0 value
      //‚get limits from right
     d xview_TabRight  pr
     d  XView                              likeDs(tXView)
     d  width                         3u 0 const
      //‚get limits from left
     d xview_TabLeft   pr
     d  XView                              likeDs(tXView)
     d  width                         3u 0 const
      //‚get column at position
     d xview_getColumnAtPos...
     d                 pr              N
     d  lXView                         *   const
     d  pos                           3u 0 const
     d  lColumn_                       *
     d  posOnColumn                   5u 0
      //‚reload the grid of xView
     d xview_reloadGrid...
     d                 pr
     D XVIEW                               likeDs(tXView)
     d lGrids                          *
     d lGrid                           *
     d gridID                        10A   const varying
     d width                          3u 0 const
