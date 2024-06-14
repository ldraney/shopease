Development flow begins with docker compose and volumes, so things should be containerized from the beginning, or easily so from local should the developer prefer local development. 

Then, there is a PR check that ensure that the code has been deployed to dev before merging to master. 

Upon merging to master, pipeline deploys to perf (if we have QA), staging, and finally production. 

These environments each have slight modifications:
  - number of ecs tasks per env
  - a DB for each env
