📈 Real-Time Stock Price Tracker

A **cloud-native application** to monitor stock market prices in real-time, send alerts, and visualize data on a live dashboard.  
Built on **Google Cloud Platform (GCP)** using Pub/Sub, Cloud Functions, Firestore, BigQuery, and Cloud Run.


---

## 🚀 Features
- **Real-Time Stock Fetcher**: Continuously retrieves live stock prices from APIs (AlphaVantage / Polygon).
- **Event-Driven Processing**: Uses **Pub/Sub** + **Cloud Functions** to process and store data.
- **Alerts System**: Sends instant email alerts when stock prices cross thresholds.
- **Analytics**: Data stored in **BigQuery** for automated trend analysis.
- **Dashboard**: Cloud Run-hosted dashboard (Flask/Streamlit) for live visualization.

---

## 📂 Project Structure

Real-time-stock-tracker/ │── bigquery/        # BigQuery schema + setup │── dashboard/       # Cloud Run dashboard (Flask/Streamlit) │   └── app.py │── fetcher/         # Stock data fetcher (Cloud Function) │── processor/       # Data processor (Cloud Function) │── alerts/          # Email alerts function │── gcp/             # Deployment scripts & configs │── .env             # Environment variables (not committed) │── requirements.txt # Dependencies │── README.md
