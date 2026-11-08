// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("portal_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("portal_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "enrollment_created",
                    "result_recorded"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "result"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "result_key"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("portal_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "result_recorded",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "assessment_metadata": "illustrative assessment_metadata",
                "publication_note": "illustrative publication_note"
            }
        }
    }
]));
  await db.getCollection("portal_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("portal_events").find({"eventType":"enrollment_created"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("portal_events").find({"source.key.result_key":401}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("portal_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("portal_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("portal_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("portal_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("portal_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
