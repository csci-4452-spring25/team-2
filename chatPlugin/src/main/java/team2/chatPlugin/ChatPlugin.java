package team2.chatPlugin;

import org.bukkit.Bukkit;
import org.bukkit.plugin.java.JavaPlugin;
import net.kyori.adventure.text.Component;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.player.PlayerJoinEvent;
import org.bukkit.event.player.PlayerQuitEvent;
import team2.chatPlugin.commands.LLMCommand;

public final class ChatPlugin extends JavaPlugin implements Listener {

    @Override
    public void onEnable() {
        Bukkit.getPluginManager().registerEvents(this, this);
        getCommand("llm").setExecutor(new LLMCommand());
    }

    @Override
    public void onDisable() {
        getLogger().info("ChatPlugin disabled.");
    }

    @EventHandler
    public void onPlayerJoin(PlayerJoinEvent event) {
        event.getPlayer().sendMessage(Component.text("[ChatPlugin] Hello, " + event.getPlayer().getName() + "!"));
    }

    @EventHandler
    public void onPlayerLeave(PlayerQuitEvent event){
        event.getPlayer().sendMessage(Component.text("[ChatPlugin] Goodbye, " + event.getPlayer().getName() + "!"));
    }


}
