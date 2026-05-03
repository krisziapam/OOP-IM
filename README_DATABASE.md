# Database Update Notes - PDTS / School Application System

This package updates the database part of the project only. It keeps the database name as `schooldb` so the existing XAMPP `config.php` can still connect.

## Main file to import in XAMPP

Use this file:

```text
schooldb.sql
```

It already includes:

1. `CREATE DATABASE IF NOT EXISTS schooldb`
2. table cleanup / reset
3. full table creation
4. reference seed data

## Important warning

Importing `schooldb.sql` will drop and recreate the project tables inside `schooldb`. Export your old data first if you need to keep it.

## Tables included

Core normalized tables:

- `applicant`
- `educational_background_category`
- `program`
- `campus`
- `application`
- `requirement_type`
- `requirement_status`
- `requirement`
- `notification`
- `curriculum_requirement`
- `previous_education`
- `applicant_emergency_contact`
- `role`
- `user`
- `application_status`
- `rejection_reason`
- `deadline`
- `tracking_sequences`
- `user_activity_log`

Helpful views:

- `vw_applicant_summary`
- `vw_application_requirements`

## XAMPP / phpMyAdmin import steps

1. Open XAMPP.
2. Start Apache and MySQL.
3. Go to `http://localhost/phpmyadmin`.
4. Click Import.
5. Select `schooldb.sql`.
6. Click Go.
7. Open the project from `htdocs`.

## GitHub update steps

Commit at least these database files:

```text
schooldb.sql
database/schema.sql
database/seed.sql
database/sample_data.sql
README_DATABASE.md
```

Suggested commit message:

```bash
git add schooldb.sql database README_DATABASE.md
git commit -m "Update normalized PDTS database schema"
git push
```

## Why the schema was updated

The old database dump had duplicated seed records and a limited set of programs, categories, requirement types, and statuses. The updated schema is normalized for applicant records, applications, document requirements, requirement statuses, notifications, programs, and educational background categories.

## Compatibility note

The existing PHP files in this branch use columns like `first_name`, `last_name`, `sex`, `email`, `phone`, `campus_id`, and `educational_background_category_id`. These columns are still present, so the existing applicant form should continue working after import.
