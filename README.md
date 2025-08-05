# C99DomainHunter 
Subdomain enumeration &amp; visualization tool for api.c99.nl. Written in PowerShell for Linux & Neo4J AuraDB. 

Created for external penetration testers, red team operators, & network security engineers.  

## Getting started
- Clone the C99DomainHunter repository
```
git clone https://github.com/ndr-repo/C99DomainHunter.git
```
- Add your C99.nl API key to the .key file
- Run the collection & enrichment script for your target domain.
```
pwsh ./C99DomainHunter.ps1 targetDomain.tld
```
  - Downloads results from [C99.nl Subdomain Finder API](https://api.c99.nl/).
  - Enriches results with DNS type ALL resolutions via [DoH](https://datatracker.ietf.org/doc/html/rfc8484).
  - Parses results and saves enriched data to CSV.
    - Results are saved to the log folder inside your C99DomainHunter directory 

## Visualization in AuraDB
  - Import the enriched CSV results using the included DoH graph model
  - Create a dashboard using the included Cypher queries
<img width="1700" height="1135" alt="image" src="https://github.com/user-attachments/assets/d54b3baa-f07c-4a28-a503-69a0abcb7d7c" />
<img width="2324" height="1144" alt="image" src="https://github.com/user-attachments/assets/a5e2a9db-2ee2-4b1e-9f9b-6265651d99c1" />

### Visualization Panel - Unique Resolutions
- Displays top 10 hosts with most unique resolved DNS entries

```
MATCH (n:Name)-[r:Resolves]->(d:Data)
RETURN d.data as name, count(DISTINCT n.name) AS uniqueResolvedCount 
ORDER BY uniqueResolvedCount DESC LIMIT 10
```

<img width="1199" height="709" alt="image" src="https://github.com/user-attachments/assets/76561bfe-65c0-4eeb-9fdc-42f7ec5b49ee" />


