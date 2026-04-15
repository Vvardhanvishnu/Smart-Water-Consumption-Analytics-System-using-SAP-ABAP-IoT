CLASS zcl_water_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_water_report IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: lt_water TYPE TABLE OF ztwater_data,
          ls_water TYPE ztwater_data.

    " Fetch all data
    SELECT *
      FROM ztwater_data
      ORDER BY sensor_id
      INTO TABLE @lt_water.

    out->write( '=== Smart Water Consumption Report ===' ).
    out->write( ' ' ).

    LOOP AT lt_water INTO ls_water.

      out->write( |Sensor: { ls_water-sensor_id } | &
                  |Zone: { ls_water-water_zone } | &
                  |Liters: { ls_water-reading_liters } | &
                  |Alert: { ls_water-alert_flag }| ).

    ENDLOOP.

    out->write( ' ' ).
    out->write( '=== End of Report ===' ).

  ENDMETHOD.

ENDCLASS.
