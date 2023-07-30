FROM python:3.9-alpine3.13
LABEL maintainer="uzaircode"

# Print output directly to console
ENV PYTHONBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app

# Refer directory to app folder
WORKDIR /app
EXPOSE 8000

# Run a command when building an image in one layer
# 1st line - create a virtual environment storing python depedencies
# 2nd/3rd line - install latest version inside the virtual environment
# 4th line - create a user to run inside the app dir (security purposes)
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /requirements.txt && \
    adduser --disabled-password --no-create-home app

# Add virtual environment to system path
ENV PATH="/py/bin:$PATH"

# Next line will run on the new created user (line 21)
USER app



