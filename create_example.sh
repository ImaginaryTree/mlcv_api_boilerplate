#!/bin/bash

# Set base path (current directory)
BASE_DIR=$(pwd)

echo "📂 Creating folder structure..."

mkdir -p \
    api/controllers/user \
    api/handlers/user \
    services/user \
    repo/user \
    models/user \
    core \
    tests \
    alembic/versions

# Database helper
mkdir -p repo
cat > repo/db.py << 'EOF'
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "sqlite:///./app.db"  # Change to PostgreSQL if needed

engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Dependency for FastAPI
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
EOF

# Models
cat > models/user/user_model.py << 'EOF'
from sqlalchemy import Column, Integer, String
from repo.db import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, unique=True, index=True)
EOF

# DTOs
cat > models/user/user_dto.py << 'EOF'
from pydantic import BaseModel, EmailStr

class UserCreate(BaseModel):
    name: str
    email: EmailStr

class UserRead(BaseModel):
    id: int
    name: str
    email: EmailStr

    class Config:
        orm_mode = True
EOF

# Repository
cat > repo/user/user_repository.py << 'EOF'
from sqlalchemy.orm import Session
from models.user.user_model import User
from models.user.user_dto import UserCreate

def create_user(db: Session, user: UserCreate):
    db_user = User(name=user.name, email=user.email)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def get_users(db: Session):
    return db.query(User).all()
EOF

# Service
cat > services/user/user_service.py << 'EOF'
from sqlalchemy.orm import Session
from repo.user.user_repository import create_user, get_users
from models.user.user_dto import UserCreate

def add_user_service(db: Session, user: UserCreate):
    return create_user(db, user)

def list_users_service(db: Session):
    return get_users(db)
EOF

# Handler
cat > api/handlers/user/user_handler.py << 'EOF'
from fastapi import Depends
from sqlalchemy.orm import Session
from repo.db import get_db
from models.user.user_dto import UserCreate
from services.user.user_service import add_user_service, list_users_service

def handle_create_user(user: UserCreate, db: Session = Depends(get_db)):
    return add_user_service(db, user)

def handle_list_users(db: Session = Depends(get_db)):
    return list_users_service(db)
EOF

# Controller
cat > api/controllers/user/user_controller.py << 'EOF'
from fastapi import APIRouter
from api.handlers.user.user_handler import handle_create_user, handle_list_users
from models.user.user_dto import UserCreate, UserRead
from typing import List

router = APIRouter()

@router.post("/", response_model=UserRead)
def create_user(user: UserCreate):
    return handle_create_user(user)

@router.get("/", response_model=List[UserRead])
def list_users():
    return handle_list_users()
EOF

# Main file
cat > main.py << 'EOF'
from fastapi import FastAPI
from api.controllers.user import user_controller
from repo import db

# Create tables if not exists (optional for dev)
db.Base.metadata.create_all(bind=db.engine)

app = FastAPI()

app.include_router(user_controller.router, prefix="/users", tags=["Users"])
EOF

# Requirements
cat > requirements.txt << 'EOF'
fastapi
uvicorn
SQLAlchemy
alembic
pydantic
psycopg2-binary
EOF

echo "✅ Boilerplate files created."
echo "💡 Next steps:"
echo "1. Install dependencies: pip install -r requirements.txt"
echo "2. Initialize Alembic: alembic init alembic"
echo "3. Generate migration: alembic revision --autogenerate -m 'create users table'"
echo "4. Apply migration: alembic upgrade head"
echo "5. Run the API: uvicorn main:app --reload"
