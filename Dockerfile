# Use an official Spark base image
FROM bitnami/spark:latest

# Set the working directory
WORKDIR /opt/spark

# Copy your application code into the container
COPY src/simple_spark_job.py /opt/spark/src/simple_spark_job.py

# Install Python dependencies if necessary
COPY requirements.txt /opt/spark/requirements.txt
RUN pip install --no-cache-dir -r /opt/spark/requirements.txt

# Set the entry point (to be overridden by spark-submit command)
ENTRYPOINT ["/bin/bash"]
