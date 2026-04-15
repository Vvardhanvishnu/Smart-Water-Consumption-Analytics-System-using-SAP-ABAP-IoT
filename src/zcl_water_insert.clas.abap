CLASS zcl_water_insert DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_water_insert IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: lt_water TYPE TABLE OF ztwater_data,
          ls_water TYPE ztwater_data.

    " Row 1 - Normal
    ls_water-mandt          = sy-mandt.
    ls_water-sensor_id      = 'SENS001'.
    ls_water-timestamp      = '20240101120000'.
    ls_water-water_zone     = 'ZONE-A'.
    ls_water-reading_liters = '150.00'.
    ls_water-alert_flag     = ''.
    APPEND ls_water TO lt_water.

    " Row 2 - Alert
    ls_water-mandt          = sy-mandt.
    ls_water-sensor_id      = 'SENS002'.
    ls_water-timestamp      = '20240101130000'.
    ls_water-water_zone     = 'ZONE-A'.
    ls_water-reading_liters = '980.00'.
    ls_water-alert_flag     = 'X'.
    APPEND ls_water TO lt_water.

    " Row 3 - Normal
    ls_water-mandt          = sy-mandt.
    ls_water-sensor_id      = 'SENS003'.
    ls_water-timestamp      = '20240101140000'.
    ls_water-water_zone     = 'ZONE-B'.
    ls_water-reading_liters = '200.00'.
    ls_water-alert_flag     = ''.
    APPEND ls_water TO lt_water.

    " Row 4 - Alert
    ls_water-mandt          = sy-mandt.
    ls_water-sensor_id      = 'SENS004'.
    ls_water-timestamp      = '20240101150000'.
    ls_water-water_zone     = 'ZONE-B'.
    ls_water-reading_liters = '1200.00'.
    ls_water-alert_flag     = 'X'.
    APPEND ls_water TO lt_water.

    " Row 5 - Normal
    ls_water-mandt          = sy-mandt.
    ls_water-sensor_id      = 'SENS005'.
    ls_water-timestamp      = '20240101160000'.
    ls_water-water_zone     = 'ZONE-C'.
    ls_water-reading_liters = '75.00'.
    ls_water-alert_flag     = ''.
    APPEND ls_water TO lt_water.

    " Insert all into DB
  INSERT ztwater_data FROM TABLE @lt_water.

    IF sy-subrc = 0.
      out->write( '5 rows inserted successfully!' ).
    ELSE.
      out->write( 'Error! Data may already exist.' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.

