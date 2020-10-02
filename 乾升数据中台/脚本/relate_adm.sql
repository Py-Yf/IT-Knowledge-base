INSERT OVERWRITE adm_relate_count
SELECT prison_code,area_code, count(criminal_code) as relate_count,
		 criminal_code , 
		 event_date, 
		 curr_veiw_date 
		 FROM edw_relate_telephones
GROUP BY 
prison_code,
area_code, 
criminal_code, 
event_date,
curr_veiw_date ;