# CAN-Verify

---

## Description

This git repository is the extension of the original [CAN-verify](https://zenodo.org/records/8282684) to support the reasoning of uncertain beliefs through epistemic states. 

If you have any question installing it or question, please send the email to corresponding author to mengwei.xu@newcastle.ac.uk. 

---
## Quick Start


We recommand building program in Ubuntu (which has been succesfully tested).

glibc version requires 2.34 or above

We have pre-combined the main binary and dependency binary in folder ```./bins``` required whereever we can to run the tool.

1. ./CAN-Verify is the main binary (as its name indicates)
2. ./bigrapher is the binary for dependency tool BigraphER




To get the binary for PRISM, we have provided the source code (for Linux x86) downloaded directly from the PRISM website.

- extract the prism source code
- navigate to the folder as current path
- simply run ```./install.sh``` 


To allow the binary dependencies to be discovered, please set these in your PATH, 

e.g. ```export PATH=$PATH:./bins:./bins/prism-4.8-linux64-x86: ```

You may also need to run ```chmod u+x bigrapher``` to use dependency binary bigrapher. 




---

## How to build the program from the source codes



### Built locally

To build the project and have an executable binary ```./CAN-Verify```, please first obtain the following dependency

#### Dependencies
1. Java 17 (or above), 
2. PRISM model checker: http://www.prismmodelchecker.org/download.php
3. BigraphER: https://uog-bigraph.bitbucket.io/
4. Opam/OCaml: ```sudo apt install ocaml opam```
5. packages for OCaml: dune, dune-configurator, jsonm, menhir, cmdliner, ppx_optcomp, mtime, zarith, odoc -- ```opam install dune dune-configurator jsonm menhir cmdliner ppx_optcomp mtime zarith odoc```


##### Dependencies note for 2 and 3


To allow the binary dependencies to be discovered, please set these in your PATH, 

e.g. ```export PATH=$PATH:./bins:./bins/prism-4.8-linux64-x86: ```

You may also need to run ```chmod u+x bigrapher``` to use dependency binary bigrapher. 

#### Build the program

run : ``` make ```  



---


## Usage


Run ```./CAN-Verify  [options] [-p prop.txt] <file.can>```

### Options: ``` [options] ```

```-static```: to perform a static check of ```file.can``` 

```-dynamic```: to perform a dynamic check with BigraphER and PRISM   

```-p```: to tell the program which file contains the properties to verify  

```-Ms```: to tell the maximum number of states possible (default: 4000)  

```-mp```: to tell the minimum number of plan required (default: 2)  

```-Mp```: to tell the maximum number of plan allowed (default: 100)  

```-mc```: to tell the minimum number of character required in a name (default: 2)  

```-Mc```: to tell the maximum number of character allowed in a name (default: 20)

```-big```:  to export the CAN model to .big file

```--help```:  to display this list of options

### Belief-based property specifications: ``` [-p prop.txt] ```

the current implementation support the input in ```prop.txt``` of the following 

1. What is the maximum probability that eventually the belief ```predicate``` holds
2. What is the minimum probability that eventually the belief ```predicate``` holds
3. What is the maximum probability that eventually the belief (```predicate1```,```predicate2```, ...,```predicaten```) holds
4. What is the minimum probability that eventually the belief (```predicate1```,```predicate2```, ...,```predicaten```) holds

The first two are for the single belief predicate whereas the last two are for the conjunction of belief predicates. 



### run examples
The project provides a running example, marine.can and marine.txt. 

Examples are included in the folder ```paper_examples/```. 

please run the command


```./CAN-Verify -dynamic -p paper_examples/marine.txt paper_examples/marine.can```

#### for a quick check

for the exmaple in marine, you should get the following

> Model checking: Pmin=? [ F ("no_failure"&(X "empty_intention")) ] ... Result: 0

there mean that there is a case that the mission can fail eventually.

> Model checking: Pmax=? [ F ("no_failure"&(X "empty_intention")) ] ... Result: 0.81

there mean that the maximum probability that the mission can succeed eventually is 0.81.


> Model checking: 

> Pmax=? [ F ("predicate_thruster_functional" & "predicate_pipe_found" & "predicate_report_sent") ];

This property asks what is the maximum probability that eventually the conjunction of these beliefs hold

> Result 0.73





### Advance usage for strategy synthesis (which is not currently supported for full automation)
We use the running example of submarine to illustrate how to do it

#### Step 1

use CAN-Verify to translate the CAN+ file to Bigraph model

```./CAN-Verify -big paper_examples/marine.can```

#### Step 2

add the relevant bigraph labellings to generated ```marine_1.big``` file in ```paper_examples/``` folder.


```
big predicate_thruster_functional = B("thruster_functional").(T | id);
big predicate_pipe_found = B("pipe_found").(T | id);
big predicate_report_sent = B("report_sent").(T | id);
```

after 
```
big failure = Intent.(ReduceF | id);
big no_failure = Intent.(Nil | id);
big empty_intention = Intentions.1;
```

Change 

```preds = {failure, no_failure, empty_intention};```

to


```preds = {failure, no_failure, empty_intention, predicate_thruster_functional, predicate_pipe_found, predicate_report_sent};```

#### Step 3

navigate the ```paper_examples/``` folder and run the command to generate the labelled transition system

```bigrapher full -p marine.tra -l marine.csl --solver=MCARD marine_1.big```

and add the following to ```marine.csl``` file
```
Pmin=? [ F ("no_failure"&(X "empty_intention")) ];
Pmax=? [ F ("no_failure"&(X "empty_intention")) ];
Pmin=? [ F ("failure"&(X "empty_intention")) ];
Pmax=? [ F ("failure"&(X "empty_intention")) ];
Pmax=? [ F ("predicate_thruster_functional" & "predicate_pipe_found" & "predicate_report_sent") ];
```
#### Step 4

run the command 

```
prism -importtrans marine.tra marine.csl -pf 'Pmax=? [ F ("predicate_thruster_functional"&"predicate_pipe_found"&"predicate_report_sent")]' -exportadvmdp adv.tra
```
The returned ```adv.tra``` is the strategy mapping the state to the actions. 


## Copyright and license
All rights reserved. Tools distributed under the terms of the Simplified BSD License that can be found in the [LICENSE file](LICENSE.md).