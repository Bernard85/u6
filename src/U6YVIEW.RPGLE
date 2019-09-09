     H option(*NOSHOWCPY) nomain
      /copy cpy,u6env_h
      /copy cpy,u6fmt_h
      /copy cpy,u6form_h
      /copy cpy,u6int_h
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6yview_h
      //‚--------------------------------------------------------------------
      //‚get vertical view
      //‚--------------------------------------------------------------------
     pyview_getYView   b                   export
     d yview_getYView  pi              *
     d  lYViews                        *
     d  lForms                         *
     d  lFmts                          *
     d  ID                           10a   const varying
     d  fmtID_                       10a   const varying options(*nopass)
      *
     d  fmtID          s             10a   varying
     d  lYView         s               *   inz(*null)
     d  pYView         s               *   inz(*null)
       //‚if the formatID is not passed take the ID for it                    -
       if %parms()=4;
         fmtID=ID;
       else;
         fmtID=fmtID_;
       endif;
       //‚create the YView anchor if it doesn't exist                         -
       if lYViews=*null;
         lYViews=tree_getnewlink(*null);
       endif;
       //
       lYView=tree_getLinkFromList(lYViews:kYView:ID);
       if lYView=*null;
         //‚load new view                                                      -
         pYView=yview_loadYView(lForms:lFmts:ID:fmtID);
         //‚link to the main tree view                                         -
         lYView=tree_getNewLink(pYView);
         tree_linktoparent(lYViews:lYView);
       endIf;
       return lYView;
     p                 e
      //‚--------------------------------------------------------------------
      //‚load new vertical view
      //‚--------------------------------------------------------------------
     pyview_loadYView  b                   export
     dyview_loadYView  pi              *
     d  lForms                         *
     d  lFmts                          *
     d  ID                           10a   const varying
     d  fmtID_                       10a   const varying options(*nopass)
      *
     d  fmtID          s             10a   varying
     d  YView          ds                  likeds(tYView) based(pYView)
     d  lFmt           s               *   inz(*null)
     d  lForm          s               *   inz(*null)
     d  lVariant       s               *   inz(*null)
     d  label          ds                  likeDs(tLabel) based(pLabel)
       //‚if the formatID is not passed take the ID for it                    -
       if %parms()=3;
         fmtID=ID;
       else;
         fmtID=fmtID_;
       endif;
       //‚create the forms anchor if it doesn't exist                         -
       if lForms=*null;
         lForms=tree_getnewlink(*null);
       endif;
       //‚create the formats anchor if it doesn't exist                       -
       if lFmts=*null;
         lFmts=tree_getnewlink(*null);
       endif;
       //‚create the new item YView                                          -
       pYView=tree_getNewItem(%addr(tYView):%size(tYView));
       YView.ID=ID;
       //‚Load corresponding format                                          -
       YView.lfmt=fmt_getFormat(lFmts:fmtID);
       //‚Lad corresponding form                                             -
       YView.lForm=form_getForm(lForms:fmtID);
       //‚Resolve formulas                                                   -
       lVariant=tree_getFirst(YView.lForm);
       dow lVariant<>*null;
         if tree_isOfTheKind(kLabel:lVariant:pLabel);
           label.lFormula
           =int_loadFormula(label.formula:yView.lFmt);
         endIf;
         lVariant=tree_getNextToDisplay(lVariant);
       endDo;
       //‚put on first segment/label                                         -
       YView.ArmTop.lVariant=tree_getNextToDisplay(yview.lform);
       YView.ArmTop.segment=0;
       return pYView;
     p                 e
