require('dotenv').config();
const express = require('express');
const session = require('express-session');
const path = require('path');
const { Pool } = require('pg');

const dbUrl = process.env.DATABASE_URL || '';
const useSsl = dbUrl && !dbUrl.includes('railway.internal') && !dbUrl.includes('localhost');

const pool = new Pool({
    connectionString: dbUrl,
    ssl: useSsl ? { rejectUnauthorized: false } : false
});

const app = express();

// Interruptor para habilitar o deshabilitar la selección de preguntas
const PERMITIR_ELEGIR_CANTIDAD = false;
const CANTIDAD_PREGUNTAS_FIJA = 5;

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));

app.use(session({
    secret: process.env.SESSION_SECRET || 'secreto-local-desarrollo',
    resave: false,
    saveUninitialized: false,
    cookie: {
        httpOnly: true,
        maxAge: 1000 * 60 * 60 * 4 // 4 horas de sesión
    }
}));

// Disponible en todas las vistas EJS para mostrar controles solo si hay sesión activa
app.use((req, res, next) => {
    res.locals.esAdmin = Boolean(req.session && req.session.esAdmin);
    next();
});

// Middleware que bloquea el acceso directo si no estás autenticado
function verificarAdmin(req, res, next) {
    if (req.session && req.session.esAdmin) {
        return next();
    }
    return res.redirect('/admin');
}

// ==========================================
// RUTAS DE AUTENTICACIÓN ADMIN (OCULTAS)
// ==========================================

app.get('/admin', (req, res) => {
    if (req.session && req.session.esAdmin) {
        return res.redirect('/panel-admin');
    }
    res.render('login_admin', { error: null });
});

app.post('/admin', (req, res) => {
    const { usuario, password } = req.body;
    const adminUser = process.env.ADMIN_USER || 'admin';
    const adminPass = process.env.ADMIN_PASSWORD;

    if (adminPass && usuario === adminUser && password === adminPass) {
        req.session.esAdmin = true;
        return res.redirect('/panel-admin');
    }

    res.render('login_admin', { error: 'Usuario o contraseña incorrectos.' });
});

app.get('/logout', (req, res) => {
    req.session.destroy(() => {
        res.redirect('/');
    });
});

// ==========================================
// RUTA PRINCIPAL (PÚBLICA)
// ==========================================

app.get('/', (req, res) => {
    res.render('inicio', { titulo: 'Simulador de Probabilidad y Estadística' });
});

// ==========================================
// RUTAS DE ADMINISTRADOR (PROTEGIDAS)
// ==========================================

