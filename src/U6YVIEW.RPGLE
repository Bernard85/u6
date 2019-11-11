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
     d  fmtID                        10a   const varying
     d  fAppli_                       1a   const options(*nopass)
      *
     d  lYView         s               *   inz(*null)
     d  pYView         s               *   inz(*null)
     d  fAppli         s              1a   inz('N')
       //‚appli means it is a object for the appli
       if %parms()=%parmnum(fAppli_);
         fAppli=fAppli_;
       endIf;
       //‚create the YView anchor if it doesn't exist
       if lYViews=*null;
         lYViews=tree_getnewlink(*null);
       endif;
       //
       lYView=tree_getLinkFromList(lYViews:kYView:fmtID);
       if lYView=*null;
         //‚load new view
         pYView=yview_loadYView(lForms:lFmts:fmtID:fAppli);
         //‚link to the main tree view
         lYView=tree_getNewLink(pYView);
         tree_linktoparent(lYViews:lYView);
       endIf;
       return lYView;
     p                 e
      //‚--------------------------------------------------------------------
      //‚load new vertical view
      //‚--------------------------------------------------------------------
     pyview_loadYView  b
     dyview_loadYView  pi              *
     d  lForms                         *
     d  lFmts                          *
     d  fmtID                        10a   const varying
     d  fAppli                        1a   const
      *
     d  YView          ds                  likeds(tYView) based(pYView)
     d  lFmt           s               *   inz(*null)
     d  lForm          s               *   inz(*null)
     d  lVariant       s               *   inz(*null)
     d  label          ds                  likeDS(tLabel) based(pLabel)
       //‚create the forms anchor if it doesn't exist
       if lForms=*null;
         lForms=tree_getnewlink(*null);
       endif;
       //‚create the formats anchor if it doesn't exist
       if lFmts=*null;
         lFmts=tree_getnewlink(*null);
       endif;
       //‚create the new item YView
       pYView=tree_getNewItem(%addr(tYView):%size(tYView));
       YView.ID=fmtID;
       //‚Load corresponding format
       YView.lfmt=fmt_getFormat(lFmts:fmtID:fAppli);
       //‚Lad corresponding form
       YView.lForm=form_getForm(lForms:fmtID:fAppli);
       //‚Resolve formulas
       lVariant=tree_getFirst(YView.lForm);
       dow lVariant<>*null;
         if tree_isOfTheKind(kLabel:lVariant:pLabel);
           label.lFormula
           =int_FormulaLoad(label.formula:yView.lFmt);
         endIf;
         lVariant=tree_getNextToDisplay(yView.lForm:lVariant);
       endDo;
       //‚put on first segment/label
       YView.ArmTop.lVariant=tree_getFirst(yView.lForm);
       YView.ArmTop.segment=0;
       return pYView;
     p                 e
