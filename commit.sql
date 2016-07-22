CREATE TABLE commit (
  id serial PRIMARY KEY,
  commit_date date,
  message varchar,
  developer_id integer REFERENCES developer(id),
  project_id integer REFERENCES project(id)
);
