# Agent Zero - Railway Compatible Image
# Fixes numpy/scipy binary incompatibility in official image
#
# Issue: https://github.com/frdel/agent-zero/issues/XXX (to be reported)
# The official agent0ai/agent-zero:latest image has incompatible numpy/scipy
# versions that cause ValueError on Railway's infrastructure.

FROM agent0ai/agent-zero:latest

# Fix numpy/scipy binary incompatibility
# scipy was compiled against a different numpy version, causing:
# "ValueError: All ufuncs must have type numpy.ufunc"
RUN /opt/venv-a0/bin/pip uninstall -y numpy scipy && \
    /opt/venv-a0/bin/pip install numpy==1.26.4 scipy==1.13.1 --no-cache-dir

# Set default branch for Agent Zero
ENV BRANCH=main

# Agent Zero web UI runs on port 80
EXPOSE 80
