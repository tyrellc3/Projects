# OpenFlights Case Study

## Business Context

The raw OpenFlights data is useful, but it is not analysis-ready. Airport, airline, and route files need to be standardized and joined before they can answer questions about market coverage, hub concentration, route mix, and carrier reach.

The practical question I wanted this project to answer was:

> Where is air route connectivity concentrated, and what does that imply for network planning or partnership analysis?

## Approach

1. Ingested raw OpenFlights CSVs into DuckDB.
2. Built dbt staging models for airports, airlines, and routes.
3. Built marts for airport coverage, airline route coverage, airport connectivity, country route mix, route corridors, and hub dependency.
4. Added dbt tests for key identifiers and required fields.
5. Used notebooks and chart exports to communicate findings in both interactive and GitHub-renderable formats.

## Practical Questions Answered

### 1. How large is the route network?

The modeled dataset includes 67,663 routes across 7,698 airports and 237 countries. After matching routes to airport countries, 66,934 routes had enough location context for domestic versus international analysis.

This gives the project enough coverage to look at global network structure, while still being small enough to run locally in DuckDB.

### 2. Is the network mostly domestic or international?

The matched route network is almost evenly split:

- 32,167 domestic routes, or 48.1%
- 34,767 international routes, or 51.9%

That split matters because the network should not be analyzed as one uniform market. Domestic-heavy countries and international-heavy countries behave differently from a planning perspective.

### 3. Which countries are domestic-heavy versus international-heavy?

The United States and China dominate total outbound route volume, but both are heavily domestic:

- United States: 13,021 outbound routes, 80.8% domestic
- China: 8,069 outbound routes, 85.2% domestic

Several European markets are much more international:

- Germany: 2,352 outbound routes, 91.0% international
- United Kingdom: 2,663 outbound routes, 88.4% international
- Spain: 2,530 outbound routes, 77.1% international
- France: 1,926 outbound routes, 74.9% international

This suggests that route strategy should be segmented by market type. The U.S. and China are better viewed through a domestic network and hub coverage lens, while European markets are better suited for cross-border connectivity and partnership analysis.

### 4. Which airlines have the broadest route coverage?

Ryanair has the highest route count in the modeled data with 2,484 routes. U.S. network carriers also show broad coverage:

- American Airlines: 2,354 routes
- United Airlines: 2,180 routes
- Delta Air Lines: 1,981 routes
- US Airways: 1,960 routes

China Southern, China Eastern, and Air China also rank highly, which aligns with China having one of the largest domestic route networks in the data.

### 5. Where is hub concentration highest?

Some countries depend heavily on a single major airport for route connectivity:

- Singapore Changi: 100.0% of Singapore route connectivity
- Hong Kong International: 100.0% of Hong Kong route connectivity
- Amsterdam Schiphol: 79.5% of Netherlands route connectivity
- Vienna International: 79.4% of Austria route connectivity
- Brussels Airport: 76.8% of Belgium route connectivity

This is important for resilience and partnership planning. A single dominant hub can be efficient, but it also creates concentration risk if that airport has operational constraints, disruption, or limited capacity.

## Recommendation

Based on the modeled data, I would prioritize two different strategies depending on the market:

1. For domestic-heavy markets like the United States and China, focus analysis on hub performance, route density, and domestic network coverage. These markets have large internal route systems, so decisions should be made at the airport and carrier-network level rather than only at the country level.

2. For international-heavy European markets like Germany, the United Kingdom, Spain, and France, prioritize cross-border corridor analysis and airline partnership opportunities. These markets show strong international route mix, making them better candidates for evaluating inter-country connectivity, codeshare potential, and regional network expansion.

If I had to choose one near-term focus area from this dataset, I would start with European international corridors. The data shows high international route share across several large markets, and the UK-Spain route pair appears as one of the highest-volume non-domestic corridors. That makes Europe a strong candidate for deeper corridor-level analysis before moving into demand, pricing, or profitability data.

## Caveats

OpenFlights is route inventory data, not booking, revenue, passenger demand, or schedule frequency data. I would not use it alone to make final commercial decisions. I would use this project as the modeled network layer, then join in demand, fare, capacity, reliability, and profitability data before making production recommendations.
