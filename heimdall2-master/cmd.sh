#!/bin/sh
set -e
yarn backend sequelize-cli db:migrate
yarn backend sequelize-cli db:seed:all
yarn backend start
