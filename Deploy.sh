sh deploy.sh
#!/bin/bash
set -e

# -------- CONFIG --------
PROJECT_ID="your-project-id"
REGION="us-central1"
DASHBOARD_IMAGE="gcr.io/$PROJECT_ID/stock-dashboard"
TOPIC_FETCH="stock-prices"
TOPIC_PROCESS="processed-prices"
TOPIC_ALERTS="alerts"
BQ_DATASET="stock_data"
BQ_TABLE="prices"
BQ_SCHEMA="bigquery/schema.json"
ENV_FILE=".env.yaml"

# -------- AUTH & SETUP --------
echo "🔑 Setting project & enabling APIs..."
gcloud config set project $PROJECT_ID
gcloud services enable pubsub.googleapis.com \
    cloudfunctions.googleapis.com \
    run.googleapis.com \
    firestore.googleapis.com \
    bigquery.googleapis.com

# -------- FUNCTIONS --------
echo "🚀 Deploying Fetcher Function..."
cd fetcher
gcloud functions deploy fetch_stock_data \
  --runtime python310 \
  --trigger-topic $TOPIC_FETCH \
  --entry-point fetch_data \
  --env-vars-file ../$ENV_FILE \
  --region $REGION
cd ..

echo "🚀 Deploying Processor Function..."
cd processor
gcloud functions deploy process_stock_data \
  --runtime python310 \
  --trigger-topic $TOPIC_PROCESS \
  --entry-point process_data \
  --env-vars-file ../$ENV_FILE \
  --region $REGION
cd ..

echo "🚀 Deploying Alerts Function..."
cd alerts
gcloud functions deploy send_alerts \
  --runtime python310 \
  --trigger-topic $TOPIC_ALERTS \
  --entry-point send_alert \
  --env-vars-file ../$ENV_FILE \
  --region $REGION \
  --allow-unauthenticated
cd ..

# -------- BIGQUERY --------
echo "📊 Setting up BigQuery..."
bq mk --dataset --location=$REGION $BQ_DATASET || true
bq mk --table $BQ_DATASET.$BQ_TABLE $BQ_SCHEMA || true

# -------- DASHBOARD --------
echo "📡 Deploying Dashboard..."
cd dashboard
gcloud builds submit --tag $DASHBOARD_IMAGE
gcloud run deploy stock-dashboard \
  --image $DASHBOARD_IMAGE \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated
cd ..

echo "✅ Deployment complete!"
