# 🍎 FreshTrack AI 

> **Stop Waste, Save Freshness.** An AI-powered food inventory manager that detects spoilage and scans expiry dates in real-time.

---

## 🚀 Overview
FreshTrack AI solves the $1 trillion global food waste problem by giving users "digital eyes" for their kitchen. It uses Computer Vision to analyze produce freshness and OCR to track packaged goods.

### ✨ Key Features
* **AI Freshness Analysis:** Detects rot, mold, and wilting in produce using a custom CNN.
* **Smart OCR Scanner:** Automatically extracts "Best Before" dates from packaging.
* **Virtual Fridge:** A digital inventory that syncs your groceries to your phone.
* **Proactive Alerts:** Push notifications sent 24 hours before food expires.
* **Recipe Suggestions:** (Beta) Suggests meals based on what's about to spoil.

---

## 🛠 Tech Stack
- **Frontend:** Flutter (iOS/Android)
- **Backend:** FastAPI (Python)
- **AI/ML:** TensorFlow, MobileNetV2, EasyOCR
- **Database:** SQLAlchemy (SQLite/Postgres)
- **Deployment:** Docker, Google Cloud Run

---

## 📸 Screenshots
| Freshness Scan | Expiry Detection | Fridge View |
| :---: | :---: | :---: |
| ![Scan](https://via.placeholder.com/200x400?text=AI+Analysis) | ![OCR](https://via.placeholder.com/200x400?text=Date+Scanner) | ![Fridge](https://via.placeholder.com/200x400?text=Inventory) |

---

## ⚙️ Installation

### 1. Backend (Python)
```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
