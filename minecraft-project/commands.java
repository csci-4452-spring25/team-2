new CommandAPICommand("chatgpt")
    .withArguments(new GreedyStringArgument("message"))
    .withAliases("chat", "chatgpt", "gpt")
    .executes((sender, args) -> {
        String message = (String) args.get("message");
        Bukkit.getServer().broadcastMessage(message);
    })
    .register();