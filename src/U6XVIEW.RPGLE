     H option(*NOSHOWCPY) nomain
      /copy cpy,u6env_h
      /copy cpy,u6fmt_h
      /copy cpy,u6grid_h
      /copy cpy,u6int_h
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6xview_h
      //‚--------------------------------------------------------------------
      //‚get View
      //‚--------------------------------------------------------------------
     pxview_getXView   b                   export
     d xview_getXView  pi              *
     d  lXViews                        *
     d  lGrids                         *
     d  lFmt                           *   const
      *
     d  lXView         s               *   inz(*null)
     d  pXView         s               *   inz(*null)
     d  Fmt            ds                  likeDs(tFormat) based(pFmt)
       //‚create the XView anchor if it doesn't exist
       if lXViews=*null;
         lXViews=tree_getnewlink(*null);
       endif;
       pFmt=tree_getItem(lFmt);
       lXView=tree_getLinkFromList(lXViews:kXView:fmt.ID);
       if lXView=*null;
         pXView=xview_loadXView(lXViews:lGrids:lfmt);
         lXView=tree_getNewLink(pXView);
         tree_linktoparent(lXViews:lXView);
       endIf;
       return lXView;
     p                 e
      //‚--------------------------------------------------------------------
      //‚load view
      //‚--------------------------------------------------------------------
     pxview_loadXView  b                   export
     dxview_loadXView  pi              *
     d  lXViews                        *   const
     d  lGrids                         *
     d  lFmt                           *   const
      *
     d  XView          ds                  likeds(tXView) based(pXView)
     d  fmt            ds                  likeDs(tFormat) based(pFmt)
     d  lGrid          s               *   inz(*null)
     d  lColumn        s               *   inz(*null)
     d  column         ds                  likeDs(tColumn) based(pColumn)
       //‚create the grids anchor if it doesn't exist
       if lGrids=*null;
         lGrids=tree_getnewlink(*null);
       endif;
       pFmt=tree_getItem(lFmt);
       //‚create the new item xView
       pXView=tree_getNewItem(%addr(tXView):%size(tXView));
       XView.ID=fmt.ID;
       //‚Load corresponding format
       XView.lfmt=lFmt;
       fmt.pBuffer1=%alloc(fmt.len);
       fmt.pBuffer0=%alloc(fmt.len);
       //‚Load corresponding grid
       XView.lGrid=grid_getGrid(lGrids:fmt.ID);
       //‚Load formulas
       lColumn=tree_getFirst(XView.lGrid);
       dow lColumn<>*null;
         pColumn=tree_getItem(lColumn);
         column.lFormula=int_FormulaLoad(column.formula:lFmt);
         lColumn=tree_getNext(lColumn);
       endDo;
       return pXView;
     p                 e
      //‚--------------------------------------------------------------------
      //‚position to the most left position
      //‚--------------------------------------------------------------------
     pxview_PosToMostLeft...
     p                 b                   export
     dxview_PosToMostLeft...
     d                 pi
     d  XView                              likeDs(tXView)
     d  width                         3u 0 const
       xview_PosAtLeft(XView:width:tree_getFirst(XView.lGrid):1);
     p                 e
      //‚--------------------------------------------------------------------
      //‚position to the left
      //‚--------------------------------------------------------------------
     pxview_PosAtLeft  b                   export
     dxview_PosAtLeft  pi
     d  XView                              likeDs(tXView)
     d  width                         3u 0 value
     d  lColumn                        *   const
     d  pos                           3u 0 value
      *
     d Column          ds                  likeDs(tColumn) based(pColumn)
       //‚Reposition --> clear the headers
       xView.hdrs='';
       xView.left.lColumn=lColumn;
       pColumn=tree_getItem(lColumn);
       xView.leftColId=Column.ID;
       if column.maxWidth<=30;
         xView.left.pos=1;
       else;
         xView.left.pos=int_getMin(column.maxWidth-30+1:pos);
       endif;
       xView.left.most=pos=1 and xView.left.lColumn=tree_getFirst(XView.lGrid);
       //‚xxxxxxxx
       XView.left.width=int_getMin(column.maxWidth-XView.left.pos+1:width-1);
       xview_setRightColumn(XView:width);
     p                 e
      //‚--------------------------------------------------------------------
      //‚tabulation at right
      //‚--------------------------------------------------------------------
     pxview_TabRight   b                   export
     d xview_TabRight  pi
     d  XView                              likeDs(tXView)
     d  width                         3u 0 const
      *
     d column          ds                  likeDs(tColumn) based(pColumn)
       //‚Already at the right
       if XView.right.most;
         return;
       endIf;
       //‚new position --> clear the headers
       XView.hdrs='';
       //‚no more on the left position
       XView.left.most=*off;
       //‚To know the right most column
       pColumn=tree_getItem(XView.right.lColumn);

       if XView.right.pos+XView.right.width-1=column.maxWidth;
         XView.left.lColumn=tree_getNext(XView.right.lColumn);
         XView.left.pos=1;
       else;
         XView.left.lColumn=XView.right.lColumn;
         XView.left.pos=int_getMin(column.maxWidth-30+1
                                  :XView.right.pos+XView.right.width);
       endIf;
       pColumn=tree_getItem(XView.left.lColumn);
       xView.leftColId=Column.ID;
       XView.left.width=int_getMin(column.maxWidth-XView.left.pos+1:width-1);
       //‚to determie the right most column
       xview_setRightColumn(XView:width);
     p                 e
      //‚--------------------------------------------------------------------
      //‚set right most column
      //‚--------------------------------------------------------------------
     pxview_setRightColumn...
     p                 b
     d xview_setRightColumn...
     d                 pi
     d  XView                              likeDs(tXView)
     d  width                         3u 0 value
      *
     d lColumn         s               *
     d column          ds                  likeDs(tColumn) based(pColumn)
     d width_          s              3u 0
       width_=width;
       //‚the right leg is initialized with the current leg
       XView.right=XView.left;
       XView.right.most=*off;
       width-=1+XView.left.width;
       //‚quit if
       pColumn=tree_getItem(XView.left.lColumn);
       if XView.left.pos+XView.left.width-1<column.maxwidth;
         return;
       endif;
       //‚new position then clear headers
       xview.hdrs='';
       //‚loop on middle columns to get the right most column
       lColumn=tree_getNext(XView.left.lColumn);
       dow lColumn<>*null;
         pColumn=tree_getItem(lColumn);
         if 1+column.maxwidth<=width;
           width-=1+column.maxwidth;
           XView.right.lColumn=lColumn;
           XView.right.pos=1;
           XView.right.width=column.maxWidth;
         elseif column.maxWidth>30 and width>30;
           XView.right.lColumn=lColumn;
           XView.right.pos=1;
           XView.right.width=width-1;
           return;
         else;
           return;
         endIf;
         lColumn=tree_getNext(lColumn);
       endDo;
       XView.right.most=*on;
       ///if not XView.left.most;
       ///  xview_setLeftColumn(XView:width_);
       ///endif;
     p                 e
      //‚--------------------------------------------------------------------
      //‚tabulation at left
      //‚--------------------------------------------------------------------
     pxview_TabLeft    b                   export
     d xview_TabLeft   pi
     d  XView                              likeDs(tXView)
     d  width                         3u 0 const
      *
     d column          ds                  likeDs(tColumn) based(pColumn)
       //‚Already at the left : nothing to do
       if XView.left.most;
         return;
       endIf;
       //‚Reposition --> clear the headers
       XView.hdrs='';
       //‚no more on the left most position
       XView.right.most=*off;
       //‚To recognize the rightmost column
       if XView.left.pos=1;
         XView.right.lColumn=tree_getPrev(XView.left.lColumn);
         pColumn=tree_getItem(XView.right.lColumn);
         XView.right.width=int_getMin(column.maxWidth:width-1);
         XView.right.pos=column.maxWidth-XView.right.width+1;
       elseIf XView.left.pos<30;
         XView.right=XView.left;
         XView.right.pos=1;
         XView.right.width=30;
       else;
         XView.right=XView.left;
         pColumn=tree_getItem(XView.right.lColumn);
         XView.right.width=int_getMin(XView.right.pos-1
                                     :width-1);
         XView.right.pos-=XView.right.width;
       endif;
       xview_setLeftColumn(XView:width);
     p                 e
      //‚--------------------------------------------------------------------
      //‚set left most column
      //‚--------------------------------------------------------------------
     pxview_setLeftColumn...
     p                 b
     d xview_setLeftColumn...
     d                 pi
     d  XView                              likeDs(tXView)
     d  width                         3u 0 value
      *
     d lColumn         s               *
     d column          ds                  likeDs(tColumn) based(pColumn)
     d width_          s              3u 0
       width_=width;
       //‚the right leg is inialized with the left leg
       xView.left=xView.right;
       xView.left.most=*off;
       //‚quit if
       if XView.right.pos>1;
         return;
       endif;
       //‚loop on middle columns to get mostleft column
       width-=xView.right.width+1;
       lColumn=tree_getprev(XView.right.lColumn);
       dow lColumn<>*null;
         pColumn=tree_getItem(lColumn);
         xView.leftColId=Column.ID;
         if column.maxwidth+1<=width;
           xView.left.lColumn=lColumn;
           xView.left.width=column.maxWidth;
           xView.left.pos=1;
           width-=1+xView.left.width;
         elseif column.maxWidth>30 and width>30;
           xView.left.lColumn=lColumn;
           xView.left.width=width-1;
           xView.left.pos=column.maxWidth-xView.left.width+1;
           return;
         else;
           xView.leftColId=Column.ID;
           return;
         endIf;
         lColumn=tree_getPrev(lColumn);
       endDo;
       xView.left.most=*on;
       if not XView.right.most;
         xview_setRightColumn(XView:width_);
       endif;
     p                 e
      //‚--------------------------------------------------------------------
      //‚set headers
      //‚--------------------------------------------------------------------
     pxview_setHdrs    b                   export
     d xview_setHdrs   pi           131a   varying
     d  xView                              likeds(tXView)
     d pos                            5u 0 value
      *
     d lColumn         s               *
     d Column          ds                  likeDs(tColumn) based(pColumn)
       //‚headers filled means no tabulation has happened
       if XView.hdrs<>'';
         return XView.hdrs;
       endif;
       //‚leftmost column
       lColumn=XView.left.lcolumn;
       pColumn=tree_getItem(lColumn);
       XView.hdrs+=XView.hdrColor+xview_getHdr(column:XView.left.Width);
       pos+=2;
       column.pos=pos;
       if XView.right.lColumn=XView.left.lColumn;
         return XView.hdrs;
       endif;
       pos+=XView.left.Width+1;
       //‚middle columns
       lColumn=tree_getNext(lColumn);
       dow lColumn<>XView.right.lColumn;
         pColumn=tree_getItem(lColumn);
         column.pos=pos;
         XView.hdrs+=XView.hdrColor+xview_getHdr(column:column.maxWidth);
         pos+=1+column.maxWidth;
         lColumn=tree_getNext(lColumn);
       endDo;
       //‚Rightmost column
       lColumn=XView.right.lcolumn;
       pColumn=tree_getItem(lColumn);
       column.pos=pos;
       XView.hdrs+=XView.hdrColor+xview_getHdr(column:XView.right.Width);
       return XView.hdrs;
     p                 e
      //‚--------------------------------------------------------------------
      //‚Load header
      //‚--------------------------------------------------------------------
     pxview_getHdr     b
     d xview_getHdr    pi           130a   varying
     d  column                             likeds(tColumn)
     d  width                         3u 0 const
      *
     d hdr             s            130a   varying
     d hdr1            s             30a
     d d               s              3u 0
     d d1              s              3u 0
     d d2              s              3u 0
     d dashes          s            130a   inz(*all'-')
       //‚Prepare the header
       hdr1=column.hdr1;
       hdr=%trim(%subst(hdr1:1:column.hdrWidth));
       d=Width-%len(hdr);
       if d>=6;
         hdr='-- '+hdr+' '+%subst(dashes:1:d-4);
       elseif d>0;
         d1=d/2;
         d2=d-d1;
         hdr=%subst(dashes:1:d1)+hdr;
         if d2>0;
           hdr=hdr+%subst(dashes:1:d2);
         endif;
       endIf;
       return hdr;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get column at position
      //‚--------------------------------------------------------------------
     pxview_getColumnAtPos...
     p                 b                   export
     d xview_getColumnAtPos...
     d                 pI              N
     d  lXView                         *   const
     d  pos                           3u 0 const
     d  lColumn_                       *
     d  posOnColumn                   5u 0
      *
     d  XView          ds                  likeds(tXView) based(pXView)
     d  lColumn        s               *
     d  column         ds                  likeds(tColumn) based(pColumn)
       pXView=tree_getItem(lXView);
       //‚loop on each displayed column
       lColumn=XView.left.lColumn;
       dow lColumn<>*null;
         lColumn_=lColumn;
         pColumn=tree_getItem(lColumn);
         if lColumn=XView.left.lColumn
         and pos>=column.pos-1
         and pos<=column.pos+XView.left.width-1;
           posOnColumn=XView.left.pos+pos-column.pos;
           return *on;
         elseif lColumn=XView.right.lColumn
         and pos>=column.pos-1
         and pos<=column.pos+XView.right.width-1;
           posOnColumn=XView.right.pos+pos-column.pos;
           return *on;
         elseif lColumn=XView.right.lColumn;
           return *off;
         elseif lColumn<>XView.left.lColumn
            and pos>=column.pos-1
            and pos<=column.pos+column.MAXwidth-1;
           posOnColumn=1+pos-column.pos;
           return *on;
         endIf;
         lColumn=tree_getNext(lColumn);
       endDo;
       return *off;
     p                 e
      //‚--------------------------------------------------------------------
      //‚reload the grid of xView
      //‚--------------------------------------------------------------------
     pxview_reloadGrid...
     p                 b                   export
     d xview_reloadGrid...
     d                 pi
     D XVIEW                               likeDs(tXView)
     d lGrids                          *
     d lGrid                           *
     d gridID                        10A   const varying
     d width                          3u 0 const
      *
     D lColumn         s               *
     d  column         ds                  likeDs(tColumn) based(pColumn)
       //‚untied old grid
       tree_unTied(lGrid);
       //‚setup new grid
       XView.lGrid=grid_getGrid(lGrids:gridID);
       //‚Resolve formulas
       lColumn=tree_getFirst(XView.lGrid);
       dow lColumn<>*null;
         column.lFormula=int_FormulaLoad(column.formula:XView.lFmt);
         lColumn=tree_getNext(lColumn);
       endDo;
       //‚left position in the new grid
       XView.left.lColumn=tree_getLinkFromList(XView.lGrid
                                              :kColumn
                                              :xview.leftColID);
       xview_setRightColumn(XView:width);
       //‚clear headers
       XVIEW.hdrs='';
     p                 e
