# Agent Zero - Railway Compatible Image
# Fixes numpy/scipy binary incompatibility in official image
#
# Issue: https://github.com/frdel/agent-zero/issues/XXX (to be reported)
# The official agent0ai/agent-zero:latest image has incompatible numpy/scipy
# versions that cause ValueError on Railway's infrastructure.

FROM agent0ai/agent-zero:v0.9.7

# Fix numpy/scipy/numba binary incompatibility on Railway
# Strategy: Completely rebuild scientific stack with compatible versions
# numpy 1.26.4 is the last 1.x version, widely compatible
# Must install in specific order due to dependency resolution
RUN /opt/venv-a0/bin/pip uninstall -y numpy scipy scikit-learn numba llvmlite && \
    /opt/venv-a0/bin/pip install --no-cache-dir \
        llvmlite==0.43.0 \
        numba==0.60.0 \
        scipy==1.13.1 \
        scikit-learn==1.4.2 && \
    /opt/venv-a0/bin/pip install --no-cache-dir --no-deps --force-reinstall numpy==1.26.4

# Set default branch for Agent Zero
ENV BRANCH=main

# Agent Zero web UI runs on port 80
EXPOSE 80
