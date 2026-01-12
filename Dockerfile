# Agent Zero - Railway Compatible Image
# Fixes numpy/scipy binary incompatibility in official image
#
# Issue: https://github.com/frdel/agent-zero/issues/XXX (to be reported)
# The official agent0ai/agent-zero:latest image has incompatible numpy/scipy
# versions that cause ValueError on Railway's infrastructure.

FROM agent0ai/agent-zero:v0.9.6

# Set default branch for Agent Zero
ENV BRANCH=main

# Agent Zero web UI runs on port 80
EXPOSE 80
