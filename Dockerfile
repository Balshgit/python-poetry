FROM python:3.12.1

ARG POETRY_VERSION=1.7.1
ARG USER

# python:
ENV PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PYTHONDONTWRITEBYTECODE=1 \
  # pip:
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  # poetry:
  POETRY_VERSION=${POETRY_VERSION} \
  POETRY_NO_INTERACTION=1 \
  POETRY_VIRTUALENVS_CREATE=false \
  POETRY_CACHE_DIR='/var/cache/pypoetry' \
  PATH="$PATH:/root/.poetry/bin"

RUN apt update \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    bash \
    build-essential \
    curl \
    gettext \
    git \
    libpq-dev \
    nano \
  && export TERM=xterm \
  && pip install --upgrade pip \
  && pip install "poetry==$POETRY_VERSION" \
  && poetry self add poetry-plugin-export


RUN groupadd ${USER} && useradd -g ${USER} ${USER}

RUN mkdir /code /poetry
RUN chown -R ${USER}:${USER} /code /poetry

COPY --chown=${USER}:${USER} ./poetry/pyproject.toml /code/

WORKDIR /code

RUN export PATH="${PATH}:/root/.local/bin" \
  && poetry --version \
  && poetry lock \
  && poetry export -f requirements.txt --with dev --without-hashes --output requirements.txt

RUN if [ -f poetry.lock ] && [ -f requirements.txt ]; then \
    echo "poetry.lock and requirements.txt created successfully" && exit 0; \
    else echo "there is no poetry.lock or requirements.txt" && exit 1;  \
    fi

CMD [ "/bin/bash", "-c", "cp /code/* /poetry -r && chown ${USER}:$USER -R /poetry" ]


