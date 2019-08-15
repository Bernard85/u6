      //‚DS for program
     DPgmSts          sds                  qualified
     D pgmID                         10a
     D sts                            5s 0
     D prvsts                         5s 0
     D srcstmt                        8a
     D routine                        8a
     D parms                          3s 0
     D msgid                          7a
     D mi                             4a
     D work                          30a
     D lib                           10a
     D errdta                        80a
     D rpgmsg                         4a
     D Filler                        69a
     D job                           10a
     D user                          10a
     D jobnum                         5s 0
     D runtime                        6s 0
      *
     d pPgmID          s               *   inz(%addr(pgmSts.pgmID))
     d pgmID           s             10    based(pPgmID)
      //‚DS for workstation
     D wsDS            DS                  qualified
     d  kp                   369    369
     D  CsrFromRow           370    370u 0
     D  CsrFromCol           371    371u 0
      //‚Api error
     D tApiErr         DS                  qualified template
     d  BytPrv                       10i 0 inz(%size(tApiErr))
     d  BytAvl                       10i 0 inz(0)
     d  MsgID                         7
     d  MsgDta                      112
     d ApiErr          ds                  likeDs(tApiErr)
      //‚sfl key words
     d  sflDsp         s               n   based(pIN88)
     d  pIN88          s               *   inz(%addr(*IN88))
     d  sflClr         s               n   based(pIN89)
     d  pIN89          s               *   inz(%addr(*IN89))
      //‚used on break
     d fStop           c                   const(-1)
     d fContinue       c                   const(1)
     d fBreak          c                   const(0)
