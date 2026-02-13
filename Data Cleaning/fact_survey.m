let
    // Extracted the employee engagement survey data from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the employee sentiment and survey records.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="fact_survey.csv"]}[Content],

    // Imported the CSV document with the correct encoding and 3-column schema.
    Imported_Survey_Data = Csv.Document(File_Content,[Delimiter=",", Columns=3, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify employee IDs, survey dates, and scores.
    Promote_Headers = Table.PromoteHeaders(Imported_Survey_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support sentiment trending and correlation analysis.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"employee_id", Int64.Type}, 
        {"date", type date}, 
        {"score", Int64.Type}
    }),

    // Renamed headers to follow a professional, business-friendly convention for HR reporting.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"employee_id", "Employee ID"}, 
        {"date", "Survey Date"}, 
        {"score", "Engagement Score"}
    })
in
    Renamed_Columns
