# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection portal_events for enrollment_created and result_recorded events. These are fictional event examples based on student, course, enrollment, result.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related course details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "enrollment_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "result",
        "key": {
            "result_key": 401
        },
        "snapshot": {
            "result_key": 401,
            "enrollment_key": 301,
            "score": 88.5,
            "outcome": "pass",
            "recorded_at": "2026-03-01T10:00:00Z",
            "published_at": "2026-03-05T12:00:00Z"
        }
    },
    "embedded": {
        "course": [
            {
                "key": {
                    "course_key": 201
                },
                "snapshot": {
                    "course_key": 201,
                    "course_code": "SYN101",
                    "title": "Synthetic Foundations",
                    "credits": 3
                },
                "via": [
                    "result.enrollment_key → enrollment.course_key → course"
                ]
            }
        ]
    },
    "references": {
        "student": [
            {
                "key": {
                    "student_key": 101
                },
                "via": [
                    "result.enrollment_key → enrollment.student_key → student"
                ]
            }
        ],
        "enrollment": [
            {
                "key": {
                    "enrollment_key": 301
                },
                "via": [
                    "result.enrollment_key → enrollment"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("portal_events").find({"eventType":"enrollment_created"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "enrollment_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "result_key": 401
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("portal_events").find({"source.key.result_key":401}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "enrollment_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "result_key": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "result_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "result_key": 401
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("portal_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "enrollment_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "result_key": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "result_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "result_key": 401
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("portal_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| enrollment_created | 1 |
| result_recorded | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run OGUNDARE_OMOTOLA_301920243_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/OGUNDARE_OMOTOLA_301920243_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

