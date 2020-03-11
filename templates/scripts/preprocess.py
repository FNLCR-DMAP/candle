def check_input():

    # Note: Just checking required (not optional) keywords for now
    # The input we're referring to is basically that from the input file. This current script runs at the start of run_workflows.sh.

    import os

    ################ Current keywords ######################################################################################
    # model_script
    model_script = os.getenv('MODEL_SCRIPT')
    if model_script is not None:
        try:
            with open(model_script):
                pass
        except IOError:
            print('ERROR: The file "{}" from the "model_script" keyword cannot be opened'.format(model_script))
    else:
        print('ERROR: The "model_script" keyword is not set in the &control section of the input file')
        exit()
    print('model_script: {}'.format(model_script))

    # workflow
    workflow = os.getenv('WORKFLOW')
    if workflow is not None:
        workflow = workflow.lower()
        valid_workflows = ('grid', 'bayesian')
        if workflow not in valid_workflows:
            print('ERROR: The "workflow" keyword in the &control section must be one of', valid_workflows)
            exit()
    else:
        print('ERROR: The "workflow" keyword is not set in the &control section of the input file')
        exit()
    print('workflow: {}'.format(workflow))

    # walltime
    walltime = os.getenv('WALLTIME')
    if walltime is None: # don't do error-checking for walltime
        print('ERROR: The "walltime" keyword is not set in the &control section of the input file')
        exit()
    print('walltime: {}'.format(walltime))

    # worker_type
    worker_type = os.getenv('WORKER_TYPE')
    valid_worker_types = ('cpu', 'k20x', 'k80', 'p100', 'v100', 'v100x')
    if worker_type is not None:
        worker_type = worker_type.lower()
        if worker_type not in valid_worker_types:
            #print('ERROR: The "worker_type" keyword in the &control section must be one of', valid_worker_types)
            print('WARNING: The "worker_type" keyword in the &control section must be one of', valid_worker_types)
            worker_type_is_valid = False
            #exit()
        else:
            worker_type_is_valid = True
        worker_type_is_set = True
    else:
        #print('ERROR: The "worker_type" keyword is not set in the &control section of the input file')
        print('WARNING: The "worker_type" keyword is not set in the &control section of the input file')
        worker_type_is_set = False
        #exit()
    if worker_type_is_set and worker_type_is_valid:
        print('worker_type: {}'.format(worker_type))

    # nworkers
    nworkers = os.getenv('NWORKERS')
    if nworkers is not None:
        nworkers = int(nworkers)
        if nworkers < 1:
            #print('ERROR: The "nworkers" keyword in the &control section must be a positive integer')
            print('WARNING: The "nworkers" keyword in the &control section must be a positive integer')
            nworkers_is_valid = False
            #exit()
        else:
            nworkers_is_valid = True
        nworkers_is_set = True
    else:
        #print('ERROR: The "nworkers" keyword is not set in the &control section of the input file')
        print('WARNING: The "nworkers" keyword is not set in the &control section of the input file')
        nworkers_is_set = False
        #exit()
    if nworkers_is_set and nworkers_is_valid:
        print('nworkers: {}'.format(nworkers))
    ########################################################################################################################


    ################ Deprecated keywords ###################################################################################
    # ngpus
    ngpus = os.getenv('NGPUS')
    if ngpus is not None:
        ngpus = int(ngpus)
        if ngpus < 1:
            #print('ERROR: The "ngpus" keyword in the &control section must be a positive integer')
            print('WARNING: The "ngpus" keyword in the &control section must be a positive integer')
            ngpus_is_valid = False
            #exit()
        else:
            ngpus_is_valid = True
        ngpus_is_set = True
    else:
        ngpus_is_set = False
    if ngpus_is_set and ngpus_is_valid:
        print('ngpus: {}'.format(ngpus))

    # gpu_type
    gpu_type = os.getenv('GPU_TYPE')
    if gpu_type is not None:
        gpu_type = gpu_type.lower()
        valid_gpu_types = ('k20x', 'k80', 'p100', 'v100')
        if gpu_type not in valid_gpu_types:
            #print('ERROR: The "gpu_type" keyword in the &control section must be one of', valid_gpu_types)
            print('WARNING: The "gpu_type" keyword in the &control section must be one of', valid_gpu_types)
            gpu_type_is_valid = False
            #exit()
        else:
            gpu_type_is_valid = True
        gpu_type_is_set = True
    else:
        gpu_type_is_set = False
    if gpu_type_is_set and gpu_type_is_valid:
        print('gpu_type: {}'.format(gpu_type))
    ########################################################################################################################


    ################ Handle deprecated keywords ############################################################################
    # Handle deprecated "gpu_type" keyword in favor of current "worker_type" keyword
    if (not worker_type_is_set) and (not gpu_type_is_set):
        print('ERROR: The "worker_type" keyword in the &control section must be set (to one of {})'.format(valid_worker_types))
        exit()
    if (not worker_type_is_set) and gpu_type_is_set:
        print('WARNING: The keyword "gpu_type" is deprecated; in the future you must instead use worker_type, whose possible values are {}'.format(valid_worker_types))
        if gpu_type_is_valid:
            print('NOTE: We''re using the setting of gpu_type ({}), for now, as the setting for worker_type'.format(gpu_type))
            worker_type = gpu_type
        else:
            print('ERROR: Attempting to use the setting of gpu_type ({}), for now, as the setting for worker_type, but it is invalid'.format(gpu_type))
            exit()
    if worker_type_is_set and (not gpu_type_is_set):
        if worker_type_is_valid:
            pass
        else:
            print('ERROR: The "worker_type" keyword in the &control section must be one of', valid_worker_types)
            exit()
    if worker_type_is_set and gpu_type_is_set:
        print('ERROR: Both keywords "worker_type" and "gpu_type" are set. The former is current but the latter is deprecated; please remove "gpu_type" and re-submit.')
        exit()

    # Handle deprecated "ngpus" keyword in favor of current "nworkers" keyword
    if (not nworkers_is_set) and (not ngpus_is_set):
        print('ERROR: The "nworkers" keyword in the &control section must be set (to a positive integer)')
        exit()
    if (not nworkers_is_set) and ngpus_is_set:
        print('WARNING: The keyword "ngpus" is deprecated; in the future you must instead use nworkers, which must be a positive integer')
        if ngpus_is_valid:
            print('NOTE: We''re using the setting of ngpus ({}), for now, as the setting for nworkers'.format(ngpus))
            nworkers = ngpus
        else:
            print('ERROR: Attempting to use the setting of ngpus ({}), for now, as the setting for nworkers, but it is invalid'.format(ngpus))
            exit()
    if nworkers_is_set and (not ngpus_is_set):
        if nworkers_is_valid:
            pass
        else:
            print('ERROR: The "nworkers" keyword in the &control section must be a positive integer')
            exit()
    if nworkers_is_set and ngpus_is_set:
        print('ERROR: Both keywords "nworkers" and "ngpus" are set. The former is current but the latter is deprecated; please remove "ngpus" and re-submit.')
        exit()
    ########################################################################################################################


    ################ Optional keywords #####################################################################################
    # nthreads
    if worker_type == 'cpu': # otherwise nthreads setting doesn't matter
        nthreads = os.getenv('NTHREADS')
        if nthreads is not None:
            nthreads = int(nthreads)
            if nthreads < 1:
                print('ERROR: The "nthreads" keyword in the &control section must be a positive integer')
                exit()
        else:
            print('WARNING: The keyword "nthreads" is not set in &control section; setting it to 1')
            nthreads = 1
        print('nthreads: {}'.format(nthreads))

    # custom_sbatch_args
    custom_sbatch_args = os.getenv('CUSTOM_SBATCH_ARGS', '')
    print('custom_sbatch_args: {}'.format(custom_sbatch_args))

    # M_gpu (GB)
    M_gpu = float(os.getenv('MEM_PER_GPU', '30'))
    print('M_gpu: {}'.format(M_gpu))

    # M_cpu (GB)
    M_cpu = float(os.getenv('MEM_PER_CPU', '7.5'))
    print('M_cpu: {}'.format(M_cpu))

    # M_swi (GB)
    M_swi = float(os.getenv('MEM_PER_SWIFTT', '4'))
    print('M_swi: {}'.format(M_swi))

    # sbatch_mem_per_cpu
    sbatch_mem_per_cpu = os.getenv('SBATCH_MEM_PER_CPU')
    if sbatch_mem_per_cpu is not None:
        sbatch_mem_per_cpu = float(sbatch_mem_per_cpu)
    print('sbatch_mem_per_cpu: {}'.format(sbatch_mem_per_cpu))

    # sbatch_cpus_per_task
    sbatch_cpus_per_task = os.getenv('SBATCH_CPUS_PER_TASK')
    if sbatch_cpus_per_task is not None:
        sbatch_cpus_per_task = int(sbatch_cpus_per_task)
    print('sbatch_cpus_per_task: {}'.format(sbatch_cpus_per_task))
    ########################################################################################################################


    #return(model_script, workflow, walltime, worker_type, nworkers, ngpus, gpu_type, nthreads, custom_sbatch_args, M_gpu, M_cpu, M_swi, sbatch_mem_per_cpu, sbatch_cpus_per_task) # all variables processed above
    return(workflow, walltime, worker_type, nworkers, nthreads, custom_sbatch_args, M_gpu, M_cpu, M_swi, sbatch_mem_per_cpu, sbatch_cpus_per_task) # just the ones we'll actually need


