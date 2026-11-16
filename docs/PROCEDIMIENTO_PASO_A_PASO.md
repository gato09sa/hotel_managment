# Cómo se hicieron las 18 pruebas de Stage 2

**Fuente:** Sección 4 y figuras 3 a 20 de `pj2.pdf`. Se distingue entre (a) los pasos y resultados **documentados realmente en el PDF** y (b) scripts de **reproducción reconstruidos** en `tests/sql/`. No se afirma que la reconstrucción sea una copia byte por byte de los comandos originales.

**Preparación:** En la consola MySQL 8.0.33 se utilizó la base `hotel_management` en el contenedor `mysqlcontainer2`. Se partió de tablas previamente creadas y datos de ejemplo. Los casos se ejecutaron en orden: los casos posteriores aprovecharon las filas y modificaciones anteriores. El runner de este repositorio usa una base diferente (`hotel_management_test`) por seguridad.

## TC-01 — Registrar y actualizar un huésped (FR_01)

1. Precondición: no existe el documento `1798765432`.
2. Se usa `INSERT` para registrar a **Diego Paredes**.
3. Se consulta con `SELECT` por identificación y se confirma que `guest_id=6`.
4. Se cambia el teléfono con `UPDATE` y se consulta de nuevo.
5. Resultado esperado/reportado: `0987776655` en el mismo registro. Prueba `Passed`.

**Por qué sirve:** demuestra creación, búsqueda y modificación sin duplicar el huésped. [Captura](evidence/TC-01.png).

## TC-02 — Registrar tipo de habitación y habitación (FR_02)

1. Precondición: existen los tipos Single, Double y Suite.
2. Se inserta tipo **Family**, capacidad `5`, tarifa `150.00`.
3. Se inserta habitación **401**, piso `4`, estado `available`, ligada al nuevo tipo mediante `room_type_id`.
4. Se consulta con `JOIN` de `room` y `room_type`.
5. Resultado: habitación 401, tipo Family, capacidad 5, tarifa 150.00. `Passed`.

**Por qué sirve:** valida la FK y la relación 1:N entre tipos y habitaciones. [Captura](evidence/TC-02.png).

## TC-03 — Buscar disponibilidad por fecha y capacidad (FR_03)

1. Precondición: 202 está reservada 10-15 dic; 201 está ocupada 12-14 dic; 301 está fuera de servicio.
2. Se solicita capacidad al menos `2` para noches del **11 al 13 de diciembre de 2026**.
3. La consulta relaciona habitaciones con tipos mediante `JOIN`, filtra `status='available'` y excluye fechas con reservas activas solapadas.
4. Resultado: solamente **102, 302 y 401**. `Passed`.

**Por qué sirve:** combina `JOIN`, comparación de fechas, `NOT EXISTS` y reglas de negocio. [Captura](evidence/TC-03.png).

## TC-04 — Crear reserva (FR_04)

1. Precondición: existen huésped 5 y habitación 302 (`room_id=6`) y está libre del 20 al 23 dic.
2. Se inserta reserva para ese huésped y habitación, fechas `2026-12-20` y `2026-12-23`, precio nocturno `70.00`, estado `booked`.
3. Se consulta el nuevo registro.
4. Resultado: `reservation_id=5`, con los datos esperados. `Passed`.

**Por qué sirve:** demuestra que las FK conectan huéspedes, reservas y habitaciones. [Captura](evidence/TC-04.png).

## TC-05 — Conflicto de reservas (FR_05)

1. Precondición: habitación 202 (`room_id=4`) ya tiene reserva 2 del 10 al 15 dic.
2. Consulta de conflicto para `14-16 dic`: `existing.start < requested.end` y `existing.end > requested.start` en reservas `booked` o `checked_in`.
3. La consulta detecta correctamente la reserva 2.
4. **Para revelar la limitación**, se insertan directamente dos reservas superpuestas (IDs 6 y 7) sin ejecutar la validación antes de guardarlas.
5. MySQL acepta ambas. El informe indica `Passed` como demostración de la detección y de la limitación existente.

**Advertencia:** NO prueba que la base bloquee solapamientos automáticamente. Nunca repetir las inserciones de conflicto en producción. [Captura](evidence/TC-05.png).

## TC-06 — Cambiar estados y fechas reales (FR_06)

1. Precondición: reservas 2 y 5 están `booked`.
2. Con `UPDATE`, la reserva 2 pasa a `checked_in` con fecha real `2026-12-10`.
3. Después pasa a `checked_out` y registra salida real `2026-12-14`.
4. Se actualiza la reserva 5 a `cancelled`.
5. Se consultan los cambios; el estado final y ambas fechas permanecen. `Passed`.

**Por qué sirve:** demuestra que los datos de una reserva pueden evolucionar sin perder fechas reales. [Captura](evidence/TC-06.png).

## TC-07 — Registrar pagos parciales (FR_07)

1. Precondición: reserva 4 existe y no tiene pagos.
2. Se registra un pago `75.00`, método `cash`, fecha `2026-12-12`, estado `completed`.
3. Se registra otro pago `100.00`, método `debit_card`, fecha `2026-12-14`, estado `completed`.
4. Se consulta la tabla `payment` filtrando por reserva 4.
5. Resultado: dos pagos, total **175.00**. `Passed`.

