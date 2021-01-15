# Postgres-Debezium

Exploring Debezium to be used in conjunction with the Outbox Pattern.

## Steps

1. Run the docker images with `make up`
2. Create the `outbox` table.

```sql
CREATE TABLE IF NOT EXISTS outbox (
        id uuid DEFAULT gen_random_uuid(),
        aggregatetype text NOT NULL,
        aggregateid text NOT NULL,
        type text NOT NULL,
        payload jsonb
);

INSERT INTO outbox(aggregatetype, aggregateid, type, payload)
VALUES ('customer', 'customer-1', 'customer-created', '{}');
```

3. Register the Postgres connector with `make step_1`. If the table does not exists, this will not work.
4. Consume messages from the Debezium topic `make step_2`
5. Perform operation by inserting values into the outbox table.


## Kafka Container

The kafka image is using the Debezium's Kafka image, but with customization on the `docker-entrypoint.sh` to allow non-docker applications to connect to kafka running in docker. The original `docker-entrypoint.sh` is [here](https://github.com/debezium/docker-images/blob/master/kafka/1.4/docker-entrypoint.sh).

## Kafka Topic Name

By default, the topic name for the events depends on the `aggregatetype`, so if the aggregate type is `customer`, the event will be published to `outbox.event.customer`.


Setting the following means the topic name will be `inventory.events`:
```
        "transforms.outbox.route.topic.replacement": "inventory.events",
```


## Using `pgoutput`

While using the pgoutput plug-in, it is recommended that you configure filtered as the publication.autocreate.mode. If you use all_tables, which is the default value for publication.autocreate.mode, and the publication is not found, the connector tries to create one by using CREATE PUBLICATION <publication_name> FOR ALL TABLES;, but this fails due to lack of permissions.

Mentioned [here](https://debezium.io/documentation/reference/1.3/connectors/postgresql.html#postgresql-on-azure).


## References

- [Debezium's Tutorial](https://github.com/debezium/debezium-examples/tree/master/tutorial)
- [Debezium's Outbox Event Router Configuration](https://debezium.io/documentation/reference/1.4/configuration/outbox-event-router.html)
- [Debezium's Postgres Docker Image](https://github.com/debezium/docker-images/tree/master/postgres)
