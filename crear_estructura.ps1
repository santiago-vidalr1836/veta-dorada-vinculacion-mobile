# ─── crear_estructura.ps1 ───
Param(
  [string]$Base = "."
)

# Moverse al directorio base
Set-Location $Base

# Estructura principal
md lib\core, lib\features -Force
ni lib\main.dart, lib\rutas.dart, lib\contenedor_inyeccion.dart -ItemType File -Force

# --- lib\core ---
md lib\core\constantes, lib\core\errores, lib\core\red, lib\core\servicios, lib\core\componentes, lib\core\utilidades -Force
ni lib\core\constantes\rutas.dart -ItemType File -Force
ni lib\core\errores\failure.dart -ItemType File -Force
ni lib\core\red\cliente_http.dart -ItemType File -Force

# Servicios transversales
ni lib\core\servicios\servicio_conectividad.dart, lib\core\servicios\servicio_bd_local.dart, lib\core\servicios\servicio_camara.dart, lib\core\servicios\servicio_ubicacion.dart -ItemType File -Force

# --- features\autenticacion ---
md lib\features\autenticacion\datos\fuentes_datos, lib\features\autenticacion\datos\repositorios, lib\features\autenticacion\dominio\entidades, lib\features\autenticacion\dominio\repositorios, lib\features\autenticacion\dominio\casos_uso, lib\features\autenticacion\presentacion\bloc, lib\features\autenticacion\presentacion\paginas -Force
ni lib\features\autenticacion\datos\fuentes_datos\azure_auth_remote_data_source.dart -ItemType File -Force
ni lib\features\autenticacion\datos\repositorios\auth_repository_impl.dart -ItemType File -Force
ni lib\features\autenticacion\dominio\entidades\usuario.dart, lib\features\autenticacion\dominio\entidades\estado_autenticacion.dart -ItemType File -Force
ni lib\features\autenticacion\dominio\repositorios\auth_repository.dart -ItemType File -Force
ni lib\features\autenticacion\dominio\casos_uso\iniciar_sesion.dart, lib\features\autenticacion\dominio\casos_uso\cerrar_sesion.dart -ItemType File -Force
ni lib\features\autenticacion\presentacion\bloc\auth_bloc.dart, lib\features\autenticacion\presentacion\bloc\auth_event.dart, lib\features\autenticacion\presentacion\bloc\auth_state.dart -ItemType File -Force
ni lib\features\autenticacion\presentacion\paginas\login_page.dart -ItemType File -Force

# --- features\visitas ---
md lib\features\visitas\datos\fuentes_datos, lib\features\visitas\datos\modelos, lib\features\visitas\datos\repositorios, lib\features\visitas\dominio\entidades, lib\features\visitas\dominio\repositorios, lib\features\visitas\dominio\casos_uso, lib\features\visitas\presentacion\bloc, lib\features\visitas\presentacion\paginas, lib\features\visitas\presentacion\componentes -Force
ni lib\features\visitas\datos\fuentes_datos\visits_remote_data_source.dart, lib\features\visitas\datos\fuentes_datos\visits_local_data_source.dart -ItemType File -Force
ni lib\features\visitas\datos\modelos\visita_model.dart -ItemType File -Force
ni lib\features\visitas\datos\repositorios\visits_repository_impl.dart -ItemType File -Force
ni lib\features\visitas\dominio\entidades\visita.dart, lib\features\visitas\dominio\entidades\estado_visita.dart -ItemType File -Force
ni lib\features\visitas\dominio\repositorios\visits_repository.dart -ItemType File -Force
ni lib\features\visitas\dominio\casos_uso\obtener_visitas_por_estado.dart, lib\features\visitas\dominio\casos_uso\eliminar_borrador.dart -ItemType File -Force
ni lib\features\visitas\presentacion\bloc\visits_bloc.dart, lib\features\visitas\presentacion\bloc\visits_event.dart, lib\features\visitas\presentacion\bloc\visits_state.dart -ItemType File -Force
ni lib\features\visitas\presentacion\paginas\visitas_tabs_page.dart -ItemType File -Force
ni lib\features\visitas\presentacion\componentes\visit_card.dart, lib\features\visitas\presentacion\componentes\pestana_personalizada.dart -ItemType File -Force

# --- features\flujo_visita ---
md lib\features\flujo_visita\datos\repositorios, lib\features\flujo_visita\dominio\entidades, lib\features\flujo_visita\dominio\repositorios, lib\features\flujo_visita\dominio\casos_uso, lib\features\flujo_visita\presentacion\bloc, lib\features\flujo_visita\presentacion\paginas, lib\features\flujo_visita\presentacion\componentes -Force
ni lib\features\flujo_visita\datos\repositorios\flow_repository_impl.dart -ItemType File -Force
ni lib\features\flujo_visita\dominio\entidades\entrada_visita.dart, lib\features\flujo_visita\dominio\entidades\campo_x.dart -ItemType File -Force
ni lib\features\flujo_visita\dominio\repositorios\flow_repository.dart -ItemType File -Force
ni lib\features\flujo_visita\dominio\casos_uso\guardar_datos_paso.dart, lib\features\flujo_visita\dominio\casos_uso\completar_flujo.dart -ItemType File -Force
ni lib\features\flujo_visita\presentacion\bloc\flow_bloc.dart, lib\features\flujo_visita\presentacion\bloc\flow_event.dart, lib\features\flujo_visita\presentacion\bloc\flow_state.dart -ItemType File -Force
ni lib\features\flujo_visita\presentacion\paginas\paso1_page.dart, lib\features\flujo_visita\presentacion\paginas\paso2_page.dart, lib\features\flujo_visita\presentacion\paginas\paso3_page.dart, lib\features\flujo_visita\presentacion\paginas\paso4_page.dart, lib\features\flujo_visita\presentacion\paginas\paso5_page.dart, lib\features\flujo_visita\presentacion\paginas\paso6_page.dart, lib\features\flujo_visita\presentacion\paginas\paso7_page.dart, lib\features\flujo_visita\presentacion\paginas\paso8_page.dart, lib\features\flujo_visita\presentacion\paginas\paso9_page.dart, lib\features\flujo_visita\presentacion\paginas\resumen_page.dart -ItemType File -Force
ni lib\features\flujo_visita\presentacion\componentes\indicador_progreso.dart, lib\features\flujo_visita\presentacion\componentes\boton_navegacion.dart -ItemType File -Force
