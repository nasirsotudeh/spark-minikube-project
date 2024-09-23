from pyspark.sql import SparkSession

# Initialize SparkSession
spark = SparkSession.builder.appName("SimpleSparkJob").getOrCreate()

# Create a simple DataFrame
data = [("Alice", 34), ("Bob", 45), ("Cathy", 29)]
columns = ["Name", "Age"]
df = spark.createDataFrame(data, columns)

# Show DataFrame content
df.show()

# Perform some basic transformations
df_filtered = df.filter(df.Age > 30)
df_filtered.show()

# Stop the Spark session
spark.stop()
