# ConsoleColors
Powershell Helper Functions for Console Color registry edits

  I've been messing around with creating themes to easily identify my various user context Powershell windows.
Colors are configured in the Shortcut File as well as the defaults in the registry. I needed a way to easily update my colors between systems, and I was bored, so I whipped this up. Its not pretty, or user friendly.

I use this with an Import-CSV (consisting of ColorTable##,Red,Green,Blue) and loop through creating New-Colors into an ArrayList, then passing that ArrayList to Create-RegFile, and performing a Merge.
