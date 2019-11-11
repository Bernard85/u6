     H nomain option(*NOSHOWCPY)
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6fmt_h

     d u6Env           ds          2000     dtaara(U6Env)
     d u6envr        e ds                   based(pU6envR)
     d g               ds                  qualified
     d  lenvR                          *   inz(*null)
      //‚--------------------------------------------------------------------
      //‚get Welcome Message
      //‚--------------------------------------------------------------------
     penv_getWelcomeMessage...
     p                 b                   export
     denv_getWelcomeMessage...
     d                 pi           100a   varying
       return env_getValue('U6MSG1');
     p                 e
      //‚--------------------------------------------------------------------
      //‚get appli path
      //‚--------------------------------------------------------------------
     penv_getAppliPath...
     p                 b                   export
     denv_getAppliPath...
     d                 pi            50a   varying
       return env_getValue('U6APPPATH');
     p                 e
      //‚--------------------------------------------------------------------
      //‚get client path
      //‚--------------------------------------------------------------------
     penv_getClientPath...
     p                 b                   export
     denv_getClientPath...
     d                 pi            50a   varying
       return env_getValue('U6CLIPATH');
     p                 e
      //‚--------------------------------------------------------------------
      //‚get client journal
      //‚--------------------------------------------------------------------
     penv_getJournalPath...
     p                 b                   export
     denv_getJournalPath...
     d                 pi            50a   varying
       return env_getValue('U6JRNPATH');
     p                 e
      //‚--------------------------------------------------------------------
      //‚get environment value
      //‚--------------------------------------------------------------------
     penv_getValue     b
     d env_getValue    pi           255a   varying
     d  TAG                          10a   const varying
      *
     d lFields         s               *
     d lField          s               *
     d field           ds                  likeDs(tField) based(pField)
     d tagValue        s            255a   varying
       tagValue='';
       in u6env;
       pU6envR=%addr(u6Env);
       if g.lEnvr=*null;
         g.lEnvR=tree_xml2tree(%trim(u6AppPath)+'u6envr.fmt'
                              :%paddr(fmt_XmlInput));
         if g.lenvR=*null;
           return '';
         endIf;
       endIf;
       //
       lFields=tree_getLinkFromList(g.lEnvr:kFields);
       lField=tree_getLinkFromList(lFields:kField:tag);
       if lField=*null;
         return '';
       endIf;
       pField=tree_getItem(lField);
       //
       tagValue=%subst(u6envR:field.posinbuffer+1:field.len);
       tagValue=%trim(tagValue);
       return tagValue;
     p                 e
