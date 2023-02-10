from fastapi import FastAPI, Header, HTTPException, Depends
import random

app = FastAPI()

suits = ["♠️", "♥️", "♣️", "♦️"]
ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

@app.get("/healthy")
async def healthy():
    """
    Healthcheck endpoint.
    Returns a JSON response with the status "OK".
    """
    return {"status": "OK"}

async def check_token(x_token: str = Header(None)):
    """
    Check the authentication token header.
    Raises an HTTPException with a status code of 401 and a detail message of "Not authorized" if the token is invalid.
    """
    if x_token != "secret-token":
        raise HTTPException(status_code=401, detail="Not authorized")
    return x_token

@app.get("/card")
async def card(x_token: str = Depends(check_token)):
    """
    Returns a random playing card with the suit as an emoji.
    Requires an `x_token` header with the value "secret-token".
    """
    suit = random.choice(suits)
    rank = random.choice(ranks)
    return {"card": f"{rank} {suit}"}
