let
    // Extracted the employee leave records from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the leave fact file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="fact_leave.csv"]}[Content],

    // Imported the CSV document with a 10-column schema and standard encoding.
    Imported_Posting_Data = Csv.Document(File_Content,[Delimiter=",", Columns=10, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify recruitment dates and funnel metrics.
    Promote_Headers = Table.PromoteHeaders(Imported_Posting_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support recruitment funnel analysis and date intelligence.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"job_posting_id", Int64.Type}, {"job_id", Int64.Type}, {"dept_id", Int64.Type}, 
        {"requisition_date", type date}, {"posting_date", type date}, {"vacancies", Int64.Type}, 
        {"applications", Int64.Type}, {"interviews", Int64.Type}, {"offers", Int64.Type}, {"hired", Int64.Type}
    }),

    // Renamed technical headers to professional labels for recruitment performance reporting.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"job_posting_id", "Job Posting ID"}, 
        {"job_id", "Job ID"}, 
        {"dept_id", "Department ID"}, 
        {"requisition_date", "Requisition Date"}, 
        {"posting_date", "Posting Date"}, 
        {"vacancies", "Vacancies"}, 
        {"applications", "Applications"}, 
        {"interviews", "Interviews"}, 
        {"offers", "Offers"}, 
        {"hired", "Hired Count"}
    })
in
    Renamed_Columns
