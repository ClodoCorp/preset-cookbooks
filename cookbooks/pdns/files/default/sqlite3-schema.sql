

create table domains (
  id                INTEGER PRIMARY KEY,
  name              VARCHAR(255) NOT NULL,
  master            VARCHAR(128) DEFAULT NULL,
  last_check        INTEGER DEFAULT NULL,
  type              VARCHAR(6) NOT NULL,
  notified_serial   INTEGER DEFAULT NULL,
  account           VARCHAR(40) DEFAULT NULL
);

CREATE UNIQUE INDEX name_index ON domains(name);

CREATE TABLE records (
  id              INTEGER PRIMARY KEY,
  domain_id       INTEGER DEFAULT NULL,
  name            VARCHAR(255) DEFAULT NULL,
  type            VARCHAR(6) DEFAULT NULL,
  content         VARCHAR(255) DEFAULT NULL,
  ttl             INTEGER DEFAULT NULL,
  prio            INTEGER DEFAULT NULL,
  change_date     INTEGER DEFAULT NULL
);

CREATE INDEX rec_name_index ON records(name);
CREATE INDEX nametype_index ON records(name,type);
CREATE INDEX domain_id ON records(domain_id);

create table supermasters (
  ip          VARCHAR(25) NOT NULL,
  nameserver  VARCHAR(255) NOT NULL,
  account     VARCHAR(40) DEFAULT NULL
);

alter table records add ordername      VARCHAR(255);
alter table records add auth bool;
create index orderindex on records(ordername);

create table domainmetadata (
 id		 INTEGER PRIMARY KEY,
 domain_id       INT NOT NULL,
 kind		 VARCHAR(16) COLLATE NOCASE,
 content	TEXT
);

create index domainmetaidindex on domainmetadata(domain_id);

create table cryptokeys (
 id		INTEGER PRIMARY KEY,
 domain_id      INT NOT NULL,
 flags		INT NOT NULL,
 active		BOOL,
 content	TEXT
);		 

create index domainidindex on cryptokeys(domain_id);           

create table tsigkeys (
 id		INTEGER PRIMARY KEY,
 name		VARCHAR(255) COLLATE NOCASE,
 algorithm	VARCHAR(50) COLLATE NOCASE,
 secret		VARCHAR(255)
);

create unique index namealgoindex on tsigkeys(name, algorithm);

