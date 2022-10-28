GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA :: arch_oketest TO [BPC-DataFactory-ligfd66ykhhtq];
GRANT EXECUTE ON SCHEMA::arch_oketest TO [BPC-DataFactory-ligfd66ykhhtq]; 
GRANT ALTER ON SCHEMA::bpc TO [BPC-DataFactory-ligfd66ykhhtq]; 


--On RPA
GRANT CREATE TABLE,SELECT, INSERT, UPDATE, DELETE TO  [BPC-DataFactory-ligfd66ykhhtq]
REVOKE CREATE TABLE,SELECT, INSERT, UPDATE, DELETE FROM  [BPC-DataFactory-ligfd66ykhhtq]

GRANT EXECUTE ON SCHEMA :: BPC TO [BPC-DataFactory-4ykfv5uftshfi];
