     h nomain option(*NOSHOWCPY)
      //‚copy
      /copy cpy,u6ifs_h
      /copy cpy,u6tree_h
      /copy cpy,u6tree_s
      /copy cpy,u6xml_h
      //‚--------------------------------------------------------------------
      //‚get new link
      //‚--------------------------------------------------------------------
     ptree_getNewLink  b                   export
     dtree_getNewLink  pi              *
     d pItem                           *   const

     d newLink         ds                  likeDs(tLink) based(pNewLink)
       pNewLink=tree_getNewItem(%addr(tLink):%size(tLink));

       NewLink.Item=pItem;
       tree_OpenLink(pNewLink);
       return pNewLink;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get new item (init)
      //‚--------------------------------------------------------------------
     ptree_getNewItem  b                   export
     dtree_getNewItem  pi              *
     d pTemplate                       *   const
     d sizeTemplate                   5u 0 const
      *
     d pNewItem        s               *
       pNewItem=%alloc(sizeTemplate);
       ifs_memcpy(pNewItem:pTemplate:sizeTemplate);
       return pnewItem;
     p                 e
      //‚--------------------------------------------------------------------
      //‚Open a link
      //‚--------------------------------------------------------------------
     ptree_OpenLink    b                   export
     dtree_OpenLink    pi
     d pLink_                          *   const
      *
     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;
       ifs_setbit(%addr(Link.flag):fopen:*on);
     p                 e
      //‚--------------------------------------------------------------------
      //‚close a link
      //‚--------------------------------------------------------------------
     p tree_CloseLink  b                   export
     d tree_closeLink  pi
     d  pLink_                         *   const
      *
     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;

       ifs_setbit(%addr(link.flag):fopen:*off);
     p                 e
      //‚--------------------------------------------------------------------
      //‚get flag of a link
      //‚--------------------------------------------------------------------
     p tree_getFlag    b
     d tree_getFlag    pi              n
     d  pLink_                         *   const
     d  iFlag                         3u 0 const

     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;
       return ifs_testbit(%addr(link.flag):iFlag);
     p                 e
      //‚--------------------------------------------------------------------
      //‚Link item to its parent
      //‚--------------------------------------------------------------------
     p tree_linkToParent...
     p                 b                   export
     d tree_linkToParent...
     d                 pi
     d pParentLink_                    *   const
     d pNewLink_                       *   const
     d pNextLink_                      *   const options(*nopass)
      *
     dparentLink       ds                  likeDs(tLink) based(pParentLink)
     dnextLink         ds                  likeDs(tLink) based(pnextLink)
     dnewLink          ds                  likeDs(tLink) based(pnewLink)
     dLink1            ds                  likeDs(tLink) based(pLink1)
     dLink9            ds                  likeDs(tLink) based(pLink9)
      *
     d pPrevLink       s               *
       pParentLink=pParentLink_;
       pNewLink   =pNewLink_;
       if %parms()=3;
         pNextLink =pNextLink_;
       endIf;
      //
       NewLink.parent=pParentLink;
       if newlink.first=*null;
         NewLink.level=ParentLink.level+1;
       endif;

       //‚Parent without child
       if ParentLink.first =*null;
         ParentLink.first =pNewLink;
         tree_link2Brothers(pNewLink:pNewLink);
       elseif pNextLink<>*null;
         pPrevLink=NextLink.prev;
         tree_link2Brothers(pPrevLink:pNewLink);
         tree_link2Brothers(pNewLink :pNextLink);
         if ParentLink.first =pNextLink;
           ParentLink.first =pNewLink;
         endIf;
       else;
         pLink1=ParentLink.first ;
         pLink9=Link1.prev;
         tree_link2Brothers(pLink9:pNewLink);
         tree_link2Brothers(pNewLink:pLink1);
       endif;
       return;
     p                 e
      //‚--------------------------------------------------------------------
      //‚Link 2 brothers
      //‚--------------------------------------------------------------------
     p tree_Link2Brothers...
     p                 b                   export
     d tree_Link2Brothers...
     d                 pi
     d  pLink1_                        *   const
     d  pLink2_                        *   const

     dLink1            ds                  likeDs(tLink) based(pLink1)
     dLink2            ds                  likeDs(tLink) based(pLink2)
       pLink1=pLink1_;
       pLink2=pLink2_;
       if plink1=*null or plink2=*null;
       return;
       endIf;
       link1.next=plink2;
       Link2.prev=plink1;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get item from a node
      //‚--------------------------------------------------------------------
     p tree_getItem    b                   export
     d tree_getItem    pi              *
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;
       if pLink=*null;
         return *null;
       endIf;
       return Link.Item;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get parent of a node
      //‚--------------------------------------------------------------------
     p tree_getParent  b                   export
     d tree_getParent  pi              *
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;

       return Link.parent;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get kind of a link/item
      //‚--------------------------------------------------------------------
     p tree_getKind    b                   export
     d tree_getKind    pi             1a
     d  pLink_                         *   const
     d item            ds                  qualified based(pItem)
     d   kind                         1a
     dLink             ds                  likeDs(tLink) based(pLink)
       if pLink_=*null;
         return '';
       endIf;
       pLink=pLink_;
       pItem=tree_getItem(pLink);
       if pItem=*null;
         return '';
       endIf;
       return Item.kind;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get first child
      //‚-----------------------------------------------------------------------
     p tree_getFirst   b                   export
     d tree_getFirst   pi              *
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
       if pLink_=*null;
         return *null;
       endif;
       pLink=pLink_;
       return Link.first;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get last child
      //‚-----------------------------------------------------------------------
     ptree_getLast     b                   export
     d tree_getLast    pi              *
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
       if pLink_=*null;
         return *null;
       endif;
       pLink=pLink_;
       pLink=Link.first;
       if pLink=*null;
         return *null;
       endif;
       return Link.prev;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get level of a link
      //‚--------------------------------------------------------------------
     p tree_getLevel   b                   export
     d tree_getLevel   pi             3i 0
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;
       return link.level;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get option of a link
      //‚--------------------------------------------------------------------
     p tree_getOption  b                   export
     d tree_getOption  pi             2a
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;
       return link.option;
     p                 e
      //‚--------------------------------------------------------------------
      //‚set option of a link
      //‚--------------------------------------------------------------------
     p tree_setOption  b                   export
     d tree_setOption  pi
     d  pLink_                         *   const
     d  option                        2a   const

     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;
       link.option=option;
     p                 e
      //‚--------------------------------------------------------------------
      //‚is the link is open
      //‚--------------------------------------------------------------------
     p tree_isOpen     b                   export
     d tree_isOpen     pi              n
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;
       return tree_getFlag(pLink:fOpen);
     p                 e
      //‚------------------------------------------------------------------- ---
      //‚get next link
      //‚------------------------------------------------------------------- ---
     p tree_getNext    b                   export
     d tree_getNext    pi              *
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
     dParent           ds                  likeDs(tLink) based(pParent)
       if pLink_=*null;
         return *null;
       endIf;
       pLink=pLink_;
       // no parent no brother
       pParent=Link.parent;
       if pparent=*null;
         return *null;
       endIf;
       if link.next<>parent.first;
         return Link.next;
       endIf;
       return *null;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get the next row to display
      //‚-----------------------------------------------------------------------
     p tree_getNextToDisplay...
     p                 b                   export
     d tree_getNextToDisplay...
     d                 pi              *
     d  pLink_                         *   const

     d pX              s               *
       pX=tree_getFirstToDisplay(pLink_);
       if pX<>*null;
         return pX;
       endIf;
       return tree_getNextOrAncestorNext(pLink_);
     p                 e
      //‚------------------------------------------------------------------- ---
      //‚get my next or my ancestor next
      //‚------------------------------------------------------------------- ---
     p tree_getNextOrAncestorNext...
     p                 b
     d tree_getNextOrAncestorNext...
     d                 pi              *
     d  pLink_                         *   const
     dLink             ds                  likeDs(tLink) based(pLink)
     dpX               s               *
       if pLink_=*null;
         return *null;
       endIf;
       pLink=pLink_;
       ///
       if Link.level=0;
         return *null;
       endif;
       ///
       pX=tree_getNext(pLink);
       if pX<>*null;
         return pX;
       endIf;

       pX=tree_getParentToDisplay(pLink);
       if pX=*null;
         return *null;
       endIf;
       return tree_getNextOrAncestorNext(pX);
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get parent to display
      //‚-----------------------------------------------------------------------
     p tree_getParentToDisplay...
     p                 b
     d tree_getParentToDisplay...
     d                 pi              *
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;

       if Link.Parent=*null;
         return *null;
       endIf;
       return Link.parent;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get the first link to display
      //‚-----------------------------------------------------------------------
     p tree_getFirstToDisplay...
     p                 b                   export
     d tree_getFirstToDisplay...
     d                 pi              *
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
       if pLink_=*null;
         return *null;
       endif;
       pLink=pLink_;
       if Link.first=*null or not tree_isOpen(pLink);
         return *null;
       endIf;
       //
       return Link.first;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get previous row to display
      //‚-----------------------------------------------------------------------
     p tree_getPrevToDisplay...
     p                 b                   export
     d tree_getPrevToDisplay...
     d                 pi              *
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
     dParent           ds                  likeDs(tLink) based(pParent)
     d pX              s               *
       pLink=pLink_;
       pX=tree_getPrev(pLink);
       if pX<>*null;
         return tree_getLastOfLastToDisplay(pX);
       endIf;
       return tree_getParentToDisplay(pLink);
     p                 e
      //‚-------------------------------------------------------------------*
      //‚get the last of last to display
      //‚--------------------------------------------------------------------
     p tree_getLastOfLastToDisplay...
     p                 b                   export
     d tree_getLastOfLastToDisplay...
     d                 pi              *
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
     d pX              s               *
       pLink=pLink_;
       pX=tree_GetLastToDisplay(pLink);
       if pX<>*Null;
         return tree_getLastOfLastToDisplay(pX);
       endIf;
       return pLink;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get last child to display
      //‚-----------------------------------------------------------------------
     p tree_getLastToDisplay...
     p                 b
     d tree_getLastToDisplay...
     d                 pi              *
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
     dLink2            ds                  likeDs(tLink) based(pLink2)
     d pX              s               *
       if pLink_=*null;
         return *null;
       endif;
       pLink=pLink_;
       if Link.First=*null or not tree_isOpen(pLink);
         return *null;
       endIf;
       pLink2=Link.first;
       pLink2=Link2.prev;
       return pLink2;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get previous link
      //‚-----------------------------------------------------------------------
     p tree_getPrev    b                   export
     d tree_getPrev    pi              *
     d  pLink_                         *   const

     dLink             ds                  likeDs(tLink) based(pLink)
     dParent           ds                  likeDs(tLink) based(pParent)
       if pLink_=*null;
         return *null;
       endIf;
       pLink=pLink_;
       // les sans parents sont sans frères
       if Link.parent=*null;
         return *null;
       endIf;
       //
       pParent=Link.parent;
       if pLink<>parent.first;
         return link.prev;
       endIf;
       return *null;
     p                 e
      //‚--------------------------------------------------------------------
      //‚xml --> tree
      //‚--------------------------------------------------------------------
     ptree_xml2tree    b                   export
     dtree_xml2tree    pi              *
     d path                         255a   varying const
     d pXXX_GetItem                    *   procptr const
     d treeBox         ds                  likeds(ttreeBox)
       treeBox.pXXX_GetItem=pXXX_GetItem;
       xml_read(path:%paddr(tree_Parse):%addr(treeBox));
       return treeBox.lRoot;
     p                 e
      //‚--------------------------------------------------------------------
      //‚build link and its item
      //‚--------------------------------------------------------------------
     p tree_parse      b
     d  tree_parse     pi              n
     d   ND                                likeDs(xml_nodeDefine)
     d   ptreeBox_                     *   const
      *
     d treeBox         ds                  likeds(ttreeBox) based(ptreeBox)
      *
     d XXX_GetItem     pr              *
     d                                     extproc(treeBox.pXXX_GetItem)
     d  ND                                 const likeDs(xml_NodeDefine)
      *
     d lItem           s               *
     d pItem           s               *
       pTreeBox=pTreeBox_;
       if ND.isOpen;
         pitem=XXX_GetItem(ND);
         lItem=tree_getNewLink(pItem);
         if treeBox.lRoot=*null;
           treeBox.lRoot=lItem;
         else;
           tree_LinkToParent(treeBox.lCur:lItem);
         endIf;
         treeBox.lCur=lItem;
       endIf;

       if ND.isClose;
         treeBox.lCur=tree_getParent(treeBox.lCur);
       endIf;
       //‚off : means continue parsing                                       -
       return *off;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get item from list by ID
      //‚--------------------------------------------------------------------
     ptree_getItemfromList...
     p                 b                   export
     d tree_getItemfromList...
     d                 pi              *
     d  lAnonyms                       *   const
     d  kind                          1a   const
     d  ID                          255a   const varying
      *
     d tAnonym         ds                  qualified template
     d  kind                          1a
     d  ID                          255A   varying
     d lAnonym         s               *
     d Anonym          ds                  likeds(tAnonym) based(pAnonym)
       lAnonym=tree_getFirst(lAnonyms);
       dow lAnonym<>*null;
         pAnonym=tree_getItem(lAnonym);
         if Anonym.kind=kind and Anonym.id=id;
           return lAnonym;
         endif;
         lAnonym=tree_getNext(lAnonym);
       endDo;
       return *null;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚link is of the kind
      //‚-----------------------------------------------------------------------
     ptree_isOfTheKind...
     p                 b                   export
     d tree_isOfTheKind...
     d                 pi              n
     d  kind                          1a   const
     d  pLink_                         *   const
     d  pItem_                         *   options(*nopass)
      //
     d Link            ds                  likeDs(tLink) based(pLink)
     d item            ds                  qualified based(pItem)
     d   kind                         1a
       if pLink_=*null;
         return *off;
       endIf;
       pLink=pLink_;
       pItem=link.item;
       if pItem=*null;
         return *off;
       endIf;
       if Item.kind<>kind;
         return *off;
       endIf;
       if %parms()=3;
         pItem_=link.item;
       endif;
       return *on;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚Sort childs of a link
      //‚-----------------------------------------------------------------------
     Ptree_Sort        B                   export
     D tree_sort       PI
     D   lParent                       *   const
     D   pComparator                   *   const procptr
      *
     d  lCurrent       S               *
     d  lNext          S               *
       //‚Start on the 2nd link
       lCurrent=tree_getNext(tree_getFirst(lParent));
       dow lCurrent<>*null;
         lNext=tree_getNext(lCurrent);
         tree_sort2(lParent:lCurrent:pComparator);
         lCurrent=lNext;
       endDo;
     P                 E
      //‚-----------------------------------------------------------------------
      //‚Sort childs of a link part2
      //‚-----------------------------------------------------------------------
     Ptree_sort2       B
     D tree_sort2      PI
     D   lParent                       *   const
     D   lCurrent                      *   const
     D   pComparator                   *   const procptr
      *
     d  lPrev          S               *
     d  lFirst         S               *
     d  lPreceding     S               *
     d  lFollow        S               *
     d  lGreater       s               *
      *
     D Comparator      PR             3i 0 extproc(pComparator)
     D  lElement1                      *   const
     D  lElement2                      *   const
       //‚Do noting if the previous is smaller
       lPrev=tree_getPrev(lCurrent);
       if comparator(lPrev:lCurrent)=-1;
         return;
       endIf;
       //‚Browse the list until find a smaller item
       lFirst =tree_getFirst(lParent);
       Dow comparator(lPrev:lCurrent)<>-1;
         lGreater=lPrev;
         if lPrev=lFirst;
           leave;
         endIf;
         lPrev=tree_getPrev(lPrev);
       endDo;
       //‚Linking 2 brothers
       lFollow   =tree_getNextReal(lCurrent);
       lPreceding=tree_getPrevReal(lCurrent);
       tree_Link2Brothers(lPreceding:lFollow);
       //‚Linking to parent (before the greater)
       tree_LinkToParent(lParent:lCurrent:lGreater);
     P                 E
      //‚------------------------------------------------------------------- ---
      //‚get link following
      //‚------------------------------------------------------------------- ---
     ptree_getNextReal...
     p                 b
     d tree_getNextReal...
     d                 pi              *
     d  pLink_                         *   const
      *
     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;
       return link.next;
     p                 e
      //‚------------------------------------------------------------------- ---
      //‚get link preceding
      //‚------------------------------------------------------------------- ---
     ptree_getPrevReal...
     p                 b
     d tree_getPrevReal...
     d                 pi              *
     d  pLink_                         *   const
      *
     dLink             ds                  likeDs(tLink) based(pLink)
       pLink=pLink_;
       return link.prev;
     p                 e
      //‚--------------------------------------------------------------------
      //‚untied a link
      //‚--------------------------------------------------------------------
     ptree_untied      b                   export
     d tree_unTied     pi
     d  pLink_                         *
      *
     d link            ds                  likeDs(tLink) based(pLink)
     d parent          ds                  likeDs(tLink) based(pParent)
       if pLink_=*null;
         return;
       endIf;
       pLink=pLink_;
       pParent=Link.parent;
       if Link.next=pLink;
         parent.first=*null;
         return;
       elseif parent.first=pLink;
         parent.first=link.next;
       endif;
       tree_link2Brothers(link.prev:link.next);
     p                 e
      //‚--------------------------------------------------------------------
      //‚dealloc a link
      //‚--------------------------------------------------------------------
     ptree_dealloc     b                   export
     d tree_dealloc    pi
     d  lLink                          *
     d  pDeallocate                    *   const procptr options(*nopass)
     d  Deallocate     pr                  extproc(pDeallocate)
     d  pItem                          *
     d  pItem          s               *
       if lLink=*null;
         return;
       endIf;
       tree_dealloc2(lLink:pDeallocate);
       if pDeallocate<>*null;
         deallocate(lLink);
       endIf;
       pItem=tree_getItem(lLink);
       if pItem<>*null;
         dealloc(en) pItem;
       endIf;
       dealloc(en) lLink;
     p                 e
      //‚--------------------------------------------------------------------
      //‚dealloc a link (part 2)
      //‚--------------------------------------------------------------------
     ptree_dealloc2    b
     d tree_dealloc2   pi
     d  lLink                          *
     d  pDeallocate                    *   const procptr
      *
     d  lCurrent       s               *
     d  lNext          s               *
       lCurrent=tree_getFirst(lLink);
       dow lCurrent<>*null;
         lNext=tree_getNext(lCurrent);
         tree_dealloc(lCurrent:pDeallocate);
         lCurrent=lNext;
       endDo;
     p                 e
