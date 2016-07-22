# GitHubLike_db

Creates a PostgreSQL database to mock the way a GitHub datatbase might look like. 

# Make Your Own Github
This project has three sections:
  * building the schema
  * inserting the data
  * writing the queries


Tables: 
  commit
  developer
  project_membership(middle table)
  project_uses_tech (middle tabele)
  project
  pullrequest
  star
  tech

## Questions

* How popular is this project (based on number of stars)?
```
select project.name, count(star)
from
project
left outer join star on project.id = star.project_id
group by project.name
order by count(star) desc;
```
* How many projects does this user have?
```
select developer.name, count(project.name)
from
project
left outer join project_membership on project.id = project_membership.project_id
left outer join developer on developer.id = project_membership.developer_id
group by developer.name;
```
* List this user's projects.
```
select developer.name, project.name
from
project
left outer join project_membership on project.id = project_membership.project_id
left outer join developer on developer.id = project_membership.developer_id
where developer.name = 'Shanda'
group by developer.name, project.name;
```
* What are this user's top 3 projects based on number of stars?
```
select developer.name as developer, project.name as project, count(star)
from
developer, project
left outer join star on project.id = star.project_id
where developer.name = 'Matt'
group by project.name, developer.name
order by count(star) desc
limit 3;
```
* What are the top 3 projects overall based on the number of tech used?
```
select project.name, count(tech.name)
from
project
left outer join project_uses_tech on project.id = project_uses_tech.project_id
left outer join tech on tech.id = project_uses_tech.tech_id
group by project.name
order by count(tech) desc
limit 3;
```
* Are there more than one project with the same name?
```
select project.name
from project
where project.name = 'Coffee App';
```
* How many contributors does each project have (include even projects that have no contributors)?
```
select project.name, count(developer.name)
from project
left outer join project_membership on project.id = project_membership.project_id
left outer join developer on developer.id = project_membership.developer_id
group by project.id;
```
* How many projects does each user have (include even users that have no projects)?
```
select developer.name, count(project.id)
from developer
left outer join project_membership on developer.id = project_membership.developer_id
left outer join project on project.id = project_membership.project_id
group by developer.id;
```
* What is the average number of commits on a project?
```
select avg(count) as avg_count
from
(select project.name, count(commit.id)
from project, commit
where project.id = commit.project_id
group by project.id)
as project_by_commit_count;
```
* What is the average number of contributors on a project?
```
select avg(count) as avg_count
from
(select project.name, count(developer.name)
from project
left outer join project_membership on project.id = project_membership.project_id
left outer join developer on developer.id = project_membership.developer_id
group by project.id)
as project_by_contributors_count;
```
* What is the average number of stars on a project?
```
<!-- this avg all the stars..... bc we used stars as a 'like' -->
select avg(count) as avg_count
from
(select project.name, count(star)
from
project
left outer join star on project.id = star.project_id
group by project.name
order by count(star) desc)
as project_by_stars_count;
```
* Who are the contributors to this project?
```
select developer.name, project.name
from
developer
left outer join project_membership on developer.id = project_membership.developer_id
left outer join project on project.id = project_membership.project_id
where project.name = 'Wiki'
group by developer.name, project.name;
```
* Who made the most PRs (pull requests) to this project?
```
select developer.name, count(pull_request.developer_id)
from
developer
left outer join pull_request on developer.id = pull_request.developer_id
left outer join project on project.id = pull_request.project_id
where project.id = 1
group by developer.name
order by count(pull_request.developer_id) desc
limit 1;
```
* What is this user's PR acceptence rate (ratio of PRs merged vs PRs unmerged)?
```
select
	name,
	approved_count::real / total_pr_count as approval_rating
from
(select
	developer.name,
	sum(case when flag then 1 else 0 end) as approved_count,
	count(*) total_pr_count
from
	developer
inner join
	pull_request on developer.id = pull_request.developer_id
group by
	developer.id) as user_pr_counts;
```
* What tech does this project use?
```
select
project.name, tech.name
from
project
left outer join
project_uses_tech on project.id = project_uses_tech.project_id
left outer join
tech on tech.id = project_uses_tech.tech_id
where project.name = 'Draw Together';
```
* What tech does this user know - based on the tech used in his projects?
```
select distinct tech.name
from
	tech
	inner join project_uses_tech on tech.id = project_uses_tech.tech_id,
(select
--developer.name, 
project.id as project_id
from
developer
left outer join
project_membership on developer.id = project_membership.developer_id
left outer join
project on project.id = project_membership.project_id
where developer.name = 'Dave'
group by developer.name, project.id) as project_id 
where project_uses_tech.project_id = project_id.project_id;
```
* Who are the top 3 contributors to this project based on number of commits?
```
select project.name,developer.name, count(commit.id)
from project, commit
left outer join developer on commit.developer_id = developer.id
where project.id = commit.project_id
 and project.name = 'Tic-Tac-Toe'
group by project.id,developer.name
limit 3;
```
​
* What are this user's top 3 projects based on number of commits?
```
select project.name, count(commit.id)
from project
	left outer join commit on project.id = commit.project_id
	left outer join developer on developer.id = commit.developer_id
where developer.id = 4
group by project.id
limit 3;
```
* Write a query to enable plotting a project's commit activity by date.
```
select project.name as project, commit.commit_date as commit_date
from
project, commit
where project.id = commit.project_id;
```
* Write a query to enable plotting a user's number of commits by date.
```
select
commit_date, count(commit)
from
commit,
developer
where developer.id = commit.developer_id and developer.id = 1
group by
commit_date;
```
