import pandas as pd
import duckdb
import os

# File paths
DATA_DIR = '../data'
DUCKDB_FILE = 'travel_insurance.db'


def load_csv_to_duckdb(table_name, csv_file):
    """
    Load a CSV file into DuckDB.
    Args:
        table_name (str): Name of the table in DuckDB.
        csv_file (str): Path to the CSV file.
    """
    try:
        print(f"Loading {csv_file} into DuckDB table {table_name}...")

        # Read CSV into a Pandas DataFrame
        df = pd.read_csv(csv_file)

        # Connect to DuckDB
        con = duckdb.connect(DUCKDB_FILE)

        # Write DataFrame to DuckDB table
        con.execute(f"CREATE TABLE IF NOT EXISTS {table_name} AS SELECT * FROM df")
        print(f"Data loaded successfully into {table_name}!")

        # Optional: Display first few rows
        print(con.execute(f"SELECT * FROM {table_name} LIMIT 5").fetchdf())
    except Exception as e:
        print(f"Error loading {csv_file} to DuckDB: {e}")


def main():
    # File-to-table mapping
    files = {
        "employees": os.path.join(DATA_DIR, "employee_data.csv"),
        "insurance": os.path.join(DATA_DIR, "insurance_data.csv"),
        "vendors": os.path.join(DATA_DIR, "vendor_data.csv")
    }

    # Load each CSV into DuckDB
    for table_name, file_path in files.items():
        if os.path.exists(file_path):
            load_csv_to_duckdb(table_name, file_path)
        else:
            print(f"File {file_path} not found!")


if __name__ == "__main__":
    main()


