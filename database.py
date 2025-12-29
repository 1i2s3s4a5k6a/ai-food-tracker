from sqlalchemy import create_engine, Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import datetime

# Create a local SQLite database for testing
SQLALCHEMY_DATABASE_URL = "sqlite:///./fridge.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()

class FoodItem(Base):
    __tablename__ = "inventory"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    status = Column(String)
    expiry_date = Column(String)
    added_on = Column(DateTime, default=datetime.datetime.utcnow)

Base.metadata.create_all(bind=engine)

def save_to_fridge(name, status, expiry):
    db = SessionLocal()
    new_item = FoodItem(name=name, status=status, expiry_date=expiry)
    db.add(new_item)
    db.commit()
    db.close()
  
