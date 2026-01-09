DROP DATABASE IF EXISTS `bookstore`;

CREATE DATABASE  `bookstore` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

USE `bookstore`;

create table products
(
    id bigint AUTO_INCREMENT not null,
    code        varchar(255) not null unique,
    name        varchar(255) not null,
    description text,
    image_url   text,
    price       decimal(10,2) not null,
    primary key (id)
);

create table order_events
(
    id           bigint AUTO_INCREMENT not null,
    order_number varchar(255) not null,
    event_id     varchar(255) not null unique,
    event_type   varchar(255) not null,
    payload      text not null,
    created_at   timestamp not null,
    updated_at   timestamp,
    primary key (id),
    foreign key (order_number) references orders (order_number)
);

create table orders
(
    id                        bigint AUTO_INCREMENT not null,
    order_number              varchar(255) not null unique,
    username                  varchar(255) not null,
    customer_name             varchar(255) not null,
    customer_email            varchar(255) not null,
    customer_phone            varchar(255) not null,
    delivery_address_line1    varchar(255) not null,
    delivery_address_line2    varchar(255),
    delivery_address_city     varchar(255) not null,
    delivery_address_state    varchar(255) not null,
    delivery_address_zip_code varchar(255) not null,
    delivery_address_country  varchar(255) not null,
    status                    varchar(255) not null,
    comments                  text,
    created_at                timestamp,
    updated_at                timestamp,
    primary key (id)
);

create table order_items
(
    id       bigint AUTO_INCREMENT not null,
    code     varchar(255) not null,
    name     varchar(255) not null,
    price    decimal(10,2) not null,
    quantity int not null,
    order_id bigint not null,
    primary key (id),
    foreign key (order_id) references orders (id)
);

CREATE TABLE shedlock(
    name VARCHAR(64) NOT NULL,
    lock_until TIMESTAMP NOT NULL,
    locked_at TIMESTAMP NOT NULL,
    locked_by VARCHAR(255) NOT NULL,
    PRIMARY KEY (name)
);


insert into products(code, name, description, image_url, price) values
('P100','The Hunger Games','Winning will make you famous. Losing means certain death...','https://images.gr-assets.com/books/1447303603l/2767052.jpg', 34.0),
('P101','To Kill a Mockingbird','The unforgettable novel of a childhood in a sleepy Southern town and the crisis of conscience that rocked it...','https://images.gr-assets.com/books/1361975680l/2657.jpg', 45.40),
('P102','The Chronicles of Narnia','Journeys to the end of the world, fantastic creatures, and epic battles between good and evil—what more could any reader ask for in one book?...','https://images.gr-assets.com/books/1449868701l/11127.jpg', 44.50),
('P103','Gone with the Wind', 'Gone with the Wind is a novel written by Margaret Mitchell, first published in 1936.', 'https://images.gr-assets.com/books/1328025229l/18405.jpg',44.50),
('P104','The Fault in Our Stars','Despite the tumor-shrinking medical miracle that has bought her a few years, Hazel has never been anything but terminal, her final chapter inscribed upon diagnosis.','https://images.gr-assets.com/books/1360206420l/11870085.jpg',14.50),
('P105','The Giving Tree','Once there was a tree...and she loved a little boy.','https://images.gr-assets.com/books/1174210942l/370493.jpg',32.0),
('P106','The Da Vinci Code','An ingenious code hidden in the works of Leonardo da Vinci.A desperate race through the cathedrals and castles of Europe','https://images.gr-assets.com/books/1303252999l/968.jpg',14.50),
('P107','The Alchemist','Paulo Coelho''s masterpiece tells the mystical story of Santiago, an Andalusian shepherd boy who yearns to travel in search of a worldly treasure','https://images.gr-assets.com/books/1483412266l/865.jpg',12.0),
('P108','Charlotte''s Web','This beloved book by E. B. White, author of Stuart Little and The Trumpet of the Swan, is a classic of children''s literature','https://images.gr-assets.com/books/1439632243l/24178.jpg',14.0),
('P109','The Little Prince','Moral allegory and spiritual autobiography, The Little Prince is the most translated book in the French language.','https://images.gr-assets.com/books/1367545443l/157993.jpg',16.50),
('P110','A Thousand Splendid Suns','A Thousand Splendid Suns is a breathtaking story set against the volatile events of Afghanistan''s last thirty years—from the Soviet invasion to the reign of the Taliban to post-Taliban rebuilding—that puts the violence, fear, hope, and faith of this country in intimate, human terms.','https://images.gr-assets.com/books/1345958969l/128029.jpg',15.50),
('P111','A Game of Thrones','Here is the first volume in George R. R. Martin’s magnificent cycle of novels that includes A Clash of Kings and A Storm of Swords.','https://images.gr-assets.com/books/1436732693l/13496.jpg',32.0),
('P112','The Book Thief','Nazi Germany. The country is holding its breath. Death has never been busier, and will be busier still.By her brother''s graveside, Liesel''s life is changed when she picks up a single object, partially hidden in the snow.','https://images.gr-assets.com/books/1522157426l/19063.jpg',30.0),
('P113','One Flew Over the Cuckoo''s Nest','Tyrannical Nurse Ratched rules her ward in an Oregon State mental hospital with a strict and unbending routine, unopposed by her patients, who remain cowed by mind-numbing medication and the threat of electric shock therapy.','https://images.gr-assets.com/books/1516211014l/332613.jpg',23.0),
('P114','Fifty Shades of Grey','When literature student Anastasia Steele goes to interview young entrepreneur Christian Grey, she encounters a man who is beautiful, brilliant, and intimidating.','https://images.gr-assets.com/books/1385207843l/10818853.jpg', 27.0)
;