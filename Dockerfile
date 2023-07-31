FROM python:3.9-alpine3.13
LABEL maintainer="uzaircode"

# Print output directly to console
ENV PYTHONBUFFERED 1

COPY ./requirements.txt /requirements.txt
# Copy the virtual env inside requirements.dev.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /config

# Refer directory to app folder
WORKDIR /config
EXPOSE 8000

# Run a command when building an image in one layer (dev env)
# python -m venv /py && -> create a virtual environment storing python depedencies
# adduser -> create a user to run inside the app dir (security purposes)
# build-base postgresql... -> depedency needed to build requirements.txt psycopg2
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-deps  \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-deps && \
    adduser --disabled-password --no-create-home config

# Add virtual environment to system path
ENV PATH="/py/bin:$PATH"

# Next line will run on the new created user (line 21)
USER config



