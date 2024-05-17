const express = require('express');
const router = express.Router();

const connection = require('../connection');

router.get('/todas_las_asignaciones', async(req,res) =>{
    try{
        const query = 'SELECT * FROM asignacion ';
        const asignaciones = await connection.query(query);
        res.json(asignaciones);
    }catch (error) {
        res.json({
            error: error
        });
    }
    return;

});

router.get('/mis_personajes:id', async(req,res) => {
    try {
        const asi_usu_username = req.params.id;
        const query = 'SELECT * FROM asignacion ' + 
                        'WHERE asignacion.asi_usu_username LIKE ?'
        const personajes = await connection.query(query, [asi_usu_username]);
        res.json(personajes);
    } catch (error) {
        res.json({
            error: error
        })
    }
});

router.delete('/eliminar_asignacion', async (req,res)=> {
    try{
        const asi_id = req.body.asi_id
        const query ='DELETE FROM asignacion WHERE asi_id = ?';
        await connection.query(query,[asi_id]);
        res.json('OK'); 
    }catch (error){
            res.json({
                error:error
            });
    }
    return;
});

router.post('/nueva_asignacion', async(req,res) => {
    try{
        const body = req.body;
        const query = 'INSERT INTO asignacion ' +
                      '(asi_usu_username,asi_per_name,asi_date_created,asi_time_created) ' +
                      'VALUES (?,?,?,?)'; 
        await connection.query(query,[body.asi_usu_username, body.asi_per_name, body.asi_date_created, body.asi_time_created]);
        res.json('OK'); 
    }catch(error){
        res.json({
            error:error
        });        
    }
    return;
});

router.get('/obtener_id_asignacion', async (req, res) =>{
    try {
        const username = req.query.username;
        const character = req.query.character;
        const query = 'SELECT asi_id ' + 
                        'FROM asignacion '+ 
                        'WHERE asignacion.asi_usu_username LIKE ? ' + 
                        'AND (asignacion.asi_per_name LIKE ?)'
    
        const id = await connection.query(query, [username, character]);

        res.json(id);

    } catch (error) {
        res.json({
            error: error
        })
    }
    return
} )

module.exports = router; 