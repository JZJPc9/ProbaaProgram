-- ============================================================================
-- RESPALDO COMPLETO: PROBABILIDAD Y ESTADÍSTICA — EQUIPO 6
-- Motor: PostgreSQL (Railway)
-- Contenido: Esquema + 3 Bancos + 60 Reactivos con soporte LaTeX
-- ============================================================================

BEGIN;

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. ESTRUCTURA DE TABLAS
CREATE TABLE IF NOT EXISTS perfiles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    rol VARCHAR(50) DEFAULT 'estudiante'
);

CREATE TABLE IF NOT EXISTS bancos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    creado_por UUID REFERENCES perfiles(id)
);

CREATE TABLE IF NOT EXISTS preguntas (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    banco_id UUID REFERENCES bancos(id) ON DELETE CASCADE,
    texto_pregunta TEXT NOT NULL,
    opciones JSONB NOT NULL,
    respuesta_correcta TEXT NOT NULL
);

-- 2. INSERCIÓN DE BANCOS Y REACTIVOS
DO $$
DECLARE
    v_banco1_id UUID;
    v_banco2_id UUID;
    v_banco3_id UUID;
BEGIN
    -- ========================================================================
    -- BANCO 1: UNIDAD 1 (20 PREGUNTAS)
    -- ========================================================================
    IF NOT EXISTS (SELECT 1 FROM bancos WHERE nombre = 'Unidad-1: Fundamentos de la probabilidad (Primer parcial)') THEN
        INSERT INTO bancos (nombre, descripcion)
        VALUES (
            'Unidad-1: Fundamentos de la probabilidad (Primer parcial)',
            'Reactivos de conteo, combinatoria, axiomas, probabilidad condicional y Bayes.'
        )
        RETURNING id INTO v_banco1_id;

        INSERT INTO preguntas (banco_id, texto_pregunta, opciones, respuesta_correcta) VALUES
        (
            v_banco1_id,
            '¿En qué consiste el complemento de un evento $A$ (denotado como $A''$) dentro de un espacio muestral $S$?',
            '["Es el subconjunto formado por todos los elementos de $S$ que NO pertenecen al evento $A$.", "Es el evento que contiene únicamente los elementos comunes entre $A$ y $B$.", "Es la unión de todos los eventos mutuamente excluyentes del experimento.", "Es el conjunto vacío ($\\emptyset$) resultante de restar el espacio muestral a $A$."]'::jsonb,
            'Es el subconjunto formado por todos los elementos de $S$ que NO pertenecen al evento $A$.'
        ),
        (
            v_banco1_id,
            '¿Cuál es la fórmula para calcular el número de permutaciones circulares de $n$ objetos distintos ordenados alrededor de un círculo?',
            '["$n!$", "$(n - 1)!$", "$n^r$", "$\\frac{n!}{(n - r)!}$"]'::jsonb,
            '$(n - 1)!$'
        ),
        (
            v_banco1_id,
            'En un grupo de 100 estudiantes, 54 cursaron Matemáticas, 69 cursaron Historia y 35 cursaron ambas materias. Si se selecciona un estudiante al azar, ¿cuál es la probabilidad de que haya cursado Matemáticas O Historia?',
            '["$0.54$", "$0.35$", "$0.88$", "$1.23$"]'::jsonb,
            '$0.88$'
        ),
        (
            v_banco1_id,
            'Se desea colocar a 6 directivos alrededor de una mesa circular de conferencias. ¿De cuántas formas distintas se puede realizar este acomodo?',
            '["720 formas", "120 formas", "36 formas", "24 formas"]'::jsonb,
            '120 formas'
        ),
        (
            v_banco1_id,
            'Un testigo informa que la matrícula de un automóvil contenía tres letras fijas seguidas por 3 dígitos distintos, de los cuales el primero era un 5. Si los 2 dígitos restantes son diferentes entre sí y distintos de 5, ¿cuántos registros como máximo se deben revisar?',
            '["72", "90", "100", "720"]'::jsonb,
            '72'
        ),
        (
            v_banco1_id,
            'Si $A$ y $B$ son dos eventos que NO son mutuamente excluyentes, ¿cuál es la expresión correcta para $P(A \cup B)$?',
            '["$P(A) + P(B)$", "$P(A) + P(B) - P(A \\cap B)$", "$P(A) \\cdot P(B)$", "$P(A) + P(B) + P(A \\cap B)$"]'::jsonb,
            '$P(A) + P(B) - P(A \cap B)$'
        ),
        (
            v_banco1_id,
            'Dos eventos $A$ y $B$ son independientes si y solo si:',
            '["$A \\cap B = \\emptyset$", "$P(A \\cup B) = P(A) + P(B)$", "$P(B \\mid A) = P(B)$", "$P(A) + P(B) = 1$"]'::jsonb,
            '$P(B \mid A) = P(B)$'
        ),
        (
            v_banco1_id,
            '¿De cuántas maneras puede extraerse una mano de póker que conste de 2 cartas rojas y 3 cartas negras de una baraja inglesa de 52 cartas?',
            '["65,780", "2,598,960", "1,690,000", "845,000"]'::jsonb,
            '845,000'
        ),
        (
            v_banco1_id,
            'Tres máquinas $B_1, B_2$ y $B_3$ montan 30%, 45% y 25% de los productos, y tienen 2%, 3% y 2% de defectuosos, respectivamente. Si un producto resulta defectuoso, ¿cuál es la probabilidad de que haya sido ensamblado por $B_2$?',
            '["$0.450$", "$0.551$", "$0.245$", "$0.030$"]'::jsonb,
            '$0.551$'
        ),
        (
            v_banco1_id,
            'La probabilidad de que un vuelo salga a tiempo es $P(D) = 0.83$, de que llegue a tiempo es $P(A) = 0.82$ y de que salga y llegue a tiempo es $P(D \cap A) = 0.78$. ¿Cuál es $P(A \mid D)$?',
            '["$0.940$", "$0.950$", "$0.780$", "$0.820$"]'::jsonb,
            '$0.940$'
        ),
        (
            v_banco1_id,
            '¿Cuál es la diferencia entre un modelo determinístico y un modelo probabilístico (estocástico)?',
            '["El modelo determinístico depende del azar y el probabilístico siempre da una solución única.", "El modelo determinístico da un resultado único y conocido con certeza, mientras que el probabilístico asigna alternativas al azar con una distribución de probabilidades.", "Ambos modelos requieren exactamente la misma información inicial y siempre ofrecen un rango de respuestas.", "El modelo probabilístico solo se aplica a experimentos con un espacio muestral de dos elementos."]'::jsonb,
            'El modelo determinístico da un resultado único y conocido con certeza, mientras que el probabilístico asigna alternativas al azar con una distribución de probabilidades.'
        ),
        (
            v_banco1_id,
            'En la teoría de conjuntos y probabilidad, ¿cuándo se dice que dos eventos $A$ y $B$ son mutuamente excluyentes?',
            '["Cuando ocurren al mismo tiempo.", "Cuando la probabilidad de su unión es igual a cero.", "Cuando su unión abarca todo el espacio muestral $S$.", "Cuando no tienen elementos en común, es decir, $A \\cap B = \\emptyset$."]'::jsonb,
            'Cuando no tienen elementos en común, es decir, $A \cap B = \emptyset$.'
        ),
        (
            v_banco1_id,
            'Un menú permite armar una comida eligiendo 1 entrada de 3 opciones, 1 plato fuerte de 5 opciones y 1 postre de 4 opciones. ¿Cuántas combinaciones diferentes de menú se pueden formar?',
            '["12", "20", "60", "120"]'::jsonb,
            '60'
        ),
        (
            v_banco1_id,
            'En un torneo de ajedrez participan 8 jugadores. Si se van a premiar los 3 primeros lugares (oro, plata y bronce), ¿de cuántas formas distintas se pueden otorgar estos 3 premios?',
            '["56", "336", "512", "672"]'::jsonb,
            '336'
        ),
        (
            v_banco1_id,
            'En una empresa, el 70% habla inglés ($I$) y el 40% habla alemán ($A$). Si el 25% habla ambos idiomas, ¿cuál es la probabilidad de que un empleado hable alemán, sabiendo que ya habla inglés?',
            '["$35.71\\%$", "$57.14\\%$", "$62.50\\%$", "$28.00\\%$"]'::jsonb,
            '$35.71\%$'
        ),
        (
            v_banco1_id,
            'Se lanza una moneda equilibrada 5 veces y en todos cae ''águila''. ¿Qué puede afirmarse sobre la probabilidad de que en el sexto lanzamiento caiga ''águila'' nuevamente?',
            '["Es menor a $0.5$, porque ya ''toca'' que caiga sol", "Es mayor a $0.5$, porque hay una racha", "Sigue siendo $0.5$, porque los lanzamientos son independientes", "Es imposible saberlo sin más información"]'::jsonb,
            'Sigue siendo $0.5$, porque los lanzamientos son independientes'
        ),
        (
            v_banco1_id,
            'Dos eventos $A$ y $B$ son independientes si se cumple que:',
            '["$P(A \\cap B) = P(A) + P(B)$", "$P(A \\mid B) = P(A)$", "$P(A \\cup B) = P(A) \\cdot P(B)$", "$P(A \\cap B) = 0$"]'::jsonb,
            '$P(A \mid B) = P(A)$'
        ),
        (
            v_banco1_id,
            'Un comité de 4 personas será seleccionado al azar de un grupo formado por 6 hombres y 5 mujeres. ¿Cuál es la probabilidad de que el comité quede formado por exactamente 2 hombres y 2 mujeres?',
            '["$\\frac{5}{11}$", "$\\frac{1}{2}$", "$\\frac{3}{7}$", "$\\frac{4}{9}$"]'::jsonb,
            '$\frac{5}{11}$'
        ),
        (
            v_banco1_id,
            'En un grupo de 50 estudiantes, 30 juegan fútbol, 20 juegan básquetbol y 10 juegan ambos. Si se elige al azar un estudiante que juega fútbol, ¿cuál es la probabilidad de que también juegue básquetbol?',
            '["$\\frac{1}{5}$", "$\\frac{1}{2}$", "$\\frac{2}{5}$", "$\\frac{1}{3}$"]'::jsonb,
            '$\frac{1}{3}$'
        ),
        (
            v_banco1_id,
            'Un entrenador de baloncesto tiene 12 jugadores disponibles y debe elegir 5 para el quinteto titular, sin asignar posiciones específicas. ¿De cuántas formas distintas puede elegir el quinteto?',
            '["792 quintetos posibles", "95,040 quintetos posibles", "120 quintetos posibles", "60 quintetos posibles"]'::jsonb,
            '792 quintetos posibles'
        );
    END IF;

    -- ========================================================================
    -- BANCO 2: UNIDAD 2 (20 PREGUNTAS)
    -- ========================================================================
    IF NOT EXISTS (SELECT 1 FROM bancos WHERE nombre = 'Unidad-2: Variables aleatorias y distribuciones (Segundo parcial)') THEN
        INSERT INTO bancos (nombre, descripcion)
        VALUES (
            'Unidad-2: Variables aleatorias y distribuciones (Segundo parcial)',
            'Reactivos sobre variables aleatorias discretas y continuas, tablas de probabilidad, función acumulada, esperanza y varianza.'
        )
        RETURNING id INTO v_banco2_id;

        INSERT INTO preguntas (banco_id, texto_pregunta, opciones, respuesta_correcta) VALUES
        (
            v_banco2_id,
            '¿Qué es una variable aleatoria en el contexto de un experimento estadístico?',
            '["Una función que asocia un número real a cada elemento del espacio muestral $S$.", "Un evento cuya probabilidad de ocurrencia siempre es igual a $0.5$.", "Cualquier parámetro desconocido de una población finita.", "El conjunto de todos los resultados posibles antes de realizar el experimento."]'::jsonb,
            'Una función que asocia un número real a cada elemento del espacio muestral $S$.'
        ),
        (
            v_banco2_id,
            '¿Cuál de los siguientes ejemplos corresponde a una variable aleatoria discreta (VAD)?',
            '["El número de llamadas recibidas en un centro de atención durante una hora.", "El tiempo exacto de duración (en horas) de una batería antes de descargarse.", "La temperatura ambiente registrada en un laboratorio a lo largo del día.", "La estatura exacta en centímetros de los estudiantes de un grupo."]'::jsonb,
            'El número de llamadas recibidas en un centro de atención durante una hora.'
        ),
        (
            v_banco2_id,
            '¿Cuál de las siguientes variables representa una variable aleatoria continua (VAC)?',
            '["El peso neto en gramos del contenido de un envase industrial.", "La cantidad de artículos defectuosos encontrados en un lote de 50 piezas.", "El número de intentos necesarios hasta encestar un tiro libre.", "La cantidad de clientes que entran a una tienda en un turno."]'::jsonb,
            'El peso neto en gramos del contenido de un envase industrial.'
        ),
        (
            v_banco2_id,
            'Para que una función $f(x)$ sea una función de masa de probabilidad válida de una variable aleatoria discreta, debe cumplirse que $f(x) \ge 0$ para todo $x$ y además:',
            '["$\\sum_{x} f(x) = 1$", "$\\sum_{x} f(x) = 0$", "$f(x) \\le 0.5$ para todo $x$", "$\\sum_{x} x \\cdot f(x) = 1$"]'::jsonb,
            '$\sum_{x} f(x) = 1$'
        ),
        (
            v_banco2_id,
            'Sea $X$ una variable aleatoria discreta con distribución dada por $f(x) = \frac{x}{k}$ para $x \in \{1, 2, 3, 4\}$. ¿Cuál debe ser el valor de la constante $k$?',
            '["$k = 10$", "$k = 4$", "$k = 6$", "$k = 24$"]'::jsonb,
            '$k = 10$'
        ),
        (
            v_banco2_id,
            'En una tabla de distribución de probabilidad para $X \in \{0, 1, 2, 3\}$, se sabe que $P(X=0)=0.15$, $P(X=1)=0.35$ y $P(X=2)=0.30$. ¿Cuál es el valor de $P(X=3)$?',
            '["$0.20$", "$0.80$", "$0.25$", "$0.10$"]'::jsonb,
            '$0.20$'
        ),
        (
            v_banco2_id,
            'Se lanza una moneda equilibrada 2 veces y se define $X$ como el número de águilas obtenidas. ¿Cuál es la distribución de probabilidad $f(x)$ correcta?',
            '["$f(0)=0.25,\\; f(1)=0.50,\\; f(2)=0.25$", "$f(0)=0.33,\\; f(1)=0.33,\\; f(2)=0.33$", "$f(0)=0.50,\\; f(1)=0.25,\\; f(2)=0.25$", "$f(1)=0.50,\\; f(2)=0.50$"]'::jsonb,
            '$f(0)=0.25,\; f(1)=0.50,\; f(2)=0.25$'
        ),
        (
            v_banco2_id,
            '¿Cómo se define formalmente la función de distribución acumulada $F(x)$ para cualquier variable aleatoria $X$?',
            '["$F(x) = P(X \\le x)$", "$F(x) = P(X = x)$", "$F(x) = P(X > x)$", "$F(x) = 1 - P(X < x)$"]'::jsonb,
            '$F(x) = P(X \le x)$'
        ),
        (
            v_banco2_id,
            'Dada la función de distribución acumulada $F(x)$ de una variable discreta con $F(1) = 0.25$, $F(2) = 0.60$ y $F(3) = 0.85$, ¿cuál es el valor de $P(X = 3)$?',
            '["$0.25$", "$0.85$", "$0.60$", "$0.15$"]'::jsonb,
            '$0.25$'
        ),
        (
            v_banco2_id,
            'Si $X$ es una variable aleatoria continua con función de densidad $f(x)$, ¿cuál es el valor de la probabilidad en un punto exacto $P(X = c)$?',
            '["$0$", "$f(c)$", "$1$", "$0.5$"]'::jsonb,
            '$0$'
        ),
        (
            v_banco2_id,
            'Para que una función $f(x)$ sea una función de densidad de probabilidad (FDP) válida de una variable aleatoria continua, debe cumplir $f(x) \ge 0$ y:',
            '["$\\int_{-\\infty}^{\\infty} f(x)\\,dx = 1$", "$\\int_{-\\infty}^{\\infty} x f(x)\\,dx = 1$", "$\\sum_{x} f(x) = 1$", "$f(x) \\le 1$ en todo su dominio"]'::jsonb,
            '$\int_{-\infty}^{\infty} f(x)\,dx = 1$'
        ),
        (
            v_banco2_id,
            'Sea $f(x) = c x$ para $0 < x < 2$ (y $0$ en otro caso) la función de densidad de una VAC. ¿Qué valor debe tomar $c$ para que sea válida?',
            '["$c = \\frac{1}{2}$", "$c = 2$", "$c = \\frac{1}{4}$", "$c = 1$"]'::jsonb,
            '$c = \frac{1}{2}$'
        ),
        (
            v_banco2_id,
            'Dada la función de densidad uniforme $f(x) = \frac{1}{4}$ para $0 \le x \le 4$, ¿cuál es el valor de $P(1 \le X \le 3)$?',
            '["$0.50$", "$0.25$", "$0.75$", "$0.40$"]'::jsonb,
            '$0.50$'
        ),
        (
            v_banco2_id,
            'Si una variable aleatoria continua tiene función de densidad $f(x) = 2x$ en el intervalo $0 \le x \le 1$, ¿cuál es su función de distribución acumulada $F(x)$ en dicho intervalo?',
            '["$F(x) = x^2$", "$F(x) = 2$", "$F(x) = \\frac{x^2}{2}$", "$F(x) = 2x^2$"]'::jsonb,
            '$F(x) = x^2$'
        ),
        (
            v_banco2_id,
            'Si $F(x)$ es la función de distribución acumulada derivable de una variable aleatoria continua $X$, ¿cómo se obtiene su función de densidad $f(x)$?',
            '["$f(x) = \\frac{d}{dx}F(x)$", "$f(x) = \\int F(x)\\,dx$", "$f(x) = 1 - F(x)$", "$f(x) = F(x) - F(x-1)$"]'::jsonb,
            '$f(x) = \frac{d}{dx}F(x)$'
        ),
        (
            v_banco2_id,
            'Sea $X$ una variable aleatoria discreta con valores $x \in \{1, 2, 3\}$ y probabilidades $f(1)=0.2$, $f(2)=0.5$ y $f(3)=0.3$. ¿Cuál es su valor esperado $E(X)$?',
            '["$2.1$", "$2.0$", "$1.9$", "$2.5$"]'::jsonb,
            '$2.1$'
        ),
        (
            v_banco2_id,
            '¿Cuál de las siguientes expresiones permite calcular de forma equivalente la varianza $\sigma^2 = \text{Var}(X)$ de una variable aleatoria?',
            '["$E(X^2) - [E(X)]^2$", "$[E(X)]^2 - E(X^2)$", "$E(X) - [E(X^2)]^2$", "$\\sqrt{E(X^2) - E(X)}$"]'::jsonb,
            '$E(X^2) - [E(X)]^2$'
        ),
        (
            v_banco2_id,
            'Si una variable aleatoria $X$ tiene valor esperado $E(X) = 3$ y segundo momento $E(X^2) = 11$, ¿cuál es el valor de su varianza $\sigma^2$?',
            '["$2$", "$8$", "$5$", "$14$"]'::jsonb,
            '$2$'
        ),
        (
            v_banco2_id,
            'Si $X$ es una variable aleatoria con media $E(X) = 4$, ¿cuál es el valor esperado de la transformación lineal $Y = 3X + 2$?',
            '["$14$", "$12$", "$6$", "$18$"]'::jsonb,
            '$14$'
        ),
        (
            v_banco2_id,
            'Si $\text{Var}(X) = 5$, ¿cuál es el valor de $\text{Var}(2X + 7)$?',
            '["$20$", "$17$", "$10$", "$27$"]'::jsonb,
            '$20$'
        );
    END IF;

    -- ========================================================================
    -- BANCO 3: UNIDAD 3 (20 PREGUNTAS)
    -- ========================================================================
    IF NOT EXISTS (SELECT 1 FROM bancos WHERE nombre = 'Unidad-3: Distribuciones de probabilidad (Segundo parcial)') THEN
        INSERT INTO bancos (nombre, descripcion)
        VALUES (
            'Unidad-3: Distribuciones de probabilidad (Segundo parcial)',
            'Reactivos de distribución binomial, binomial negativa, geométrica, hipergeométrica, Poisson y normal.'
        )
        RETURNING id INTO v_banco3_id;

        INSERT INTO preguntas (banco_id, texto_pregunta, opciones, respuesta_correcta) VALUES
        (
            v_banco3_id,
            'De acuerdo con las propiedades de la función de densidad de una distribución normal con media $\mu$ y desviación estándar $\sigma$, ¿en qué valores del eje horizontal se encuentran sus puntos de inflexión?',
            '["$\\mu - 2\\sigma$ y $\\mu + 2\\sigma$", "$\\mu - \\sigma$ y $\\mu + \\sigma$", "$\\mu - 3\\sigma$ y $\\mu + 3\\sigma$", "$\\mu$ y $\\mu + \\sigma$"]'::jsonb,
            '$\mu - \sigma$ y $\mu + \sigma$'
        ),
        (
            v_banco3_id,
            'Se selecciona una muestra de 12 piezas sin reemplazo de un lote de 400 piezas. Si cada pieza puede clasificarse como defectuosa o no defectuosa, ¿por qué puede aproximarse la distribución hipergeométrica mediante una distribución binomial?',
            '["Porque la muestra representa una parte muy pequeña de la población y la probabilidad de éxito cambia muy poco.", "Porque el tamaño de la muestra siempre debe ser igual al de la población.", "Porque el muestreo sin reemplazo hace que los ensayos sean totalmente independientes.", "Porque la distribución binomial solo se utiliza cuando hay más de dos resultados."]'::jsonb,
            'Porque la muestra representa una parte muy pequeña de la población y la probabilidad de éxito cambia muy poco.'
        ),
        (
            v_banco3_id,
            'La duración de cierto componente electrónico sigue una distribución normal con media de $100$ horas y desviación estándar de $15$ horas. ¿Cuál es la probabilidad de que un componente elegido al azar dure más de $130$ horas?',
            '["$0.9772$", "$0.5000$", "$0.0228$", "$0.1587$"]'::jsonb,
            '$0.0228$'
        ),
        (
            v_banco3_id,
            'En una línea de producción, la probabilidad de que una pieza pase la inspección es $0.4$. Si las inspecciones son independientes, ¿cuál es la probabilidad de que la sexta pieza inspeccionada sea la tercera que pasa?',
            '["$0.04608$", "$0.13824$", "$0.27648$", "$0.40000$"]'::jsonb,
            '$0.13824$'
        ),
        (
            v_banco3_id,
            'Un almacén contiene 30 sensores, de los cuales 8 son defectuosos y 22 funcionan correctamente. Si se seleccionan 6 sensores al azar sin reemplazo, ¿cuál es la probabilidad de obtener exactamente 2 defectuosos?',
            '["$0.3522$ aproximadamente", "$0.2468$ aproximadamente", "$0.4215$ aproximadamente", "$0.1584$ aproximadamente"]'::jsonb,
            '$0.3522$ aproximadamente'
        ),
        (
            v_banco3_id,
            'De acuerdo con las propiedades de la función de densidad de una distribución normal con media $\mu$ y desviación estándar $\sigma$, ¿en qué valores del eje horizontal cambia su concavidad (puntos de inflexión)?',
            '["$x = \\mu$", "$x = \\mu \\pm \\sigma$", "$x = \\mu \\pm 2\\sigma$", "$x = 0$"]'::jsonb,
            '$x = \mu \pm \sigma$'
        ),
        (
            v_banco3_id,
            'Al extraer una muestra aleatoria de tamaño $n$ sin reemplazo de una población finita $N$, ¿qué condición debe cumplirse para aproximar la distribución hipergeométrica mediante una binomial?',
            '["$np \\ge 5$ y $n(1-p) \\ge 5$", "$\\frac{n}{N} \\le 0.05$", "$n > 30$ y $p < 0.05$", "$\\frac{k}{N} \\ge 0.50$"]'::jsonb,
            '$\frac{n}{N} \le 0.05$'
        ),
        (
            v_banco3_id,
            'El tiempo de duración de la carga de la batería de un teléfono sigue una distribución normal con $\mu = 18$ horas y $\sigma = 2.5$ horas. ¿Cuál es la probabilidad de que una batería elegida al azar dure más de $21.5$ horas?',
            '["$0.9192$", "$0.0808$", "$0.1400$", "$0.4192$"]'::jsonb,
            '$0.0808$'
        ),
        (
            v_banco3_id,
            'En un centro de soporte técnico, la probabilidad de resolver una incidencia en la primera llamada es $p = 0.4$. Si las llamadas son independientes, ¿cuál es la probabilidad de que la sexta llamada sea la tercera resuelta con éxito?',
            '["$0.2765$", "$0.0553$", "$0.1382$", "$0.2074$"]'::jsonb,
            '$0.1382$'
        ),
        (
            v_banco3_id,
            'Una caja contiene 10 sensores en total, de los cuales 4 están defectuosos y 6 funcionan bien. Si se extraen 3 sensores al azar sin reemplazo, ¿cuál es la probabilidad de encontrar exactamente 2 defectuosos?',
            '["$0.1667$", "$0.3000$", "$0.4320$", "$0.5000$"]'::jsonb,
            '$0.3000$'
        ),
        (
            v_banco3_id,
            'La probabilidad de que una persona crea un rumor es $p = 0.8$. Si se cuenta el rumor de forma independiente, ¿cuál es la probabilidad de que la sexta persona que lo escuche sea la cuarta en creerlo?',
            '["$0.1638$", "$0.0320$", "$0.4096$", "$0.2458$"]'::jsonb,
            '$0.1638$'
        ),
        (
            v_banco3_id,
            'Si la probabilidad de que una persona crea un rumor es $p = 0.8$, ¿cuál es la probabilidad de que la tercera persona que lo escuche sea la primera en creerlo (distribución geométrica)?',
            '["$0.032$", "$0.128$", "$0.512$", "$0.160$"]'::jsonb,
            '$0.032$'
        ),
        (
            v_banco3_id,
            'A un aeropuerto llegan en promedio $\lambda = 6$ aviones pequeños por hora siguiendo un proceso de Poisson. ¿Cuál es la probabilidad de que lleguen exactamente 4 aviones en un periodo de una hora?',
            '["$0.1338$", "$0.8488$", "$0.1512$", "$0.2500$"]'::jsonb,
            '$0.1338$'
        ),
        (
            v_banco3_id,
            'En un punto de revisión de aeropuerto, la probabilidad de detener a una persona con un objeto cuestionable es $p = 0.03$. ¿Cuál es el número esperado de personas revisadas hasta encontrar la primera (media $\mu = \frac{1}{p}$)?',
            '["$33.33$ personas", "$30.00$ personas", "$3.00$ personas", "$15.00$ personas"]'::jsonb,
            '$33.33$ personas'
        ),
        (
            v_banco3_id,
            'A la sala de urgencias de un hospital llegan en promedio $\lambda = 5$ emergencias por hora. ¿Cuál es la media esperada ($\mu = \lambda t$) de llegadas durante un turno de 3 horas?',
            '["$15$ emergencias", "$5$ emergencias", "$8$ emergencias", "$20$ emergencias"]'::jsonb,
            '$15$ emergencias'
        ),
        (
            v_banco3_id,
            'En una revisión médica de $n = 1875$ estudiantes, la probabilidad de detectar escoliosis es $p = 0.004$. ¿Cuál es el parámetro $\mu = np$ para aproximar el problema mediante una distribución de Poisson?',
            '["$\\mu = 7.5$", "$\\mu = 4.0$", "$\\mu = 18.75$", "$\\mu = 0.75$"]'::jsonb,
            '$\mu = 7.5$'
        ),
        (
            v_banco3_id,
            'Una secretaria comete en promedio $\mu = 2$ errores mecanográficos por página. Aplicando la distribución de Poisson, ¿cuál es la probabilidad de que en la siguiente página no cometa ningún error ($P(X=0)$)?',
            '["$0.1353$", "$0.2707$", "$0.0000$", "$0.5000$"]'::jsonb,
            '$0.1353$'
        ),
        (
            v_banco3_id,
            'En una distribución binomial con $n = 20$ ensayos y probabilidad de éxito $p = 0.25$, ¿cuáles son su media $\mu$ y su varianza $\sigma^2$?',
            '["$\\mu = 5$ y $\\sigma^2 = 3.75$", "$\\mu = 5$ y $\\sigma^2 = 5$", "$\\mu = 4$ y $\\sigma^2 = 3$", "$\\mu = 15$ y $\\sigma^2 = 3.75$"]'::jsonb,
            '$\mu = 5$ y $\sigma^2 = 3.75$'
        ),
        (
            v_banco3_id,
            '¿Qué valores de media $\mu$ y desviación estándar $\sigma$ caracterizan a una distribución normal estándar $Z$?',
            '["$\\mu = 0$ y $\\sigma = 1$", "$\\mu = 1$ y $\\sigma = 0$", "$\\mu = 1$ y $\\sigma = 1$", "$\\mu = 0.5$ y $\\sigma = 0.5$"]'::jsonb,
            '$\mu = 0$ y $\sigma = 1$'
        ),
        (
            v_banco3_id,
            'De acuerdo con la regla empírica de la distribución normal, ¿qué porcentaje aproximado de las observaciones se encuentra dentro del intervalo $\mu \pm 2\sigma$?',
            '["$95.44\\%$", "$68.26\\%$", "$99.73\\%$", "$50.00\\%$"]'::jsonb,
            '$95.44\%$'
        );
    END IF;
END $$;

COMMIT;