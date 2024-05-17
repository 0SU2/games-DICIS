const express = require('express');
const router = express.Router();

const connection = require('../connection');

router.get('/todos_los_usuarios', async(req,res) => {
    try {
        const query = 'SELECT usu_username, usu_email, usu_region FROM usuario';
        const usuarios = await connection.query(query);
        res.json(usuarios);
    } catch (error) {
        res.json({
            error: error
        });
    }
    return;
})

router.get('/busqueda_usuario:usu_username', async(req,res) => {
    try {
        const api_data = req.params.usu_username;
        const query = 'SELECT usuario.usu_password ' +
                        'FROM usuario ' + 
                        'WHERE usuario.usu_username LIKE ?';
        const usuario_name = await connection.query(query, [api_data]);
        res.json(usuario_name);
    } catch (error) {
        res.json({
            error:error
        });
    }
    return;
})

router.post('/nuevo_usuario', async(req,res) => {
    try {
        const body = req.body;
        const query = 'INSERT INTO usuario (usu_username, usu_email, usu_password, usu_birthday, usu_region) ' +
                        'VALUES (?, ?, ?, ?, ?)';
        console.log(body);
        await connection.query(query, [body.usu_username, body.usu_email, body.usu_password, body.usu_birthday, body.usu_region]);
        res.json('Ok');
    } catch (error) {
        res.json({
            error:error
        });
    }
    return;
})


module.exports = router;

