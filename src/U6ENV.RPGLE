     H nomain option(*NOSHOWCPY)
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6fmt_h

     d u6Env           ds          2000     dtaara(U6Env)
     d u6envr        e ds                   based(pU6envR)
     d g               ds                  qualified
     d  lenvR                          *   inz(*null)
      //‚--------------------------------------------------------------------
      //‚get file name
      //‚--------------------------------------------------------------------
     penv_getFileName  b                   export
     d env_getFileName...
     d                 pi           255a   varying
     d   TAG                         10a   const varying
     d   fileID                     255a   const varying
       return env_getValue('U6PATH'+tag)
             +fileID
             +'.'+env_getValue('U6EXT'+tag);
     p                 e
      //‚--------------------------------------------------------------------
      //‚get path
      //‚--------------------------------------------------------------------
     penv_getPAth      b                   export
     d env_getPAth     pi           255a   varying
     d   TAG                         10a   const varying
       return env_getValue('U6PATH'+tag);
     p                 e
      //‚--------------------------------------------------------------------
      //‚get extention
      //‚--------------------------------------------------------------------
     penv_getExt       b                   export
     d env_getExt      pi           255a   varying
     d   TAG                         10a   const varying
       return env_getValue('U6EXT'+tag);
     p                 e
      //‚--------------------------------------------------------------------
      //‚get dot+extention
      //‚--------------------------------------------------------------------
     penv_getExt$      b                   export
     d env_getExt$     pi           255a   varying
     d   tag                         10a   const varying
       return '.'+env_getValue('U6EXT'+tag);
     p                 e
      //‚--------------------------------------------------------------------
      //‚get Welcome Message
      //‚--------------------------------------------------------------------
     penv_getWelcomeMessage...
     p                 b                   export
     denv_getWelcomeMessage...
     d                 pi           255a   varying
       return env_getValue('U6MSG1');
     p                 e
      //‚--------------------------------------------------------------------
      //‚get tag value
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
       if g.lEnvr=*null;
         pU6envR=%addr(u6Env);
         g.lEnvR=tree_xml2tree(%trim(u6pathfmt)+'u6envR.'+%trim(u6extfmt)
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
