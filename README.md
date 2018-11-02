# service-libpostal

# Usage

## Download Docker Image

See Docker Hub: [service-libpostal](https://github.com/ClickSend/service-libpostal)

## Running image

Run this command: `docker run -d -p 8087:8087 service-libpostal` 

## API Example

Replace `localhost` with your service host URL.

## Parser
`curl -X POST -d '{"query": "100 main st buffalo ny"}' localhost:8087/parser`

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
`curl -X POST -d '{"query": "100 main st buffalo ny"}' localhost:8087/expand`

**Response**
```
[
  "100 main saint buffalo new york",
  "100 main saint buffalo ny",
  "100 main street buffalo new york",
  "100 main street buffalo ny"
]
```

## Health Check
`curl -X GET localhost:8087/health`

**Response**
```
OK
```

# Credits
- For more info on REST API: [See johnlonganecker/libpostal-rest](https://github.com/johnlonganecker/libpostal-rest)
- For more info on libpostal: [See openvenues/libpostal](https://github.com/openvenues/libpostal)
