CREATE TABLE pull_request (
  id serial PRIMARY KEY,
  message varchar,
  flag boolean,
  developer_id integer REFERENCES developer(id),
  project_id integer REFERENCES project(id)
);
