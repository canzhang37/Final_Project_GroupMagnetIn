# Final Project - Group MagnetIn

Jiayi Hu & Can Zhang

a)  Product title

    AIDInsight: HIV Data Explorer

b)  Product purpose:

    The AIDInsight: HIV Data Explorer app provides an interactive platform for users to analyze, visualize, and better understand trends and patterns related to HIV-AIDS in the United States. The app aims to empower users, including researchers, policymakers, healthcare professionals, and the general public, by offering comprehensive and up-to-date information on HIV-AIDS prevalence, incidence, mortality rates, and the effectiveness of various interventions and programs. By making this data more accessible and user-friendly, the app aims to support informed decision-making and contribute to the efforts to prevent, treat, and ultimately eradicate HIV-AIDS.

c)  Availability

    Our Shiny app can be accessed contacting jiayi007@umn.edu or zhan8639@umn.edu 

d)  Data source(s):

    The data source for the AIDInsight: HIV Data Explorer app is Altus Plus of CDC, which can be accessed via the following link: <https://gis.cdc.gov/grasp/nchhstpatlas/tables.html> This dataset is publicly available and can be used to develop the app.

e)  Product features:

    -   **Overview Tab**: Displays the key statistics related to HIV-AIDS, including total cases, new infections, deaths, and prevalence rates, along with line and bar charts to show trends over time and comparisons across different regions, respectively.

    -   **Insight Tab**: Allows users to filter data based on geography, age group, gender, and race/ethnicity, and provides visualizations such as line and scatter plots, and pie charts, to explore trends and patterns in the data.

    -   **Data Tab**: Enables users to download a CSV file of the filtered data from the Insight tab, with options to filter by year, geography, gender, race/ethnicity, age group, and transmission category.

f)  Interactivity

    -   **Filter and Customize Data**: Users can filter and customize data based on various criteria such as time range, geographical region, age group, gender, and race. This allows them to focus on specific aspects of the data that are most relevant to their needs.

    -   **Interactive Visualizations**: The app provides interactive charts, graphs, and maps that allow users to explore trends and patterns related to HIV-AIDS. Users can hover over or click on data points to get more information, zoom in and out of maps, and adjust chart parameters to visualize data in different ways.

    -   **Download Filtered Data**: Users can download a CSV file of the filtered data from the Data tab with options to filter by year, geography, gender, race/ethnicity, age group, and transmission category.

g)  Programming challenges\
    We are using a large dataset without API, such that we need to download several parts of it and combine in the coding. The coding is not very difficult itself, but we spent a lot of time debugging(always the case), adjusting the overall frame, image sizes and the color of each part to make it look coordinated.\

h)  Division of labor\
    Jiayi Hu -- Overview page\
    Can Zhang -- Insight page and Data page\
    Both contributed to other works.

i)  Future work\
    We wish to find an updating API to refine our shiny app if possible. We could further explore HIV more detailed in Minnesota(or other states), adding leaflets of the public health service... We could also develop some epidemiological models.
