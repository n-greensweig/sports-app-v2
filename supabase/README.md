# Supabase Database Structure

This folder contains database migrations and seed data for Ola Ball.

## Folder Structure

```
supabase/
├── README.md                      # This file
├── migrations/
│   ├── 00_initial_schema.sql      # Schema REFERENCE (do not run directly)
│   └── 01_lesson_completions.sql  # Adds multi-completion tracking
└── seed_tf1.sql                   # TF1 lesson content (9 questions)
```

## Important Notes

### Schema Management
- The actual schema is managed by **Supabase migrations** in the dashboard
- `00_initial_schema.sql` is a **reference document only** - it documents the current schema but should NOT be run directly
- When making schema changes, use the Supabase dashboard SQL editor or create new migration files

### Content Hierarchy
```
Sport (Football)
  └── Module (Rookie, Veteran, All-Pro, etc.)
       └── Lesson (TF1, TF2, OT1, etc.)
            └── Item (questions)
                 └── Item Variant (versioned content)
```

### Key Tables

| Table | Purpose |
|-------|---------|
| `sports` | Top-level categories (Football, Basketball, etc.) |
| `modules` | Sections within a sport (Rookie, Veteran, etc.) |
| `lessons` | Individual lessons with completion requirements |
| `items` | Questions/exercises linked to lessons |
| `item_variants` | Versioned question content for A/B testing |
| `user_lesson_completions` | Tracks multi-completion progress per user |
| `user_progress` | Per-sport progression (level, XP, current position) |

### Lesson Completion System
- Each lesson requires **3 completions** to master (`required_completions` column)
- Each session shows **5 questions** from a pool (`items_per_session` column)
- Questions are randomized each session, prioritizing unseen items
- Progress tracked in `user_lesson_completions.completion_count`

## Seed Data

### seed_tf1.sql
Seeds the first lesson "The Field 1" (TF1) with:
- Football sport
- Rookie module
- TF1 lesson (9 questions about field dimensions, yard lines, goal lines, end zones)

**To run:** Execute in Supabase SQL Editor

## Adding New Content

1. Create a new seed file (e.g., `seed_tf2.sql`)
2. Follow the pattern in `seed_tf1.sql`:
   - Use UUIDs for all IDs
   - Use `ON CONFLICT` for idempotent inserts
   - Create items and item_variants together
3. Reference `00_initial_schema.sql` for table structures and enums

## Lesson Codes
| Code | Lesson Name |
|------|-------------|
| TF1 | The Field 1 |
| TF2 | The Field 2 |
| OT1 | Offensive Terms 1 |
| DT1 | Defensive Terms 1 |
| ... | See CLAUDE.md for full list |
