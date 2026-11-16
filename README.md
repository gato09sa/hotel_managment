# Comprehensive Hotel Management and Administration System

Proyecto universitario de diseno e implementacion de una BD para **un hotel**, con siete tablas: `guest`, `room_type`, `room`, `reservation`, `payment`, `service` y `service_charge`.

## Estado y honestidad de las fuentes

Este repositorio es una **reconstruccion reproducible basada en `pj2.pdf`**, no una copia exacta de los scripts SQL usados inicialmente en Stage 2. El PDF reporta 18 casos `Passed` ejecutados manualmente en MySQL 8.0.33 (Docker: `mysqlcontainer2`); aqui se aporta un archivo SQL por caso y un ejecutor para repetirlos en un esquema aislado. No se ha verificado de nuevo su ejecucion en el MySQL del equipo del estudiante.

Los archivos `01_schema.sql`, `02_sample_data.sql` y `03_queries.sql` se recrearon respetando el esquema, los valores principales y las reglas documentadas. Los datos de ejemplo que no figuraban en el PDF son **ficticios**, construidos para poder reproducir los resultados esperados.

## Estructura

```text
hotel-management-reproducible/
  README.md
  database/01_schema.sql        # MySQL 8.0: 7 tablas, llaves, checks, indices
  database/02_sample_data.sql   # Fixtures ficticios de prueba
  database/03_queries.sql       # Disponibilidad, conflictos y balances
  tests/sql/TC-01.sql ... TC-18.sql  # Un SQL por caso documentado
  tests/run_all.py              # Runner secuencial y validacion de resultados
  tests/TC-12_manual.md         # Reinicio Docker (manual)
  docs/TEST_CASES.md            # Trazabilidad de los 18 tests
  docs/PROCEDIMIENTO_PASO_A_PASO.md # Explicacion de cada prueba
  docs/evidence/TC-01.png ... # Capturas del PDF, 18 imagenes
  docs/TRACEABILITY.md          # Diferencias PDF/codigo y limitaciones
  docs/pj2.pdf                  # Especificacion Stage 2, fuente primaria
  docs/README_Stage2_source.md # Documentacion anterior preservada
```

## Requisitos para ejecutar

- MySQL 8.0.16 o superior con `CHECK` activo (referencia: 8.0.33).
- Docker y el contenedor `mysqlcontainer2` funcionando (por defecto), o cliente `mysql` local.
- Python 3.9+ para ejecutar `tests/run_all.py` (solo biblioteca estandar).
- Permisos para crear/eliminar **solo la base de prueba `hotel_management_test`**.

## Ejecucion automatica de pruebas

En Ubuntu con contenedor Docker existente:

```bash
export HOTEL_MYSQL_MODE=docker
export HOTEL_MYSQL_CONTAINER=mysqlcontainer2
export HOTEL_MYSQL_USER=root
# Solo en tu terminal local, sin compartir passwords en GitHub:
read -rs -p 'Password MySQL: ' HOTEL_MYSQL_PASSWORD; echo
export HOTEL_MYSQL_PASSWORD
python3 tests/run_all.py --reset-test-db
unset HOTEL_MYSQL_PASSWORD
```

Para un servidor MySQL accesible mediante el cliente local:

```bash
export HOTEL_MYSQL_MODE=local
export HOTEL_MYSQL_HOST=127.0.0.1
export HOTEL_MYSQL_PORT=3306
export HOTEL_MYSQL_USER=root
read -rs -p 'Password MySQL: ' HOTEL_MYSQL_PASSWORD; echo
export HOTEL_MYSQL_PASSWORD
python3 tests/run_all.py --reset-test-db
unset HOTEL_MYSQL_PASSWORD
```

El runner recrea **unicamente `hotel_management_test`**, carga tablas y fixtures, y ejecuta los tests en orden. Valida 17 tests; TC-12 depende de reiniciar Docker y se explica en `tests/TC-12_manual.md`. Los tests de errores esperan los codigos **1048, 1062 y 3819**. TC-05 evidencia una limitacion, no un bloqueo completo; TC-11 es una prueba basica, no una prueba de estres.

**No ejecutes el reset contra una BD real con datos que quieras conservar.** No se recomienda subir contrasenas, claves, ni exportaciones con datos de personas reales.

## Manual: inspeccionar scripts

Si solo quieres revisar SQL, abre `database/01_schema.sql`, luego los SQL de cada prueba, y consulta `docs/TEST_CASES.md`. La carpeta `database/` usa el nombre `hotel_management` y sirve para desplegar el esquema nuevo; el runner sustituye dicho nombre por `hotel_management_test` para ejecutar pruebas sin afectar tu BD principal.

## Limitaciones y siguiente fase

- No se garantizan reservas sin solapamiento ante inserciones directas (ver TC-05).
- No se implementan usuarios por rol, backups diarios, cifrado TLS ni pruebas de concurrencia.
- No hay API/GUI entregada en este paquete. Para *Project Advance* falta implementar API CRUD 70%, GUI 50% e integracion, y generar **nuevos tests HTTP**.

El documento original `docs/pj2.pdf` contiene la seccion 4 y las capturas de los tests manuales. Los scripts de esta entrega son una *reproduccion* de su comportamiento, no sus originales.

## Evidencias originales y guia

- [Procedimiento de cada test](docs/PROCEDIMIENTO_PASO_A_PASO.md)
- [Tabla de 18 pruebas con capturas enlazadas](docs/TEST_CASES.md)
- [Evidencia original: TC-05](docs/evidence/TC-05.png)

## Cómo publicarlo en GitHub

1. Crea un repositorio privado vacío, por ejemplo `hotel-management-system`, en GitHub.
2. En la carpeta de este proyecto ejecuta:

```bash
git init -b main
git add .
git commit -m "Documentar esquema y 18 pruebas MySQL (reconstruccion)"
git remote add origin https://github.com/TU_USUARIO/hotel-management-system.git
git push -u origin main
```

El contenido se entrega listo para GitHub, pero **no se ha publicado aun** porque la conexion disponible solo expone otro repositorio (`IEEEXTREME---CODES`), ajeno a esta asignatura.
