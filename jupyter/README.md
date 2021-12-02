# Tweaks to Legate.Core to Investigate Adding Jupyter Support

NOTE: This is very much a work-in-progress and should not be considered a working approach to providing a
Legion/Legate/cuNumeric kernel for Jupyter.

   See https://github.com/nv-legate/legate.core and https://github.com/nv-legate/cunumeric for the basic building blocks.

# Notes on this repo

This is a proof-of-concept for providing a jupyter kernel for use with legion/legate/cunumeric.  We have it in the Legion
repo to keep it as a potential general path (e.g. Regent, Pygion support, etc.).  At present this is not ready to upstream
into Legion's main code base.

## Legate changes

The `install.py` script has been tweaked to be cloned and built using a test cluster.

## Legion changes

The `legion_top.py` script was changed so that if no script passed as an
argument, it will start up the jupyter kernel.  This is more for simplifying
test cases than a final proposed solution path.

In addition, `main.cc` file was changed to just assume we always start up in a
control replication usage model.  This simplifies the testing process within our
enviornment.

## Install procedure

To install this are the steps we're using:

```bash
salloc -p clx-volta -N2
module load miniconda cuda/11.0 openmpi/4.0.3-gcc_9.3.0
conda create -n legate-jup-env pip
source activate legate-jup-env
conda install pyarrow=1.0.1 numpy cffi jupyter matplotlib

./install.py --gasnet --conduit ibv --cuda --with-cuda $CUDA_HOME --arch volta
```

A `kernel.json` file will need to be manually installed. Typically the kernel
file goes in your home directory: `~/.local/share/jupyter/kernels` directory
(might need to double-check with `jupyter --paths`).  Once that's done,
create a `kernel.json` file in `~/.local/share/jupyter/kernels/legate_jup/`:

```json
{
  "argv": ["install/path/to/legate", "list", "of", "legate", "args", "--jupyter-connection-file", "{connection_file}"],
  "display_name": "LegateJupyter testing",
  "language": "python"
}
```

Again, this is not as flexible as it will need to be for broad use.

Legate.numpy (now cunumeric) can then be installed pointing to this
install.  We need to revisit the details here with the release of
cunumeric (see link above).

## TODO

Some useful resources as we sort our way through the mix of possible paths forward:

* https://jupyter-client.readthedocs.io/en/latest/kernels.html#kernels
* https://github.com/takluyver/bash_kernel
* https://zguide.zeromq.org/docs/preface
