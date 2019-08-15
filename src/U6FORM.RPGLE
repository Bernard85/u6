     H nomain option(*NOSHOWCPY)
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6env_h

      /copy cpy,u6form_h
      //‚--------------------------------------------------------------------
      //‚get item form JOURNAL family
      //‚--------------------------------------------------------------------
     pform_XMLinput...
     p                 b                   export
     d form_XMLinput...
     d                 pi              *
     d   ND                                const likeDs(xml_nodeDefine)

     d   form          ds                  likeds(tForm) based(pForm)
     d   panel         ds                  likeds(tpanel) based(pPanel)
     d   label         ds                  likeds(tlabel) based(plabel)
       if ND.ID='FORM';
         pForm=tree_getnewitem(%addr(tForm):%size(tForm));
         form.ID  =xml_getAttAsString('ID':ND.atts);
         Form.text=ND.text;
         return pForm;
       elseif ND.ID='PANEL';
         pPanel=tree_getnewitem(%addr(tPanel):%size(tPanel));
         Panel.text=ND.text;
         return pPanel;
       elseif ND.ID='LABEL';
         pLabel=tree_getnewitem(%addr(tLabel):%size(tLabel));
         label.text   =xml_getAttAsString('TEXT'   :ND.atts);
         label.formula=xml_getAttAsString('FORMULA':ND.atts);
         label.input  =xml_getAttAsBoolean('INPUT' :ND.atts);
         label.maxWidth=xml_getAttAsInteger('MAXWIDTH':ND.atts);
         return pLabel;
       endIf;
       return *null;
     p                 e
      //‚------------------------------------------------------------------*
      //‚set item for FORM family
      //‚-------------------------------------------------------------------
     pForm_XMLoutput   b                   export
     d form_XMLoutput  pi                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      *
     d   ND            ds                  likeDs(xml_nodeDefine)
      *
     d   form          ds                  likeds(tForm)  based(pForm)
     d   panel         ds                  likeds(tPanel) based(pPanel)
     d   label         ds                  likeds(tLabel) based(pLabel)
       clear ND;

       if tree_isofthekind(kForm:lNode:pForm);
         ND.ID='FORM';
         xml_setAttfromString (ND.atts:'ID':form.ID);
         ND.text=form.text;
       elseif tree_isofthekind(kPanel:lNode:pPanel);
         ND.ID='PANEL';
         ND.text=panel.text;
       elseif tree_isofthekind(kLabel:lNode:pLabel);
         ND.ID='LABEL';
         xml_setAttfromString (ND.atts:'FORMULA':label.formula);
         xml_setAttfromInteger(ND.atts:'MAXWIDTH':label.maxwidth);
         xml_setAttfromBoolean(ND.atts:'INPUT':label.input);
         xml_setAttfromString (ND.atts:'TEXT'   :label.text);
       endIf;

       return ND;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get form
      //‚--------------------------------------------------------------------
     pform_getForm     b                   export
     d form_getForm    pi              *
     d  lForms                         *
     d  formID                       10a   const varying
      *
     d  lForm          s               *
       if lForms=*null;
         lforms=tree_getnewlink(*null);
       endif;
       lForm=tree_getItemFromList(lForms:kForm:formID);
       if lForm=*null;
         lForm=tree_Xml2Tree(env_getfilename(cForm:formId)
                            :%pAddr(FORM_XmlInput));
         if lForm<>*null;
           tree_linktoparent(lForms:lForm);
         endif;
       endIf;
       return lForm;
     p                 e
