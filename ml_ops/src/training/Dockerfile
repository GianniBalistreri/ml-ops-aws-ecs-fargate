FROM python:3.8

RUN mkdir /src
COPY /ml_ops/src/training/pyproject.toml /src

WORKDIR /src

RUN python -m pip install --upgrade pip
RUN python -m pip install setuptools
RUN python -m pip install poetry

RUN poetry config virtualenvs.create false
RUN poetry install --no-dev

COPY /ml_ops/src/training/src /src

ENTRYPOINT [ "python", "training.py" ]