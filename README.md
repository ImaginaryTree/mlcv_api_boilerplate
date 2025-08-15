# 🖼️ CV API Boilerplate

A clean and modular Python boilerplate for **Computer Vision API projects** with a **5-layer architecture** and categorized folders for each feature.  
Designed for scalability, easy maintenance, and integration with ML/DL pipelines.

---

## 📂 Project Structure

```
cv_api_boilerplate/
│
├── api/
│   ├── controllers/         # Define API endpoints
│   │   └── image/
│   │       └── image_controller.py
│   └── handlers/            # Request/Response handling
│       └── image/
│           └── image_handler.py
│
├── services/                 # Business logic
│   └── image/
│       └── image_service.py
│
├── core/                     # Core CV logic (model loading, inference, preprocessing)
│   └── image/
│       └── inference_pipeline.py
│
├── repo/                     # Data access and storage layer
│   └── image/
│       └── model_repository.py
│   └── db.py                 # SQLAlchemy DB session & engine
│
├── utils/                    # Shared helper functions
│   └── image/
│       └── image_utils.py
│
├── models/                   # DTOs / Data models
│   └── image/
│       └── image_dto.py
│
├── migrations/               # Alembic migration files
├── main.py                   # Application entry point
├── requirements.txt          # Python dependencies
└── Dockerfile                # Container configuration
```

---

## 🚀 Layers Overview

1. **Controller** – Defines API routes (`/predict`, `/upload`) and HTTP interface only.  
2. **Handler** – Parses requests, validates inputs, formats responses.  
3. **Service** – Contains core business logic.  
4. **Core** – Model loading, inference, preprocessing, postprocessing.  
5. **Repo** – Handles data access (DB, filesystem, cloud).  
6. **Utils** – Reusable helper functions.  
7. **Models (DTO)** – Request/response schemas with **Pydantic**.

---

## 🛠️ Setup

### 1️⃣ Create Virtual Environment
```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 2️⃣ Install Dependencies
```bash
pip install -r requirements.txt
```

---

## ▶️ Running the API
```bash
uvicorn main:app --reload
```
**API URL:** [http://localhost:8000](http://localhost:8000)

---

## 📜 API Documentation
FastAPI provides:
- **Swagger UI** → [http://localhost:8000/docs](http://localhost:8000/docs)
- **ReDoc** → [http://localhost:8000/redoc](http://localhost:8000/redoc)

---

## 🗄️ Database (SQLAlchemy + Alembic)

### 1️⃣ Install
```bash
pip install sqlalchemy alembic psycopg2-binary  # For PostgreSQL
```

### 2️⃣ Configure `repo/db.py`
```python
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "sqlite:///./app.db"  # Replace with your DB URL

engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
```

### 3️⃣ Initialize Alembic
```bash
alembic init migrations
```

Edit `migrations/env.py`:
```python
from repo.db import Base
from models import *  # Import all models
target_metadata = Base.metadata
```

### 4️⃣ Create Migration
```bash
alembic revision --autogenerate -m "create tables"
```

### 5️⃣ Apply Migration
```bash
alembic upgrade head
```

---

## 📝 CRUD Example (User)
**Model**
```python
# models/user.py
from sqlalchemy import Column, Integer, String
from repo.db import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, unique=True, index=True)
```

**Repository**
```python
# repo/user_repository.py
from sqlalchemy.orm import Session
from models.user import User

def create_user(db: Session, name: str, email: str):
    user = User(name=name, email=email)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user
```

**Controller**
```python
# api/controllers/user_controller.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from repo.db import SessionLocal
from repo.user_repository import create_user

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/users")
def add_user(name: str, email: str, db: Session = Depends(get_db)):
    return create_user(db, name, email)
```

---

## 🐳 Docker
```bash
docker build -t cv_api_boilerplate .
docker run -p 8000:8000 cv_api_boilerplate
```

---

## 📌 Features
- Modular folder-per-feature structure  
- 5-layer architecture  
- DTOs for request/response validation  
- ML/DL ready  
- SQLAlchemy ORM with Alembic migrations  
- Built-in API docs (Swagger + ReDoc)  
- Docker support  

---

## 📄 License
MIT License
