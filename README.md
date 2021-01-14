# Postgres-Debezium

Exploring Debezium to be used in conjunction with the Outbox Pattern.

https://github.com/debezium/debezium-examples/tree/master/tutorial


```sql
CREATE EXTENSION pgcrypto;
CREATE TABLE IF NOT EXISTS inventory.outboxevent (
        id uuid DEFAULT gen_random_uuid(),
        aggregatetype text NOT NULL,
        aggregateid text NOT NULL,
        type text NOT NULL,
        payload jsonb
);

INSERT INTO outboxevent(aggregatetype, aggregateid, type, payload) VALUES ('customer', 'customer-1', 'customer-created', '{}');
```


## Note

By default, the topic name for the events depends on the `aggregatetype`, so if the aggregate type is `customer`, the event will be published to `outbox.event.customer`.


Setting the following means the topic name will be `inventory.events`:
```
        "transforms.outbox.route.topic.replacement": "inventory.events",
```



