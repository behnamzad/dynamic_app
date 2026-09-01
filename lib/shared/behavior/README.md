# Behavior module

This shared module owns the local-first behavioral telemetry pipeline. Feature screens are producers only; interactive UI uses `BehaviorLogger.recordNonBlocking` and never writes SQLite rows or calls Supabase directly.

## Runtime flow

`BehaviorEventDraft -> validation/catalog -> BehaviorLogger enrichment -> SQLite pending row -> bounded sync batch -> Supabase acknowledgement -> synced row`

The singleton `BehaviorDatabase` is initialized once during app startup, before `runApp`, so schema creation/migration and connection setup never delay the first event. Data sources use its already-open synchronous `database` getter. Recording is local-only. `App` starts `BehaviorSyncCoordinator`; it normally wakes every 60 seconds while the app can execute. Its default request limits are 100 rows and approximately 256 KiB. A successful atomic idempotent upsert acknowledges the complete selected batch: every row was either inserted or already existed by `event_id`. If the request throws, the complete batch remains `pending`; no second acknowledgement query is issued.

Sessions are lifecycle-based and have no arbitrary inactivity timeout. Every fresh app launch creates a new session and immediately records `session_start` in the local queue. Navigation between screens/features keeps the same `session_id` while updating last activity. The root `App` records `app_background` and `session_end` before ending the session, then records `app_foreground` and a new `session_start` after a real resume. A cold launch always replaces any stale persisted session ID.

## Adding or retiring an event

1. Add a wire-stable value to `BehaviorEventType`.
2. Add or reuse a typed `BehaviorEventPayload` implementation.
3. Add validation and analytical semantics to `BehaviorEventCatalog`.
4. Add the producer in the owning feature and update the project event catalog/documentation.
5. Increment the event schema version only when compatibility semantics require it.

Retiring an event stops its producer in a documented schema version. Historical rows are never deleted or reinterpreted.

## Data exclusions

Price, original/final price, discount, cart monetary value, stock, availability, credentials, tokens, payment secrets, and free-text reviews/comments are rejected from extensible payloads and are not represented in typed payloads or database columns.

Optional columns remain nullable in local SQLite so the schema is queryable, but null-valued fields are recursively omitted from the JSON sent to Supabase. Valid values such as `false`, `0`, and empty strings are preserved.

## Product review reading

Use `BehaviorEventDraftFactory.productReviewsView` when the user deliberately opens the reviews area and `productReviewsViewEnd` when that area closes. The open event carries the product/category/brand snapshot, entry trigger, source screen, and review count when known; the end event carries review dwell duration without review text. Repeated opens remain separate raw events. A later feature builder calculates the read rate as eligible product-detail views with at least one review open divided by all eligible product-detail views.

## Ownership boundaries

- `domain`: event envelope, typed payloads, catalog, logger, session manager, sync coordinator, and repository contracts.
- `data`: SQLite schema/data source, DTO mapping, repository implementation, and Supabase uploader.
- `lib/feature/*`: interaction producers; the exact active coverage is documented in `EVENT_CATALOG.md`.
- `supabase_behavior_schema.sql`: append-only shared server table, indexes, and RLS.
