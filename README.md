# Final Project - Group MagnetIn

1.  Names of team members

    Jiayi Hu & Can Zhang

2.  Product title

    AIDInsight: HIV Data Explorer

3.  Product type (report, presentation, Shiny app, etc.)

    Shiny app.

4.  Product purpose: what is the main purpose of your app?

    The main purpose of the AIDInsight: HIV Data Explorer app is to provide an interactive platform for users to analyze, visualize, and better understand trends and patterns related to HIV-AIDS. The app aims to empower users, including researchers, policymakers, healthcare professionals, and the general public, by offering comprehensive and up-to-date information on HIV-AIDS prevalence, incidence, mortality rates, and the effectiveness of various interventions and programs. By making this data more accessible and user-friendly, the app aims to support informed decision-making and contribute to the global efforts to prevent, treat, and ultimately eradicate HIV-AIDS.

5.  What data source(s) will you be using, if any? Are they publicly available? If not, indicate why not, and if it will be possible to make your product publicly available after the end of the class.

    For the AIDInsight: HIV Data Explorer app, we will be using the HIV-AIDS dataset available on Kaggle, which can be accessed via the following link:

    <https://www.kaggle.com/datasets/programmerrdai/hiv-aids>

    This dataset is publicly available and can be used to develop the app.

    We will also use the API to fetch data related to new infections, prevalence, and mortality rates, among other metrics. The API documentation is available at:

    <https://www.who.int/data/gho/info/gho-odata-api>

6.  Product features: What are the main elements of your data product (tables, plots, etc.)? What questions will they answer and how will they provide insight into your data?

    -   **Summary Statistics Table**: A table displaying key statistics, such as the total number of HIV-AIDS cases, new infections, deaths, and prevalence rates. This table provides an overview of the current state of the HIV-AIDS epidemic and helps users quickly grasp the scale of the issue.

    -   **Line Charts**: Line charts depicting trends in HIV-AIDS incidence, prevalence, and mortality rates over time. These charts can help users understand how the situation has evolved and identify patterns or changes in the data.

    -   **Bar Charts**: Bar charts comparing HIV-AIDS data across different regions, countries, or demographic groups. These charts can highlight disparities and areas of concern, enabling users to focus on specific populations or regions that may require more targeted interventions.

    -   **Pie Charts**: Pie charts showing the distribution of HIV-AIDS cases by gender, age group, or other demographic factors. These charts can help users visualize the proportion of cases affecting different segments of the population.

    -   **Heatmap or Choropleth Map**: An interactive map that displays the geographical distribution of HIV-AIDS cases, prevalence, or incidence rates. This map allows users to explore regional trends, identify hotspots, and compare data across different areas.

7.  Automation [if applicable]: How will you automate the creation and deployment of your data product? What event(s) will trigger updates?

    Since our data source provides an API and is updated regularly, we can set up a script to fetch new data automatically at predefined intervals monthly. This script can be scheduled Task Scheduler on a Windows system. Alternatively, we can use a cloud-based service like AWS Lambda to run the script periodically.

    Updates can be triggered when the data source is updated at specific intervals (e.g., monthly, quarterly, or yearly). This ensures that the app is up-to-date with the latest information, helping users make more informed decisions.

8.  Interactivity [if applicable]: What are the main functions/actions that the app will allow the user to do?

    -   **Filter and Customize Data**: Users can filter and customize data based on various criteria, such as time range, geographical region, age group, gender, and race. This allows them to focus on specific aspects of the data that are most relevant to their needs.

    -   **Interactive Visualizations**: The app will provide interactive charts, graphs, and maps that allow users to explore trends and patterns related to HIV-AIDS. Users can hover over or click on data points to get more information, zoom in and out of maps, and adjust chart parameters to visualize data in different ways.

    -   **Comparison and Analysis**: Users can compare data across different regions, demographic groups, or time periods to identify trends, disparities, and areas of concern. The app may also offer statistical analysis tools to help users derive insights from the data.
