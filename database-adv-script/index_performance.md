id,select_type,table,partitions,type,possible_keys,key,key_len,ref,rows,filtered,Extra
1,SIMPLE,p,NULL,ALL,NULL,NULL,NULL,NULL,10,100.00,"Using temporary; Using filesort"
1,SIMPLE,b,NULL,ref,property_id,property_id,145,alx_airbnb.p.property_id,1,100.00,"Using index"