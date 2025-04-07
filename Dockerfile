# Use a Python image with uv pre-installed
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# Enable bytecode compilation and set the link mode for mounted volumes
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# Install the project's dependencies from the lockfile.
# This first sync installs production dependencies only (for caching),
# but does not use --no-dev so that dev dependencies will be installed later.
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project

# Add the rest of the project source code and install it.
# This sync will install the project itself along with any dev dependencies.
ADD . /app
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen

# Place executables in the environment's PATH
ENV PATH="/app/.venv/bin:$PATH"

# Reset entrypoint so that uv isn’t automatically invoked
ENTRYPOINT []

CMD ["python", "-Xfrozen_modules=off", "-m", "fastapi", "dev", "--host=0.0.0.0", "src/uv_docker_example"]