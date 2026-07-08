# User Requirements

user should be able to:

## RSS fonts

- [x] add `sources` CRUD
- [x] add `rss_execution_log` CRUD
- [x] add `XML` to fetch and parse RSS 2.0 (sweet_xml)
- [x] add `FeedWorker` to fetch, parse and persist posts
  - [x] crate worker dynamic supervisor
  - [x] fetch sources
  - [x] validate body feched
  - [x] update and add test
  - [ ] integrate with `execution_log`
  - [ ] add `posts` CRUD
  - [ ] parse posts
  - [ ] integrate with `posts`
  - [ ] ensure uniqness for `posts`
- [ ] validate `sources` at insertion
- [ ] add `/feed` View

Data Workflows:

1. User -> add source (server) -> add source to db + register schedule a cronjob
2. Job triggered (cronjob) -> get all sources to be feched -> **enqueue** RSS Loaded
3. RSS Loaded (queue, item) -> **fetch all xml recent posts, parse, persist posts**
4. User -> access `/feed` -> list all posts by order
