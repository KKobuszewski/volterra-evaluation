# docker run -it IMAGE /bin/bash
# docker run -it quay.io/pypa/manylinux_2_28_x86_64 /bin/bash
# docker build -f ./Dockerfile -t volterra-build:latest
# docker run -it volterra-build:latest /bin/bash

# libomp-dev

# https://github.com/pypa/python-manylinux-demo
# https://github.com/pypa/manylinux
FROM quay.io/pypa/manylinux_2_28_x86_64

# install OpenMP (https://yum-info.contradodigital.com/view-package/updates/libgomp/)
RUN yum update && \
    yum install -y \
    libgomp \
    && yum -y clean all && rm -rf /var/cache 

# copy necessary stuff from repository (uses .dockerignore here?)
WORKDIR /app
COPY . .

# install dependencies for each python version 
RUN for PYBIN in /opt/python/*/bin; do \
     "${PYBIN}/pip" install --upgrade pip && \
     "${PYBIN}/pip" install --no-cache-dir -r requirements.txt; \
     done

# using poetry
#COPY poetry.lock poetry.toml pyproject.toml ./
#ENV POETRY_LOCATION=/opt/poetry
#RUN python3 -m venv $POETRY_LOCATION \
#    && $POETRY_LOCATION/bin/pip install poetry==1.7.0 \
#    && $POETRY_LOCATION/bin/poetry install --only=main \
#    && rm -rf .poetry_cache
