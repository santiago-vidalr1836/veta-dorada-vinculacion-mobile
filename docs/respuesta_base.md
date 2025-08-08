# Uso de `RespuestaBase`

Las respuestas de la API se envuelven en un objeto JSON con la siguiente estructura:

```json
{
  "codigoRespuesta": 1,
  "respuesta": {},
  "mensaje": "Descripción del error opcional"
}
```

* `codigoRespuesta` indica si la petición fue exitosa (`1`) o si ocurrió un error (`-1`).
* `respuesta` contiene los datos específicos de la operación cuando `codigoRespuesta` es correcto.
* `mensaje` es un texto opcional que describe el error cuando `codigoRespuesta` es negativo.

Las fuentes de datos remotas deben analizar este formato y convertirlo en instancias de la clase `RespuestaBase<T>`. Los consumidores (por ejemplo, BLoCs, widgets o servicios) deben inspeccionar `codigoRespuesta` antes de usar el valor de `respuesta` y manejar adecuadamente los mensajes de error.

Este patrón garantiza una gestión coherente de errores y facilita la propagación de advertencias desde la capa de datos hasta la interfaz de usuario.
