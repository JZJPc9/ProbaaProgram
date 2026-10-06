require('dotenv').config();
const express = require('express');
const path = require('path');
const { createClient } = require('@supabase/supabase-js');

// Configuración de Supabase
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

const app = express();

// Configuración de Express y EJS
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));

// ==========================================
// RUTAS PRINCIPALES
// ==========================================

app.get('/', (req, res) => {
    res.render('inicio', { titulo: 'Bienvenido al Sistema de Probabilidad' });
});

// ==========================================
// RUTAS DE ADMINISTRADOR
// ==========================================

app.get('/panel-admin', async (req, res) => {
    const { data: bancos, error } = await supabase.from('bancos').select('*');
    if (error) return res.send('Error al cargar los bancos: ' + error.message);
    
    res.render('panel_admin', { bancos: bancos || [] });
});

app.post('/crear-banco', async (req, res) => {
    const { nombre, descripcion } = req.body;
    const { error } = await supabase.from('bancos').insert([{ nombre, descripcion }]);
    
    if (error) return res.send('Error al crear el banco');
    res.redirect('/panel-admin');
});

// Ruta GET: Ver un banco específico y sus preguntas
app.get('/banco/:id', async (req, res) => {
    const bancoId = req.params.id;

    const { data: banco, error: errorBanco } = await supabase
        .from('bancos')
        .select('*')
        .eq('id', bancoId)
        .single();

    const { data: preguntas } = await supabase
        .from('preguntas')
        .select('*')
        .eq('banco_id', bancoId);

    if (errorBanco) {
        return res.send('Error al cargar la información del banco');
    }

    res.render('banco', { banco: banco, preguntas: preguntas || [] });
});

// Ruta POST: Guardar una nueva pregunta manualmente
app.post('/banco/:id/agregar-pregunta', async (req, res) => {
    const bancoId = req.params.id;
    const { texto_pregunta, opcionA, opcionB, opcionC, opcionD, correcta } = req.body;

    const { error } = await supabase
        .from('preguntas')
        .insert([{
            banco_id: bancoId,
            texto_pregunta: texto_pregunta,
            opciones: [opcionA, opcionB, opcionC, opcionD],
            respuesta_correcta: correcta
        }]);

    if (error) {
        return res.send('Error al guardar la pregunta');
    }

    res.redirect(`/banco/${bancoId}`);
});

// ==========================================
// RUTAS DE ESTUDIANTE
// ==========================================

app.get('/estudiante', async (req, res) => {
    const { data: bancos } = await supabase.from('bancos').select('*');
    res.render('lista_bancos', { bancos: bancos || [] });
});

app.get('/examen/:bancoId', async (req, res) => {
    const bancoId = req.params.bancoId;
    const n = 5; // Número de preguntas a seleccionar

    const { data: preguntas } = await supabase
        .from('preguntas')
        .select('*')
        .eq('banco_id', bancoId);

    if (!preguntas || preguntas.length === 0) {
        return res.send('Este banco no tiene preguntas todavía.');
    }

    const mezcladas = preguntas.sort(() => 0.5 - Math.random());
    const seleccionadas = mezcladas.slice(0, n);

    res.render('quiz', { preguntas: seleccionadas, bancoId });
});

app.post('/calificar', async (req, res) => {
    const respuestasUsuario = req.body;
    const idsPreguntas = Object.keys(respuestasUsuario);

    // Validación crucial: Evita que el servidor caiga si envían el examen vacío
    if (idsPreguntas.length === 0) {
        return res.send('Debes responder al menos una pregunta antes de enviar el examen.');
    }

    const { data: correctas } = await supabase
        .from('preguntas')
        .select('id, texto_pregunta, respuesta_correcta')
        .in('id', idsPreguntas);

    let aciertos = 0;
    
    const resultados = correctas.map(p => {
        const respondida = respuestasUsuario[p.id];
        const esCorrecta = respondida === p.respuesta_correcta;
        if (esCorrecta) aciertos++;
        
        return {
            texto: p.texto_pregunta,
            respondida: respondida || 'No contestada',
            correcta: p.respuesta_correcta,
            esCorrecta: esCorrecta
        };
    });

    res.render('resultados', { resultados, aciertos, total: correctas.length });
});

// ==========================================
// INICIO DEL SERVIDOR
// ==========================================

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en el puerto ${PORT}`);
});