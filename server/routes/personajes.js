const express = require('express');
const router = express.Router();

const connection = require('../connection');

router.get('/todos_los_personajes', async(req,res) =>{
    try{
        const query = 'SELECT * FROM personaje';
        const personajes = await connection.query(query);
        res.json(personajes);
    }catch (error) {
        res.json({
            error: error
        });
    }
    return;

});

router.post('/nuevo_det_personaje', async(req,res)=>{
    try{
        const body = req.body;
        const query = 'INSERT INTO asignacion ' +
                      '(asi_usu_username, asi_per_name, asi_date_created) ' +
                      'VALUES (?,?,?)';
        await connection.query(query,[body.asi_usu_username, body.asi_per_name, body.asi_date_created]);
        res.json('OK');
    }catch(error){
        res.json({
            error:error
        });        
    }

    return;
});

module.exports = router; 