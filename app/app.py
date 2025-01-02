from flask import Flask
import psycopg2

app = Flask(__name__)

def connect_db():
    try:
        conn = psycopg2.connect(
            host="terraform-20241103035945975700000004.cjeqis2oi24n.us-east-1.rds.amazonaws.com",
            database="postgres",  
            user="omartamer",      
            password="(iT}Halc!P)zb4e3msn1}*LOl(.u" 
        )
        return "Connected to the database!"
    except Exception as e:
        return f"Failed to connect: {str(e)}"

@app.route('/')
def index():
    return connect_db()

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
