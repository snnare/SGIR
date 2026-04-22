-- Create the monitoring user
-- '%%' allows connection from any host (common for containers)
-- Use a strong password for production
CREATE USER 'sgir_monitoreo'@'%%' IDENTIFIED BY '123Nokia$';

-- Grant access to check global status and variables
GRANT SELECT, PROCESS ON *.* TO 'sgir_monitoreo'@'%%';

-- Grant access to the Information Schema (Metadata, Tables, Views)
-- Note: In MySQL, all users can usually see information_schema, 
-- but explicit SELECT on specific databases helps.
GRANT SELECT ON information_schema.* TO 'sgir_monitoreo'@'%%';

-- If you use Performance Schema (available in 5.6+)
GRANT SELECT ON performance_schema.* TO 'sgir_monitoreo'@'%%';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;
