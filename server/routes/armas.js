// Archivo encagarad de las rutas para manejar a las armas, INSERTAR; ELIMINAR, CONSULTAR 

// Primero creamos una peticion hacia las armas, para que nos devuelvan a las armas que tenemos en la base de datos
// Para ello, primero impotamos:
const express = require('express'); 
const router = express.Router(); // Nuestro manejador de rutas

const connection = require('../connection'); // Es para indicar que el archivo connection se encuentra en la parte de arrriba

// Primero se hace la peticion OBTENER Y MOSTRAR LAS ARMAS DE LA BASE DE DATOS
router.get('/todas_las_armas', async (req,res) => {
    try {
        // Seleccionarmos a las amas de la base de datos:
        const query = 'SELECT * FROM arma'; 
        const armas = await connection.query(query); // Recuperamos el objeto const armas
        res.json(armas); // Regresamos la informacion en formato JSON.
    } catch (error) {
        // En caso de que no se cumpla la condicion anterior:
        res.json({
            error: error
        });
    }
    return ; 
});

router.get('/precio_arma:id', async (req, res) => {
    try {
        const arma_id = req.params.id;
        const query = 'SELECT arm_price ' + 
                        'FROM arma ' + 
                        'WHERE arma.arm_name LIKE ?'
        const precio_arma = await connection.query(query, [arma_id]);
        
        res.json(precio_arma);
    } catch (error) {
        res.json({
            error: error
        });
    }
    return;
})

// Exportamos el objeto que creamos para el app.js:
module.exports = router; // Se exprota el meanejador de rutas