package team2.chatPlugin.commands;

import org.bukkit.command.Command;
import org.bukkit.command.CommandExecutor;
import org.bukkit.command.CommandSender;
import org.bukkit.entity.Player;
import org.jetbrains.annotations.NotNull;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;

public class LLMCommand implements CommandExecutor {

    @Override
    public boolean onCommand(@NotNull CommandSender commandSender, @NotNull Command command, @NotNull String label, @NotNull String[] args) {
        if (!(commandSender instanceof Player)) {
            commandSender.sendMessage("§a[ChatPlugin]§f Only players can use this command.");
            return true;
        }

        Player player = (Player) commandSender;

        if (args.length == 0) {
            player.sendMessage("§a[ChatPlugin]§f No Message Received: Please enter a message to send.");
            return true;
        }

        // Join all the arguments into a single string
        String message = String.join(" ", args);

        player.sendMessage("§a[ChatPlugin]§f Message Recieved: " + message);

        StringBuilder errorBuilder = new StringBuilder();
        try {
            File currentDir = new File("./LLM");

            // Build the command: python3 <script> <player_name> <message>
            ProcessBuilder processBuilder = new ProcessBuilder(
                    "python3", "chatMessagesLLM.py", player.getName(), message
            );

            processBuilder.directory(currentDir);

            // Start the process
            Process process = processBuilder.start();

            // Capture output
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));

            StringBuilder responseBuilder = new StringBuilder();

            String line;
            while ((line = reader.readLine()) != null) {
                responseBuilder.append(line).append("\n");
            }

            while ((line = errorReader.readLine()) != null) {
                errorBuilder.append(line).append("\n");
            }

            // Wait for the process to complete
            int exitCode = process.waitFor();
            String response = responseBuilder.toString().trim();
            String errors = errorBuilder.toString().trim();

            if (exitCode == 0) {
                if (response.isEmpty()) {
                    player.sendMessage("§a[ChatPlugin]§f (No response from LLM.)");
                } else {
                    player.sendMessage("§a[ChatPlugin]§f LLM: " + response);
                }
            } else {
                player.sendMessage("§c[ChatPlugin]§f Error: LLM process failed.");
                System.out.println("[ChatPlugin] LLM process failed with errors:");
                System.out.println(errors);
            }
        } catch (Exception e) {
            e.printStackTrace();
            player.sendMessage("§c[ChatPlugin]§f Error: Could not run LLM script.");
        }

        return true;
    }
}
