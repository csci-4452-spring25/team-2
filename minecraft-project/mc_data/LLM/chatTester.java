import java.io.BufferedReader;
import java.io.InputStreamReader;

public class chatTester {

    public static void main(String[] args) {
        // Example usage:
        String playerName = "Alex";
        String userInput = "How do I make a crafting table";
        
        String response = callPythonBot(playerName, userInput);
        System.out.println("Assistant's Response: " + response);
    }

    public static String callPythonBot(String playerName, String userInput) {
        StringBuilder output = new StringBuilder();

        try {
            // Wrap userInput inside quotes manually
            String quotedInput = "\"" + userInput + "\"";

            ProcessBuilder pb = new ProcessBuilder(
                "python",
                "chatMessagesLLM.py",
                playerName,
                quotedInput
            );

            // Set working directory if needed
            // pb.directory(new File("path/to/your/python/script"));

            Process process = pb.start();

            // Read the output
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;

            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }

            // Read error output too (in case of crash)
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
            while ((line = errorReader.readLine()) != null) {
                System.err.println("ERROR: " + line);
            }

            int exitCode = process.waitFor();
            if (exitCode != 0) {
                System.err.println("Python script exited with error code: " + exitCode);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return output.toString().trim();
    }
}
