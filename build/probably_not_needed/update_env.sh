#!/bin/bash

# Arguments:
#
#   -C output.txt -L log.txt -o output.tic -n 1 -t c -t C
#
#   /data/BIDS-HPC/public/candle/swift-t-install/stc/bin/stc -C output.txt -L log.txt -o output.tic -V hello-world.swift
#
#   /data/BIDS-HPC/public/candle/swift-t-install/turbine/bin/turbine -n 1 -c -C -V output.tic


if [ 0 -eq 1 ]; then

    module load gcc/7.2.0
    module load openmpi/3.0.0/gcc-7.2.0-pmi2
    module load python/3.6
    module load tcl_tk/8.6.8_gcc-7.2.0 # note that when I compiled the R libraries, I had this line above the python line
    module load R/3.5.0
    module load ant/1.10.3
    module load java/1.8.0_181 # didn't have this when compiling R libraries

fi

#/data/BIDS-HPC/public/candle/swift-t-install/stc/bin/stc -C output.txt -L log.txt -o output.tic -V hello-world.swift

#/data/BIDS-HPC/public/candle/swift-t-install/stc/bin/stc -C output.txt -L log.txt -o output.tic -V test.swift

#/data/BIDS-HPC/public/candle/swift-t-install/stc/bin/stc -C output.txt -L log.txt -o myprog.tic -V mytest.swift

#/data/BIDS-HPC/public/candle/swift-t-install/stc/bin/stc -C output.txt -L log.txt -o myprog.tic -V types.swift



#/data/BIDS-HPC/public/candle/swift-t-install/turbine/bin/turbine -n 1 -c -C -V output.tic

#/data/BIDS-HPC/public/candle/swift-t-install/turbine/bin/turbine -n 3 -V output.tic

#/data/BIDS-HPC/public/candle/swift-t-install/turbine/bin/turbine -n 4 -V output.tic

# USE -l

#/data/BIDS-HPC/public/candle/swift-t-install/turbine/bin/turbine -l -n 6 -V myprog.tic


#export TURBINE_LOG=1
#export TURBINE_FOO_WORK_WORKERS=2
export ADLB_DEBUG_RANKS=1
export ADLB_DEBUG_HOSTMAP=1
/data/BIDS-HPC/public/candle/swift-t-install/stc/bin/swift-t -l -n 5 mytest2.swift


if [ 0 -eq 1 ]; then

    pushd /data/BIDS-HPC/public/candle/Supervisor
    git pull
    popd

    pushd /data/BIDS-HPC/public/candle/Candle
    git pull
    popd

    export R_LIBS=/data/BIDS-HPC/public/candle/R/libs/
    /data/BIDS-HPC/public/candle/Supervisor/workflows/common/R/install-candle.sh

    export R_LIBS=/data/BIDS-HPC/public/candle/R/libs/
    /data/BIDS-HPC/public/candle/swift-t/dev/build/build-swift-t.sh -v

fi

#/data/BIDS-HPC/public/candle/swift-t-install/stc/bin/swift-t hello-world.swift
