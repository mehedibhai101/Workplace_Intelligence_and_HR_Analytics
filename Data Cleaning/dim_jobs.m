let
    // Extracted the job dimension data from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the job roles and salary bands.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="dim_jobs.csv"]}[Content],

    // Imported the CSV document with a 6-column schema and standard encoding.
    Imported_Job_Data = Csv.Document(File_Content,[Delimiter=",", Columns=6, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify job IDs and salary ranges.
    Promote_Headers = Table.PromoteHeaders(Imported_Job_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to facilitate salary analysis and relationship mapping.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"job_id", Int64.Type}, 
        {"dept_id", Int64.Type}, 
        {"job_title", type text}, 
        {"job_level", Int64.Type}, 
        {"min_salary", Int64.Type}, 
        {"max_salary", Int64.Type}
    }),

    // Renamed technical headers to professional labels for business stakeholders.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"job_id", "Job ID"}, 
        {"dept_id", "Department ID"}, 
        {"job_title", "Job Title"}, 
        {"job_level", "Job Level"}, 
        {"min_salary", "Min Salary"}, 
        {"max_salary", "Max Salary"}
    })
in
    Renamed_Columns
