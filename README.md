# Pravin's Personal Finance Platform

A personal finance data platform designed to ingest, store, and analyse financial data such as expenses, income, and account activity.  
This project focuses on **clean data architecture**, **governance**, and **scalable analytics**, rather than just UI features.

---

## 🎯 Project Vision

 # The goal of this platform is to:
- Build a **centralised financial data store**
- Track and categorise personal expenses and income
- Enable future analytics, reporting, and insights
- Follow **production-grade data engineering practices**

This is a learning-focused but real-world oriented project.

---

## 🏗️ High-Level Architecture

personal-finance-platform
│
├── docker/ # Docker and container configuration
├── database/ # Database schemas, migrations, SQL scripts
├── ingestion/ # Data ingestion pipelines (CSV, APIs, etc.)
├── data/
│ └── raw/ # Raw input data (intentionally git-ignored)
├── notebooks/ # Exploratory analysis and experiments
└── README.md


---

## 🐳 Local Development Setup

### Prerequisites
- Git
- Docker Desktop
- DBeaver (or any PostgreSQL client)
- VS Code

---

### Run PostgreSQL locally

From the `docker/` directory:

```bash

docker compose up -d

```

This will start a PostgreSQL container with:
Host: localhost
Port: 5432
Database: finance

## Connect to PostgreSQL (DBeaver)

| Field    | Value          |
| -------- | -------------- |
| Host     | `localhost`    |
| Port     | `5432`         |
| Database | `finance`      |
| Username | `finance_user` |
| Password | `************` |


## 📦 Data Handling & Governance

- Raw financial data is stored under data/raw/

- This folder is git-ignored to prevent sensitive data leaks

- Only schema, transformations, and logic are version-controlled

- Environment variables (passwords, secrets) are not committed

## ⚠️ Disclaimer

This project is for learning and personal use only.
Do not commit real credentials or sensitive financial data to the repository.

# 👤 Author

Pravin Maske

