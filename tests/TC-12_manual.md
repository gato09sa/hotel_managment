# TC-12: persistencia tras reiniciar el contenedor (manual)

**Basado en:** NFR_03, pj2.pdf pagina 13. El informe dice que se mantuvieron 6 huespedes, 7 habitaciones, 7 reservas y 5 pagos.

No se automatiza la parada del contenedor para evitar interrumpir otras bases de datos.

1. Ejecuta `python3 tests/run_all.py --reset-test-db` con el contenedor `mysqlcontainer2` en marcha.
2. Ejecuta dos veces `tests/sql/TC-12.sql` (una antes y otra despues del reinicio):

   ```bash
   docker exec -i mysqlcontainer2 mysql -u root -p hotel_management_test < tests/sql/TC-12.sql
   ```

   Si tu version de MySQL solicita la contrasena de modo interactivo, abre primero `docker exec -it mysqlcontainer2 mysql -u root -p` y utiliza `SOURCE` desde un archivo copiado al contenedor. Alternativamente, configura el acceso por cliente local.

3. Registra los conteos previos. Deten y arranca **solo si controlas ese contenedor**:

   ```bash
   docker stop mysqlcontainer2
   docker start mysqlcontainer2
   ```

4. Ejecuta de nuevo la consulta y compara. Si los cuatro totales coinciden, la prueba de persistencia pasa.

Nota: esta prueba NO comprueba restauracion de respaldos ni alta disponibilidad.
