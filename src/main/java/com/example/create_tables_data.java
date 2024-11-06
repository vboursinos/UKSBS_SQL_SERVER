package com.example;

import io.github.cdimascio.dotenv.Dotenv;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

public class create_tables_data {

    public static void main(String[] args) {
        // Load environment variables from .env file
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

        // Paths to the SQL files in the resources directory
        String sqlFilePath1 = "sql/USR_REP_PaymentsData_modified.sql";
        String sqlFilePath2 = "sql/dummydata2.sql";
        String sqlFilePath3 = "sql/USR_REP_PromptPaymentsReport_All_modified.sql";

        // Execute SQL scripts with waits
        if (!executeSQLScript(url, user, password, sqlFilePath1)) {
            System.exit(1);
        }
        waitOneSecond();

        if (!executeSQLScript(url, user, password, sqlFilePath2)) {
            System.exit(1);
        }
        waitOneSecond();

        if (!executeSQLScript(url, user, password, sqlFilePath3)) {
            System.exit(1);
        }
    }

    private static boolean executeSQLScript(String url, String user, String password, String sqlFilePath) {
        try (InputStream inputStream = create_tables_data.class.getClassLoader().getResourceAsStream(sqlFilePath)) {
            if (inputStream == null) {
                throw new IOException("SQL file not found: " + sqlFilePath);
            }

            String sqlScript = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);

            try (Connection connection = DriverManager.getConnection(url, user, password);
                 Statement statement = connection.createStatement()) {

                String[] sqlStatements = sqlScript.split("(?i)GO");
                for (String sql : sqlStatements) {
                    if (!sql.trim().isEmpty()) {
                        statement.execute(sql);
                    }
                }

                System.out.println("SQL script executed successfully: " + sqlFilePath);
                return true;

            } catch (SQLException e) {
                System.err.println("Error executing SQL script: " + sqlFilePath);
                e.printStackTrace();
                return false;
            }

        } catch (IOException e) {
            System.err.println("Error reading the SQL file: " + sqlFilePath);
            e.printStackTrace();
            return false;
        }
    }

    private static void waitOneSecond() {
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            System.err.println("Thread was interrupted during sleep.");
            e.printStackTrace();
            System.exit(1);
        }
    }
}
