package com.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

public class do_view_and_refill {

    public static void main(String[] args) {
        // Register the driver
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.exit(1); // Exit with a non-zero status code to indicate failure
        }

        // Database connection details
        String url = "jdbc:sqlserver://35.189.89.97:1433;encrypt=false";
        String user = "sa";
        String password = "Contraseña12345678";

        // Paths to the SQL files in the resources directory
        String sqlFilePath1 = "sql/USR_VW_PromptPaymentsReport_modified.sql";
        String sqlFilePath2 = "sql/USR_Refill_REP_Schema_PromptPay_ToOptimise_modified.sql";

        // Execute the first SQL script
        if (!executeSQLScript(url, user, password, sqlFilePath1)) {
            System.exit(1); // Exit if execution fails
        }

        // Wait for 1 second
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            System.err.println("Thread was interrupted during sleep.");
            e.printStackTrace();
            System.exit(1); // Exit with a non-zero status code to indicate failure
        }

        // Execute the second SQL script
        if (!executeSQLScript(url, user, password, sqlFilePath2)) {
            System.exit(1); // Exit if execution fails
        }

        // Wait for 1 second
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            System.err.println("Thread was interrupted during sleep.");
            e.printStackTrace();
            System.exit(1); // Exit with a non-zero status code to indicate failure
        }
    }

    private static boolean executeSQLScript(String url, String user, String password, String sqlFilePath) {
        try (InputStream inputStream = do_view_and_refill.class.getClassLoader().getResourceAsStream(sqlFilePath)) {
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
}
