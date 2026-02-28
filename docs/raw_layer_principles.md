# Raw Layer Principles

The raw layer stores data exactly as received from source systems.

Rules:

1. No transformations
2. No business logic
3. Preserve original values
4. Add metadata:
   - source_file_name
   - account_name
   - ingestion_timestamp

The raw layer is append-only.
It serves as the system of record for auditing and reproducibility.
