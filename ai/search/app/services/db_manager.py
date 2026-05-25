"""
Database Manager - SQLite operations for storing products
"""
import sqlite3
import json
import logging
from typing import List, Dict, Optional, Any
from datetime import datetime

logger = logging.getLogger(__name__)

class DatabaseManager:
    def __init__(self, db_path: str):
        self.db_path = db_path
        self.conn = None
        self._connect()
    
    def _connect(self):
        """Create database connection"""
        try:
            self.conn = sqlite3.connect(self.db_path, check_same_thread=False)
            self.conn.row_factory = sqlite3.Row
            logger.info(f"Connected to database: {self.db_path}")
        except Exception as e:
            logger.error(f"Failed to connect to database: {str(e)}")
            raise
    
    def init_db(self):
        """Initialize database schema"""
        cursor = self.conn.cursor()
        
        # Products table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS products (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                price REAL,
                currency TEXT DEFAULT 'EUR',
                url TEXT UNIQUE,
                source TEXT,
                description TEXT,
                specs JSON,
                found_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        
        # Search history table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS search_history (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                query TEXT NOT NULL,
                criteria JSON,
                result_count INTEGER,
                processing_time_ms REAL,
                executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        
        # Comparisons table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS comparisons (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                comparison_name TEXT NOT NULL,
                products JSON,
                notes TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        
        # Create indices for better query performance
        cursor.execute('CREATE INDEX IF NOT EXISTS idx_products_price ON products(price)')
        cursor.execute('CREATE INDEX IF NOT EXISTS idx_products_source ON products(source)')
        cursor.execute('CREATE INDEX IF NOT EXISTS idx_products_found_at ON products(found_at)')
        cursor.execute('CREATE INDEX IF NOT EXISTS idx_products_name ON products(name)')
        
        self.conn.commit()
        logger.info("Database schema initialized")
    
    def add_product(self, product: Dict[str, Any]) -> int:
        """Add a product to the database"""
        cursor = self.conn.cursor()
        
        try:
            cursor.execute('''
                INSERT OR REPLACE INTO products 
                (name, price, currency, url, source, description, specs, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
            ''', (
                product.get('name'),
                product.get('price'),
                product.get('currency', 'EUR'),
                product.get('url'),
                product.get('source'),
                product.get('description'),
                json.dumps(product.get('specs', {}))
            ))
            
            self.conn.commit()
            return cursor.lastrowid
        except Exception as e:
            logger.error(f"Failed to add product: {str(e)}")
            raise
    
    def get_products(
        self,
        limit: int = 50,
        offset: int = 0,
        sort_by: str = "price"
    ) -> List[Dict]:
        """Get products from database"""
        cursor = self.conn.cursor()
        
        valid_sorts = {"price": "price ASC", "name": "name ASC", "date": "found_at DESC"}
        sort_clause = valid_sorts.get(sort_by, "price ASC")
        
        try:
            cursor.execute(f'''
                SELECT id, name, price, currency, url, source, description, specs, found_at
                FROM products
                ORDER BY {sort_clause}
                LIMIT ? OFFSET ?
            ''', (limit, offset))
            
            rows = cursor.fetchall()
            products = []
            for row in rows:
                products.append(self._row_to_dict(row))
            
            return products
        except Exception as e:
            logger.error(f"Failed to get products: {str(e)}")
            raise
    
    def search_products(self, query: str, limit: int = 20) -> List[Dict]:
        """Search products by name or description"""
        cursor = self.conn.cursor()
        
        try:
            cursor.execute('''
                SELECT id, name, price, currency, url, source, description, specs, found_at
                FROM products
                WHERE name LIKE ? OR description LIKE ?
                ORDER BY price ASC
                LIMIT ?
            ''', (f'%{query}%', f'%{query}%', limit))
            
            rows = cursor.fetchall()
            products = []
            for row in rows:
                products.append(self._row_to_dict(row))
            
            return products
        except Exception as e:
            logger.error(f"Failed to search products: {str(e)}")
            raise
    
    def count_products(self) -> int:
        """Get total product count"""
        cursor = self.conn.cursor()
        cursor.execute('SELECT COUNT(*) FROM products')
        return cursor.fetchone()[0]
    
    def count_sources(self) -> int:
        """Get number of unique sources"""
        cursor = self.conn.cursor()
        cursor.execute('SELECT COUNT(DISTINCT source) FROM products')
        return cursor.fetchone()[0]
    
    def get_price_stats(self) -> Dict[str, float]:
        """Get price statistics"""
        cursor = self.conn.cursor()
        
        try:
            cursor.execute('''
                SELECT 
                    MIN(price) as min_price,
                    MAX(price) as max_price,
                    AVG(price) as avg_price,
                    COUNT(*) as total_with_price
                FROM products
                WHERE price IS NOT NULL
            ''')
            
            row = cursor.fetchone()
            return {
                "min": row[0],
                "max": row[1],
                "average": row[2],
                "count": row[3]
            }
        except Exception as e:
            logger.error(f"Failed to get price stats: {str(e)}")
            return {}
    
    def add_search_history(
        self,
        query: str,
        criteria: Dict,
        result_count: int,
        processing_time_ms: float
    ) -> int:
        """Record search history"""
        cursor = self.conn.cursor()
        
        try:
            cursor.execute('''
                INSERT INTO search_history (query, criteria, result_count, processing_time_ms)
                VALUES (?, ?, ?, ?)
            ''', (query, json.dumps(criteria), result_count, processing_time_ms))
            
            self.conn.commit()
            return cursor.lastrowid
        except Exception as e:
            logger.error(f"Failed to record search history: {str(e)}")
            raise
    
    def clear_products(self):
        """Clear all products (use with caution)"""
        cursor = self.conn.cursor()
        try:
            cursor.execute('DELETE FROM products')
            self.conn.commit()
            logger.info("All products cleared from database")
        except Exception as e:
            logger.error(f"Failed to clear products: {str(e)}")
            raise
    
    def _row_to_dict(self, row) -> Dict:
        """Convert database row to dictionary"""
        return {
            "id": row[0],
            "name": row[1],
            "price": row[2],
            "currency": row[3],
            "url": row[4],
            "source": row[5],
            "description": row[6],
            "specs": json.loads(row[7]) if row[7] else {},
            "found_at": row[8]
        }
    
    def close(self):
        """Close database connection"""
        if self.conn:
            self.conn.close()
            logger.info("Database connection closed")
