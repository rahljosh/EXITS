<!----------------------------------------------------------
	Get List of Table Names and their auto increment values
----------------------------------------------------------->
SELECT 
       table_name, 
       table_type, 
       engine, 
       auto_increment 
FROM 
     information_schema.tables     
WHERE 
      table_schema = 'smg'
order by                      
      table_name