CREATE TABLE project_uses_tech (
  project_id integer REFERENCES project (id),
  tech_id integer REFERENCES tech (id)
);
