
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
## APK
## ScreenShots

<img width="464" height="821" alt="Captura de pantalla 2025-12-04 040108" src="https://github.com/user-attachments/assets/8e46ac3f-32b9-4a82-831f-fa87154ac7bc" />
<img width="452" height="814" alt="Captura de pantalla 2025-12-04 040324" src="https://github.com/user-attachments/assets/d245d92b-9967-4432-b0cf-83917d84eb75" />
<img width="456" height="820" alt="Captura de pantalla 2025-12-04 040241" src="https://github.com/user-attachments/assets/54659d78-1eeb-485e-a84f-008551b8aff1" />
<img width="462" height="818" alt="Captura de pantalla 2025-12-04 040029" src="https://github.com/user-attachments/assets/8dda4c23-94ad-4a41-be5a-e8ea56e55f89" />
<img width="464" height="822" alt="Captura de pantalla 2025-12-04 040011" src="https://github.com/user-attachments/assets/7abec4e9-6a9b-4521-adcd-a72b2eeaca86" />
<img width="463" height="814" alt="Captura de pantalla 2025-12-04 040129" src="https://github.com/user-attachments/assets/b075ddba-1047-4783-a5f4-416cea814e3e" />
<img width="464" height="823" alt="Captura de pantalla 2025-12-04 040751" src="https://github.com/user-attachments/assets/5d69f542-1e1e-4229-8188-f6ed6142d88e" />
<img width="465" height="818" alt="Captura de pantalla 2025-12-04 040809" src="https://github.com/user-attachments/assets/f1083fda-14fe-4e87-b8f9-4700665d64f6" />
<img width="389" height="586" alt="Captura de pantalla 2025-12-04 040340" src="https://github.com/user-attachments/assets/ea7f86f5-0211-40bd-9c79-ea84c003389c" />


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
 ```
## Navegación entre pantallas
```mermaid
---
config:
  layout: dagre
---
stateDiagram
  direction LR
  [*] --> Still
  Still --> [*]
  Still --> Moving
  Moving --> Still
  Moving --> Crash
  Crash --> Still
  Still --> s1
  Still --> s2
  s1 --> s3
  s2 --> Still
  s1 --> Still
  s3 --> s1
  s1 --> s4
  s4 --> s1
  s4 --> s5
  s5 --> s4
  s1 --> s6
  s6 --> s1
  Still:Home Page
  Moving:Settings
  Crash:Login/register
  s1:VoucherScreen
  s2:ConsultScreen
  s3:EditVoucher
  s4:AddVoucher
  s5:Send voucher (WhatsApp)
  s6:Send message (WhatsApp)
```


