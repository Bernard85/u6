     h nomain option(*NOSHOWCPY)
      //‚copy                                                               -
      /copy cpy,u6ibm_h
      /copy cpy,u6fmt_h
      /copy cpy,u6ifs_h
      /copy cpy,u6int_h
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      //‚--------------------------------------------------------------------
      //‚xml_read
      //‚--------------------------------------------------------------------
     pxml_read         b                   export
     d xml_read        pi
     d  path                        255a   varying const
     d  pprocessNode                   *   procptr const
     d  pBox                           *           const
      *
     d  ND             ds                  likeDs(xml_NodeDefine)
      *
     d  processNode    pr              n   extproc(pProcessNode)
     d    ND                               likeDs(xml_NodeDefine)
     d    pBox                         *   const
     d p1              s              5U 0
     d p2              s              5U 0
     d p9              s              5U 0 INZ(1)
     d buffer          s          65535a
     d hstmf           s             10i 0
     d nRead           s             10i 0
       //‚open the text file
       hSTMF=open(path:O_rdonly+o_TextData);
       nRead=Read(hSTMF:%addr(buffer):%size(buffer));
       //‚read nodes
       p1=%scan('<':buffer);
       dow p1>0;
         clear ND;
         p9=xml_SyncScan('>':buffer:p1:hSTMF);
         //‚XML declaration
         if %subst(buffer:p1:2)='<?';
         //‚XML close node
         elseIf %subst(buffer:p1:2)='</';
             ND.isOpen=*off;
             ND.isclose=*on;
             ND.ID=%subst(buffer:p1+2:p9-p1-2);
             if processNode(ND:pBox);
               leave;
             endif;
         else;
         //‚XML regular node
             ND.isOpen=*on;
             ND.isClose=%subst(buffer:p9-1:2)='/>';
             p2      =getminnot0(%scan(' ' :buffer:p1):
                                 %scan('/>':buffer:p1):
                                 %scan('>' :buffer:p1));
             ND.id  =%subst(buffer:p1+1:p2-p1-1);
             //‚Case of a node with attributes
             if p9>p2;
               ND.atts=%subst(buffer:p2+1:p9-p2-1);
               ND.atts=xml_SeekSpecialCharacters(ND.atts);
             endif;
             p1=p9;
             p9=xml_SyncScan('<':buffer:p1:hSTMF);
             ND.text=%subst(buffer:p1+1:p9-p1-1);
             ND.text=%scanRpl(x'0d':'':ND.Text);
             ND.text=%scanRpl(x'25':'':ND.Text);
             ND.Text=%trimR(ND.Text);
             ND.text=xml_SeekSpecialCharacters(ND.text);
             if processNode(ND:pBox);
               leave;
             endif;
         endIf;
         p1=xml_SyncScan('<':buffer:p9:hSTMF);
       endDo;
       //‚Close the file
       hSTMF=Close(hSTMF);
     p                 e
      //‚--------------------------------------------------------------------
      //‚sync and scan
      //‚--------------------------------------------------------------------
     pxml_SyncScan     b
     d xml_SyncScan    pi             5u 0
     d  what                          2a   const varying
     d  buffer                    65535a
     d  p1                            5u 0
     d  hStmf                        10i 0
      *
     d p               s              5u 0
       p=%scan(what:buffer:p1);
       if p>0;
         return p;
       endif;
       buffer=%subst(buffer:p1:%size(buffer)-p1+1);
       if read(hstmf:%addr(buffer)+%size(buffer)-p1+1:p1-1)=0;
         return 0;
       endif;
       p1=1;
       return %scan(what:buffer);
     p                 e
      //‚--------------------------------------------------------------------
      //‚get attribut as string
      //‚--------------------------------------------------------------------
     pXML_getAttAsString...
     p                 b                   export
     dXML_getAttAsString...
     d                 pi           128    varying
     d  pty                         128    varying const
     d  ptys                       2048    varying const
      *
     d  p1             s              5u 0
     d  p2             s              5u 0
     d  val            s            128a   varying
       p1=%scan(pty+'="':ptys);
       if p1=0;
         return '';
       endif;
       p1+=%len(pty)+2;
       p2=%scan('"':ptys:p1);
       val=%subst(ptys:p1:p2-p1);
       return val;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get attribut as integer
      //‚--------------------------------------------------------------------
     pXML_getAttAsInteger...
     p                 b                   export
     dXML_getAttAsInteger...
     d                 pi            10i 0
     d  pty                         128    varying const
     d  ptys                       2048    varying const
      *
     d  val            s            128a   varying
        val=XML_getAttAsString(pty:ptys);
        if val='';
          return 0;
        else;
          return %int(val);
        endif;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get attribut as boolean
      //‚--------------------------------------------------------------------
     pXML_getAttAsBoolean...
     p                 b                   export
     dXML_getAttAsBoolean...
     d                 pi              n
     d  pty                         128    varying const
     d  ptys                       2048    varying const
      *
     d  val            s            128a   varying
        val=XML_getAttAsString(pty:ptys);
        return val='Y';
     p                 e
      //‚--------------------------------------------------------------------
      //‚get min not null
      //‚--------------------------------------------------------------------
     pgetMinNot0       b
     d                 pi             5u 0
     d    u1                          5u 0 const
     d    u2                          5u 0 const
     d    u3                          5u 0 const
     d    min          s              5u 0 inz(*hival)
        if u1<min and u1>0;
          min=u1;
        endif;
        if u2<min and u2>0;
          min=u2;
        endif;
        if u3<min and u3>0;
          min=u3;
        endif;
        if min=*hival;
          return 0;
        endif;
        return min;
     p                 e
      //‚--------------------------------------------------------------------
      //‚hide special characters
      //‚--------------------------------------------------------------------
     pxml_HideSpecialCharacters...
     p                 b                   export
     dxml_HideSpecialCharacters...
     d                 pi          2048a   varying
     d S_                          2048a   varying const
     d S               s           2048a   varying
       S=%scanRpl(';':'&amp;' :S_);
       S=%scanRpl('<':'&lt;'  :S );
       S=%scanRpl('>':'&gt;'  :S );
       S=%scanRpl('"':'&quot;':S );
       return s     ;
     p                 e
      //‚--------------------------------------------------------------------
      //‚seek special characters
      //‚--------------------------------------------------------------------
     pxml_SeekSpecialCharacters...
     p                 b                   export
     dxml_SeekSpecialCharacters...
     d                 pi          2048a   varying
     d String_                     2048a   varying const
     d String          s           2048a   varying
       String=%scanrpl('&lt;'  :'<':String_);
       String=%scanrpl('&gt;'  :'>':String );
       String=%scanrpl('&quot;':'"':String );
       String=%scanrpl('&amp;' :';':String );
       return string;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚set attribut from string value
      //‚-----------------------------------------------------------------------
     pxml_setAttfromString...
     p                 b                   export
     dxml_setAttfromString...
     d                 pi
     d  atts                       2048    varying
     d  pty                         128    varying const
     d  val                         128    varying const
       atts+=' '+pty+'="'+%trimR(val)+'"';
     p                 e
      //‚-----------------------------------------------------------------------
      //‚set attribut from integer value
      //‚-----------------------------------------------------------------------
     pxml_setAttfromInteger...
     p                 b                   export
     dxml_setAttfromInteger...
     d                 pi
     d  atts                       2048    varying
     d  pty                         128    varying const
     d  val                          20i 0 const
       atts+=' '+pty+'="'+%char(val)+'"';
     p                 e
      //‚-----------------------------------------------------------------------
      //‚set attribut from boolean value
      //‚-----------------------------------------------------------------------
     pxml_setAttfromBoolean...
     p                 b                   export
     dxml_setAttfromBoolean...
     d                 pi
     d  atts                       2048    varying
     d  pty                         128    varying const
     d  val                            n           const
       if val;
         atts+=' '+pty+'="Y"';
       else;
         atts+=' '+pty+'="N"';
       endif;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚xml write node
      //‚-----------------------------------------------------------------------
     pxml_writeNode    b                   export
     d xml_writeNode   pi
     d  hJRN                         10i 0 const
     d  ND                                 likeDs(xml_nodeDefine) const
      *
     d  space          s            255    inz('')
     d  dta            s          65535a   varying inz('')
       if ND.level>0;
         dta=%subst(space:1:ND.level*2);
       endIf;
       if ND.isOpen and ND.isClose and ND.level=0;
         dta+='<'+ND.ID+ND.atts+'>'+ND.text+'</'+ND.ID+'>';
       elseif ND.isOpen;
         dta+='<'+ND.ID+ND.atts;
         if ND.isClose;
           dta+='/';
         endIf;
         dta+='>';
         dta+=ND.text;
       elseif ND.isClose;
         dta+='</'+ND.ID+'>';
       endIf;
       ifs_println(hJRN:dta);
     p                 e
      //‚--------------------------------------------------------------------
      //‚Save tree as XML
      //‚--------------------------------------------------------------------
     pxml_tree2XML     b                   export
     d xml_tree2XML    pi
     d  xmlpath                     128a   const varying
     d  lRoot                          *   const
     d  pXX_XMLoutput                  *   const procptr
      *
     d  hXML           s             10i 0
        hXML=ifs_openforWrite(XMLpath);
        ifs_println(hXML:'<?xml version="1.0" encoding="ISO-8859-1" ?>');
        xml_tree2XML2(hXML:lRoot:pXX_XMLoutput);
        ifs_close(hXML);
     p                 e
      //‚--------------------------------------------------------------------
      //‚Save tree as XML part2
      //‚--------------------------------------------------------------------
     pxml_tree2XML2    b
     d xml_tree2XML2   pi
     d  hXml                         10i 0
     d  lNode                          *   const
     d  pXX_XMLoutput                  *   const procptr
      *
     d ND              ds                  likeDs(xml_NodeDefine)
     d lNode2          s               *
      *
     d xxx_XMLoutPut   pr                  extProc(pXX_XMLoutput)
     d                                     likeDs(xml_nodeDefine)
     d   lNode                         *   const
       ND=xxx_XMLoutput(lNode);
       if nd.id='';
         return;
       endif;
       ND.isOpen=*on;
       ND.isClose=tree_getFirst(lNode)=*null;
       ND.level=tree_getLevel(lNode);
       xml_writeNode(hXml:ND);
       //
       if not ND.isClose;
         //‚Process childs                                                     -
         lNode2=tree_getFirst(lNode);
         dow lNode2<>*null;
           xml_tree2XML2(hXML:lNode2:pXX_XMLoutput);
           lNode2=tree_getNext(lNode2);
         endDo;
         ND.isOpen=*off;
         ND.isClose=*on;
         xml_writeNode(hXml:ND);
       endIf;
     p                 e
