# detom - A personal project

_Combien de temps?_

A minimal command line interface for tracking time spent against projects of clients.

Time is manually logged in minutes or hours, either today or for a specified date.

This project is a small, personal project that I don't expect anyone else to use seriously.
If you do think this is something that you might use, please [let me know on Twitter](https://twitter.com/njpearman).

Installation is as one would expect:

```
   gem install detom
```

## Motivation
This is a toy project that allows me to practice a few different things:

* Think about the design of command line apps.
* Practice the topics covered in Build Awesome Command Line Applications in Ruby 2 by David Copeland, published by The Pragmatic Bookshelf but seemingly now out of print (which is a great shame because it's a great book)
* Think about what's important when recording time spent on projects and clients.
* Practice writing and testing Ruby code.

## Commands

For detailed instructions on commands, use `detom --help` and `detom <command> --help`.

`detom clients`

Lists all clients that have time recorded against them, and the total amount of time in minutes.

`detom record`

Allows an amount of time in minutes to be added to a client / project. Optionally can be set to a different date of the same year.

## Commands to implement

* `archive`
* `mark`
