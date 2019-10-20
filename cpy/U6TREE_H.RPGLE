      //‚Link kind
     d kLink           c                   const('#')
      //‚for bringing item
     d tree_Item       ds                  qualified
     d  ptr                            *   inz(*null)
     d  kind                          1a   inz('?')
      //‚get new link
     dtree_getNewLink  pr              *
     d pItem                           *   const
      //‚get new item (init)
     dtree_getNewItem  pr              *
     d pTemplate                       *   const
     d sizeTemplate                   5u 0 const
      //‚Open a link
     dtree_OpenLink    pr
     d pLink                           *   const
      //‚close a link
     dtree_closeLink   pr
     d   pLink                         *   const
      //‚get flag of a link
     dtree_getFlag     pr              n
     d  pLink_                         *   const
     d  iFlag                         3u 0 const
      //‚set flag of a link
     dtree_setFlag     pr
     d  pLink_                         *   const
     d  iFlag                         3u 0 const
     d  status                         n   const
      //‚Link a node to its parent
     dtree_linkToParent...
     d                 pr
     d pParentLink_                    *   const
     d pNewLink_                       *   const
     d pNextLink_                      *   const options(*nopass)
      //‚get item from a node
     d tree_getItem    pr              *
     d  pLink_                         *   const
      //‚get kind of a link
     d tree_getKind    pr             1a
     d  pLink_                         *   const
      //‚get first link
     d tree_getFirst   pr              *
     d  pLink_                         *   const
      //‚force first child
     d tree_setFirst   pr
     d  lItem                          *   const
      //‚get level of a link
     d tree_getLevel   pr             3i 0
     d  pLink_                         *   const
      //‚get option of a link
     d tree_getOption  pr             2a
     d  pLink_                         *   const
      //‚set option of a link
     d tree_setOption  pr
     d  pLink_                         *   const
     d  option                        2a   const
      //‚get true if the link is open
     d tree_isOpen     pr              n
     d  pLink_                         *   const
      //‚get parent
     d tree_getParent  pr              *
     d  pLink_                         *   const
      //‚get current link
     dtree_getCurrent  pr              *
     d  pLink                          *   const
     d  pValidator_                    *   const procptr options(*nopass)
      //‚get next link
     d tree_getNext    pr              *
     d  pLink_                         *   const
     d  pValidator_                    *   const procptr options(*nopass)
      //‚get next link in Loop
     d tree_getNextInLoop...
     d                 pr              *
     d  pLink                          *   const
      //‚get previous link
     d tree_getPrev    pr              *
     d  pLink_                         *   const
     d  pValidator_                    *   const procptr options(*nopass)
      //‚get the next row to sisplay
     d tree_getNextToDisplay...
     d                 pr              *
     d  pRoot                          *   const
     d  pLink_                         *   const
   69d  pValidator_                    *   const procptr options(*nopass)
      //‚get the first link to display
     d tree_getFirstToDisplay...
     d                 pr              *
     d  pLink_                         *   const
     d  pValidator_                    *   const procptr options(*nopass)
      //‚get previous row to display
     d tree_getPrevToDisplay...
     d                 pr              *
     d  pRoot                          *   const
     d  pLink_                         *   const
     d  pValidator_                    *   const procptr options(*nopass)
      //‚get the last of last to display
     d tree_getLastOfLastToDisplay...
     d                 pr              *
     d  pLink_                         *   const
     d  pValidator_                    *   const procptr options(*nopass)
      //‚xml --> tree
     dtree_xml2tree    pr              *
     d path                         255a   varying const
     d XXX_GetNewItem                  *   procptr const
      //‚get item from list by ID
     d tree_getLinkfromList...
     d                 pr              *
     d  lItems                         *   const
     d  kind                          1a   const
     d  ID                          255a   const varying options(*nopass)
      //‚get last
     d tree_getLast    pr              *
     d  pLink_                         *   const
      //‚link is of the kind
     d tree_isOfTheKind...
     d                 pr              n
     d  kind                          1a   const
     d  pLink_                         *   const
     d  pItem                          *   options(*nopass)
      //‚Sort childs of a link
     D tree_sort       Pr
     D   lParent                       *   const
     D   pComparator                   *   const procptr
      //‚Link 2 brothers
     d tree_Link2Brothers...
     d                 pr
     d  pLink1_                        *   const
     d  pLink2_                        *   const
      //‚untied a link
     d tree_unTied     pr
     d  pLink_                         *
      //‚dealloc a link
     d tree_dealloc    pr
     d  lLink                          *
     d  pDeallocate                    *   const procptr options(*nopass)
      //‚dealloc childs of a link
     d tree_deallocChilds...
     d                 pr
     d  lLink                          *   const
     d  pDeallocate                    *   const procptr
