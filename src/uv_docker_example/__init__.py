from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI()

def hello():
    message = "Hello from inside the container!"
    return message

@app.get("/", response_class=HTMLResponse)
async def root():
    message = hello()
    return f"""
    <!DOCTYPE html>
    <html>
        <head>
            <title>UV Docker Example</title>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 0;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    background-color: #f5f5f5;
                }}
                .message-box {{
                    padding: 20px;
                    border-radius: 5px;
                    background-color: white;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                }}
            </style>
        </head>
        <body>
            <div class="message-box">
                <h1>{message}</h1>
            </div>
        </body>
    </html>
    """