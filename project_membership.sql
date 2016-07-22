CREATE TABLE project_membership (
  developer_id integer REFERENCES developer (id),
  project_id integer REFERENCES project (id)
);
