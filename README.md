# Poetry main packages

Used for poetry packages management with docker

required `docker` and `docker-compose`


## Poetry lock for any version

- copy `pyproject.toml` file to poetry dir
- set `python` version the same as in `pyproject.toml` and set `poetry` versions in Dockerfile

run 

```bash
docker-compose up --build
```

script will generate `poetry.lock` and `requirements.txt` files