# MILESTONE: COMPUTER ARCHITECHTURE

## Overview

Design 2 basic architechtures of RISC_V: single-cycle and pipelined. 

## Details

1. **Connect github to computer**
   - Dowload git for connection.
   - Press symbol 'code<>' at the top right of screen to get HTTP: link (copy that)
   - Press 'Source control' in the VSCode and choose .../clone
   - Paste link to the search toolbar
2. **Folder description**
   - **'00_src'**: source code
   - **'01_tb'** : testbench file
   - **'03_dump'** : file data (instruction memory)
   - **'test_module_image'**: upload the test waveform of each module or block, also dump_test_bench file
   - **Update later**
3. **Update work to github from VSCode**
   - Pull data before working (always do it)
   - Commit & push to github
   - Wait the owner accept the request or messaging to ánh
4. **Control unit signal excel**
   - Link for single cycle: https://docs.google.com/spreadsheets/d/1aaAOjJfxVr4wakKfACmRoRKg5aqppr6bIWHU7UIUbmI/edit?usp=sharing
   - link for pipeline    : update later
5. **Predicted question**
   - Data flow: 
      + Explain or show the longest datapath (signals change mode of each block). 
      + Shortest datapath. 
      + The different between R, I, BR, LOAD, STORE instructions. 
   - Code
      + Mode of some blocks (LSU, ALU)
      + The reason why we have 2 blocks (st_rewrite and ld_rewrite). 
      + FSM of SRAM IP Controller. 
      + Explain the concatenation of ImmGen module. 

## Note
  Any new ignores, it will be updated later.
      

