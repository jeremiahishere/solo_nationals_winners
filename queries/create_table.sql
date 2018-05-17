CREATE EXTERNAL TABLE IF NOT EXISTS national_results (
year STRING,
name STRING,
city STRING,
car STRING) PARTITIONED BY (category STRING, class STRING) ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar"     = "\"",
  "escapeChar"    = "\\"
) LOCATION 's3://<bucket>/<base_path>/national_results' TBLPROPERTIES( "has_encrypted_data" = "false")
