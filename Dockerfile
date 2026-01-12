# Agent Zero - Railway Compatible Image
# Fixes numpy/scipy binary incompatibility in official image
#
# Issue: https://github.com/frdel/agent-zero/issues/XXX (to be reported)
# The official agent0ai/agent-zero:latest image has incompatible numpy/scipy
# versions that cause ValueError on Railway's infrastructure.

FROM agent0ai/agent-zero:latest

# Fix numpy/scipy and related packages binary incompatibility
# Multiple packages were compiled against different numpy versions
# Force reinstall all numeric/ML packages with compatible versions
RUN /opt/venv-a0/bin/pip uninstall -y numpy scipy scikit-learn && \
    /opt/venv-a0/bin/pip install --force-reinstall numpy==1.26.4 && \
    /opt/venv-a0/bin/pip install --force-reinstall scipy==1.13.1 && \
    /opt/venv-a0/bin/pip install --force-reinstall scikit-learn==1.5.2 --no-cache-dir

# Set default branch for Agent Zero
ENV BRANCH=main

# Agent Zero web UI runs on port 80
EXPOSE 80
