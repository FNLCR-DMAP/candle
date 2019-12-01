UPDATE:

For simplicity now only a single input file is required (rather than three); this is the file with the ".in" extension.  This new input file contains three sections, each containing what the original three input files contained.

In other words, rather than requiring the three input files submit_candle_job.sh, feature-reduction-R_default_params.txt, and grid_workflow-feature-reduction-R.txt, all that is required is r_example.in.  While for the time being the command "candle import-template r" will copy over all FOUR of these files, you only really need the fourth of these (r_example.in).  You can safely delete the other three (submit_candle_job.sh, feature-reduction-R_default_params.txt, grid_workflow-feature-reduction-R.txt).

Now, instead of running the job like "candle submit-job submit_candle_job.sh", you should run the job like "candle submit-job r_example.in".  For the time being, for backwards compatibility, the former method of running the job is still supported.

Of course, as usual the model script is always required (which in this case is feature-reduction.R).
