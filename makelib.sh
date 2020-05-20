#! /bin/bash
source build_settings

# set date and build libraries
ssh-keygen -R $1 &> /dev/null || true
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 $BBB_ADDRESS "date -s \"`date '+%Y%m%d %T %z'`\" > /dev/null"
ssh $BBB_ADDRESS "cd Bela && rm lib/*"
ssh $BBB_ADDRESS "cd Bela && make -f Makefile.libraries cleanall && make -f Makefile.libraries all"
ssh $BBB_ADDRESS "cd Bela && make lib && make libbelafull"