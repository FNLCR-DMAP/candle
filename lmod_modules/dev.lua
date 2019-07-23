-- George and I built this on 7/22/19

whatis("Version: dev")
whatis("URL: https://cbiit.github.com/sdsi/candle")
whatis("Description: Open source software for scalable hyperparameter optimization")

local app         = "candle"
local version     = "dev"
local base = "/data/BIDS-HPC/public/software/distributions/candle/dev"
-- local wrappers = "/data/BIDS-HPC/public/software/checkouts/dev/fnlcr-bids-sdsi/candle"

setenv("CANDLE", base) -- used by submit_candle_job.sh, run_without_candle.sh, and copy_candle_template.sh
-- setenv("CANDLE_WRAPPERS", wrappers)
setenv("SITE", "biowulf") -- used by submit_candle_job.sh
setenv("DEFAULT_PYTHON_MODULE", "python/3.6")
setenv("DEFAULT_R_MODULE", "R/3.5.0")
setenv("USE_OPENMPI", "1")

append_path("PATH", pathJoin(base,"wrappers/templates/scripts")) -- used only in order to find the copy_candle_template script

if (mode() == "load") then
    LmodMessage("[+] Loading  ", app, version, " ...")
end
if (mode() == "unload") then
    LmodMessage("[-] Unloading ", app, version, " ...")
end
