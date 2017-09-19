# Usage

## Download Docker Image

See Docker Hub: [clicksend/libpostal-rest](https://hub.docker.com/r/clicksend/libpostal-rest)

## Running image

Run this command: `docker run -d -p 8080:8080 clicksend/libpostal-rest` 

## API Example

Replace <host> with your host

## Parser
`curl -X POST -d '{"query": "100 main st buffalo ny"}' <host>:8080/parser`

**Response**
```
[
  {
    "label": "house_number",
    "value": "100"
  },
  {
    "label": "road",
    "value": "main st"
  },
  {
    "label": "city",
    "value": "buffalo"
  },
  {
    "label": "state",
    "value": "ny"
  }
]
```

## Expand
`curl -X POST -d '{"query": "100 main st buffalo ny"}' <host>:8080/expand`

**Response**
```
[
  "100 main saint buffalo new york",
  "100 main saint buffalo ny",
  "100 main street buffalo new york",
  "100 main street buffalo ny"
]
```

# Credits
- For more info on REST API: [See johnlonganecker/libpostal-rest](https://github.com/johnlonganecker/libpostal-rest)
- For more info on libpostal: [See openvenues/libpostal](https://github.com/openvenues/libpostal)
