# main.py
from fastapi import FastAPI, HTTPException, Depends
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List, Optional
import sqlite3
import os

# Initialize FastAPI app
app = FastAPI(title="Product API", description="CRUD API for Product Management")

# Database connection
DATABASE_NAME = "product.db"

def get_db():
    conn = sqlite3.connect(DATABASE_NAME)
    conn.row_factory = sqlite3.Row
    try:
        yield conn
    finally:
        conn.close()

# Initialize the database and create table if it doesn't exist
def init_db():
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS product (
        product_code INTEGER PRIMARY KEY,
        product_name TEXT NOT NULL,
        cost REAL NOT NULL,
        amount INTEGER NOT NULL
    )
    ''')
    conn.commit()
    conn.close()
    print(f"Database initialized with table 'product'")

# Models
class ProductBase(BaseModel):
    product_name: str
    cost: float
    amount: int

class ProductCreate(ProductBase):
    product_code: int

class Product(ProductCreate):
    class Config:
        orm_mode = True

class ProductUpdate(BaseModel):
    product_name: Optional[str] = None
    cost: Optional[float] = None
    amount: Optional[int] = None

# Initialize DB at startup
@app.on_event("startup")
async def startup_event():
    init_db()

# CRUD Operations
@app.post("/products/", response_model=Product, status_code=201)
def create_product(product: ProductCreate, conn: sqlite3.Connection = Depends(get_db)):
    cursor = conn.cursor()
    
    # Check if product with this code already exists
    cursor.execute("SELECT 1 FROM product WHERE product_code = ?", (product.product_code,))
    if cursor.fetchone():
        raise HTTPException(status_code=400, detail="Product code already exists")
    
    # Insert new product
    cursor.execute(
        "INSERT INTO product (product_code, product_name, cost, amount) VALUES (?, ?, ?, ?)",
        (product.product_code, product.product_name, product.cost, product.amount)
    )
    conn.commit()
    
    return product

@app.get("/products/", response_model=List[Product])
def read_products(skip: int = 0, limit: int = 100, conn: sqlite3.Connection = Depends(get_db)):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM product LIMIT ? OFFSET ?", (limit, skip))
    
    products = []
    for row in cursor.fetchall():
        products.append({
            "product_code": row["product_code"],
            "product_name": row["product_name"],
            "cost": row["cost"],
            "amount": row["amount"]
        })
    
    return products

@app.get("/products/{product_code}", response_model=Product)
def read_product(product_code: int, conn: sqlite3.Connection = Depends(get_db)):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM product WHERE product_code = ?", (product_code,))
    
    product = cursor.fetchone()
    if product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    
    return {
        "product_code": product["product_code"],
        "product_name": product["product_name"],
        "cost": product["cost"],
        "amount": product["amount"]
    }

@app.put("/products/{product_code}", response_model=Product)
def update_product(product_code: int, product: ProductUpdate, conn: sqlite3.Connection = Depends(get_db)):
    cursor = conn.cursor()
    
    # Check if product exists
    cursor.execute("SELECT * FROM product WHERE product_code = ?", (product_code,))
    db_product = cursor.fetchone()
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    
    # Build update query based on fields provided
    update_fields = []
    update_values = []
    
    if product.product_name is not None:
        update_fields.append("product_name = ?")
        update_values.append(product.product_name)
    
    if product.cost is not None:
        update_fields.append("cost = ?")
        update_values.append(product.cost)
    
    if product.amount is not None:
        update_fields.append("amount = ?")
        update_values.append(product.amount)
    
    if not update_fields:
        # No fields to update
        cursor.execute("SELECT * FROM product WHERE product_code = ?", (product_code,))
        db_product = cursor.fetchone()
        return {
            "product_code": db_product["product_code"],
            "product_name": db_product["product_name"],
            "cost": db_product["cost"],
            "amount": db_product["amount"]
        }
    
    # Add product_code to update values for WHERE clause
    update_values.append(product_code)
    
    # Execute update query
    cursor.execute(
        f"UPDATE product SET {', '.join(update_fields)} WHERE product_code = ?",
        tuple(update_values)
    )
    conn.commit()
    
    # Return updated product
    cursor.execute("SELECT * FROM product WHERE product_code = ?", (product_code,))
    updated_product = cursor.fetchone()
    
    return {
        "product_code": updated_product["product_code"],
        "product_name": updated_product["product_name"],
        "cost": updated_product["cost"],
        "amount": updated_product["amount"]
    }

@app.delete("/products/{product_code}", response_model=dict)
def delete_product(product_code: int, conn: sqlite3.Connection = Depends(get_db)):
    cursor = conn.cursor()
    
    # Check if product exists
    cursor.execute("SELECT 1 FROM product WHERE product_code = ?", (product_code,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="Product not found")
    
    # Delete product
    cursor.execute("DELETE FROM product WHERE product_code = ?", (product_code,))
    conn.commit()
    
    return {"message": f"Product with code {product_code} deleted successfully"}

# Run the application 
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)