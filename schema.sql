-- ==========================================
-- ESTRUCTURA DE LA BASE DE DATOS
-- PROYECTO: APPWEB DE PROBABILIDAD Y ESTADÍSTICA
-- ==========================================

-- 1. Habilitar extensión para generar UUIDs automáticamente
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Tabla para manejar los roles y permisos (Superusuario)
CREATE TABLE perfiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  rol VARCHAR(50) DEFAULT 'estudiante'
);

-- 3. Tabla para los Bancos de Preguntas
CREATE TABLE bancos (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT,
  creado_por UUID REFERENCES perfiles(id)
);

-- 4. Tabla para las Preguntas y sus opciones
CREATE TABLE preguntas (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  banco_id UUID REFERENCES bancos(id) ON DELETE CASCADE,
  texto_pregunta TEXT NOT NULL,
  opciones JSONB NOT NULL,
  respuesta_correcta TEXT NOT NULL
);

-- ==========================================
-- INSTRUCCIONES DE CONFIGURACIÓN INICIAL
-- ==========================================
-- Después de crear las tablas, registra un usuario en el panel de Authentication de Supabase.
-- Copia su User UID y ejecuta esta línea para darle permisos de administrador:
-- INSERT INTO perfiles (id, rol) VALUES ('TU_USER_UID_AQUI', 'superuser');