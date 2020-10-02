INSERT OVERWRITE edw_relate_telephones
SELECT  
    serial_no,
    prison_code,
    area_code,
    event_date,
    criminal_code,
    current_tel_no,
    curr_veiw_date,
    view_bg_time,
    view_ed_time,
    actual_view_len,
    valid_flag,
    data_src_flag
 FROM cms_relate_telephones
 WHERE 
    prison_code IS NOT NULL and
    event_date IS NOT NULL AND
    area_code IS NOT NULL;