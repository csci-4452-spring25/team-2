package team2.chatPlugin;

import org.bukkit.event.player.PlayerQuitEvent;
import org.bukkit.plugin.java.JavaPlugin;
import net.kyori.adventure.text.Component;
import org.bukkit.Bukkit;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.player.PlayerJoinEvent;
import team2.chatPlugin.commands.LLMCommand;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;


public final class ChatPlugin extends JavaPlugin implements Listener {

    @Override
    public void onEnable() {
        Bukkit.getPluginManager().registerEvents(this, this);
        getCommand("llm").setExecutor(new LLMCommand());
    }

    @Override
    public void onDisable() {
        // Plugin shutdown logic
    }

    @EventHandler
    public void onPlayerJoin(PlayerJoinEvent event) {
        event.getPlayer().sendMessage(Component.text("§a[ChatPlugin]§f Hello, " + event.getPlayer().getName() + "!"));

        try {
            File currentDir = new File("./LLM");
            ProcessBuilder processBuilder = new ProcessBuilder(
                    "python3", "load_SaveChat", "download"
            );

            processBuilder.directory(currentDir);

            // Start the process
            Process process = processBuilder.start();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    @EventHandler
    public void onPlayerExit(PlayerQuitEvent event){
        event.getPlayer().sendMessage(Component.text("§a[ChatPlugin]§f Goodbye, " + event.getPlayer().getName() + "!"));

        try {
            File currentDir = new File("./LLM");
            ProcessBuilder processBuilder = new ProcessBuilder(
                    "python3", "load_SaveChat", "upload"
            );

            processBuilder.directory(currentDir);

            // Start the process
            Process process = processBuilder.start();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }
}
