# Reproduction Instruction
---

## Description
This is the manual to reproduce the scalability experiments for SCP special issue submission, entitled **Modelling and Verifying BDI Agents under Uncertainty**, in Advances in Formal Methods for Autonomous Systems.

As we have made clear that the complexity comes from the construction of the transition systems in Bigraph level, the experiments are done directly in the Bigraph level. That said, to reproduce the experiments, there is no requirement on the knowledge of the bigraph per se other than following a serial command line instructions which we will give now. 

If you require assistance, please email:
please also send the email to corresponding author to [mengwei.xu@newcastle.ac.uk](mailto:mengwei.xu@newcastle.ac.uk)

---

## Reproduction

There are a list of .big file with self-explanatory names. 
For example, the file ```two_patches.big``` models the drone to suvey two patches given in Listing 4. 

To execute this model, as we have also attached a BigraphER binary in this directory, please can simply run the command of such as

```./bigrapher full -p one_patch.tra -l one_patch.csl --solver=MCARD -M 100000 one_patch.big```

If no permission to Bigrapher, please run ```chmod u+x ./bigrapher``` first

The first command line is to take an input of a bigraph model and outputs the transition system, i.e. ```one_patch.tra``` and the labels i.e. ```one_patch.csl```. It should also output the computational insights such as transitions, number of states, and construction time. 

To conduct the verification through PRISM, please first add the following property to the end of .csl file. Just copy and paste will do the trick here. 

**Pmin=? [ F ("predicate_flood_patch1" &  "predicate_report_back_patch1")]**
**Pmax=? [ F ("predicate_flood_patch1" &  "predicate_report_back_patch1")]**


Then run the command line 
```prism -importtrans one_patch.tra one_patch.csl```

Make sure you haver *prism* in any of your /bin folder in this case, or you can use the prism binary in the directory where the PRISM is installed. 


This above instruction can be applied to the rest of files. For example, the file ````action_4_effects.big````  is to model the drone with two patches to survey but each action has five outcomes of uncertain effects.  




## Copyright and license

Copyright 2012-2022 Glasgow Bigraph Team 

All rights reserved. Tools distributed under the terms of the Simplified BSD License that can be found in the [LICENSE file](LICENSE.md)