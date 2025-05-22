# Set the base image to Ubuntu, use a public image
FROM python:3.11.1-slim-stretch as builder

# To build tests run
# docker-compose -f docker-compose.test.yml build

# File Author / Maintainer
# MAINTAINER Thomas Schmelzer "thomas.schmelzer@gmail.com"

COPY requirements.txt /tmp/flowpylib/requirements.txt

# Dependencies for pystore and weasyprint in buildDeps
# If we don't want to use weasyprint we
# build-essential libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info
RUN buildDeps='gcc g++ libsnappy-dev unixodbc-dev build-essential libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info' && \
    apt-get update && apt-get install -y $buildDeps --no-install-recommends && \
    pip install --no-cache-dir -r /tmp/flowpylib/requirements.txt && \
    rm  /tmp/flowpylib/requirements.txt
    # && \
    #apt-get purge -y --auto-remove $buildDeps

# Copy to /
COPY ./flowpylib /flowpylib/flowpylib
COPY ./flowpylibgen /flowpylib/flowpylibgen
COPY ./flowpylibuser /flowpylib/flowpylibuser
COPY ./test /flowpylib/test
COPY ./test /test

# Make sure flowpylib on the PYTHONPATH
ENV PYTHONPATH "${PYTHONPATH}:/flowpylib"

#### Here's the test-configuration
FROM builder as test

# We install some extra libraries purely for testing
RUN pip install --no-cache-dir httpretty pytest pytest-cov pytest-html sphinx mongomock requests-mock

WORKDIR /flowpylib

# For temp caching for the tests
RUN mkdir -p /tmp/csv
RUN mkdir -p /tmp/flowpylib

CMD echo "${RUN_PART}"

# Run the pytest
# If RUN_PART is not defined, we're not running on GitHub CI, we're running tests locally
# Otherwise if RUN_PART is defined, it's likely we're running on GitHub, so we avoid running multithreading tests which run
# out of memory (machines have limited memory)
CMD if [ "${RUN_PART}" = 1 ]; \
    then py.test --cov=flowpylib  --cov-report html:artifacts/html-coverage --cov-report term --html=artifacts/html-report/report.html --ignore-glob='*multithreading*.py'; \
    else py.test --cov=flowpylib  --cov-report html:artifacts/html-coverage --cov-report term \
        --html=artifacts/html-report/report.html; \
    fi

# Run everything
# CMD py.test --cov=flowpylib  --cov-report html:artifacts/html-coverage --cov-report term \
#        --html=artifacts/html-report/report.html

# Example to run a specific test script
# CMD py.test --cov=flowpylib  --cov-report html:artifacts/html-coverage --cov-report term \
#    --html=artifacts/html-report/report.html test/test_flowpylib/test_tca_multithreading.py

# Example to run an individual test function
# CMD py.test --cov=flowpylib  --cov-report html:artifacts/html-coverage --cov-report term \
#    --html=artifacts/html-report/report.html test/test_flowpylib/test_data_read_write.py::test_write_trade_data_sql

# For debugging to keep container going
# CMD tail -f /dev/null
