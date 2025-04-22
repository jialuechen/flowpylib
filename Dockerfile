# Set the base image to Ubuntu, use a public image
FROM python:3.11.1-slim-stretch as builder

# To build tests run
# docker-compose -f docker-compose.test.yml build

# File Author / Maintainer
# MAINTAINER Thomas Schmelzer "thomas.schmelzer@gmail.com"

COPY requirements.txt /tmp/pyflow/requirements.txt

# Dependencies for pystore and weasyprint in buildDeps
# If we don't want to use weasyprint we
# build-essential libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info
RUN buildDeps='gcc g++ libsnappy-dev unixodbc-dev build-essential libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info' && \
    apt-get update && apt-get install -y $buildDeps --no-install-recommends && \
    pip install --no-cache-dir -r /tmp/pyflow/requirements.txt && \
    rm  /tmp/pyflow/requirements.txt
    # && \
    #apt-get purge -y --auto-remove $buildDeps

# Copy to /
COPY ./pyflow /pyflow/pyflow
COPY ./pyflowgen /pyflow/pyflowgen
COPY ./pyflowuser /pyflow/pyflowuser
COPY ./test /pyflow/test
COPY ./test /test

# Make sure pyflow on the PYTHONPATH
ENV PYTHONPATH "${PYTHONPATH}:/pyflow"

#### Here's the test-configuration
FROM builder as test

# We install some extra libraries purely for testing
RUN pip install --no-cache-dir httpretty pytest pytest-cov pytest-html sphinx mongomock requests-mock

WORKDIR /pyflow

# For temp caching for the tests
RUN mkdir -p /tmp/csv
RUN mkdir -p /tmp/pyflow

CMD echo "${RUN_PART}"

# Run the pytest
# If RUN_PART is not defined, we're not running on GitHub CI, we're running tests locally
# Otherwise if RUN_PART is defined, it's likely we're running on GitHub, so we avoid running multithreading tests which run
# out of memory (machines have limited memory)
CMD if [ "${RUN_PART}" = 1 ]; \
    then py.test --cov=pyflow  --cov-report html:artifacts/html-coverage --cov-report term --html=artifacts/html-report/report.html --ignore-glob='*multithreading*.py'; \
    else py.test --cov=pyflow  --cov-report html:artifacts/html-coverage --cov-report term \
        --html=artifacts/html-report/report.html; \
    fi

# Run everything
# CMD py.test --cov=pyflow  --cov-report html:artifacts/html-coverage --cov-report term \
#        --html=artifacts/html-report/report.html

# Example to run a specific test script
# CMD py.test --cov=pyflow  --cov-report html:artifacts/html-coverage --cov-report term \
#    --html=artifacts/html-report/report.html test/test_pyflow/test_tca_multithreading.py

# Example to run an individual test function
# CMD py.test --cov=pyflow  --cov-report html:artifacts/html-coverage --cov-report term \
#    --html=artifacts/html-report/report.html test/test_pyflow/test_data_read_write.py::test_write_trade_data_sql

# For debugging to keep container going
# CMD tail -f /dev/null
