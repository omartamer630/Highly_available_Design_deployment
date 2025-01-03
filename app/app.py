from flask import Flask
import psycopg2

app = Flask(__name__)

def connect_db():
    try:
        conn = psycopg2.connect(
            host="forgtech-postgres-db.c9w8688c6c79.us-east-1.rds.amazonaws.com",
            database="postgres",  
            user="omartamer",      
            password="2<W)ecak_fK$zROMteq2uxRR6j09" 
        )
        return "Connected to the database!"
    except Exception as e:
        return f"Failed to connect: {str(e)}"

@app.route('/')
def index():
    return connect_db()

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
