# Bug Report: Agent Zero Docker Image - NumPy/SciPy Binary Incompatibility on Railway

## Summary

The official `agent0ai/agent-zero:latest` Docker image fails to start on Railway's infrastructure due to NumPy/SciPy binary incompatibility issues. The image works correctly on local Docker Desktop (Windows) but crashes immediately on Railway.

## Environment

- **Platform:** Railway (cloud)
- **Image:** `agent0ai/agent-zero:latest` (sha256:ef3993faf67928d8bea4e1979c7cff417fcfb1d456b62af2831e43e7a47ebfb4)
- **Date:** 2026-01-12
- **Local test:** Docker Desktop on Windows - **WORKS**
- **Railway deploy:** **FAILS**

## Error Messages

### Error 1: SciPy ufunc incompatibility
```
File "/opt/venv-a0/lib/python3.12/site-packages/scipy/special/_multiufuncs.py", line 41, in __init__
    raise ValueError("All ufuncs must have type `numpy.ufunc`."
ValueError: All ufuncs must have type `numpy.ufunc`. Received (<ufunc 'sph_legendre_p'>, <ufunc 'sph_legendre_p'>, <ufunc 'sph_legendre_p'>)
```

### Error 2: Numba/NumPy version mismatch
```
ImportError: Numba needs NumPy 2.3 or less. Got NumPy 2.4.
```

## Root Cause Analysis

The official Docker image contains conflicting versions of numerical computing packages:

| Package | Version in Image | Required Version |
|---------|------------------|------------------|
| numpy | 2.2.6 / 2.4.1 | <2.0 or 1.26.x |
| scipy | 1.16.3 | Compatible with numpy |
| numba | 0.62.1 | Requires numpy <2.4 |
| scikit-learn | varies | Compatible with numpy |

The issue manifests on Railway but not locally, likely due to:
1. Different CPU architecture or instruction sets
2. Different shared library versions
3. Railway's containerization layer differences

## Affected Components

- `run_ui` - Web UI service (crashes on import)
- `run_tunnel_api` - Tunnel API service (crashes on import)
- Whisper (speech recognition) - Depends on numba
- sentence-transformers - Depends on scipy/sklearn

## Workaround

We created a patched Dockerfile that forces compatible package versions:

```dockerfile
FROM agent0ai/agent-zero:latest

# Fix numpy/scipy and related packages binary incompatibility
# Install numpy LAST with --no-deps to prevent dependency resolution from upgrading it
RUN /opt/venv-a0/bin/pip uninstall -y numpy scipy scikit-learn numba && \
    /opt/venv-a0/bin/pip install scipy==1.13.1 scikit-learn==1.4.2 numba==0.60.0 --no-cache-dir && \
    /opt/venv-a0/bin/pip install numpy==1.26.4 --no-deps --force-reinstall --no-cache-dir

ENV BRANCH=main
EXPOSE 80
```

**Key insight:** NumPy must be installed **last** with `--no-deps` flag to prevent pip's dependency resolver from upgrading it back to an incompatible version.

## Recommended Fix for Official Image

1. **Pin numpy version** in requirements.txt to `numpy==1.26.4` (or another 1.x version)
2. **Pin scipy version** to `scipy==1.13.1`
3. **Pin numba version** to `numba==0.60.0`
4. **Add version constraints** to prevent future dependency conflicts:
   ```
   numpy>=1.24.0,<2.0.0
   scipy>=1.10.0,<1.14.0
   numba>=0.58.0,<0.61.0
   ```

## Steps to Reproduce

1. Create a new Railway project
2. Add service with Docker Image: `agent0ai/agent-zero:latest`
3. Set port to 80
4. Generate public domain
5. Observe 502 errors and check logs for numpy/scipy errors

## Additional Context

- Local Docker Desktop (Windows) with the same image works perfectly
- The issue appears to be specific to Railway's infrastructure
- Similar issues have been reported in other projects:
  - https://github.com/roboflow/rf-detr/issues/425
  - https://github.com/roboflow/rf-detr/issues/467
  - https://github.com/m-bain/whisperX/issues/1282

## Workaround Repository

A Railway-compatible fork is available at:
https://github.com/Brixyy/agent-zero-railway

---

**Reporter:** Elyon Development Team
**Date:** 2026-01-12
**Severity:** Critical (blocks cloud deployment)
