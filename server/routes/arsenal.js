const express = require('express');
const router = express.Router();

const connection = require('../connection');

router.get('/todos_los_arsenales:usu_name', async (req, res) => {
    try {
        const usu_name = req.params.usu_name;
        const query = 'SELECT s.asi_usu_username, s.asi_per_name, ' +
                      'GROUP_CONCAT(a.ars_arm_name ORDER BY a.ars_arm_name ASC SEPARATOR ", ") AS ars_armas, ' +
                      'GROUP_CONCAT(a.ars_acc_name ORDER BY a.ars_acc_name ASC SEPARATOR ", ") AS ars_accesorios ' +
                      'FROM asignacion AS s ' +
                      'INNER JOIN arsenal AS a ' +
                      'ON asi_id = ars_asi_id ' +
                      'GROUP BY s.asi_id ' +
                      'HAVING s.asi_usu_username = ?';
        const arsenales = await connection.query(query, [usu_name]);
        res.json(arsenales);
    } catch (error) {
        res.json ({
            error: error
        });
    }
    return;
});

router.get('/arsenal_especifico', async (req, res) => {
    try {
        const per_name = req.query.per_name;
        const usu_name = req.query.usu_name;
        const query = 'SELECT s.asi_usu_username, s.asi_per_name, a.ars_arm_name, a.ars_acc_name, a.ars_id ' +
                      'FROM asignacion AS s ' +
                      'INNER JOIN arsenal AS a ' +
                      'ON asi_id = ars_asi_id ' +
                      'HAVING s.asi_usu_username = ? AND s.asi_per_name = ?';
        const arsenales_especifico = await connection.query(query, [usu_name, per_name]);
        res.json(arsenales_especifico);
    } catch (error) {
        res.json ({
            error: error
        });
    }
    return;
});

router.delete('/eliminar_arsenal:ars_id', async (req, res) => {
    try {
        const ars_id = req.params.ars_id;
        const query = 'DELETE FROM arsenal WHERE ars_id = ?';

        const result = await connection.query(query, [ars_id]);
    } catch (error) {
        res.json ({
            error: error
        });
    }
    return;
});

router.get('/nuevo_arsenal', async(req,res) => {
    try {
        const id_asignacion = req.query.id_asignacion;
        const ars_acc_name = req.query.accesorio_elegido;
        const ars_arm_name = req.query.arma_elegida;
        const ars_buy = req.query.total_a_pagar;
        const ars_date_created = req.query.datetime;

        const query = 'INSERT INTO arsenal (ars_asi_id , ars_arm_name, ars_acc_name, ars_date_created, ars_buy) ' +
                        'VALUES (?,?,?,?,?) ';
        
        await connection.query(query, [id_asignacion, ars_arm_name, ars_acc_name, ars_date_created, ars_buy]);
        res.json('Ok');
    } catch (error) {
        res.json({
            error: error
        });
    }
    return;
})

router.get('/datos_especificos:id', async(req,res) => {
    try {
        const arsenal_id = req.params.id;
        const query = 'SELECT ars_arm_name, ars_acc_name ' +
                        'FROM arsenal '+
                        'WHERE ars_id LIKE ?'
        const respuesta = await connection.query(query, [arsenal_id]);
        res.json(respuesta); 
    } catch (error) {
        res.json({
            error: error
        })
    }
    return;
})

module.exports = router; 

