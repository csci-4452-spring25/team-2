import json
import boto3

# === CONFIGURATION ===
SAVE_FILE = "player_chat_history.json"
DYNAMODB_TABLE = "PlayerChatLogs"
REGION_NAME = "us-west-2"

# === AWS INITIALIZATION ===
dynamodb = boto3.resource('dynamodb', region_name=REGION_NAME)
table = dynamodb.Table(DYNAMODB_TABLE)

# === LOAD PLAYER DATA ===
with open(SAVE_FILE, "r") as f:
    all_data = json.load(f)

# === BATCH UPLOAD ===
with table.batch_writer() as batch:
    for player_data in all_data:
        batch.put_item(Item=player_data)
        print(f"Queued player {player_data['player']} for upload.")
