package com.example;

public class Orchestrator {
    public static void main(String[] args) {
        // Call the main method of create_tables_data
        create_tables_data.main(args);

        // Call the main method of do_view_and_refill
        do_view_and_refill.main(args);

        // Execute sp
        execute_store_procedure.main(args);
    }
}
