package team2.chatPlugin.commands;

import org.bukkit.GameMode;
import org.bukkit.command.Command;
import org.bukkit.command.CommandExecutor;
import org.bukkit.command.CommandSender;
import org.bukkit.entity.Player;
import org.jetbrains.annotations.NotNull;

public class LLMCommand implements CommandExecutor {

    @Override
    public boolean onCommand(@NotNull CommandSender commandSender, @NotNull Command command, @NotNull String s, @NotNull String[] strings) {
        if (!(commandSender instanceof  Player)){
            commandSender.sendMessage("Only Players Can use this command");
            return true;
        }

        final Player player = (Player) commandSender;

        if(strings.length == 0){
            player.sendMessage("Please Enter A Message.");
            return true;
        }

        String playerMessage = String.join(" ", strings);

        player.sendMessage("[ChatPlugin] You Said: §f" + playerMessage);

        return true;
    }

}