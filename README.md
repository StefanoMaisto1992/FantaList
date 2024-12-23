This is a simple project to select a list of player in to another one -> Favourite player

L'App non contiene librerie di terze parti -
- L'architettura dell'app basata sul framework UIkit nativo di iOS non fa uso di storyboards
- Il pattern dell'app è un ibrido tra MVVM ed una clean Arch
- Il repositoty è un Actor per ovviare problemi di race conditions , ma anche un classico singleton avrebbe potuto compiere le medesime operazioni
- la persistenza dei giocatoriu preferiti è salvata nello user defaults in modo _light_ salvando solo gli id (Interi) dei primitivi all'interno di un array.
- Vi sono solo due componenti custom una cella ed un componenet custom per la ricerca.
- L'architettura è fatta in modo che un repositoty ed i suoi casi d'uso esposti possono essere testate ed utilizzati in qualsiasi altro punto dell'applicazione.

** Alternative all'utilizzo dello userdefaults che non è pensato per strutture dati complesse potrebbero essere state le seguneti ->
- Usare il File System (archiviazione su disco) se si necessitano salvare più info  su ogni giocatore (ad esempio, l'intero oggetto Player), per archiviare i dati in un file JSON
- Core data , un framework di gestione dei dati che ti permette di memorizzare oggetti strutturati in modo persistente, come il caso dei tuoi giocatori preferiti.

