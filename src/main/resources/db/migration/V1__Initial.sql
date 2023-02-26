CREATE TABLE IF NOT EXISTS player (
    id GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(64) NOT NULL,
    password VARCHAR(64) NOT NULL,
    index INT NULL
);

CREATE TABLE IF NOT EXISTS card (
    id GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(16) NOT NULL,
    suit INT NOT NULL,
    weight INT DEFAULT 0,
    order_number INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS card2player (
    player_id INT,
    card_id INT,

    CONSTRAINT card2player_pk PRIMARY KEY (player_id, card_id)
);

CREATE TABLE IF NOT EXISTS team (
    id GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(32) NOT NULL,
    first_player_id INT NULL,
    second_player_id INT NULL,
    score INT DEFAULT 0,

    CONSTRAINT first_player_fk FOREIGN KEY(first_player_id) REFERENCES player(id),
    CONSTRAINT second_player_fk FOREIGN KEY(second_player_id) REFERENCES player(id)
);

CREATE TABLE IF NOT EXISTS game (
    id GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(32) NOT NULL,
    first_team_id INT NULL,
    second_team_id INT NULL,
    dealer_id INT NULL,
    open_points INT DEFAULT 0,

    CONSTRAINT first_team_fk FOREIGN KEY(first_team_id) REFERENCES team(id),
    CONSTRAINT second_team_fk FOREIGN KEY(second_team_id) REFERENCES team(id),
    CONSTRAINT dealer_fk FOREIGN KEY(dealer_id) REFERENCES player(id)
);

CREATE TABLE IF NOT EXISTS combination (
    id GENERATED ALWAYS AS IDENTITY,
    combination_type INT NOT NULL,
    team_id INT NOT NULL,
    score INT NOT NULL,

    CONSTRAINT team_fk FOREIGN KEY(team_id) REFERENCES team(id),
);

CREATE TABLE IF NOT EXISTS card2combination (
    card_id INT,
    combination_id INT,
    CONSTRAINT card2combination_pk PRIMARY KEY (card_id, combination_id)
);

CREATE TABLE IF NOT EXISTS round (
    id GENERATED ALWAYS AS IDENTITY,
    displayed_card_id INT NOT NULL,
    duty_player_id INT NOT NULL,
    order_suit INT NULL,
    order_player_id INT NULL,
    vote_player_id INT NULL,
    bargain_round INT DEFAULT 1,

    CONSTRAINT displayed_card_fk FOREIGN KEY(displayed_card_id) REFERENCES card(id),
    CONSTRAINT duty_player_fk FOREIGN KEY(duty_player_id) REFERENCES player(id),
    CONSTRAINT order_player_fk FOREIGN KEY(order_player_id) REFERENCES player(id),
    CONSTRAINT vote_player_fk FOREIGN KEY(vote_player_id) REFERENCES player(id)
);

CREATE TABLE IF NOT EXISTS combination2round (
    combination_id INT,
    round_id INT,
    CONSTRAINT combination2round_pk PRIMARY KEY (combination_id, round_id)
);

CREATE TABLE IF NOT EXISTS trick (
    id GENERATED ALWAYS AS IDENTITY,
    winner_team_id INT NOT NULL,
    starter_player_id INT NOT NULL,
    score INT NULL,

    CONSTRAINT winner_team_fk FOREIGN KEY(winner_team_id) REFERENCES team(id),
    CONSTRAINT starter_player_fk FOREIGN KEY(starter_player_id) REFERENCES player(id)
);

CREATE TABLE IF NOT EXISTS card2trick (
    card_id INT,
    trick_id INT,
    CONSTRAINT card2trick_pk PRIMARY KEY (card_id, round_id)
);

CREATE TABLE IF NOT EXISTS trick2round (
    trick_id INT,
    round_id INT,
    CONSTRAINT trick2round_pk PRIMARY KEY (trick_id, round_id)
);