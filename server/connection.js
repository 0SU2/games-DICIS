const mysql = require('mysql');
const { promisify } =  require('util');

const connection = mysql.createPool({
    // cambiar el nombre de tu nombre del host que usas
    host: 'localhost',
    user: '',
    password: '',
    database: 'games_db'
})

connection.getConnection( (err, con) => {
    if(err){
        console.log("No se logro conexion con la DB" + err.stack);
    }
    if(con){
        console.log("DB CONECTADA!");
    }
    return;
})

connection.query = promisify(connection.query);

module.exports = connection