**Por qué sirve:** verifica la relación 1:N reserva-pagos. [Captura](evidence/TC-07.png).

## TC-08 — Mantener precio histórico de servicios (FR_08)

1. Precondición: el desayuno cuesta `8.00` y la reserva 4 tiene un cargo de Spa por `35.00`.
2. Se inserta un cargo por `2` desayunos, fecha `2026-12-13`, precio unitario `8.00`.
3. Se verifica que la línea vale `16.00`.
4. Se cambia en el catálogo `service.standard_price` a `9.50`.
5. La consulta conjunta muestra catálogo `9.50` y cargo histórico `8.00`. `Passed`.

**Por qué sirve:** asegura que actualizar precios del catálogo no altere lo cobrado previamente. [Captura](evidence/TC-08.png).

## TC-09 — Resumen y saldo de reserva (FR_09)

1. Precondición: TC-07 y TC-08 completados.
2. Costo de habitación: dos noches × `70.00` = `140.00`.
3. Costo de servicios: spa `35.00` + desayunos `16.00` = `51.00`.
4. Pagos completados = `175.00`.
5. Se calcula saldo: `140 + 51 - 175 = 16.00`. `Passed`.

**Por qué sirve:** el total se calcula a partir de tablas relacionadas, no se almacena duplicado. [Captura](evidence/TC-09.png).

## TC-10 — Búsquedas administrativas (FR_10)

1. Se consulta por identificación del huésped Ana Torres (`1712345678`), fecha, habitación y estado.
2. Por huésped aparecen reservas `1,6,7`.
3. Por fecha `2026-12-13` aparecen `2,4`.
4. Por habitación 202 aparecen `2,6,7`.
5. Por estado `cancelled` aparecen `3,5`. `Passed`.

**Por qué sirve:** valida filtros `WHERE` diferentes para una misma tabla. [Captura](evidence/TC-10.png).

## TC-11 — Tiempo de una búsqueda (NFR_01)

1. Se ejecuta la consulta de disponibilidad usada antes.
2. Se lee la duración indicada por la consola.
3. El informe muestra `0.00 sec` y registra `Passed`.

**Límite:** una consulta sobre pocos registros, sin usuarios concurrentes, no demuestra rendimiento en producción ni garantiza la meta de 3 segundos. [Captura](evidence/TC-11.png).

## TC-12 — Persistencia tras reinicio de Docker (NFR_03)

1. Se cuentan registros en `guest`, `room`, `reservation` y `payment`.
2. Se detiene y vuelve a iniciar **el contenedor controlado por el equipo** (`mysqlcontainer2`).
3. Se vuelve a conectar MySQL y se repite la consulta de conteo.
4. Resultado original: **6 huéspedes, 7 habitaciones, 7 reservas y 5 pagos** antes y después. `Passed`.

**Límite:** se valida persistencia en un reinicio, no recuperación desde backup. El runner no apaga Docker; ver `tests/TC-12_manual.md`. [Captura](evidence/TC-12.png).

## TC-13 — NOT NULL (NFR_05)

1. Se intenta insertar un huésped con `full_name=NULL`.
2. MySQL responde con **ERROR 1048** y no guarda fila.
3. `Passed`: en pruebas negativas el resultado correcto es el rechazo. [Captura](evidence/TC-13.png).

## TC-14 — Extender catálogos (NFR_06)

1. Se crea tipo **Penthouse**, capacidad `6`, precio `300.00`.
2. Se crea servicio **Parking**, precio `5.00`.
3. Se consultan ambas inserciones y se comprueba que las siete reservas existentes siguen intactas.
4. `Passed`. [Captura](evidence/TC-14.png).

## TC-15 — UNIQUE (FR_01)

1. Ya existe huésped Ana Torres con identificación `1712345678`.
2. Se intenta insertar otra persona con el mismo documento.
3. MySQL responde **ERROR 1062**, rechazo por `uq_guest_identification_number`.
4. `Passed`. [Captura](evidence/TC-15.png).

## TC-16 — Capacidad positiva (FR_02)

1. Se intenta crear tipo de habitación `Broken` con capacidad `0`.
2. MySQL rechaza por `ck_room_type_capacity_positive`, **ERROR 3819**.
3. `Passed`. [Captura](evidence/TC-16.png).

## TC-17 — Fechas ordenadas (FR_04)

1. Se intenta crear una reserva cuya entrada y salida son `2026-12-25`.
2. MySQL rechaza por `ck_reservation_dates_ordered`, **ERROR 3819**.
3. `Passed`. [Captura](evidence/TC-17.png).

## TC-18 — Pagos positivos (FR_07)

1. Se intenta registrar un pago de `-10.00` para la reserva 4.
2. MySQL rechaza por `ck_payment_amount_positive`, **ERROR 3819**.
3. `Passed`. [Captura](evidence/TC-18.png).

## Lo que falta en Project Advance

Estas pruebas son de nivel **SQL/MySQL**. Para la nueva entrega hace falta implementar endpoints de API, probar CRUD por HTTP y demostrar desde la GUI que las operaciones llegan a MySQL. Ninguno de esos tests HTTP está incluido en la evidencia original Stage 2.
