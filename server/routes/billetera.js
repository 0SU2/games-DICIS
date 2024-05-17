const express = require('express');
const router = express.Router();

const connection = require('../connection');

router.get('/mi_belletera:id', async (req,res) => {
    try {
        const username = req.params.id;
        const query = 'SELECT bil_amount, bil_id ' +
                        'FROM billetera ' +
                        'WHERE billetera.bil_usu_username LIKE ?';
        const money = await connection.query(query, [username]);
        console.log(money);
        res.json(money);
    } catch (error) {
        res.json({
            error:error
        });
    }
    return;
})

router.get('/agregar_dinero_billetera', async (req,res) => {
    try {
        const username = req.query.username;
        const money_reward = req.query.new_money;
        const query = 'UPDATE billetera ' +
                        'SET billetera.bil_amount = billetera.bil_amount + ? ' +
                        'WHERE billetera.bil_usu_username = ?';
        await connection.query(query, [money_reward, username]);
        res.json('Ok');
    } catch (error) {
        res.json({
            error: error
        });
    }
    return;
})

router.get('/crear_billetera', async(req,res) => {
    try {
        const bil_usu_username = req.query.usuario;
        console.log(bil_usu_username);
        const money_new = '1000';
        const query = 'INSERT INTO billetera(bil_usu_username, bil_amount) ' +
                        'VALUES (?, ?)';
        await connection.query(query, [bil_usu_username, money_new]);
        res.json('Ok');
    } catch (error) {
        res.json({
            error: error
        })
    }
    return;
})

router.get('/decrementar_dinero_billetera', async (req, res) => {
    try {
        const money_minus = req.query.total_a_pagar;
        const username = req.query.username;
        const query = 'UPDATE billetera ' +
                        'SET billetera.bil_amount = billetera.bil_amount - ? ' +
                        'WHERE billetera.bil_usu_username = ?'
        await connection.query(query, [money_minus, username]);
        res.json('Ok');
    } catch (error) {
        res.json({
            error: error
        });
    }
    return;
})


module.exports = router; 
