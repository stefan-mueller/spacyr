[![CRAN Version](https://www.r-pkg.org/badges/version/spacyr)](https://CRAN.R-project.org/package=spacyr) ![Downloads](https://cranlogs.r-pkg.org/badges/spacyr) [![Travis-CI Build Status](https://travis-ci.org/kbenoit/spacyr.svg?branch=master)](https://travis-ci.org/kbenoit/spacyr) [![Appveyor Build status](https://ci.appveyor.com/api/projects/status/jqt2atp1wqtxy5xd/branch/master?svg=true)](https://ci.appveyor.com/project/kbenoit/spacyr/branch/master) [![codecov.io](https://codecov.io/github/kbenoit/spacyr/coverage.svg?branch=master)](https://codecov.io/gh/kbenoit/spacyr/branch/master)

spacyr: an R wrapper for spaCy
==============================

This package is an R wrapper to the spaCy "industrial strength natural language processing" Python library from <http://spacy.io>.

Installing the package
----------------------

1.  Install or update Python on your system.

    macOS and Linux typically come with Python installed, although you may wish to install a newer or different version from <https://www.python.org/downloads/>.

    **Windows only:** If you have not yet installed Python, Download and install [Python for Windows](https://www.python.org/downloads/windows/). We recommend using Python 3, although the Python 2.7.x also works. During the installation process, be sure to scroll down in the installation option window and find the "Add Python.exe to Path", and click on the small red "x."

    For the installation of `spaCy` and **spacyr** in macOS (in homebrew and for the default Python) and Windows you can find more detailed instructions for a [Mac OS X Installation](inst/doc/MAC.md) and [Windows Installation](inst/doc/WINDOWS.md).

2.  Install additional command-line compiler tools.

    -   Windows:
        -   Install \[Virtual Studio Express 2015\]([here](https://www.visualstudio.com/post-download-vs/?sku=xdesk&clcid=0x409&telem=ga#).
        -   Install [RTools](https://cran.r-project.org/bin/windows/Rtools/).
    -   macOS:

    Either install XCode from the App Store, or an abbreviated version using the following from Terminal:

    ``` bash
    xcode-select --install
    ```

    -   Linux: no additional tools are required.

3.  Install spaCy.

    Installation instructions for spaCy are available [from spacy.io](https://spacy.io/docs/usage/). In short, once Python is installed on your system:

    ``` bash
    pip install -U spacy
    python -m spacy download en
    ```

    You can test your installation at the command line using:

    ``` bash
    python -c "import spacy; spacy.load('en'); print('OK')"
    ```

    Additional instructions are available from the spaCy website for installing using a [`virtualenv`](https://spacy.io/docs/usage/#pip) or an [Anaconda](https://spacy.io/docs/usage/#conda) installation.

4.  Install the **spacyr** R package:

    To install the latest package from source, you can simply run the following.

    ``` r
    devtools::install_github("kbenoit/spacyr", build_vignettes = FALSE)
    ```

    **Coming soon**: Installation from CRAN will be possible using standard methods.

<a name="multiplepythons"></a>Multiple Python executables in your system
------------------------------------------------------------------------

If you have multiple Python executables in your systems (for instance if you are a macOS user and have installed Python 3, you will also have the system-installed Python 2.7.x), then the `spacy_initialize()` function will check whether each of them have spaCy installed or not.
You can also specify the python executable directly, when calling `spacy_initialize()`. For instance, if your installation of spaCy uses `/usr/local/bin/python`, then you could use:

``` r
library(spacyr)
spacy_initialize(python_executable = "/usr/local/bin/python")
```

Comments and feedback
---------------------

We welcome your comments and feedback. Please file issues on the [issues](https://github.com/kbenoit/spacyr/issues) page, and/or send us comments at <kbenoit@lse.ac.uk> and <A.Matsuo@lse.ac.uk>.

A walkthrough of **spacyr**
---------------------------

### Starting a **spacyr** session

To allow R to access the underlying Python functionality, it must open a connection by being initialized within your R session.

We provide a function for this, `spacy_initialize()`, which attempts to make this process as painless as possible by searching your system for Python executables, and testing which have spaCy installed. For power users (such as those with multiple installations of Python), it is possible to specify the path manually through the `python_executable` argument, which also makes initialization faster.

``` r
require(spacyr)
## Loading required package: spacyr
spacy_initialize()
## Finding a python executable with spacy installed...
## spaCy (language model: en) is installed in /usr/local/bin/python
## successfully initialized (spaCy Version: 1.8.2, language model: en)
```

### Tokenizing and tagging texts

The `spacy_parse()` is **spacyr**'s main function. It calls spaCy both to tokenize and tag the texts. It provides two options for part of speech tagging, plus options to return word lemmas, entity recognition, and dependency parsing. It returns a `data.frame` corresponding to the emerging [*text interchange format*](https://github.com/ropensci/tif) for token data.frames.

The approach to tokenizing taken by spaCy is inclusive: it includes all tokens without restrictions, including punctuation characters and symbols.

Example:

``` r
txt <- c(d1 = "spaCy excels at large-scale information extraction tasks.",
         d2 = "Mr. Smith goes to North Carolina.")

# process documents and obtain a data.table
parsedtxt <- spacy_parse(txt)
parsedtxt
##    doc_id sentence_id token_id       token       lemma   pos   entity
## 1      d1           1        1       spaCy       spacy  NOUN         
## 2      d1           1        2      excels       excel  VERB         
## 3      d1           1        3          at          at   ADP         
## 4      d1           1        4       large       large   ADJ         
## 5      d1           1        5           -           - PUNCT         
## 6      d1           1        6       scale       scale  NOUN         
## 7      d1           1        7 information information  NOUN         
## 8      d1           1        8  extraction  extraction  NOUN         
## 9      d1           1        9       tasks        task  NOUN         
## 10     d1           1       10           .           . PUNCT         
## 11     d2           1        1         Mr.         mr. PROPN         
## 12     d2           1        2       Smith       smith PROPN PERSON_B
## 13     d2           1        3        goes          go  VERB         
## 14     d2           1        4          to          to   ADP         
## 15     d2           1        5       North       north PROPN    GPE_B
## 16     d2           1        6    Carolina    carolina PROPN    GPE_I
## 17     d2           1        7           .           . PUNCT
```

Two fields are available for part-of-speech tags. The `pos` field returned is the [Universal tagset for parts-of-speech](http://universaldependencies.org/u/pos/all.html), a general scheme that most users will find serves their needs, and also that provides equivalencies across langages. **spacyr** also provides a more detailed tagset, defined in each spaCy language model. For English, this is the [OntoNotes 5 version of the Penn Treebank tag set](https://spacy.io/docs/usage/pos-tagging#pos-tagging-english).

``` r
spacy_parse(txt, tag = TRUE, entity = FALSE, lemma = FALSE)
##    doc_id sentence_id token_id       token   pos  tag
## 1      d1           1        1       spaCy  NOUN   NN
## 2      d1           1        2      excels  VERB  VBZ
## 3      d1           1        3          at   ADP   IN
## 4      d1           1        4       large   ADJ   JJ
## 5      d1           1        5           - PUNCT HYPH
## 6      d1           1        6       scale  NOUN   NN
## 7      d1           1        7 information  NOUN   NN
## 8      d1           1        8  extraction  NOUN   NN
## 9      d1           1        9       tasks  NOUN  NNS
## 10     d1           1       10           . PUNCT    .
## 11     d2           1        1         Mr. PROPN  NNP
## 12     d2           1        2       Smith PROPN  NNP
## 13     d2           1        3        goes  VERB  VBZ
## 14     d2           1        4          to   ADP   IN
## 15     d2           1        5       North PROPN  NNP
## 16     d2           1        6    Carolina PROPN  NNP
## 17     d2           1        7           . PUNCT    .
```

For the German language model, the Universal tagset (`pos`) remains the same, but the detailed tagset (`tag`) is the [TIGER Treebank](https://spacy.io/docs/usage/pos-tagging#pos-tagging-german) scheme.

### Extracting entities

**spacyr** can extract entities, either named or ["extended"](https://spacy.io/docs/usage/entity-recognition#entity-types).

``` r
parsedtxt <- spacy_parse(txt, lemma = FALSE)
entity_extract(parsedtxt)
##   doc_id sentence_id         entity entity_type
## 1     d2           1          Smith      PERSON
## 2     d2           1 North Carolina         GPE
```

``` r
entity_extract(parsedtxt, type = "all")
##   doc_id sentence_id         entity entity_type
## 1     d2           1          Smith      PERSON
## 2     d2           1 North Carolina         GPE
```

Or, convert multi-word entities into single "tokens":

``` r
entity_consolidate(parsedtxt)
##    doc_id sentence_id token_id          token    pos entity_type
## 1      d1           1        1          spaCy   NOUN            
## 2      d1           1        2         excels   VERB            
## 3      d1           1        3             at    ADP            
## 4      d1           1        4          large    ADJ            
## 5      d1           1        5              -  PUNCT            
## 6      d1           1        6          scale   NOUN            
## 7      d1           1        7    information   NOUN            
## 8      d1           1        8     extraction   NOUN            
## 9      d1           1        9          tasks   NOUN            
## 10     d1           1       10              .  PUNCT            
## 11     d2           1        1            Mr.  PROPN            
## 12     d2           1        2          Smith ENTITY      PERSON
## 13     d2           1        3           goes   VERB            
## 14     d2           1        4             to    ADP            
## 15     d2           1        5 North_Carolina ENTITY         GPE
## 16     d2           1        6              .  PUNCT
```

### Dependency parsing

Detailed parsing of syntactic dependencies is possible with the `dependency = TRUE` option:

``` r
spacy_parse(txt, dependency = TRUE, lemma = FALSE, pos = FALSE)
##    doc_id sentence_id token_id       token head_token_id  dep_rel   entity
## 1      d1           1        1       spaCy             2    nsubj         
## 2      d1           1        2      excels             2     ROOT         
## 3      d1           1        3          at             2     prep         
## 4      d1           1        4       large             6     amod         
## 5      d1           1        5           -             6    punct         
## 6      d1           1        6       scale             7 compound         
## 7      d1           1        7 information             9 compound         
## 8      d1           1        8  extraction             9 compound         
## 9      d1           1        9       tasks             3     pobj         
## 10     d1           1       10           .             2    punct         
## 11     d2           1        1         Mr.             2 compound         
## 12     d2           1        2       Smith             3    nsubj PERSON_B
## 13     d2           1        3        goes             3     ROOT         
## 14     d2           1        4          to             3     prep         
## 15     d2           1        5       North             6 compound    GPE_B
## 16     d2           1        6    Carolina             4     pobj    GPE_I
## 17     d2           1        7           .             3    punct
```

### Using other language models

By default, **spacyr** loads an English language model in spacy, but you also can load a German language model (or others) instead by specifying `model` option when calling `spacy_initialize()`.

``` r
## first finalize the spacy if it's loaded
spacy_finalize()
spacy_initialize(model = "de")
## Python space is already attached.  If you want to swtich to a different Python, please restart R.
## successfully initialized (spaCy Version: 1.8.2, language model: de)

txt_german <- c(R = "R ist eine freie Programmiersprache für statistische Berechnungen und Grafiken. Sie wurde von Statistikern für Anwender mit statistischen Aufgaben entwickelt.",
               python = "Python ist eine universelle, üblicherweise interpretierte höhere Programmiersprache. Sie will einen gut lesbaren, knappen Programmierstil fördern.")
results_german <- spacy_parse(txt_german, dependency = TRUE, lemma = FALSE, tag = TRUE)
results_german
##    doc_id sentence_id token_id              token   pos   tag
## 1       R           1        1                  R     X    XY
## 2       R           1        2                ist   AUX VAFIN
## 3       R           1        3               eine   DET   ART
## 4       R           1        4              freie   ADJ  ADJA
## 5       R           1        5 Programmiersprache  NOUN    NN
## 6       R           1        6                für   ADP  APPR
## 7       R           1        7       statistische   ADJ  ADJA
## 8       R           1        8       Berechnungen  NOUN    NN
## 9       R           1        9                und  CONJ   KON
## 10      R           1       10           Grafiken  NOUN    NN
## 11      R           1       11                  . PUNCT    $.
## 12      R           2        1                Sie  PRON  PPER
## 13      R           2        2              wurde   AUX VAFIN
## 14      R           2        3                von   ADP  APPR
## 15      R           2        4       Statistikern  NOUN    NN
## 16      R           2        5                für   ADP  APPR
## 17      R           2        6           Anwender  NOUN    NN
## 18      R           2        7                mit   ADP  APPR
## 19      R           2        8      statistischen   ADJ  ADJA
## 20      R           2        9           Aufgaben  NOUN    NN
## 21      R           2       10         entwickelt  VERB  VVPP
## 22      R           2       11                  . PUNCT    $.
## 23 python           1        1             Python PROPN    NE
## 24 python           1        2                ist   AUX VAFIN
## 25 python           1        3               eine   DET   ART
## 26 python           1        4        universelle   ADJ  ADJA
## 27 python           1        5                  , PUNCT    $,
## 28 python           1        6      üblicherweise   ADV   ADV
## 29 python           1        7     interpretierte   ADJ  ADJA
## 30 python           1        8             höhere   ADJ  ADJA
## 31 python           1        9 Programmiersprache  NOUN    NN
## 32 python           1       10                  . PUNCT    $.
## 33 python           2        1                Sie  PRON  PPER
## 34 python           2        2               will  VERB VMFIN
## 35 python           2        3              einen   DET   ART
## 36 python           2        4                gut   ADJ  ADJD
## 37 python           2        5           lesbaren   ADJ  ADJA
## 38 python           2        6                  , PUNCT    $,
## 39 python           2        7            knappen   ADJ  ADJA
## 40 python           2        8    Programmierstil  NOUN    NN
## 41 python           2        9            fördern  VERB VVINF
## 42 python           2       10                  . PUNCT    $.
##    head_token_id dep_rel   entity
## 1              2      sb         
## 2              2    ROOT         
## 3              5      nk         
## 4              5      nk         
## 5              2      pd         
## 6              5     mnr         
## 7              8      nk         
## 8              6      nk         
## 9              8      cd         
## 10             9      cj         
## 11             2   punct         
## 12             2      sb         
## 13             2    ROOT         
## 14            10     sbp         
## 15             3      nk         
## 16             4     mnr         
## 17             5      nk         
## 18            10      mo         
## 19             9      nk         
## 20             7      nk         
## 21             2      oc         
## 22             2   punct         
## 23             2      sb PERSON_B
## 24             2    ROOT         
## 25             9      nk         
## 26             9      nk         
## 27             4   punct         
## 28             7      mo         
## 29             4      cj         
## 30             4  cj||cj         
## 31             2      pd         
## 32             2   punct         
## 33             2      sb         
## 34             2    ROOT         
## 35             8      nk         
## 36             5      mo         
## 37             8      nk         
## 38             5   punct         
## 39             5      cj         
## 40             9      oa         
## 41             2      oc         
## 42             2   punct
```

Note that the additional language models must first be installed in spaCy. The German language model can be installed (`python -m spacy download de`) before you call `spacy_initialize()`.

### When you finish

A background process of spaCy is initiated when you ran `spacy_initialize()`. Because of the size of language models of spaCy, this takes up a lot of memory (typically 1.5GB). When you do not need the Python connection any longer, you can finalize the python connection (and terminate the process) by calling the `spacy_finalize()` function.

``` r
spacy_finalize()
```

By calling `spacy_initialize()` again, you can restart the backend spaCy.

Using **spacyr** with other packages
------------------------------------

### **quanteda**

Some of the token- and type-related standard methods from [**quanteda**](http://githiub.com/kbenoit/quanteda) also work on the new tagged token objects:

``` r
require(quanteda, warn.conflicts = FALSE, quietly = TRUE)
## quanteda version 0.9.9.61
## Using 3 of 4 cores for parallel computing
docnames(parsedtxt)
## [1] "d1" "d2"
ndoc(parsedtxt)
## [1] 2
ntoken(parsedtxt)
## d1 d2 
## 10  7
ntype(parsedtxt)
## d1 d2 
## 10  7
```

### Conformity to the *Text Interchange Format*

The [Text Interchange Format](https://github.com/ropensci/tif) is an emerging standard structure for text package objects in R, such as corpus and token objects. `spacy_initialize()` can take a TIF corpus data.frame or character object as a valid input. Moreover, the data.frames returned by `spacy_parse()` and `entity_consolidate()` conform to the TIF tokens standard for data.frame tokens objects. This will make it easier to use with any text analysis package for R that works with TIF standard objects.
