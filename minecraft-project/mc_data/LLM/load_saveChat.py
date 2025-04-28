import json
import os
import sys
import boto3

# Config
SAVE_FILE = "player_chat_history.json"
DYNAMODB_TABLE = "PlayerChatLogs"
REGION_NAME = "us-west-2"

# AWS
dynamodb = boto3.resource('dynamodb', region_name=REGION_NAME)
table = dynamodb.Table(DYNAMODB_TABLE)

# Pull Data into File
def load_player_data_from_dynamodb():
    if not os.path.exists(SAVE_FILE):
        print(f"{SAVE_FILE} not found. Creating an empty file...")
        with open(SAVE_FILE, "w") as f:
            json.dump([], f)
    
    response = table.scan()
    player_data = response.get('Items', [])
    
    with open(SAVE_FILE, "w") as f:
        json.dump(player_data, f, indent=4)
    
    print(f"Pulled {len(player_data)} players from DynamoDB and saved to {SAVE_FILE}.")

# Push file into database
def upload_player_data_to_dynamodb():
    if not os.path.exists(SAVE_FILE):
        print(f"Error: {SAVE_FILE} not found. Nothing to upload.")
        return

    with open(SAVE_FILE, "r") as f:
        player_data = json.load(f)
    
    with table.batch_writer() as batch:
        for player in player_data:
            batch.put_item(Item=player)
            print(f"Uploaded player {player['player']}.")

    print("All player data uploaded to DynamoDB.")

# Main entry
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python sync_dynamodb.py [upload|download]")
        sys.exit(1)

    action = sys.argv[1].lower()

    if action == "download":
        load_player_data_from_dynamodb()
    elif action == "upload":
        upload_player_data_to_dynamodb()
    else:
        print("Invalid action. Use 'upload' or 'download'.")
        sys.exit(1)
