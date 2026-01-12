# Agent Zero - Railway Deploy

Railway-compatible Docker image for [Agent Zero](https://github.com/frdel/agent-zero).

## Why this repo?

The official `agent0ai/agent-zero:latest` Docker image has a numpy/scipy binary incompatibility that causes crashes on Railway's infrastructure. This repo provides a patched Dockerfile that fixes the issue.

## Quick Deploy to Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/...)

Or manually:
1. Fork this repo
2. Create new project in Railway
3. Connect to your forked repo
4. Set port to `80` in Settings → Networking
5. Deploy

## The Bug

```
ValueError: All ufuncs must have type `numpy.ufunc`.
Received (<ufunc 'sph_legendre_p'>, ...)
```

This occurs because scipy in the official image was compiled against a different numpy version than what's installed.

## The Fix

```dockerfile
RUN /opt/venv-a0/bin/pip uninstall -y numpy scipy && \
    /opt/venv-a0/bin/pip install numpy==1.26.4 scipy==1.13.1 --no-cache-dir
```

## Configuration

After deployment, configure Agent Zero through its web UI:
- Settings → LLM Providers (OpenAI, Anthropic, etc.)
- Settings → API Keys

## Related

- [Agent Zero GitHub](https://github.com/frdel/agent-zero)
- [Agent Zero Documentation](https://docs.agent0.ai/)
