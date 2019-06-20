whatis("Version: main")
whatis("URL: https://cbiit.github.io/fnlcr-bids-hpc/documentation/candle")
whatis("Description: Open source software for scalable hyperparameter optimization")

local app         = "candle"
local version     = "main"
local base = "/data/BIDS-HPC/public/software/distributions/candle/main"
local wrappers = "/data/BIDS-HPC/public/software/checkouts/fnlcr-bids-sdsi/candle"

setenv("CANDLE", base) -- used by submit_candle_job.sh, run_without_candle.sh, and copy_candle_template.sh
setenv("CANDLE_WRAPPERS", wrappers)
append_path("PATH", pathJoin(wrappers,"templates/scripts")) -- used only in order to find the copy_candle_template script
setenv("SITE", "biowulf") -- used by submit_candle_job.sh
setenv("MODULES_FOR_BUILD", "python/3.6")
setenv("DEFAULT_R_MODULE", "R/3.5.0")
setenv("USE_OPENMPI", "1")

if (mode() == "load") then
    LmodMessage("[+] Loading  ", app, version, " ...")
end
if (mode() == "unload") then
    LmodMessage("[-] Unloading ", app, version, " ...")
end
