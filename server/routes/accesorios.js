// Archivo encargado de las rutas para manejar a los  de un personaje de dicho usuario

// Primero creamos una peticion hacia los accesorios, para que nos devuelvan los accesorios existentes en la base de datos
// Por ende, importmaos:
const express = require('express');
const router = express.Router(); // Nuestro manejador de rutas

const connection = require('../connection'); // Para indicar que se encuentra un directorio mas arriba

// PRIMERA PETICION: 'GET' Para poder obtener la informacion de la base de datos 
router.get('/todos_los_accesorios', async (req,res) => {
    try {
        // Seleccionamos todos los accesorios de la base de datos:
        const query = 'SELECT * FROM accesorio';
        const accesorios  = await connection.query(query); // se almacena en el objeto accesorios
        res.json(accesorios);
    } catch (error) {
        res.json({
            error: error
        });
    }
    return;
});


router.get('/precio_accesorio:id', async (req, res)=> {
    try {
        const acc_name_completo = req.params.id;
        const query = 'SELECT acc_price ' +
                        'FROM accesorio ' + 
                        'WHERE accesorio.acc_name LIKE ?';
        const precio_total = await connection.query(query, [acc_name_completo]);
        res.json(precio_total);
        
    } catch (error) {
        res.json({
            error: error
        })
    }
    return;
})

// Exportamos el objeto que creamos para el app.js:
module.exports = router; // Se exprota el meanejador de rutas