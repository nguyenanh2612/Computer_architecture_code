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
   - **'02_test'** : file data (instruction memory)
   - **'test_module_image'**: upload the test waveform of each module or block, also dump_test_bench file
   - **Update later**
3. **Update work to github from VSCode**
   - Pull data before working (always do it)
   - Commit & push to github
   - Wait the owner accept the request or messaging to ánh
4. **Control unit signal excel**
   - Link for single cycle & pipeline: https://docs.google.com/spreadsheets/d/1aaAOjJfxVr4wakKfACmRoRKg5aqppr6bIWHU7UIUbmI/edit?usp=sharing  
5. **Testbench**
   Chạy trên Console transcript của modelsim nha ko phải coi waveform. 
   Tao có hệ thống lại một tí như sau: 
      + Với FETCH, thì sẽ test câu lênh đưa ra nếu đúng thì PASS hết ko thì sẽ FAILED và câu lệnh sai. 
      + Với DECODE, test lại cách lưu ghi, đọc với regfile và hoạt động của ImmGen (phần này t hơi lười ae có được thì thêm test phần này thêm 1 số trường hợp nha t mới test trường hợp default: 0 thôi=)) ).  
      

