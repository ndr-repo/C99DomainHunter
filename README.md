# C99DomainHunter 
Subdomain enumeration &amp; visualization tool for c99.nl. Written in PowerShell for Linux & Neo4J AuraDB.

### Getting started
- Clone the repository
```
git clone https://github.com/ndr-repo/C99DomainHunter.git
```
- Add your C99.nl API key to the .key file
  
- Run the collection & enrichment script for your target domain.
  - Downloads results from [C99.nl Subdomain Finder API](https://api.c99.nl/).
  - Enriches results with DNS type ALL resolutions via [DoH](https://datatracker.ietf.org/doc/html/rfc8484).
  - Parses results and saves enriched data to CSV.
    - Results are saved to the log folder inside your C99DomainHunter directory 
```
pwsh ./C99DomainHunter.ps1 targetDomain.tld
```

- OPTIONAL: Visualization in AuraDB
  - Import the enriched CSV results using the included DoH graph model
  - Create a dashboard using the included Cypher queries
