package team2.chatPlugin.commands;

import org.bukkit.command.Command;
import org.bukkit.command.CommandExecutor;
import org.bukkit.command.CommandSender;
import org.bukkit.entity.Player;
import org.jetbrains.annotations.NotNull;

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

        // Join all the arguments into a single string (in case of multiple words)
        String message = String.join(" ", args);

        // Send the message privately to the player
        player.sendMessage("§a[ChatPlugin]§f You said: " + message);

        return true;
    }
}
