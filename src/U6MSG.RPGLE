     H option(*NOSHOWCPY) nomain
      /copy cpy,u6ibm_h
      //‚-------------------------------------------------------------------
      //‚Send program message
      //‚-------------------------------------------------------------------
     p msg_SndPM       b                   export
     d                 pi
     d  pn                           10    const
     d  mt                          130    const
       QMHSNDPM('':'':mt:%len(mt):'*INFO':pn:0:' ':ApiErr);
     p                 e
      //‚-------------------------------------------------------------------
      //‚Remove all program messages
      //‚-------------------------------------------------------------------
     p msg_RmvPM       b                   export
     d                 pi
     d  pn                           10     const
       Qmhrmvpm(pn:0:' ':'*ALL':ApiErr);
     p                 e
      //‚-------------------------------------------------------------------
      //‚Send message text to user
      //‚-------------------------------------------------------------------
     p msg_SndM        b                   export
     d msg_SndM        pi
     D  mi                            7a   const
     D  md                          256a   const varying
      *
     d  mk             s              4a
     D  mf             s             20a   inz('QCPFMSG   QSYS')
       qmhsndm(mi:mf:md:%len(md):'*DIAG':pgmsts.user+'*LIBL':1:'':mk:ApiErr);
     p                 e
