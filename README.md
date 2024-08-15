# Advent of Code 2023

```mermaid
erDiagram
    DELIVERY_POINTS {
        serial id

    }
    DELIVERY_POINT_KEYS {
        serial id "notes here"
    }
    DELIVERY_POINT_VALUES {
        
    }

    DELIVERY_POINTS ||--o{ DELIVERY_POINT_KEYS : "FK_DELIVERY_POINTS_KEY"
    DELIVERY_POINT_KEYS ||--o{ DELIVERY_POINT_VALUES : ""
```