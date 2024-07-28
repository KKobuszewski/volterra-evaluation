FROM quay.io/pypa/manylinux_2_28_x86_64

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libgomp1 \ # libomp-dev
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .      # copy necessary stuff from repository (uses .dockerignore here?)

# using pip
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt


# using poetry
#COPY poetry.lock poetry.toml pyproject.toml ./
#ENV POETRY_LOCATION=/opt/poetry
#RUN python3 -m venv $POETRY_LOCATION \
#    && $POETRY_LOCATION/bin/pip install poetry==1.7.0 \
#    && $POETRY_LOCATION/bin/poetry install --only=main \
#    && rm -rf .poetry_cache
