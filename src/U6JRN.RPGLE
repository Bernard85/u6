     H nomain option(*NOSHOWCPY)
      /copy cpy,u6filter_h
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h

      /copy cpy,u6jrn_h
      //‚--------------------------------------------------------------------
      //‚get item form JOURNAL family
      //‚--------------------------------------------------------------------
     pjrn_XMLinput...
     p                 b                   export
     djrn_XMLinput...
     d                 pi              *
     d   ND                                const likeDs(xml_nodeDefine)

     d   journal       ds                  likeds(tjournal) based(pjournal)
     d   entries       ds                  likeds(tEntries) based(pEntries)
     d   entry         ds                  likeds(tEntry)   based(pEntry)
       if ND.ID='JOURNAL';
         pJournal=tree_getnewitem(%addr(tJournal):%size(tJournal));
         Journal.ID=xml_getAttAsString('ID':ND.atts);
         Journal.text=ND.text;
         return pJournal;

       elseif ND.ID='ENTRIES';
         pEntries=tree_getnewitem(%addr(tEntries):%size(tEntries));
         return pEntries;

       elseif ND.ID='ENTRY';
         pEntry=tree_getnewitem(%addr(tEntry):%size(tEntry));
         entry.det.ASeq=xml_getAttAsInteger('ASEQ':ND.atts);
         entry.det.APos=xml_getAttAsInteger('APOS':ND.atts);
         entry.det.Dtal=xml_getAttAsInteger('DTAL':ND.atts);
         entry.det.Seqn=xml_getAttAsInteger('SEQN':ND.atts);
         entry.det.code=xml_getAttAsString ('CODE':ND.atts);
         entry.det.entt=xml_getAttAsString ('ENTT':ND.atts);
         entry.det.tstp=xml_getAttAsString ('TSTP':ND.atts);
         entry.det.jobNO =xml_getAttAsString ('JOBNO' :ND.atts);
         entry.det.jobUSR=xml_getAttAsString ('JOBUSR' :ND.atts);
         entry.det.jobID =xml_getAttAsString ('JOBID' :ND.atts);
         entry.det.pgm =xml_getAttAsString ('PGM' :ND.atts);
         entry.det.obj =xml_getAttAsString ('OBJ' :ND.atts);
         entry.det.Lib =xml_getAttAsString ('LIB' :ND.atts);
         entry.det.Mbr =xml_getAttAsString ('MBR' :ND.atts);
         entry.det.Ctrr=xml_getAttAsInteger('CTRR':ND.atts);
         entry.det.uspf=xml_getAttAsString ('USPF':ND.atts);
         entry.det.syNM=xml_getAttAsString ('SYNM':ND.atts);
         return pEntry;
       else;
         return filter_XMLinput(ND);
       endIf;
     p                 e
      //‚--------------------------------------------------------------------
      //‚Set line for Xml parser from node on journal family
      //‚--------------------------------------------------------------------
     pjrn_XmlOutput...
     p                 b                   export
     d jrn_XmlOutput...
     d                 pi                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      *
     d   ND            ds                  likeDs(xml_nodeDefine)
     d   journal       ds                  likeds(tjournal) based(pjournal)
     d   entries       ds                  likeds(tEntries) based(pEntries)
     d   entry         ds                  likeds(tEntry)   based(pEntry)
       clear ND;
       if tree_isofthekind(kJournal:lNode:pJournal);
         ND.ID='JOURNAL';
         ND.text=journal.text;
         xml_setAttfromString(ND.atts:'ID':journal.ID);
       elseif tree_isofthekind(kEntries:lNode:pEntries);
         ND.ID='ENTRIES';
       elseif tree_isofthekind(kEntry:lNode:pEntry);
         ND.ID='ENTRY';
         xml_setAttfromInteger(ND.atts:'ASEQ':entry.det.ASeq);
         xml_setAttfromInteger(ND.atts:'APOS':entry.det.APos);
         xml_setAttfromInteger(ND.atts:'DTAL':entry.det.Dtal);
         xml_setAttfromInteger(ND.atts:'SEQN':entry.det.Seqn);
         xml_setAttfromString (ND.atts:'CODE':entry.det.code);
         xml_setAttfromString (ND.atts:'ENTT':entry.det.entt);
         xml_setAttfromString (ND.atts:'TSTP':entry.det.tstp);
         xml_setAttfromString (ND.atts:'JOBNO':entry.det.jobNO);
         xml_setAttfromString (ND.atts:'JOBUSR':entry.det.jobUsr);
         xml_setAttfromString (ND.atts:'JOBID':entry.det.jobID);
         xml_setAttfromString (ND.atts:'PGM' :entry.det.pgm );
         xml_setAttfromString (ND.atts:'OBJ' :entry.det.obj );
         xml_setAttfromString (ND.atts:'LIB' :entry.det.Lib );
         xml_setAttfromString (ND.atts:'MBR' :entry.det.Mbr );
         xml_setAttfromInteger(ND.atts:'CTRR':entry.det.Ctrr);
         xml_setAttfromString (ND.atts:'USPF':entry.det.uspf);
         xml_setAttfromString (ND.atts:'SYNM':entry.det.syNM);
       else;
         ND=filter_XmlOutput(lNode);
       endIf;
       return ND;
     p                 e
      //‚--------------------------------------------------------------------
      //‚link entries
      //‚--------------------------------------------------------------------
     pjrn_tieEntries   b                   export
     d jrn_tieEntries  pi
     d  lEntries                       *   const
      *
     d lEntry          s               *
     d Entry           ds                  likeDs(tEntry) based(pEntry )
       lEntry=tree_getFirst(lEntries);
       dow lentry <>*null;
         pEntry=tree_getItem(lEntry);
         if entry.det.entt='UP'
         or entry.det.entt='UR';
           Entry.pEntry0=jrn_tieEntries2(lEntry);
         endIf;
         lEntry=tree_getNext(lEntry);
       endDo;
     p                 e
      //‚--------------------------------------------------------------------
      //‚link entries (part 2)
      //‚--------------------------------------------------------------------
     pjrn_tieEntries2  b
     djrn_tieEntries2  pi              *
     d lEntry                          *   const
      *
     d Entry           ds                  likeDs(tEntry) based(pEntry)
     d lEntry0         s               *
     d Entry0          ds                  likeDs(tEntry) based(pEntry0)
       pEntry=tree_getItem(lEntry);
       lEntry0=tree_getprev(lEntry);
       dow lEntry0<>*null;
         pEntry0=tree_getItem(lEntry0);
         if entry0.det.OBJ   = Entry.det.OBJ
         and Entry0.det.ctrr = Entry.det.ctrr;
           return pEntry0;
         endif;
         lEntry0=tree_getprev(lEntry0);
       endDo;
       return *null;
     p                 e
