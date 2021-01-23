I'm trying to develop a modular logic game engine and have decided that Prolog is perhaps the most suitable development environment. There are several reasons for this:  

1. Adventures tend to be a collection of logic puzzles - the prolog paradigm is based on logic.
2. Prototyping in prolog is fast and simple, you just enter the facts and the rules (getting the rules right is a wee bit tricky at times)
3. There are several free prolog implementations:
   * Gnu prolog - part of the unix free software initiative and perfectly adequate
   * Swi Prolog - very easy to use and great for development. Problems with compiling and hiding code for distribution
   * Ciao - a massive logic development system with excellent compilation facilities. Including files seems to be based on modules that have to be compiled with the base file, this complicates the development cycle.  

Cons:  

1. Distribution. All the Prolog systems can run files essentially as scripts and can consult other data files. This is a problem for distributed programs:
   - No code hiding - the user can alter the code
   - The user needs knowledge of Prolog
2. All compile to their native systems, but cross-compilation seems to require compilation on the intended system of use
3. I have yet to find a way of compiling for use on mobile devices.

See [languages.md](./languages.md)
  
