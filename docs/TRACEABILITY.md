# Trazabilidad y limites

- **Fuentes**: `pj2.pdf`, Stage 2 (16 nov 2026), y `README_Hotel_Management.md` suministrado.
- **Recreado, no recuperado**: scripts SQL, datos de demostracion y asserts de cada test. Los resultados objetivos y las reglas reflejan el PDF pero algunos nombres y datos iniciales se inventaron solo para hacer reproducible la demostracion; no se deben citar como transcripcion literal.
- **Verificable**: `tests/run_all.py` utiliza un esquema separado `hotel_management_test` que elimina y vuelve a crear. Nunca resetea `hotel_management` de produccion.
- **TC-05**: el control de overlap **no es atomicamente exigido** por la BD. Un SELECT previo no previene inserciones directas ni carreras entre clientes. Requiere transaccion con bloqueo adecuado o mecanismo equivalente.
- **TC-11**: el reporte de 0.00 sec en la consola no valida un SLO de tres segundos bajo carga.
- **TC-12**: se mantiene manual para proteger el contenedor del usuario.
- **Sin API**: No existe Flask, frontend ni tests HTTP reales en estos archivos. Se debe desarrollar para Project Advance.
- **Sin credenciales**: las contrasenas y .env reales nunca se suben a GitHub.
