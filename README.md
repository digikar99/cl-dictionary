
## Background and Introduction

This is a library for creating and using dictionaries (in the context of languages), and may be useful for NLP work. Dictionaries are created and used in the form of [Trie](https://en.wikipedia.org/wiki/Trie), to facilitate faster lookup. 

It comes with a english.dict, made from the linux `/usr/share/dict/words` file.

## 1 Min Overview

A lot of libraries lack a "1 min overview". Here's the 1 min-overview: (In fact, this is the only overview.)

#### Packages and exported functions / macros

_dictionary_

- in-dict-p
- add-to-dict-p
- clean-dict
- write-dict

The documentation for each of these can be viewed using `(describe ,symbol-name)`. (Eg. `(describe 'in-dict-p)`.) 

#### Examples


```lisp
    CL-USER> (ql:quickload 'dictionary) 
    ;; assuming this is cloned in your projects directory
    To load "dictionary":
      Load 1 ASDF system:
        dictionary
    ; Loading "dictionary"
    [package dictionary]
    (DICTIONARY)

    CL-USER> (dictionary:in-dict-p "facilitate") ;; uses the english dictionary
    T

    CL-USER> (defvar dict '(0 (#\a (#\n (#\d NIL)) NIL (#\b NIL))))
    DICT

    CL-USER> (dictionary:in-dict-p "and" dict)
    T

    CL-USER> (dictionary:in-dict-p "an" dict)
    NIL

    CL-USER> (dictionary:add-to-dict "a" dict) ;; functional
    (0 (#\a (#\n (#\d NIL)) NIL (#\b NIL)))

    CL-USER> (dictionary:clean-dict input-file output-file)
    ;; Writes cleaned dictionary to the output file.
    ;; Input file is expected to be a new-line separated text file.
    ;; Cleaning keeps only words that start with lowercase letters.
    NIL

    CL-USER> (dictionary:write-dict input-file output-file)
    ;; Creates a dictionary from the words in the input file.
    ;; Input file is expected to be a new-line separated text file.
    ;; The dictionary is manipulated in the form of tries, implemented as lists.
    NIL

```
 
