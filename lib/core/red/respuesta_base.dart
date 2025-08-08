class RespuestaBase<T> {
  static const int RESPUESTA_CORRECTA = 1;
  static const int RESPUESTA_ERROR = -1;

  final int codigoRespuesta;
  final T? respuesta;
  final String? mensajeError;

  const RespuestaBase({
    required this.codigoRespuesta,
    this.respuesta,
    this.mensajeError,
  });

  static RespuestaBase<T> respuestaCorrecta<T>(T data) {
    return RespuestaBase<T>(
      codigoRespuesta: RESPUESTA_CORRECTA,
      respuesta: data,
    );
  }

  static RespuestaBase<T> respuestaError<T>(String mensaje) {
    return RespuestaBase<T>(
      codigoRespuesta: RESPUESTA_ERROR,
      mensajeError: mensaje,
    );
  }
}