def determine_sbatch_settings(workflow, walltime, worker_type, nworkers, nthreads, custom_sbatch_args, M_gpu, M_cpu, M_swi, sbatch_mem_per_cpu, sbatch_cpus_per_task):

    # Note: See cpus_tasks_etc.docx for explanations of the following

    # Define dependent variables from the formulas in cpus_tasks_etc.docx
    if workflow == 'grid':
        S = 1
    elif workflow == 'bayesian':
        S = 2
    W = nworkers
    ntasks = S + W
    ntasks_per_core = 1

    # In the future, once the DOE guys hopefully tell us how to implement heterogeneous sbatch jobs, we can use the "ideally" versions of the variables below and split into two separate homogeneous jobs making up a larger heterogeneous job
    # Also then we would change the per-node and per-task versions to the single-number versions
    # Basically overall, just uncomment what's commented out
    if worker_type == 'cpu': # CPU-only job (threading-capable)
        T = nthreads
        if sbatch_cpus_per_task is None:
            #cpus_per_task = S*[1] + W*[T] # ideally
            cpus_per_task = T # practically
        else:
            cpus_per_task = sbatch_cpus_per_task
        if sbatch_mem_per_cpu is None:
            #mem_per_cpu = S*[M_swi] + W*(T*[M_cpu]) # ideally
            mem_per_cpu = M_cpu # practically
        else:
            mem_per_cpu = sbatch_mem_per_cpu
        partition = 'norm'
        gres = None
        #ntasks_per_node = ntasks*[1] # per-node version
        ntasks_per_node = 1 # single-number version
    else: # GPU-only job
        if sbatch_cpus_per_task is None:
            #cpus_per_task = ntasks*[1] # per-task version
            cpus_per_task = 1 # single-number version
        else:
            cpus_per_task = sbatch_cpus_per_task
        if sbatch_mem_per_cpu is None:
            #mem_per_cpu = S*[M_swi] + W*[M_gpu] # ideally
            mem_per_cpu = M_gpu # practically
        else:
            mem_per_cpu = sbatch_mem_per_cpu
        partition = 'gpu'
        gres = worker_type
        #ntasks_per_node = [S+1] + (W-1)*[1] # ideally
        ntasks_per_node = 1 # practically

    # Output the calculated settings
    print('')
    print('sbatch settings:')
    print('ntasks: {}'.format(ntasks))
    print('cpus_per_task: {}'.format(cpus_per_task))
    print('mem_per_cpu: {}'.format(mem_per_cpu))
    print('ntasks_per_core: {}'.format(ntasks_per_core))
    print('partition: {}'.format(partition))
    print('gres: {}'.format(gres))
    print('ntasks_per_node: {}'.format(ntasks_per_node))
    print('nnodes: {}'.format(len(ntasks_per_node)))

    # # Output some checks; uncomment once hetergeneous sbatch jobs are implemented (see above)
    # print('')
    # print('sbatch settings checks:')
    # print('ntasks: {} == {} == {}'.format(ntasks, len(cpus_per_task), sum(ntasks_per_node)))
    # print('ncpus: {} == {}'.format(sum(cpus_per_task), len(mem_per_cpu)))

    # Print the desired sbatch arguments to work toward
    print('')
    print('DESIRED sbatch arguments:')
    ntasks_part = ' --ntasks={}'.format(ntasks)
    if custom_sbatch_args == '':
        custom_sbatch_args_part = ''
    else:
        custom_sbatch_args_part = ' {}'.format(custom_sbatch_args)
    if gres is not None:
        gres_part = ' --gres=gpu:{}:1'.format(gres)
    else:
        gres_part = ''
    mem_per_cpu_part = ' --mem-per-cpu={}G'.format(mem_per_cpu)
    cpus_per_task_part = ' --cpus-per-task={}'.format(cpus_per_task)
    ntasks_per_core_part = ' --ntasks-per-core={}'.format(ntasks_per_core)
    partition_part = ' --partition={}'.format(partition)
    walltime_part = ' --time={}'.format(walltime) # total run time of the job allocation
    ntasks_per_node_part = ' --ntasks-per-node={}'.format(ntasks_per_node)
    print('{}{}{}{}{}{}{}{}{}'.format(ntasks_part, custom_sbatch_args_part, gres_part, mem_per_cpu_part, cpus_per_task_part, ntasks_per_core_part, partition_part, walltime_part, ntasks_per_node_part))

    return(ntasks, gres, mem_per_cpu, cpus_per_task, ntasks_per_core, partition, ntasks_per_node)


