import json
import os
import sys
from openai import OpenAI

# Config
SAVE_FILE = "player_chat_history.json"
OPENAI_API_KEY = ""  # Replace securely
client = OpenAI(api_key=OPENAI_API_KEY)

def main():
    if len(sys.argv) != 3:
        print("Usage: python llm_runner.py <player_name> <user_input>")
        sys.exit(1)

    player_name = sys.argv[1]
    user_input = sys.argv[2]

    # Load or create player data
    if not os.path.exists(SAVE_FILE):
        with open(SAVE_FILE, "w") as f:
            json.dump([], f)

    with open(SAVE_FILE, "r") as f:
        all_data = json.load(f)

    player_entry = next((p for p in all_data if p["player"] == player_name), None)
    if player_entry is None:
        player_entry = {"player": player_name, "chat": []}
        all_data.append(player_entry)

    player_entry["chat"].append({
        "user": user_input
    })

    conversation = f"Player: {player_name}\n"
    for message in player_entry["chat"]:
        conversation += f"User: {message['user']}\n"
        if "assistant" in message:
            conversation += f"Assistant: {message['assistant']}\n"
    conversation += f"User: {user_input}"

    # Call OpenAI
    response = client.responses.create(
        model="gpt-4o",
        instructions="You are an assistant in a Minecraft server, answer all questions shortly.",
        input=conversation
    )

    # Save response
    player_entry["chat"][-1]["assistant"] = response.output_text

    with open(SAVE_FILE, "w") as f:
        json.dump(all_data, f, indent=4)

    # Output
    print(response.output_text)

if __name__ == "__main__":
    main()