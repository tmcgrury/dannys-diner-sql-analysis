 Danny's Diner — Customer Spending and Loyalty Analysis

**Tanya McGrury | SQL portfolio project**

I used SQL to investigate customer spending, visit frequency, menu preferences, and loyalty points in Danny's Diner's sample data. The analysis covers the ten core questions from Danny Ma's case study.

## Business objective

Help the restaurant understand customer behavior and identify what it should measure before expanding its loyalty program. The work translates purchase records into customer summaries, preserves tied results, and makes the loyalty rules explicit.

## Findings and business implications

| Finding | Evidence | Business implication |
| --- | --- | --- |
| Similar spending can conceal different visit patterns | A spent $76 across 4 visit days. B spent $74 across 6. | Review spending alongside visit frequency when designing customer offers. |
| Ramen leads purchase volume in this sample | 8 of the 15 item records are ramen. It is A's and C's most purchased item. | Use ramen demand as a starting point for monitoring stock needs, then validate with a larger sample. |
| Customer preferences include ties | B purchased curry, ramen, and sushi twice each. | Preserve all tied favorites so personalized offers reflect the evidence. |
| Membership status affects who appears in an analysis | C has $36 of spending across 2 visit days but no membership record. | Retain all customers for spending analysis and use membership joins intentionally. |
| Reward rules materially affect balances | Under question 10's stated interpretation, January balances are 1,370 points for A and 820 for B. | Confirm eligibility dates and multiplier rules before implementing a rewards calculation. |

## Recommendation

Pilot any loyalty expansion with documented eligibility rules and a measurement plan. Track customer spending, distinct visit days, reward redemption, and contribution margin over comparable periods. Review whether behavior changes after joining while accounting for different observation windows and customer self-selection.

The sample supports checking calculation logic and describing purchasing patterns. A larger dataset with costs, redemption records, and a suitable comparison group would be needed to evaluate whether the program improves profitability or causes additional visits.

## Data and definitions

The case provides three tables, with 15 sales records, 3 menu items, and 2 members across 3 customers. Sales dates span January 1 through February 1, 2021.

| Table | Fields | Purpose |
| --- | --- | --- |
| sales | customer_id, order_date, product_id | Item purchase records |
| menu | product_id, product_name, price | Product names and prices |
| members | customer_id, join_date | Membership start dates |

- Spending uses the listed menu price for each sales record. Taxes, discounts, refunds, and costs are unavailable.
- A visit means a distinct purchase date. Multiple same-day visits cannot be distinguished.
- Repeated customer/date/product records remain in the data because they may represent multiple items. There is no transaction identifier to establish accidental duplication.
- First and last purchases are determined at day level. All qualifying products on the selected date are retained because purchase times are unavailable.
- Membership begins on the join date. Pre-membership purchases fall strictly before it.
- Question 4 preserves the original top-one approach. Ramen is the unique leader here. A dataset with tied leaders would require tie-aware ranking.
- Question 9 applies the hypothetical points rule to every customer's full purchase history, including B's February purchase and nonmember C.
- Question 10 includes January purchases before joining, matching the submitted query's interpretation. The seven-day welcome period includes the join date and the following six days. Sushi and welcome multipliers do not stack. If points should accrue only after enrollment, add `s.order_date >= mem.join_date` to that query. This policy choice needs stakeholder confirmation.

## Questions investigated

1. Total spending by customer.
2. Distinct visit days by customer.
3. Products purchased on each customer's first visit.
4. The most purchased menu item and its purchase count.
5. Each customer's most purchased products, including ties.
6. The first products purchased on or after joining.
7. The last products purchased before joining.
8. Item counts and spending before membership.
9. Points under the base rule and sushi multiplier.
10. January points for A and B under the welcome offer.

See [the complete results](results.md) and [the SQL analysis](analysis.sql).

## SQL techniques

Inner joins, grouped aggregates, distinct date counts, CTEs, `DENSE_RANK`, `PARTITION BY`, conditional calculations with `CASE`, and date intervals.

The first-purchase query uses the minimum date and joins back to the purchase records to retain multiple products. Customer preference ranking uses `DENSE_RANK` to preserve ties. Membership queries filter eligible dates before ranking. The points calculation evaluates the welcome period first so overlapping offers receive one multiplier.

## Run the project

Use a fresh PostgreSQL database or a PostgreSQL SQL playground.

1. Run [schema.sql](schema.sql) once to create and populate the sample tables.
2. Run [analysis.sql](analysis.sql), either one numbered statement at a time or as a script in an editor supporting multiple result sets.
3. Compare the outputs with [results.md](results.md).

The setup creates a schema named `dannys_diner` and should run in a database where that schema does not already exist. It contains no drop commands. Rerunning inserts would duplicate sales rows.

Validation executed all ten queries against the sample in DuckDB and compared every result row with independently calculated expected values. The SQL targets PostgreSQL, but native PostgreSQL execution has not been verified in this environment.

## Limitations

Only three customers are represented. The sales table lacks order IDs, timestamps, quantities, redemption activity, and costs. Menu prices are assumed constant. Question 10 is restricted to January, while other questions use the complete supplied sample. Differences between those results should be interpreted within their respective date scopes. Purchase rankings describe this sample and do not establish future demand or loyalty-program effectiveness.

## Source and authorship

Scenario, sample data, and original questions are credited to Danny Ma's [8 Week SQL Challenge — Danny's Diner](https://8weeksqlchallenge.com/case-study-1/).

Tanya McGrury supplied the ten SQL solutions. AI assistance supported formatting, validation, and preparation of the project documentation. Formatting and explicit January boundaries were refined while retaining the submitted analytical logic.

