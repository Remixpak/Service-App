
# Service App

Service App es una aplicación Cross-Platform que ofrece un servicio de consultas y administración de vouchers para productos de tiendas. 

## Authors

- [@remixpak](https://github.com/Remixpak)
- [@iondrw](https://github.com/iondrw)


## Features

- Permite que los usuarios se puedan identificar como clientes o como administradores.
- Permite que aquellos que usuarios que sean administradores puedan emitir, editar y eliminar comprobantes
- Tanto los usuarios como los comprobantes deben quedar guardados en la nube
- Todo tipo de usuario registrado o no puede consultar cualquier comprobante con el numero de orden
- Al emitir un comprobante este registra su "ID"/numero de orden automaticamente
- Los ID de los comprobantes deben ser unicos
- Aquellos usuarios administradores pueden asignar el rol a otros usuarios registrados
  
## Flujo de la App
```mermaid
---
config:
  theme: redux
---
flowchart TB
    A(["Start"]) --> B{"Administrador?"}
    B --> C["NO"] & D["Sí"]
    C --> n1["Mostrar sólo botón de consultas"]
    D --> n2["Mostrar botón de consultas y comprobantes"]
    n3["Emitir Comprobante?"] --> n4["Sí"] & n5["no"]
    n2 --> n17["Consultar?"]
    n4 --> n6["Emitir comprobante"]
    n5 --> n7["Editar Comprobante?"]
    n7 --> n8["Si"] & n9["no"]
    n8 --> n10["Editar campos"]
    n9 --> n11["Eliminar comprobante"]
    n6 --> n12["Añadir campos"]
    n10 --> n13["Guardar cambios"]
    n12 --> n14["Guardar comprobante"]
    n1 --> n15["Ingresar ID del comprobante"]
    n15 --> n16["Mostrar comprobante correspondiente"]
    n17 --> n18["Sí"] & n19["No"]
    n19 --> n3
    n20["Ingresar ID del comprobante"] --> n21["Mostrar comprobante correspondiente"]
    n18 --> n20

    n3@{ shape: diam}
    n17@{ shape: diam}
    n7@{ shape: diam}
    n20@{ shape: rect}
    n21@{ shape: rect}


