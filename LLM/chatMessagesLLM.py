import json
import os
from openai import OpenAI

SAVE_FILE = "player_chat_history.json"
PLAYER_NAME = "Steve"
USER_INPUT = "Hello"
OPENAI_API_KEY = ""  # Replace securely

client = OpenAI(api_key=OPENAI_API_KEY)

# Load Player Data
if not os.path.exists(SAVE_FILE):
    with open(SAVE_FILE, "w") as f:
        json.dump([], f) 

with open(SAVE_FILE, "r") as f:
    all_data = json.load(f)

# Make player entry
player_entry = next((p for p in all_data if p["player"] == PLAYER_NAME), None)
if player_entry is None:
    player_entry = {"player": PLAYER_NAME, "chat": []}
    all_data.append(player_entry)

# Add new message from player
player_entry["chat"].append({
    "user": USER_INPUT
})

conversation = f"Player: {PLAYER_NAME}\n"
for message in player_entry["chat"]:
    conversation += f"User: {message['user']}\n"
    if "assistant" in message:
        conversation += f"Assistant: {message['assistant']}\n"

conversation += f"User: {USER_INPUT}"


# Call API
response = client.responses.create(
    model="gpt-4o",
    instructions="You are an assistant in a Minecraft server, answer all questions shortly.",
    input=conversation
)

# append api message
player_entry["chat"][-1]["assistant"] = response.output_text

# Save File
with open(SAVE_FILE, "w") as f:
    json.dump(all_data, f, indent=4)
