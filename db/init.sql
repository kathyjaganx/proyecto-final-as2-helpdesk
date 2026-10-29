-- =====================================================
-- Proyecto Final - Análisis de Sistemas II
-- Mesa de ayuda (Help Desk) local
-- Autora: Irma Yaritza Katiuxca Jagan Xol - 4090-23-9748
-- =====================================================

-- Personal de soporte
CREATE TABLE tecnicos (
    id_tecnico   SERIAL PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    especialidad VARCHAR(20)  NOT NULL
                 CHECK (especialidad IN ('ACCESO', 'CORREO', 'HARDWARE', 'SOFTWARE', 'RED', 'GENERAL')),
    activo       BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en    TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Tickets de soporte
CREATE TABLE tickets (
    id_ticket       SERIAL PRIMARY KEY,
    solicitante     VARCHAR(100) NOT NULL,
    correo          VARCHAR(120) NOT NULL CHECK (correo ~ '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$'),
    departamento    VARCHAR(60)  NOT NULL,
    categoria       VARCHAR(20)  NOT NULL
                    CHECK (categoria IN ('ACCESO', 'CORREO', 'HARDWARE', 'SOFTWARE', 'RED', 'OTRO')),
    asunto          VARCHAR(150) NOT NULL,
    descripcion     TEXT NOT NULL,
    datos_ocultados BOOLEAN NOT NULL DEFAULT FALSE,
    prioridad       VARCHAR(10) NOT NULL CHECK (prioridad IN ('ALTA', 'MEDIA', 'BAJA')),
    estado          VARCHAR(15) NOT NULL DEFAULT 'ABIERTO'
                    CHECK (estado IN ('ABIERTO', 'EN_PROCESO', 'RESUELTO', 'CERRADO')),
    id_tecnico      INT REFERENCES tecnicos(id_tecnico),
    escalado        BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_limite    TIMESTAMP NOT NULL,
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en  TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_fecha_limite CHECK (fecha_limite > creado_en)
);

-- Bitácora de auditoría: toda operación queda registrada
CREATE TABLE auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    fecha        TIMESTAMP NOT NULL DEFAULT NOW(),
    workflow     VARCHAR(100) NOT NULL,
    accion       VARCHAR(50)  NOT NULL,
    resultado    VARCHAR(15)  NOT NULL CHECK (resultado IN ('EXITO', 'RECHAZADO', 'ERROR')),
    detalle      JSONB
);

-- Registro de errores capturados por el Error Trigger de n8n
CREATE TABLE errores (
    id_error     SERIAL PRIMARY KEY,
    fecha        TIMESTAMP NOT NULL DEFAULT NOW(),
    workflow     VARCHAR(100),
    nodo         VARCHAR(100),
    mensaje      TEXT NOT NULL,
    id_ejecucion VARCHAR(50),
    datos        JSONB
);

-- Índices para las consultas más frecuentes
CREATE INDEX idx_tickets_estado ON tickets(estado);
CREATE INDEX idx_tickets_fecha_limite ON tickets(fecha_limite);
CREATE INDEX idx_tickets_tecnico ON tickets(id_tecnico);

-- Personal de soporte inicial
INSERT INTO tecnicos (nombre, especialidad) VALUES
('Carlos Pop',    'RED'),
('María Caal',    'SOFTWARE'),
('Luis Tiul',     'SOFTWARE'),
('Ana Choc',      'HARDWARE'),
('Pedro Xol',     'ACCESO'),
('Sofía Coc',     'CORREO'),
('Jorge Maquín',  'GENERAL');