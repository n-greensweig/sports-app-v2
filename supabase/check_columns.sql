SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'submission_judgments';

--Results
| column_name                | data_type                | is_nullable |
| -------------------------- | ------------------------ | ----------- |
| id                         | uuid                     | NO          |
| submission_id              | uuid                     | NO          |
| submission_submitted_at    | timestamp with time zone | NO          |
| is_correct                 | boolean                  | NO          |
| score                      | numeric                  | YES         |
| judged_by                  | USER-DEFINED             | NO          |
| explanation                | text                     | YES         |
| ground_truth_ref           | uuid                     | YES         |
| provider_event_id          | uuid                     | YES         |
| provider_event_received_at | timestamp with time zone | YES         |
| confidence                 | numeric                  | YES         |
| created_at                 | timestamp with time zone | NO          |