import { Kafka } from "kafkajs";

const topic = "outbox.event.customer";
// Connecting from outside of docker-compose does not work, because of
// some configuration in the debezium kafka.
const kafka = new Kafka({
  clientId: "my-app",
  brokers: ["kafka:9092"]
});
console.log("subscribed to topic:", topic);

// You can get the value of group.id for your kafka cluster by looking
// into $KAFKA_HOME/config/consumer.properties.
const consumer = kafka.consumer({ groupId: "test-consumer-group" });
await consumer.connect();
await consumer.subscribe({
  topic,
  fromBeginning: true
});

await consumer.run({
  eachMessage: async ({ topic, partition, message }) => {
    console.log({
      value: message.value.toString()
    });
  }
});
