# airline-flight-delay-analysis-sql
A comprehensive SQL analysis project examining airline flight delays and cancellations using multi-table relational modeling, advanced queries, window functions, and real-world aviation data. Identifies delay patterns, high-risk routes, congestion hours, cancellation causes, and airline performance insights.
📂 Dataset

The dataset contains 3 CSV files:

1. flights.csv

Includes detailed flight information:

Airline code

Flight number

Origin & destination airports

Scheduled & actual departure/arrival

Delay minutes

Cancellation & diversion info

Delay categories (weather, security, airline, NAS)

2. airlines.csv

Maps airline codes to airline names.

3. airports.csv

Contains airport metadata:

Airport name

City, state, country

Latitude, longitude

🛠 SQL Techniques Used

This project demonstrates:

✔ Multi-table joins (airlines + airports + flights)

✔ CTEs (Common Table Expressions)

✔ Window functions (RANK, DENSE_RANK)

✔ Aggregations & grouping

✔ Time-based analysis

✔ Delay categorization

✔ Route-level analytics

✔ Data cleaning & validation

🔍 Key Analysis Questions
1️⃣ Which airlines have the highest average delays?
Analyzes average arrival & departure delays per airline.
2️⃣ Which airports experience the worst congestion?
Finds airports with the highest departure/arrival delays.
3️⃣ What routes suffer the most delays?
Identifies high-risk routes (Origin → Destination).
4️⃣ What are the peak delay hours?
Detects congestion times based on scheduled departure hour.
5️⃣ What are the primary cancellation reasons?
Breaks down cancellations by reason code.
6️⃣ Which airlines have the highest cancellation rates?
7️⃣ How do long-haul and short-haul flights differ in delay behavior?
8️⃣ Which destinations receive the most diverted flights?
9️⃣ What is the punctuality score for each airline?


#Insights Summary
Example insights include:
✈️ Certain airlines consistently show higher delays than others.
🛫 Major hub airports experience heavier congestion and higher average delays.
🔁 Some specific routes show significantly worse delays than others.
⏳ Delays peak during evening hours due to cumulative schedule disruptions.
🌧 Weather-related cancellations spike during specific months.
🛬 Long-haul flights often show different delay patterns compared to short-haul flights.
