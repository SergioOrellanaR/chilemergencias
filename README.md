# chilemergencias V1.0

Este proyecto muestra los servicios de urgencia mas cercanos a la ubicación actual dentro de Chile, para hacerlo correr en su máquina loca, necesita setear la siguiente configuración primero:

1.- En info.plist y androidManifest inserte su propia Mapbox key (Conseguible en https://www.mapbox.com/ creando una cuenta).

2.- Cree una llave local y configurela en key.properties on la carpeta de android con los siguientes datos (Cambie value por los datos generados en su llave) 

storePassword=value
keyPassword=value
keyAlias=value
storeFile=value

La aplicación se encuentra ampliamente testeada en Android, pero aún no en iOS, por lo que las correcciones correspondientes se subirán en la versión 1.0.1.

Los archivos Json ubicados en la carpeta "Data" son solo ejemplo con 18 edificaciones de servicios de urgencia en chile (6 en cada archivo) ubicado en el norte del país, si desea acceder a toda la información (con mas de 1500 edificaciones), puede contactarme via PM o email a serorellanar@gmail.com

# chilemergencias V1.0 (Eng)

This proyect shows the closest urgency service (Police station, Hospital or Fire station) in Chile, if you want to run and make this app work on your local machine, you need to set these configuration first:

1.- On info.plist and androidManifest set your own mapbox Key, on tag <YOUR_MAPBOX_API_KEY>.

2.- Create a key and set it up on key.properties on android folder with the following data (change value for your key values):

storePassword=value
keyPassword=value
keyAlias=value
storeFile=value

This app works at 100% on Android, but hasn't been tested on iOS yet, so any correction foir iOS will be uploaded on 1.0.1 version.

Json files located on data folder are just examples for testing with 18 buildings (6 on each file) located on Chile's north, if you want all the information and location of the different buildings (with more than 1500 different buildings), you can contact me via PM or email at serorellanar@gmail.com.
