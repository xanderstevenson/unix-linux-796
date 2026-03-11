# Network Script Flowchart

```mermaid
flowchart TD
    A([Start]) --> B{Script Selected?}

    B -->|check_google_domain.sh| C[Ping google.com]
    C --> D{Ping Success?}
    D -->|Yes| E[Print "Network is up."]
    D -->|No| F[Print failure message and exit 1]

    B -->|check_google_dns_ip.sh| G[Ping 8.8.8.8]
    G --> H{Ping Success?}
    H -->|Yes| I[Print success message]
    H -->|No| J[Print failure message and exit 1]

    B -->|check_dns_resolution.sh| K[Run nslookup example.com]
    K --> L{Lookup Success?}
    L -->|Yes| M[Print DNS working message]
    L -->|No| N[Print DNS failure message and exit 1]

    E --> O([End])
    F --> O
    I --> O
    J --> O
    M --> O
    N --> O
```
