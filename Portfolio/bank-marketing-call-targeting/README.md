# Bank Marketing Call Targeting
### Which client segments should a call center prioritize to improve term deposit conversion?

## Business Problem

A retail bank runs outbound phone campaigns to sell term deposits. Call center
capacity is finite — every call spent on an unlikely buyer is a call not spent
on a likely one. Contacting the full client base converts at just **11.7%**,
meaning roughly 9 in 10 calls end without a sale.

This project identifies which client segments a call center should prioritize,
and when it should stop calling, to lift conversion above that baseline without
increasing headcount.

## Dataset

[UCI Bank Marketing Dataset](https://archive.ics.uci.edu/dataset/222/bank+marketing) —
45,211 phone calls made by a Portuguese retail bank between 2008 and 2010.
- **Grain:** one row = one call to one client
- **Target:** `y` — did the client subscribe to a term deposit?

## Tools

- **SQLite** (DB Browser) — data exploration, cleaning, and segment analysis
- **Excel** — pivot summaries and charts for the reporting layer

## Data Cleaning & Analytical Decisions

- **duration** excluded — data leakage (only known after the call; 
  predictive but not actionable for targeting).
- **poutcome** unknowns (81.75%) kept — represent new clients with no 
  prior contact, not missing data. Dropping them would remove most of 
  the dataset.
- **contact** excluded from targeting — cellular (14.9%) and telephone 
  (13.4%) convert almost identically; unknown (4.1%) likely reflects 
  early data gaps, not the channel.

## Analysis
**Baseline conversion rate: 11.7%** (5,289 subscriptions out of 45,211 calls).
Every segment below is measured against this benchmark.

| Segment | Clients | Conversion | vs. baseline |
|---|---|---|---|
| Prior campaign success | 1,511 | **64.7%** | 5.5× |
| Age 60+ | 1,784 | **33.6%** | 2.9× |
| Age under 30 | 5,273 | 17.6% | 1.5× |
| Balance 3k–10k | 4,786 | 16.3% | 1.4× |
| *All clients (baseline)* | *45,211* | *11.7%* | — |
| 4+ contact attempts | 9,641 | 7.4% | 0.6× |
| Negative balance | 3,766 | 5.6% | 0.5× |

### Prior campaign success is the strongest predictor
Clients who subscribed in a previous campaign convert at **64.7%** — 5.5× the
baseline. At only 1,511 clients (3.3% of the base), this segment is small but
delivers the highest return per call.

### Conversion follows a U-shape across age
**Hypothesis:** Life-cycle theory suggests both ends of the age range favour
term deposits — retirees become risk-averse once income stops, while clients
under 30 save toward shorter-term goals.

Clients under 30 (17.6%) and over 60 (**33.6%**) both convert well above
baseline, while ages 40–50 bottom out at 9.1%. Splitting the 50+ bracket
revealed the surge begins only after 60 — ages 50–60 convert at just 9.3%,
suggesting **retirement status, not age alone**, drives the shift.

### Conversion plateaus with balance, rather than rising indefinitely
**Hypothesis:** Clients allocate by surplus level — those with modest savings
favour stable products like term deposits, while the wealthiest have capacity
for higher-yield alternatives.

Conversion climbs from 5.6% (negative balance) to 16.3% (3k–10k), then flattens:
clients holding over 10k convert at the same 16.3% despite far larger holdings.
Term deposits appeal to clients with moderate surplus, not the wealthiest.
Mid-High (3k–10k) is also the higher-volume target — 4,786 clients vs 829 above 10k.

### Age outranks balance among new clients
Among new clients (`poutcome = unknown`, 82% of the base), age dominates:
low-balance 60+ clients convert at 23.3%, beating high-balance 30–40 year olds
at 11.6%. Balance still sorts *within* each age band, but age sets the tier.
This confirms the 60+ effect is independent of prior campaign history.

### Conversion drops sharply after three contact attempts
**Hypothesis:** Repeated contact yields diminishing returns — clients who
haven't converted after several attempts are unlikely to convert at all.

The first three calls hold near baseline (14.6% / 11.2% / 11.2%), but the fourth
drops to 9.0% and continues falling to 4.9% beyond eight attempts. The 9,641 calls
made after the third attempt yielded only 7.4% conversion.

## Key Insights

TBD

## Business Recommendations

TBD

<!-- ## Visualizations -->
<!-- ## Limitations & Next Steps -->

## Impact

TBD

## How to Reproduce

1. Download `bank-full.csv` from the [UCI repository](https://archive.ics.uci.edu/dataset/222/bank+marketing)
2. Import into SQLite (semicolon-delimited, first row as headers)
3. Run the scripts in `sql/` in order: exploration → cleaning → analysis

The `.db` file is not committed — it can be regenerated from the CSV above.

## Repo Tree
```
bank-marketing-call-targeting/
├── data/          # UCI bank-full.csv (raw)
├── sql/           # 01_exploration → 02_cleaning → 03_analysis
├── excel/         # pivot summaries and charts
└── images/        # chart exports used in this README
```