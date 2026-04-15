CLASS zcl_water_analytics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_water_analytics IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    TYPES: BEGIN OF ty_water,
             sensor_id      TYPE ztwater_data-sensor_id,
             water_zone     TYPE ztwater_data-water_zone,
             reading_liters TYPE ztwater_data-reading_liters,
             timestamp      TYPE ztwater_data-timestamp,
             alert_flag     TYPE ztwater_data-alert_flag,
           END OF ty_water.

    TYPES: tt_water TYPE TABLE OF ty_water.

    DATA: lt_water        TYPE tt_water,
          ls_row          TYPE ty_water,
          lv_total_liters TYPE p DECIMALS 2,
          lv_alert_count  TYPE i,
          lv_normal_count TYPE i,
          lv_total_count  TYPE i.

    " ── Fetch Data ──────────────────────────────────
    SELECT sensor_id,
           water_zone,
           reading_liters,
           timestamp,
           alert_flag
      FROM ztwater_data
      ORDER BY sensor_id
      INTO TABLE @lt_water.

    " ════════════════════════════════════════════════
    out->write( '╔══════════════════════════════════════════════════╗' ).
    out->write( '║     SMART WATER CONSUMPTION ANALYTICS REPORT    ║' ).
    out->write( '╚══════════════════════════════════════════════════╝' ).
    out->write( ' ' ).

    " ── Column Header ───────────────────────────────
    out->write( '--- ALL SENSOR READINGS ---' ).
    out->write( ' ' ).

    " ── Data Rows ───────────────────────────────────
    LOOP AT lt_water INTO ls_row.

      lv_total_count  = lv_total_count + 1.
      lv_total_liters = lv_total_liters + ls_row-reading_liters.

      IF ls_row-alert_flag = 'X'.
        lv_alert_count = lv_alert_count + 1.
        out->write( |⚠  [ALERT] Sensor: { ls_row-sensor_id WIDTH = 10 }| &
                    | Zone: { ls_row-water_zone WIDTH = 8 }| &
                    | Liters: { ls_row-reading_liters }| ).
      ELSE.
        lv_normal_count = lv_normal_count + 1.
        out->write( |✅ [OK]    Sensor: { ls_row-sensor_id WIDTH = 10 }| &
                    | Zone: { ls_row-water_zone WIDTH = 8 }| &
                    | Liters: { ls_row-reading_liters }| ).
      ENDIF.

    ENDLOOP.

    " ── Zone-wise Summary ───────────────────────────
    out->write( ' ' ).
    out->write( '--- ZONE-WISE CONSUMPTION ---' ).
    out->write( ' ' ).

    TYPES: BEGIN OF ty_zone,
         water_zone     TYPE ztwater_data-water_zone,
         total_liters   TYPE p LENGTH 10 DECIMALS 2,
         sensor_count   TYPE i,
       END OF ty_zone.

    DATA: lt_zone  TYPE TABLE OF ty_zone,
          ls_zone  TYPE ty_zone.

    LOOP AT lt_water INTO ls_row.
      READ TABLE lt_zone INTO ls_zone
        WITH KEY water_zone = ls_row-water_zone.

      IF sy-subrc = 0.
        ls_zone-total_liters = ls_zone-total_liters + ls_row-reading_liters.
        ls_zone-sensor_count = ls_zone-sensor_count + 1.
        MODIFY lt_zone FROM ls_zone
          TRANSPORTING total_liters sensor_count
          WHERE water_zone = ls_row-water_zone.
      ELSE.
        ls_zone-water_zone   = ls_row-water_zone.
        ls_zone-total_liters = ls_row-reading_liters.
        ls_zone-sensor_count = 1.
        APPEND ls_zone TO lt_zone.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_zone INTO ls_zone.
      out->write( |📍 Zone: { ls_zone-water_zone WIDTH = 10 }| &
                  | Sensors: { ls_zone-sensor_count WIDTH = 4 }| &
                  | Total Liters: { ls_zone-total_liters }| ).
    ENDLOOP.

    " ── Final Summary ───────────────────────────────
    out->write( ' ' ).
    out->write( '--- OVERALL SUMMARY ---' ).
    out->write( ' ' ).
    out->write( |📊 Total Sensors  : { lv_total_count }| ).
    out->write( |💧 Total Liters   : { lv_total_liters }| ).
    out->write( |⚠  Alert Count    : { lv_alert_count }| ).
    out->write( |✅ Normal Count   : { lv_normal_count }| ).
    out->write( ' ' ).
    out->write( '╔══════════════════════════════════════════════════╗' ).
    out->write( '║                 END OF REPORT                   ║' ).
    out->write( '╚══════════════════════════════════════════════════╝' ).

  ENDMETHOD.

ENDCLASS.
