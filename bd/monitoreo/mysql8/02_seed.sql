-- Cambia 'mi_base' por el nombre que quieras
SET @base_name = 'mi_base_';
SET @i = 1;

PREPARE stmt FROM 'CREATE DATABASE IF NOT EXISTS ??';

WHILE @i <= 50 DO
    SET @db_name = CONCAT(@base_name, @i);
    SET @sql = CONCAT('CREATE DATABASE IF NOT EXISTS `', @db_name, '`;');
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @i = @i + 1;
END WHILE;