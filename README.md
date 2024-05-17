# Games 

Para la instalacion debes entrar individualmente mediante tu terminal a las carpetas client y server. Tienes que tener instalado [Node JS](https://nodejs.org/en/download/prebuilt-installer). Además de haber clonado el repositorio.

### Server
1. Entras a la carpeta server.
2. Dentro en tu terminal escribes: `npm install`
3. Entras al archivo `connection.js`.
4. Cambias los valores ( Esto valores dependen de como hayas configurado tu MySQL ): 
    - "user". 
    - "password".
5. Entra a MySQL.
6. Abre el archivo `games_db.sql`.
7. Ejecuta la base de datos y ve que se haya creado de forma correcta.
8. Abre tu terminal donde realizaste el paso **2.** 
9. Dentro de la terminal escribe: `npm run dev`.
10. La terminal te marcara que la API se ejecuto sin problema y la base de datos se conecto sin ningun error.

**NO CIERRES PARA NADA ESTA TERMINAL O VENTANA DONDE SE ESTE EJEUCANTO EL SERVER. SOLO AL TERMINAR CUALQUIER CAMBIO QUE SE REALICE.**

***

### Client
1. Abre una nueva terminal.
2. Entra a la carpeta **client**.
3. Dentro en tu terminal escribes: `npm install`.
4. ( Opcional ) Escribe en tu terminal: `npm run build`.
5. Escribe en tu terminal: `npm run serve`.
6. Abre el localhost y la pagina estara en funcion con la base de datos conectada.
