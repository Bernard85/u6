      //‚enviroment tags
     d cFile           c                   CONST('FILE')
     d cFmt            c                   CONST('FMT')
     d cForm           c                   CONST('FORM')
     d cJournal        c                   CONST('JRN')
     d cData           c                   CONST('DTA')
     d cGrid           c                   CONST('GRID')
      //‚get file name
     d env_getFileName...
     d                 pr           255a   varying
     d   TAG                         10A   const varying
     d   fileID                     255a   const varying
      //‚get path
     d env_getPath...
     d                 pr           255a   varying
     d   TAG                         10A   const varying
      //‚get extension
     d env_getExt...
     d                 pr           255a   varying
     d   TAG                         10A   const varying
      //‚get extension
     d env_getExt$...
     d                 pr           255a   varying
     d   TAG                         10A   const varying
      //‚get Welcome Message
     denv_getWelcomeMessage...
     d                 pr           255a   varying