def export_variables(workflow, ntasks, gres, custom_sbatch_args, mem_per_cpu, cpus_per_task, ntasks_per_core, partition, ntasks_per_node):

    f = open('preprocessed_vars_to_export.sh', 'w')

    # Export variables (well, print export statements for loading later) we'll need for later
    f.write('export WORKFLOW_TYPE={}\n'.format(workflow))
    f.write('export PROCS={}\n'.format(ntasks))
    if gres is not None:
        f.write('export TURBINE_SBATCH_ARGS="{} --gres=gpu:{}:1 --mem-per-cpu={}G --cpus-per-task={} --ntasks-per-core={}"\n'.format(custom_sbatch_args, gres, mem_per_cpu, cpus_per_task, ntasks_per_core))
    else:
        f.write('export TURBINE_SBATCH_ARGS="{} --mem-per-cpu={}G --cpus-per-task={} --ntasks-per-core={}"\n'.format(custom_sbatch_args, mem_per_cpu, cpus_per_task, ntasks_per_core))
    f.write('export QUEUE={}\n'.format(partition))
    f.write('export PPN={}\n'.format(ntasks_per_node))

    f.close()


# Check the input settings and return the resulting required and optional variables that we'll need later (all required variables are checked but not yet all optional variables)
workflow, walltime, worker_type, nworkers, nthreads, custom_sbatch_args, M_gpu, M_cpu, M_swi, sbatch_mem_per_cpu, sbatch_cpus_per_task = check_input()

# Determine the settings for the arguments to the sbatch, turbine, etc. calls
ntasks, gres, mem_per_cpu, cpus_per_task, ntasks_per_core, partition, ntasks_per_node = determine_sbatch_settings(workflow, walltime, worker_type, nworkers, nthreads, custom_sbatch_args, M_gpu, M_cpu, M_swi, sbatch_mem_per_cpu, sbatch_cpus_per_task)

# Export variables we'll need later to a file in order to be sourced back in in run_workflows.sh
export_variables(workflow, ntasks, gres, custom_sbatch_args, mem_per_cpu, cpus_per_task, ntasks_per_core, partition, ntasks_per_node)
