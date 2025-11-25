namespace :solid_queue do
  desc "Load Solid Queue schema into production database"
  task load_schema: :environment do
    puts "🔧 Loading Solid Queue schema into database..."

    # Connect to the main database (not queue database)
    ActiveRecord::Base.connection.execute(<<-SQL)
      -- Solid Queue Jobs
      CREATE TABLE IF NOT EXISTS solid_queue_jobs (
        id BIGSERIAL PRIMARY KEY,
        queue_name VARCHAR NOT NULL,
        class_name VARCHAR NOT NULL,
        arguments TEXT,
        priority INTEGER DEFAULT 0 NOT NULL,
        active_job_id VARCHAR,
        scheduled_at TIMESTAMP,
        finished_at TIMESTAMP,
        concurrency_key VARCHAR,
        created_at TIMESTAMP NOT NULL,
        updated_at TIMESTAMP NOT NULL
      );

      CREATE INDEX IF NOT EXISTS index_solid_queue_jobs_on_active_job_id ON solid_queue_jobs(active_job_id);
      CREATE INDEX IF NOT EXISTS index_solid_queue_jobs_on_class_name ON solid_queue_jobs(class_name);
      CREATE INDEX IF NOT EXISTS index_solid_queue_jobs_on_finished_at ON solid_queue_jobs(finished_at);
      CREATE INDEX IF NOT EXISTS index_solid_queue_jobs_for_filtering ON solid_queue_jobs(queue_name, finished_at);
      CREATE INDEX IF NOT EXISTS index_solid_queue_jobs_for_alerting ON solid_queue_jobs(scheduled_at, finished_at);

      -- Solid Queue Blocked Executions
      CREATE TABLE IF NOT EXISTS solid_queue_blocked_executions (
        id BIGSERIAL PRIMARY KEY,
        job_id BIGINT NOT NULL,
        queue_name VARCHAR NOT NULL,
        priority INTEGER DEFAULT 0 NOT NULL,
        concurrency_key VARCHAR NOT NULL,
        expires_at TIMESTAMP NOT NULL,
        created_at TIMESTAMP NOT NULL
      );

      CREATE INDEX IF NOT EXISTS index_solid_queue_blocked_executions_for_release ON solid_queue_blocked_executions(concurrency_key, priority, job_id);
      CREATE INDEX IF NOT EXISTS index_solid_queue_blocked_executions_for_maintenance ON solid_queue_blocked_executions(expires_at, concurrency_key);
      CREATE UNIQUE INDEX IF NOT EXISTS index_solid_queue_blocked_executions_on_job_id ON solid_queue_blocked_executions(job_id);

      -- Solid Queue Claimed Executions
      CREATE TABLE IF NOT EXISTS solid_queue_claimed_executions (
        id BIGSERIAL PRIMARY KEY,
        job_id BIGINT NOT NULL,
        process_id BIGINT,
        created_at TIMESTAMP NOT NULL
      );

      CREATE UNIQUE INDEX IF NOT EXISTS index_solid_queue_claimed_executions_on_job_id ON solid_queue_claimed_executions(job_id);
      CREATE INDEX IF NOT EXISTS index_solid_queue_claimed_executions_on_process_id_and_job_id ON solid_queue_claimed_executions(process_id, job_id);

      -- Solid Queue Failed Executions
      CREATE TABLE IF NOT EXISTS solid_queue_failed_executions (
        id BIGSERIAL PRIMARY KEY,
        job_id BIGINT NOT NULL,
        error TEXT,
        created_at TIMESTAMP NOT NULL
      );

      CREATE UNIQUE INDEX IF NOT EXISTS index_solid_queue_failed_executions_on_job_id ON solid_queue_failed_executions(job_id);

      -- Solid Queue Pauses
      CREATE TABLE IF NOT EXISTS solid_queue_pauses (
        id BIGSERIAL PRIMARY KEY,
        queue_name VARCHAR NOT NULL,
        created_at TIMESTAMP NOT NULL
      );

      CREATE UNIQUE INDEX IF NOT EXISTS index_solid_queue_pauses_on_queue_name ON solid_queue_pauses(queue_name);

      -- Solid Queue Processes
      CREATE TABLE IF NOT EXISTS solid_queue_processes (
        id BIGSERIAL PRIMARY KEY,
        kind VARCHAR NOT NULL,
        last_heartbeat_at TIMESTAMP NOT NULL,
        supervisor_id BIGINT,
        pid INTEGER NOT NULL,
        hostname VARCHAR,
        metadata TEXT,
        created_at TIMESTAMP NOT NULL,
        name VARCHAR NOT NULL
      );

      CREATE INDEX IF NOT EXISTS index_solid_queue_processes_on_last_heartbeat_at ON solid_queue_processes(last_heartbeat_at);
      CREATE UNIQUE INDEX IF NOT EXISTS index_solid_queue_processes_on_name_and_supervisor_id ON solid_queue_processes(name, supervisor_id);
      CREATE INDEX IF NOT EXISTS index_solid_queue_processes_on_supervisor_id ON solid_queue_processes(supervisor_id);

      -- Solid Queue Ready Executions
      CREATE TABLE IF NOT EXISTS solid_queue_ready_executions (
        id BIGSERIAL PRIMARY KEY,
        job_id BIGINT NOT NULL,
        queue_name VARCHAR NOT NULL,
        priority INTEGER DEFAULT 0 NOT NULL,
        created_at TIMESTAMP NOT NULL
      );

      CREATE UNIQUE INDEX IF NOT EXISTS index_solid_queue_ready_executions_on_job_id ON solid_queue_ready_executions(job_id);
      CREATE INDEX IF NOT EXISTS index_solid_queue_poll_all ON solid_queue_ready_executions(priority, job_id);
      CREATE INDEX IF NOT EXISTS index_solid_queue_poll_by_queue ON solid_queue_ready_executions(queue_name, priority, job_id);

      -- Solid Queue Recurring Executions
      CREATE TABLE IF NOT EXISTS solid_queue_recurring_executions (
        id BIGSERIAL PRIMARY KEY,
        job_id BIGINT NOT NULL,
        task_key VARCHAR NOT NULL,
        run_at TIMESTAMP NOT NULL,
        created_at TIMESTAMP NOT NULL
      );

      CREATE UNIQUE INDEX IF NOT EXISTS index_solid_queue_recurring_executions_on_job_id ON solid_queue_recurring_executions(job_id);
      CREATE UNIQUE INDEX IF NOT EXISTS index_solid_queue_recurring_executions_on_task_key_and_run_at ON solid_queue_recurring_executions(task_key, run_at);

      -- Solid Queue Recurring Tasks
      CREATE TABLE IF NOT EXISTS solid_queue_recurring_tasks (
        id BIGSERIAL PRIMARY KEY,
        key VARCHAR NOT NULL,
        schedule VARCHAR NOT NULL,
        command VARCHAR(2048),
        class_name VARCHAR,
        arguments TEXT,
        queue_name VARCHAR,
        priority INTEGER DEFAULT 0,
        static BOOLEAN DEFAULT true NOT NULL,
        description TEXT,
        created_at TIMESTAMP NOT NULL,
        updated_at TIMESTAMP NOT NULL
      );

      CREATE UNIQUE INDEX IF NOT EXISTS index_solid_queue_recurring_tasks_on_key ON solid_queue_recurring_tasks(key);
      CREATE INDEX IF NOT EXISTS index_solid_queue_recurring_tasks_on_static ON solid_queue_recurring_tasks(static);

      -- Solid Queue Scheduled Executions
      CREATE TABLE IF NOT EXISTS solid_queue_scheduled_executions (
        id BIGSERIAL PRIMARY KEY,
        job_id BIGINT NOT NULL,
        queue_name VARCHAR NOT NULL,
        priority INTEGER DEFAULT 0 NOT NULL,
        scheduled_at TIMESTAMP NOT NULL,
        created_at TIMESTAMP NOT NULL
      );

      CREATE UNIQUE INDEX IF NOT EXISTS index_solid_queue_scheduled_executions_on_job_id ON solid_queue_scheduled_executions(job_id);
      CREATE INDEX IF NOT EXISTS index_solid_queue_dispatch_all ON solid_queue_scheduled_executions(scheduled_at, priority, job_id);

      -- Solid Queue Semaphores
      CREATE TABLE IF NOT EXISTS solid_queue_semaphores (
        id BIGSERIAL PRIMARY KEY,
        key VARCHAR NOT NULL,
        value INTEGER DEFAULT 1 NOT NULL,
        expires_at TIMESTAMP NOT NULL,
        created_at TIMESTAMP NOT NULL,
        updated_at TIMESTAMP NOT NULL
      );

      CREATE INDEX IF NOT EXISTS index_solid_queue_semaphores_on_expires_at ON solid_queue_semaphores(expires_at);
      CREATE INDEX IF NOT EXISTS index_solid_queue_semaphores_on_key_and_value ON solid_queue_semaphores(key, value);
      CREATE UNIQUE INDEX IF NOT EXISTS index_solid_queue_semaphores_on_key ON solid_queue_semaphores(key);

      -- Foreign Keys
      DO $$
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_rails_blocked_executions_job_id') THEN
          ALTER TABLE solid_queue_blocked_executions ADD CONSTRAINT fk_rails_blocked_executions_job_id FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;
        END IF;

        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_rails_claimed_executions_job_id') THEN
          ALTER TABLE solid_queue_claimed_executions ADD CONSTRAINT fk_rails_claimed_executions_job_id FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;
        END IF;

        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_rails_failed_executions_job_id') THEN
          ALTER TABLE solid_queue_failed_executions ADD CONSTRAINT fk_rails_failed_executions_job_id FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;
        END IF;

        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_rails_ready_executions_job_id') THEN
          ALTER TABLE solid_queue_ready_executions ADD CONSTRAINT fk_rails_ready_executions_job_id FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;
        END IF;

        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_rails_recurring_executions_job_id') THEN
          ALTER TABLE solid_queue_recurring_executions ADD CONSTRAINT fk_rails_recurring_executions_job_id FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;
        END IF;

        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_rails_scheduled_executions_job_id') THEN
          ALTER TABLE solid_queue_scheduled_executions ADD CONSTRAINT fk_rails_scheduled_executions_job_id FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE;
        END IF;
      END $$;
    SQL

    puts "✅ Solid Queue schema loaded successfully!"
  end
end
