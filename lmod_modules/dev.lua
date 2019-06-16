 -- This is the development distribution, which can be understood by observing the symbolic links in /data/BIDS-HPC/public/software/distributions/candle/dev

whatis("Version: dev")
whatis("URL: https://cbiit.github.io/fnlcr-bids-hpc/documentation/candle")
whatis("Description: Open source software for scalable hyperparameter optimization")

local app         = "candle"
local version     = "dev"
local base = "/data/BIDS-HPC/public/software/distributions/candle/dev"

setenv("CANDLE", base) -- used by submit_candle_job.sh, run_without_candle.sh, and copy_candle_template.sh
-- append_path("PATH", pathJoin(base,"scripts")) -- used only in order to find the copy_candle_template script
append_path("PATH", pathJoin(base,"Supervisor/templates/scripts")) -- used only in order to find the copy_candle_template script
setenv("SITE", "biowulf") -- used by submit_candle_job.sh
setenv("TURBINE_HOME", pathJoin(base,"builds/swift-t-install/turbine"))
setenv("MODULES_FOR_BUILD", "python/3.6")
setenv("DEFAULT_R_MODULE", "R/3.5.2")

if (mode() == "load") then
    LmodMessage("[+] Loading  ", app, version, " ...")
end
if (mode() == "unload") then
    LmodMessage("[-] Unloading ", app, version, " ...")
end