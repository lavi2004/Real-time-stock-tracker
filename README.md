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
--

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/lavi2004/Real-time-stock-tracker.git
cd Real-time-stock-tracker

## 🚀 Deployment

### 1. Setup Google Cloud Project
```bash
gcloud auth login
gcloud config set project <YOUR_PROJECT_ID>
gcloud services enable pubsub.googleapis.com \
    cloudfunctions.googleapis.com \
    run.googleapis.com \
    firestore.googleapis.com \
    bigquery.googleapis.com
cd fetcher
gcloud functions deploy fetch_stock_data \
  --runtime python310 \
  --trigger-topic stock-prices \
  --entry-point fetch_data \
  --env-vars-file ../.env.yaml \
  --region us-central1
cd processor
gcloud functions deploy process_stock_data \
  --runtime python310 \
  --trigger-topic processed-prices \
  --entry-point process_data \
  --env-vars-file ../.env.yaml \
  --region us-central1
cd alerts
gcloud functions deploy send_alerts \
  --runtime python310 \
  --trigger-topic alerts \
  --entry-point send_alert \
  --env-vars-file ../.env.yaml \
  --region us-central1
bq mk --dataset stock_data
bq mk --table stock_data.prices bigquery/schema.json
cd dashboard
gcloud builds submit --tag gcr.io/<YOUR_PROJECT_ID>/stock-dashboard
gcloud run deploy stock-dashboard \
  --image gcr.io/<YOUR_PROJECT_ID>/stock-dashboard \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
gcloud pubsub topics publish stock-prices --message '{"symbol":"AAPL","price":175}'
sh deploy.sh
