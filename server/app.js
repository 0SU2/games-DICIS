const express = require('express');
const app = express();
const morgan = require('morgan');
const cors = require('cors');
const path = require('path');

const history = require('connect-history-api-fallback');

app.use(cors());
app.use(history());
app.use(morgan('tiny'));

app.use(express.json());
app.use(express.urlencoded({extended: true}));
app.use(express.static(path.join(__dirname, 'public')));


app.use('/usuarios', require('./routes/usuarios.js'));
app.use('/personajes', require('./routes/personajes.js'));
// app.use('/accesorios', require('./routes/accesorios.js').default);
app.use('/armas', require('./routes/armas.js'));
app.use('/asignaciones', require('./routes/asignaciones.js'));
app.use('/arsenal', require('./routes/arsenal.js'));
app.use('/billetera', require('./routes/billetera.js'));


// puerto donde estara escuchando la API para usarse en nuestro framework
app.listen( 2023, () => {
        console.log('API ejecutada con exito');
    }
);