app.get('/panel-admin', verificarAdmin, async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT b.*, COUNT(p.id)::int AS total_preguntas
            FROM bancos b
            LEFT JOIN preguntas p ON p.banco_id = b.id
            GROUP BY b.id
            ORDER BY b.nombre ASC
        `);
        res.render('panel_admin', { bancos: result.rows });
    } catch (err) {
        res.status(500).send('Error al cargar los bancos: ' + err.message);
    }
});

app.post('/crear-banco', verificarAdmin, async (req, res) => {
    const { nombre, descripcion } = req.body;
    try {
        await pool.query(
            'INSERT INTO bancos (nombre, descripcion) VALUES ($1, $2)',
            [nombre, descripcion]
        );
        res.redirect('/panel-admin');
    } catch (err) {
        res.status(500).send('Error al crear el banco: ' + err.message);
    }
});

app.get('/banco/:id', verificarAdmin, async (req, res) => {
    const { id } = req.params;
    try {
        const bancoRes = await pool.query('SELECT * FROM bancos WHERE id = $1', [id]);
        if (bancoRes.rows.length === 0) return res.status(404).send('Banco no encontrado');

        const preguntasRes = await pool.query('SELECT * FROM preguntas WHERE banco_id = $1', [id]);
        res.render('banco', { banco: bancoRes.rows[0], preguntas: preguntasRes.rows });
    } catch (err) {
        res.status(500).send('Error al cargar el banco: ' + err.message);
    }
});

app.post('/banco/:id/agregar-pregunta', verificarAdmin, async (req, res) => {
    const { id } = req.params;
    const { texto_pregunta, opcionA, opcionB, opcionC, opcionD, correcta } = req.body;
    const opciones = JSON.stringify([opcionA, opcionB, opcionC, opcionD]);

    try {
        await pool.query(
            'INSERT INTO preguntas (banco_id, texto_pregunta, opciones, respuesta_correcta) VALUES ($1, $2, $3::jsonb, $4)',
            [id, texto_pregunta, opciones, correcta]
        );
        res.redirect(`/banco/${id}`);
    } catch (err) {
        res.status(500).send('Error al guardar la pregunta: ' + err.message);
    }
});

app.post('/pregunta/:id/eliminar', verificarAdmin, async (req, res) => {
    const { id } = req.params;
    const { banco_id } = req.body;
    try {
        await pool.query('DELETE FROM preguntas WHERE id = $1', [id]);
        res.redirect(`/banco/${banco_id}`);
    } catch (err) {
        res.status(500).send('Error al eliminar la pregunta');
    }
});

// ==========================================
// RUTAS DE ESTUDIANTE (PÚBLICAS)
// ==========================================

app.get('/estudiante', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT b.*, COUNT(p.id)::int AS total_preguntas
            FROM bancos b
            LEFT JOIN preguntas p ON p.banco_id = b.id
            GROUP BY b.id
            ORDER BY b.nombre ASC
        `);
        res.render('lista_bancos', {
            bancos: result.rows,
            permitirElegirCantidad: PERMITIR_ELEGIR_CANTIDAD,
            cantidadFija: CANTIDAD_PREGUNTAS_FIJA
        });
    } catch (err) {
        res.status(500).send('Error al cargar los bancos: ' + err.message);
    }
});

app.get('/examen/:bancoId', async (req, res) => {
    const { bancoId } = req.params;
    const n = PERMITIR_ELEGIR_CANTIDAD
        ? Math.max(1, parseInt(req.query.n, 10) || CANTIDAD_PREGUNTAS_FIJA)
        : CANTIDAD_PREGUNTAS_FIJA;

    try {
        const bancoRes = await pool.query('SELECT * FROM bancos WHERE id = $1', [bancoId]);
        if (bancoRes.rows.length === 0) return res.status(404).send('Banco no encontrado');

        const preguntasRes = await pool.query(
            'SELECT * FROM preguntas WHERE banco_id = $1 ORDER BY RANDOM() LIMIT $2',
            [bancoId, n]
        );

        if (preguntasRes.rows.length === 0) {
            return res.send('Este banco aún no tiene preguntas registradas.');
        }

        const preguntas = preguntasRes.rows.map(p => {
            const ops = [...p.opciones];
            for (let i = ops.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                [ops[i], ops[j]] = [ops[j], ops[i]];
            }
            return { ...p, opciones: ops };
        });

        res.render('quiz', { banco: bancoRes.rows[0], preguntas });
    } catch (err) {
        res.status(500).send('Error al generar el examen: ' + err.message);
    }
});

app.post('/calificar', async (req, res) => {
    const { bancoId, ...respuestasUsuario } = req.body;
    const idsPreguntas = Object.keys(respuestasUsuario);

    if (idsPreguntas.length === 0) return res.redirect('/estudiante');

    try {
        const result = await pool.query(
            'SELECT id, texto_pregunta, respuesta_correcta FROM preguntas WHERE id = ANY($1::uuid[])',
            [idsPreguntas]
        );

        let aciertos = 0;
        const resultados = result.rows.map(p => {
            const respondida = respuestasUsuario[p.id];
            const esCorrecta = respondida === p.respuesta_correcta;
            if (esCorrecta) aciertos++;

            return {
                texto: p.texto_pregunta,
                respondida: respondida || 'No contestada',
                correcta: p.respuesta_correcta,
                esCorrecta
            };
        });

        res.render('resultados', {
            resultados,
            aciertos,
            total: result.rows.length,
            bancoId
        });
    } catch (err) {
        res.status(500).send('Error al calificar el examen: ' + err.message);
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en el puerto ${PORT}`);
});