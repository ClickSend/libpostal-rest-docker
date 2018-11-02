# Usage

## Download Docker Image

See Docker Hub: [service-libpostal](https://github.com/ClickSend/service-libpostal)

## Running image

Run this command: `docker run -d -p 8087:8087 service-libpostal` 

## API Example

Replace <host> with your host

## Parser
`curl -X POST -d '{"query": "100 main st buffalo ny"}' <host>:8087/parser`

**Response**
```
[
    [
        "100",
        "house_number"
    ],
    [
        "main st",
        "road"
    ],
    [
        "buffalo",
        "city"
    ],
    [
        "ny",
        "state"
    ]
]
```

## Expand
`curl -X POST -d '{"query": "100 main st buffalo ny"}' <host>:8087/expand`

**Response**
```
[
    "100 main saint buffalo ny",
    "100 main saint buffalo new york",
    "100 main street buffalo ny",
    "100 main street buffalo new york"
]
```

## Health Check
`curl -X GET <host>:8087/health`

**Response**
```
{
    "data": "service-libpostal is up!"
}
```

# Credits
- For more info on libpostal: [See openvenues/libpostal](https://github.com/openvenues/libpostal)
