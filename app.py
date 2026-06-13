from fastapi import FastAPI
import datetime
import os

app = FastAPI(
    title="Dockerized Python App",
    description="A production-ready FastAPI app with multi-stage Docker build",
    version="1.0.0"
)

@app.get("/")
def root():
    return {
        "message": "Hello from Dockerized Python App!",
        "timestamp": str(datetime.datetime.now()),
        "environment": os.getenv("ENVIRONMENT", "development")
    }

@app.get("/health")
def health():
    return {"status": "healthy"}

@app.get("/version")
def version():
    return {
        "app": "Dockerized Python App",
        "version": "1.0.0",
        "python_version": os.sys.version
    }

@app.get("/info")
def info():
    return {
        "name": "Dockerized Python App",
        "description": "Multi-stage Docker build example",
        "endpoints": ["/", "/health", "/version", "/info"]
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)