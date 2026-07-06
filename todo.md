# User Requirements

user should be able to:

## RSS fonts

- [x] add `sources` CRUD
- [x] add `rss_execution_log` CRUD
- [ ] add `posts` CRUD
  - [ ] add `/feed` View
- [ ] add `FeedWorker` to fetch, parse and persist posts

Data Workflows:

1. User -> add source (server) -> add source to db + register schedule a cronjob
2. Job triggered (cronjob) -> get all sources to be feched -> **enqueue** RSS Loaded
3. RSS Loaded (queue, item) -> **fetch all xml recent posts, parse, persist posts**
4. User -> access `/feed` -> list all posts by order
