package com.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.SQLException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import io.github.cdimascio.dotenv.Dotenv;

public class execute_store_procedure {

    public static void main(String[] args) {
        // Register the driver
        Dotenv dotenv = Dotenv.load();

        // Register the driver
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.exit(1);
        }

        // Database connection details from environment variables
        String url = dotenv.get("DB_URL");
        String user = dotenv.get("DB_USER");
        String password = dotenv.get("DB_PASSWORD");

        // Path to the SQL file in the resources directory
        String sqlFilePath = "sql/execute_sp.sql";

        // Execute the SQL script
        try {
            executeSQLScript(url, user, password, sqlFilePath);
        } catch (SQLException e) {
            System.err.println("Stored procedure execution failed with error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1); // Exit with a non-zero status code to indicate failure
        }
    }

    private static void executeSQLScript(String url, String user, String password, String sqlFilePath) throws SQLException {
        try (InputStream inputStream = execute_store_procedure.class.getClassLoader().getResourceAsStream(sqlFilePath)) {
            if (inputStream == null) {
                throw new IOException("SQL file not found: " + sqlFilePath);
            }

            // Read the SQL file content
            String sqlScript = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);

            try (Connection connection = DriverManager.getConnection(url, user, password);
                 Statement statement = connection.createStatement()) {

                // Split the script by "GO" and execute each part
                String[] sqlStatements = sqlScript.split("(?i)GO");
                for (String sql : sqlStatements) {
                    if (!sql.trim().isEmpty()) {
                        boolean hasResultSet = statement.execute(sql);
                        if (!hasResultSet) {
                            int updateCount = statement.getUpdateCount();
                            if (updateCount == -1) {
                                throw new SQLException("Execution of the stored procedure failed.");
                            }
                        }
                    }
                }

                System.out.println("SQL script executed successfully: " + sqlFilePath);

            } catch (SQLException e) {
                System.err.println("Error executing SQL script: " + sqlFilePath);
                throw e; // Rethrow the exception to be handled in the main method
            }

        } catch (IOException e) {
            System.err.println("Error reading the SQL file: " + sqlFilePath);
            e.printStackTrace();
        }
    }
}
