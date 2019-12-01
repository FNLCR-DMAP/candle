UPDATE:

For simplicity now only a single input file is required (rather than three); this is the file with the ".in" extension.  This new input file contains three sections, each containing what the original three input files contained.

In other words, rather than requiring the three input files submit_candle_job.sh, mnist_default_params.txt, and grid_workflow-mnist.txt, all that is required is grid_example.in.  While for the time being the command "candle import-template grid" will copy over all FOUR of these files, you only really need the fourth of these (grid_example.in).  You can safely delete the other three (submit_candle_job.sh, mnist_default_params.txt, grid_workflow-mnist.txt).

Now, instead of running the job like "candle submit-job submit_candle_job.sh", you should run the job like "candle submit-job grid_example.in".  For the time being, for backwards compatibility, the former method of running the job is still supported.

Of course, as usual the model script is always required (which in this case is mnist_mlp.py).
