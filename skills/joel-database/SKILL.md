---
name: joel-database
description: Joel's data modelling and persistence patterns - choosing a store, schema as the single source of truth, naming, identity, time, money, enumerations, lifecycle over soft delete, tenancy, constraints as invariants, expand/contract migrations, data-access boundaries, transactions and concurrency, pagination, caching and object storage. Use when designing a schema, adding tables or columns, writing migrations or queries, or deciding where data should live in one of Joel's projects.
---

# Data patterns

Read `joel-architecture` first. Default tools: Postgres, Drizzle, committed SQL migrations.

## Choosing where data lives

- **The relational database is the system of record.** Durable facts live there, including idempotency records, job queues, counters on runtimes without shared memory, and embeddings.
- **Caches hold only what is cheap to lose** and are never the only copy. A cache failure degrades to a miss and logs; it never fails the request.
- **Bytes go to object storage**, keys and metadata go to the database.
- **Add a new store only when the current one demonstrably cannot do the job**, and write the reason where the decision lives.
- Development uses the same engine as production, in a container. No lighter substitute "for convenience".

## The schema is the source of truth

One package owns the schema, the migrations and shared queries. Application types are derived from it. Nobody hand-writes a type that mirrors a table.

## Modelling rules

- **Naming:** plural snake_case tables; snake_case columns mapped to the language's casing; `<entity>_id` foreign keys; `<verb>_at` instants; `<noun>_on` dates; booleans that read as flags; named constraints and indexes.
- **Identity:** database-generated UUIDs internally. Developer-facing APIs may expose prefixed, sortable public ids (`msg_...`) mapped to them, because developers read them in logs. Entities owned by an external identity provider keep the provider's id as a text key. Tokens are random and opaque. No sequential ids exposed to clients.
- **Time:** timezone-aware timestamps; creation time on every row, update time on mutable rows set on every write. Append-only tables have only a creation time.
- **Money:** integer minor units plus a currency code, guarded by constraints. Never floating point. Fees and rates as explicit basis points or fixed-precision decimals.
- **Enumerations:** text constrained by a check and typed by a union in code. Native database enum types are hard to evolve; avoid them.
- **Lifecycle over soft delete:** model status and lifecycle timestamps (suspended, closed, revoked). Hard-delete through cascades from the tenant root. Add a deleted marker only when a feature needs recovery.
- **Semi-structured data** goes in JSON columns only for settings and metadata, never for relations you will query.
- **Nullable means "use the default"**, and the schema says so.

## Constraints are invariants

Push every rule the database can enforce into the database: foreign keys, per-tenant uniqueness, check constraints for positive amounts and valid states, partial unique indexes for "at most one active". Code-level validation is for messages; constraints are for truth.

## Tenancy

Every tenant-owned table carries the tenant key, cascades from the tenant root, leads its composite indexes with the tenant, and is unique per tenant. Every query scopes by tenant, including primary-key lookups.

## Indexes

Index for the queries you actually run: tenant plus sort key for lists, partial indexes for queues and optional uniqueness, expression indexes for case-insensitive lookups, trigram for search. Build indexes concurrently on large live tables. Each index maps to a named query need.

## Migrations: expand, migrate, contract

1. Generate the migration from the schema, name it for what it does, and **read the SQL** before committing.
2. Additive first: add nullable columns or new tables, backfill with a separate named script, then add the constraint, then remove the old shape in a later release.
3. Commit migrations and apply them with a one-shot task before the new code rolls out, never on container start. Schema push is for local development only.
4. Prove each migration from an empty database and against a copy of the current shape.
5. Run migration work in its own worktree.

## Data access boundary

- Only repositories (or a shared query module used by several ingresses) touch storage.
- Repository functions take the database handle (or transaction) as their first argument, so callers compose them inside one transaction and tests swap them.
- Use the query builder by default. Drop to raw SQL only for what it cannot express, and keep that SQL small and isolated.
- Large ID sets bind as arrays, never string-built lists.

## Concurrency and consistency

- Multi-row changes run in one transaction.
- Counters update atomically with upserts or in-place arithmetic, never read-modify-write.
- Work claims and money movements take row locks and skip locked rows.
- At-least-once inserts use conflict-ignore with a unique key as the dedupe guard.
- Check that a write returned a row; an empty result is an error, not success.

## Pagination

- **Offset** for admin tables and bounded lists: page, limit, total via a parallel count, a stable tiebreak on id, a hard cap on exports.
- **Keyset** for feeds, inboxes and anything unbounded: an opaque cursor encoding the sort key plus id, fetch one extra row to know if more exist, reject malformed cursors with a typed error.

## Caching

Namespaced keys with explicit time buckets for windows. A time-to-live on everything, twice the window for counters. Cache reads and writes never decide correctness. Tag or key-based invalidation is planned with the write path, not bolted on.

## Object storage

One client abstraction across providers. Keys are structured `<kind>/<tenant>/<id>.<ext>`. Clients upload and download through short-lived signed URLs. The store interface has a local adapter for development, and production refuses to start without the real bucket.

## Testing

Integration tests run against a real database created and migrated for the test run, executed sequentially or under advisory locks when shared. No in-memory database imitations.
