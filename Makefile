export
DEBEZIUM_VERSION=1.4

up:
	@docker-compose up -d

down:
	@docker-compose down

# 1. Start Postgres connector.
step_1:
	@curl -i -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:8083/connectors/ -d @register-postgres.json

# 2. Consume messages from a Debezium topic.
step_2:
	@docker-compose exec kafka /kafka/bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --from-beginning --property print.key=true --topic outbox.event.customer

# 3. Modify records in the database via Postgres client.
step_3:
	@docker-compose exec postgres env PGOPTIONS="--search_path=inventory" bash -c 'psql -U ${POSTGRES_USER} postgres'
