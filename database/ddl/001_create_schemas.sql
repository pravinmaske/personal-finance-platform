-- CREATE SCHEMA IF NOT EXISTS raw;
-- CREATE SCHEMA IF NOT EXISTS clean;
-- CREATE SCHEMA IF NOT EXISTS analytics;

-- =============================================================
-- 001_create_schemas.sql
-- Creates all layer schemas: raw, staging, dim, mart
-- Run once on fresh database
-- =============================================================

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS dim;
CREATE SCHEMA IF NOT EXISTS mart;