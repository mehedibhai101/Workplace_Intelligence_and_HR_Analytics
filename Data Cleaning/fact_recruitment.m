let
    // Extracted the recruitment funnel records from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the candidate journey and sourcing data.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="fact_recruitment.csv"]}[Content],

    // Imported the CSV document with the correct encoding and 6-column schema.
    Imported_Recruitment_Data = Csv.Document(File_Content,[Delimiter=",", Columns=6, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify employee IDs and key recruitment milestones.
    Promote_Headers = Table.PromoteHeaders(Imported_Recruitment_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support duration calculations between recruitment stages.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"employee_id", Int64.Type}, 
        {"source", type text}, 
        {"posting_date", type date}, 
        {"apply_date", type date}, 
        {"interview_date", type date}, 
        {"joining_date", type date}
    }),

    // Renamed headers to follow a professional, business-friendly convention for recruitment reporting.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"employee_id", "Employee ID"}, 
        {"source", "Sourcing Channel"}, 
        {"posting_date", "Posting Date"}, 
        {"apply_date", "Application Date"}, 
        {"interview_date", "Interview Date"}, 
        {"joining_date", "Joining Date"}
    })
in
    Renamed_Columns
