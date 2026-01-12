# Agent Zero - Railway Compatible Image
# Fixes numpy/scipy binary incompatibility in official image
#
# Issue: https://github.com/frdel/agent-zero/issues/XXX (to be reported)
# The official agent0ai/agent-zero:latest image has incompatible numpy/scipy
# versions that cause ValueError on Railway's infrastructure.

FROM agent0ai/agent-zero:latest

# Fix numpy/scipy and related packages binary incompatibility
# Install numpy LAST with --no-deps to prevent dependency resolution from upgrading it
RUN /opt/venv-a0/bin/pip uninstall -y numpy scipy scikit-learn numba && \
    /opt/venv-a0/bin/pip install scipy==1.13.1 scikit-learn==1.4.2 numba==0.60.0 --no-cache-dir && \
    /opt/venv-a0/bin/pip install numpy==1.26.4 --no-deps --force-reinstall --no-cache-dir

# Set default branch for Agent Zero
ENV BRANCH=main

# Agent Zero web UI runs on port 80
EXPOSE 80
