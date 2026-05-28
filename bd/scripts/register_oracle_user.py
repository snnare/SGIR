import os

def run_sql(container_name, sql_commands):
    """
    Executes SQL commands inside an Oracle container using sqlplus via docker exec.
    """
    # Join commands with newlines and escape for shell usage
    # We use 'sys as sysdba' for administrative tasks
    # The 'exit' at the end ensures sqlplus terminates
    full_sql = "\n".join(sql_commands) + "\nexit;\n"
    
    # Write SQL to a temporary file inside the container or pipe it
    # Piped version to avoid writing files:
    command = f'echo "{full_sql}" | docker exec -i {container_name} sqlplus -s sys/123Nokia$ as sysdba'
    
    print(f"--- Executing on {container_name} ---")
    os.system(command)
    print(f"--- Finished {container_name} ---\n")

def main():
    # Credentials
    user = "sgir_monitoreo"
    password = "oracle"

    # SQL commands to register user and grant permissions
    # Note: 21c uses PDB (XEPDB1), 12c might be different depending on config, 
    # but the setup script used 'ALTER SESSION SET CONTAINER = XEPDB1' for 21c.
    # For a general registration, we might try to handle both.
    
    sql_21c = [
        "ALTER SESSION SET CONTAINER = XEPDB1;",
        f"DROP USER {user} CASCADE;", # Optional: remove if exists
        f"CREATE USER {user} IDENTIFIED BY {password};",
        f"GRANT CREATE SESSION TO {user};",
        f"GRANT SELECT_CATALOG_ROLE TO {user};",
        f"GRANT SELECT ON v_$session TO {user};",
        f"GRANT SELECT ON v_$sql TO {user};",
        f"GRANT SELECT ON v_$process TO {user};",
        f"GRANT SELECT ON v_$lock TO {user};",
        f"GRANT SELECT ON v_$instance TO {user};",
        f"GRANT SELECT ON dba_segments TO {user};",
        f"GRANT SELECT ON dba_tablespaces TO {user};",
        f"GRANT SELECT ON dba_free_space TO {user};"
    ]

    sql_12c = [
        # 12c Sequelize image often uses the root container or a default SID
        f"DROP USER {user} CASCADE;",
        f"CREATE USER {user} IDENTIFIED BY {password};",
        f"GRANT CREATE SESSION TO {user};",
        f"GRANT SELECT_CATALOG_ROLE TO {user};",
        f"GRANT SELECT ON v_$session TO {user};",
        f"GRANT SELECT ON v_$sql TO {user};",
        f"GRANT SELECT ON v_$process TO {user};",
        f"GRANT SELECT ON v_$lock TO {user};",
        f"GRANT SELECT ON v_$instance TO {user};",
        f"GRANT SELECT ON dba_segments TO {user};",
        f"GRANT SELECT ON dba_tablespaces TO {user};",
        f"GRANT SELECT ON dba_free_space TO {user};"
    ]

    # Run for Oracle 21c
    run_sql("sgir_oracle21c", sql_21c)

    # Run for Oracle 12c
    run_sql("sgir_oracle12c", sql_12c)

if __name__ == "__main__":
    main()
