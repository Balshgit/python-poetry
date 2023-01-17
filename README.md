# Poetry main packages

Used for poetry packages management with docker

required `docker` and optionally `docker-compose`


## Generate poetry lock for any version

- copy `pyproject.toml` file to `poetry` dir
- In Dockerfile set `python` version the same as in `pyproject.toml` and `poetry` version which will be used


### Run from docker:

```bash
docker build --build-arg USER=$USER -t poetry-python . && docker run --rm -u $USER -v $PWD/poetry:/poetry poetry-python
```

### Or from docker-compose:
```bash
docker-compose up --build
```

script will generate `poetry.lock` and `requirements.txt` files in `poetry` directory