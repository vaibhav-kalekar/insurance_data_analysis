import streamlit as st
import duckdb
import matplotlib.pyplot as plt
import plotly.express as px
import pandas as pd

# Connect to DuckDB
conn = duckdb.connect('../ingestion/travel_insurance.db')

st.title("Streamlit with DBT Models and DuckDB")

# Add a sidebar for user inputs
st.sidebar.header("Filter Options")

# Example widget: Dropdown for choosing DBT model
model_choices = ["dim_employee", "dim_insurance_type", "dim_claim_details", "dim_customer_details", "dim_vendor",
                 "fct_claims_mobile", "fct_claims_summary_by_type", "fct_incident_state_severity_count"]

selected_model = st.sidebar.selectbox("Select a DBT Model:", model_choices)

# Example widget: Input box for limiting the number of rows
row_limit = st.sidebar.number_input("Number of rows to display:", min_value=1, max_value=10000, value=10, step=1)

# Example widget: Text input for custom filters
custom_filter = st.sidebar.text_input("Add a WHERE condition (optional):", "")

# Create the SQL query dynamically based on widget inputs
query = f"SELECT * FROM {selected_model} LIMIT {row_limit}"
if custom_filter:
    query = f"SELECT * FROM {selected_model} WHERE {custom_filter} LIMIT {row_limit}"

# Display the dynamically generated query
st.text_area("Generated SQL Query:", query, height=100)

# Initialize session state for the dataframe if it doesn't exist
if 'df' not in st.session_state:
    st.session_state.df = None

# Button to execute the query
if st.button("Run Query"):
    try:
        # Execute query and fetch result
        st.session_state.df = conn.execute(query).fetchdf()
        st.write("Query Results:")
        st.dataframe(st.session_state.df)
    except Exception as e:
        st.error(f"Error executing query: {e}")

# Only show visualization options if we have data
if st.session_state.df is not None and not st.session_state.df.empty:
    st.header("Visualization Options")

    # Get numeric and text columns
    numeric_columns = st.session_state.df.select_dtypes(include=["object","number","string"]).columns
    text_columns = st.session_state.df.select_dtypes(include=["object", "string", "number"]).columns

    if len(numeric_columns) > 0 and len(text_columns) > 0:
        col1, col2 = st.columns(2)

        with col1:
            x_axis = st.selectbox("Select X-axis (categorical):", text_columns)

        with col2:
            y_axis = st.selectbox("Select Y-axis (numeric):", numeric_columns)

        if x_axis and y_axis:
            # Create tabs for different visualization types
            tab1, tab2, tab3 = st.tabs(["Matplotlib", "Plotly", "Streamlit Native"])

            with tab1:
                # Matplotlib visualization
                fig, ax = plt.subplots(figsize=(10, 6))
                ax.scatter(st.session_state.df[x_axis], st.session_state.df[y_axis], color='blue')
                ax.set_xlabel(x_axis)
                ax.set_ylabel(y_axis)
                ax.set_title(f"{y_axis} vs {x_axis}")
                plt.xticks(rotation=45)
                st.pyplot(fig)

            with tab2:
                # Plotly visualization
                fig = px.scatter(st.session_state.df, x=x_axis, y=y_axis,
                                 title=f"{y_axis} vs {x_axis}",
                                 labels={x_axis: x_axis.replace('_', ' ').title(),
                                         y_axis: y_axis.replace('_', ' ').title()})
                st.plotly_chart(fig)

            with tab3:
                # Streamlit native charts
                chart_type = st.radio("Select chart type:", ["Bar Chart", "Line Chart", "Area Chart"])

                if chart_type == "Bar Chart":
                    st.bar_chart(data=st.session_state.df, x=x_axis, y=y_axis)
                elif chart_type == "Line Chart":
                    st.line_chart(data=st.session_state.df, x=x_axis, y=y_axis)
                else:
                    st.area_chart(data=st.session_state.df, x=x_axis, y=y_axis)
    else:
        st.warning("The selected table doesn't have both numeric and categorical columns for visualization.")