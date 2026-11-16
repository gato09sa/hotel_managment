# Bitacora de 18 Test Cases - reconstruccion a partir de pj2.pdf

**Procedencia**: PDF de Stage 2, seccion 4 y figuras 3-20 (paginas 10-23).
Este repositorio **no contiene los comandos originales de la consola**: los archivos `tests/sql/TC-XX.sql` son implementaciones reproducibles reconstruidas desde la descripcion y los resultados del informe.

Los resultados `Passed` pertenecen al informe original; NO se afirma que el codigo reconstruido haya sido ejecutado de nuevo. La secuencia importa porque TC-01 a TC-14 alteran los datos. En esta version automatizada, TC-12 requiere una ejecucion manual luego de los otros cambios.

| Test | Objetivo | Estado documentado en PDF | Que verifica la reconstruccion |
|---|---|---|---|
| [TC-01](evidence/TC-01.png) | FR_01: registrar/editar Diego Paredes | Passed | `guest_id=6`, telefono final `0987776655` |
| [TC-02](evidence/TC-02.png) | FR_02: tipo Family y habitacion 401 | Passed | 401, capacidad 5, tarifa 150 |
| [TC-03](evidence/TC-03.png) | FR_03: disponibilidad 11-13 dic | Passed | Solo 102, 302, 401 |
| [TC-04](evidence/TC-04.png) | FR_04: reservar 302 del 20-23 dic | Passed | ID 5, tarifa 70 |
| [TC-05](evidence/TC-05.png) | FR_05: evitar superposiciones | Passed (deteccion + limitacion) | Consulta detecta conflicto; las inserciones directas **no** se bloquean |
| [TC-06](evidence/TC-06.png) | FR_06: estados y fechas reales | Passed | Reserva 2 checked_out; reserva 5 cancelled |
| [TC-07](evidence/TC-07.png) | FR_07: pagos 75 y 100 | Passed | Total 175 |
| [TC-08](evidence/TC-08.png) | FR_08: 2 desayunos a 8.00 | Passed | Cargo conserva 8 aunque catalogo cambia a 9.50 |
| [TC-09](evidence/TC-09.png) | FR_09: balance | Passed | 140 + 51 - 175 = 16 |
| [TC-10](evidence/TC-10.png) | FR_10: busquedas | Passed | Guest 1: 1,6,7; fecha: 2,4; room 202: 2,6,7; canceladas: 3,5 |
| [TC-11](evidence/TC-11.png) | NFR_01: rendimiento | Passed (0.00 s en consola) | Solo smoke test, NO carga concurrente |
| [TC-12](evidence/TC-12.png) | NFR_03: reiniciar Docker | Passed | Manual: mismo numero de filas antes y despues |
| [TC-13](evidence/TC-13.png) | NFR_05: nombre NULL | Passed | MySQL error 1048 esperado |
| [TC-14](evidence/TC-14.png) | NFR_06: ampliar catalogos | Passed | Penthouse, Parking sin alterar reservas |
| [TC-15](evidence/TC-15.png) | FR_01: documento duplicado | Passed | MySQL error 1062 esperado |
| [TC-16](evidence/TC-16.png) | FR_02: capacidad cero | Passed | MySQL error 3819 esperado |
| [TC-17](evidence/TC-17.png) | FR_04: salida igual a entrada | Passed | MySQL error 3819 esperado |
| [TC-18](evidence/TC-18.png) | FR_07: pago negativo | Passed | MySQL error 3819 esperado |

## Como defender la metodologia

1. **Precondiciones:** cargar un esquema y los registros de ejemplo.
2. **Accion:** ejecutar los INSERT, UPDATE y SELECT del caso.
3. **Validacion:** comparar los resultados reales de MySQL con los esperados por el requisito.
4. **Evidencia:** guardar la salida de la consola y asociarla con el ID del caso.
5. **Pruebas negativas:** el test pasa si MySQL **rechaza** el dato invalido con el error esperado.

### Diferencia entre las pruebas de Stage 2 y las de Project Advance

Esta carpeta valida el **nivel SQL**. La consigna de Project Advance pide tambien pruebas de la **API HTTP CRUD** y la integracion **GUI-API**, que todavia no estan implementadas en esta reconstruccion. No presentarlas como ya realizadas.

## Capturas originales

Se incluyen recortes de las figuras 3-20 del PDF, conservando las evidencias visuales. Los archivos SQL del repositorio son reconstrucciones: al comparar, el profesor debe distinguir las capturas originales de los comandos reconstruidos.
