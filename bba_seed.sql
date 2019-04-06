drop table if exists users;
drop table if exists articles;
drop table if exists comments;
drop table if exists favorites;
drop table if exists tags;
drop table if exists whole_notices;
drop table if exists personal_notices;

create table users (
  id integer primary key AUTOINCREMENT,
  name text not null unique check (length(name) > 2),
  password_hash not null,
  password_salt not null,
  iconPath text,
  comment text,
  birth,
  mail text unique,
  authority integer null, -- 1:一般ユーザー 2:管理ユーザー
  created_at,
  updated_at
);

create table articles (
  id integer primary key AUTOINCREMENT,
  title text not null,
  content text,
  user_id integer not null, -- 書き込んだユーザー
  status integer not null,  -- 0:非公開 1:公開
  created_at,
  updated_at
);

create table comments (
  id integer primary key AUTOINCREMENT,
  user_id integer,  -- 書き込んだユーザー
  article_id integer not null,  -- コメントが付随する記事
  content text not null,
  status integer not null,  -- 0:非公開 1:公開
  created_at,
  updated_at
);

create table favorites (
  id integer primary key,
  article_id integer not null,  -- お気に入りした記事
  user_id integer not null,   -- お気に入りしたユーザー
  created_at,
  updated_at
);

create table tags (
  id integer primary key,
  name text not null,
  created_at,
  updated_at
);

-- 全体表示されるお知らせ
create table whole_notices (
  id integer primary key,
  write_user_id integer not null, -- 書き込んだユーザー
  notice text not null,
  created_at,
  updated_at
);

-- 個別表示されるお知らせ
create table personal_notices (
  id integer primary key,
  write_user_id integer not null, -- 書き込んだユーザー
  read_user_id integer not null,  -- 読み込むユーザー
  notice text not null,
  status integer not null,  -- 0:未読 1:既読
  created_at,
  updated_at
);

insert into users ( name, comment, mail, authority, password_hash, password_salt )
  values( 'first user', 'Nice to meet you!!', 'sample_sample@mail_sample', 1, 'aa', 'aa'
);
insert into users (name, comment, mail, authority, password_hash, password_salt )
  values( 'second user', 'Nice to meet you!! 2nd user!','sample_sample2@mail_sample', 1, 'aa', 'aa'
);

insert into articles( title, content, user_id, status )
  values( 'first title', 'first content', 1, 1
);

insert into articles( title, content, user_id, status )
  values( 'second title', 'second content', 2, 1
);

insert into articles( title, content, user_id, status )
  values( '3 title', 'second content', 1, 1
);
insert into articles( title, content, user_id, status )
  values( '4 title', 'second content', 1, 1
);
insert into articles( title, content, user_id, status )
  values( '5 title', 'second content', 1, 1
);
insert into articles( title, content, user_id, status )
  values( '6 title', 'second content', 1, 1
);
insert into articles( title, content, user_id, status )
  values( '7 title', 'second content', 1, 1
);
insert into articles( title, content, user_id, status )
  values( '8 title', 'second content', 1, 1
);
insert into articles( title, content, user_id, status )
  values( '9 title', 'second content', 2, 1
);
insert into articles( title, content, user_id, status )
  values( '10 title', 'second content', 2, 1
);


insert into comments ( user_id, article_id, content, status )
  values( 2, 1, '1st comment to 1st article by user2', 1
);

insert into comments ( user_id, article_id, content, status )
  values( 1, 2, '2nd comment to 2nd article by user1', 1
);

insert into favorites( article_id, user_id )
  values( 1, 2
);

select * from users;
select * from articles;
select * from comments;
select * from favorites;
