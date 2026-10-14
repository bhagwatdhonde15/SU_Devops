"""
Enterprise Smart Library Management Platform
Unit 4: Infrastructure Automation Mini-Project
Author: Bhagwat Dhonde (PRN: 2125UMLM1015)
"""

import os
import sqlite3
from flask import Flask, jsonify, request

app = Flask(__name__)

# Determine database path from environment variable or default
DB_PATH = os.environ.get("DATABASE_PATH", "/opt/library/data/library.db")

def get_db_connection():
    db_dir = os.path.dirname(DB_PATH)
    if db_dir and not os.path.exists(db_dir):
        os.makedirs(db_dir, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS books (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            author TEXT NOT NULL
        )
    """)
    # Check if empty, seed default book matching lab specifications
    cursor.execute("SELECT COUNT(*) FROM books")
    count = cursor.fetchone()[0]
    if count == 0:
        cursor.execute(
            "INSERT INTO books (id, title, author) VALUES (?, ?, ?)",
            (1, "The Great Gatsby", "F. Scott Fitzgerald")
        )
    conn.commit()
    conn.close()

# Initialize DB on module load
try:
    init_db()
except Exception as e:
    app.logger.error(f"Error initializing database: {e}")

@app.route("/", methods=["GET"])
def root():
    """Root endpoint verifying application status"""
    return jsonify({
        "application": "Smart Library Management Platform",
        "status": "running"
    }), 200

@app.route("/api/health", methods=["GET"])
def health():
    """Health check endpoint for Docker, Nginx, and monitoring agents"""
    return jsonify({
        "status": "healthy"
    }), 200

@app.route("/api/books", methods=["GET"])
def get_books():
    """Retrieve all books from the library"""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, author, title FROM books ORDER BY id ASC")
    rows = cursor.fetchall()
    conn.close()
    
    books = [{"id": row["id"], "author": row["author"], "title": row["title"]} for row in rows]
    return jsonify(books), 200

@app.route("/api/books/<int:book_id>", methods=["GET"])
def get_book(book_id):
    """Retrieve a single book by ID"""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, author, title FROM books WHERE id = ?", (book_id,))
    row = cursor.fetchone()
    conn.close()
    if row is None:
        return jsonify({"error": "Book not found"}), 404
    return jsonify({"id": row["id"], "author": row["author"], "title": row["title"]}), 200

@app.route("/api/books", methods=["POST"])
def add_book():
    """Add a new book to the library"""
    data = request.get_json(silent=True) or {}
    title = data.get("title")
    author = data.get("author")
    if not title or not author:
        return jsonify({"error": "Fields 'title' and 'author' are required"}), 400
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO books (title, author) VALUES (?, ?)", (title, author))
    new_id = cursor.lastrowid
    conn.commit()
    conn.close()
    
    return jsonify({"id": new_id, "title": title, "author": author}), 201

@app.route("/api/books/<int:book_id>", methods=["DELETE"])
def delete_book(book_id):
    """Delete a book from the library"""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM books WHERE id = ?", (book_id,))
    deleted = cursor.rowcount
    conn.commit()
    conn.close()
    if deleted == 0:
        return jsonify({"error": "Book not found"}), 404
    return jsonify({"message": f"Book {book_id} deleted successfully"}), 200

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=False)
