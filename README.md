# Real-time Stock Tracker

Tracks stock prices in real-time using:
- **Cloud Functions** (`fetcher`, `processor`, `alerts`)
- **Cloud Run Dashboard**
- **Firestore + BigQuery**

## Deploy
```bash
export GCP_PROJECT=your-project-id
bash deploy.sh
