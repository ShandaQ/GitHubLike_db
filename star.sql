CREATE TABLE star (
  id serial PRIMARY KEY,
  developer_id integer REFERENCES developer(id),
  project_id integer REFERENCES project(id)
);
