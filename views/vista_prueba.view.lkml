view: vista_prueba {
  derived_table: {
    # Aquí creamos múltiples filas virtuales en lugar de solo SELECT 1.
    # Esto nos dará volumen de datos para que los gráficos tengan sentido.
    sql:
      SELECT '2025-01-01' AS fecha, 'Chile' AS pais, 0.85 AS porcentaje
      UNION ALL
      SELECT '2025-02-01' AS fecha, 'Argentina' AS pais, 0.60 AS porcentaje
      UNION ALL
      SELECT '2025-03-01' AS fecha, 'Peru' AS pais, 0.75 AS porcentaje
      UNION ALL
      SELECT '2025-04-01' AS fecha, 'Chile' AS pais, 0.90 AS porcentaje
      UNION ALL
      SELECT '2025-05-01' AS fecha, 'Argentina' AS pais, 0.65 AS porcentaje
      UNION ALL
      SELECT '2025-06-01' AS fecha, 'Peru' AS pais, 0.80 AS porcentaje
      ;;
  }

  label: "Vista Prueba Demo"

  # --- DIMENSIONES (Leen los datos de la tabla derivada) ---

  dimension: fecha {
    type: date
    # Mantenemos el casteo a fecha que tenías en tu código
    sql: CAST(${TABLE}.fecha AS DATE) ;;
  }

  dimension: paises {
    type: string
    # Ahora cada fila tendrá un país distinto, permitiendo agrupar en gráficos
    sql: ${TABLE}.pais ;;
  }

  dimension: porcentaje_base {
    type: number
    hidden: yes # Ocultamos la dimensión pura para usar la medida
    sql: ${TABLE}.porcentaje ;;
  }

  # --- MEDIDAS ---

  measure: porcentaje_promedio {
    type: average # Usamos un promedio para la métrica
    sql: ${porcentaje_base} ;;
    value_format_name: percent_1
  }

  # --- EXTRAS DE TU CÓDIGO (Si aún los necesitas) ---

  dimension: fecha_actual {
    type: date
    sql: CURRENT_DATE() ;;
  }

  parameter: selector_fecha {
    type: date
    default_value: "2026-01-01"
  }

  dimension: fecha_dinamica {
    type: date
    sql: CAST({% parameter selector_fecha %} AS DATE) ;;
  }
}
